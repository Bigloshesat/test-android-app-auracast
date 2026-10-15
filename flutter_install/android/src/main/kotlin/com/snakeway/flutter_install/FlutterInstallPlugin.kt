package com.snakeway.flutter_install

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.core.content.FileProvider
import java.io.File
import java.io.FileNotFoundException
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;


/** FlutterInstallPlugin */
class FlutterInstallPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private var apkFile: File? = null
    private var appId: String? = null
    private val INSTALL_REQUEST_CODE = 1234

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_install")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "installApk") {
            val filePath = call.argument<String>("filePath")
            val appId = call.argument<String>("appId")
            try {
                installApk(filePath, appId)
                result.success("Success")
            } catch (e: Throwable) {
                result.error(e.javaClass.simpleName, e.message, null)
            }
        }
    }

    private fun installApk(filePath: String?, currentAppId: String?) {
        if (filePath == null) throw NullPointerException("fillPath is null!")

        val file = File(filePath)
        if (!file.exists()) throw FileNotFoundException("$filePath is not exist! or check permission")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            if (canRequestPackageInstalls(activity)) install24(activity, file, currentAppId)
            else {
                showSettingPackageInstall(activity)
                apkFile = file
                appId = currentAppId
            }
        } else {
            installBelow24(activity, file)
        }
    }


    private fun showSettingPackageInstall(activity: Activity) { // todo to test with android 26
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
            intent.data = Uri.parse("package:" + activity.packageName)
            activity.startActivityForResult(intent, INSTALL_REQUEST_CODE)
        } else {
            throw RuntimeException("VERSION.SDK_INT < O")
        }

    }

    private fun canRequestPackageInstalls(activity: Activity): Boolean {
        return Build.VERSION.SDK_INT <= Build.VERSION_CODES.O || activity.packageManager.canRequestPackageInstalls()
    }

    private fun installBelow24(context: Context, file: File?) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val uri = Uri.fromFile(file)
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        context.startActivity(intent)
    }

    /**
     * android24及以上安装需要通过 ContentProvider 获取文件Uri，
     * 需在应用中的AndroidManifest.xml 文件添加 provider 标签，
     * 并新增文件路径配置文件 res/xml/provider_path.xml
     * 在android 6.0 以上如果没有动态申请文件读写权限，会导致文件读取失败，你将会收到一个异常。
     * 插件中不封装申请权限逻辑，是为了使模块功能单一，调用者可以引入独立的权限申请插件
     */
    private fun install24(context: Context?, file: File?, appId: String?) {
        if (context == null) throw NullPointerException("context is null!")
        if (file == null) throw NullPointerException("file is null!")
        if (appId == null) throw NullPointerException("appId is null!")
        val intent = Intent(Intent.ACTION_VIEW)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        val uri: Uri = FileProvider.getUriForFile(context, "$appId.fileProvider.install", file)
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        context.startActivity(intent)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this);

    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (resultCode == Activity.RESULT_OK && requestCode == INSTALL_REQUEST_CODE) {
            install24(activity, apkFile, appId)
            return true;
        }
        return false
    }
}
