import 'dart:async';

import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/configs/key_config.dart';
import 'package:base_flutter/configs/router_config.dart';
import 'package:base_flutter/utils/navigator_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:framework/utils/device_util.dart';
import 'package:framework/utils/shared_preferences_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class ApplicationController extends ChangeNotifier {
  late String version;

  static ApplicationController getInstance() {
    return Provider.of<ApplicationController>(
        AppConfig.navigatorStateKey.currentContext!,
        listen: false);
  }

  Future<void> init() async {
    if (DeviceUtil.isAndroid() || DeviceUtil.isIOS()) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    } else {
      version = "";
    }
    await AppConfig.initHttpManager(version);


    //todo
    String deviceId  = "testDevices";
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if(DeviceUtil.isAndroid()) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidDeviceInfo.id;
    }

    FlutterBugly.init(
      androidAppId: "6bc5618d8b",
      userId: deviceId,
      appKey: "f025444a-e9cf-477c-bd02-534e34a11560",
    );
    // FlutterBugly.log(tag: "test", message: "这是一个测试",level:LogLevel.INFO);


  }

  void loginOut(BuildContext context) {
    SharedPreferencesManager().remove(KeyConfig.sp_token_key);
    NavigatorUtil.popUntil(context, ActivityName.MainActivity);
  }

  Future<void> updateToken(String token) async {
    await SharedPreferencesManager().putString(KeyConfig.sp_token_key, token);
  }

  String? getToken() {
    return SharedPreferencesManager().getString(KeyConfig.sp_token_key);
  }

  // Future<void> checkVersion(BaseActivityState baseActivityState,
  //     {VoidStringCallback? noNewVersionCallback}) async {
  //   Map<String, dynamic> query = {};
  //   query["_os_"] = DeviceUtil.osName();
  //   await NetworkUtil.request<dynamic>(Method.GET, UrlConfig.get_latest_apk,
  //       appendBase: false,
  //       query: query,
  //       showLog: true,
  //       requestKey: baseActivityState.getKey(),
  //       successCallback: (data, baseEntity) async {
  //     if (data == null) {
  //       return;
  //     }
  //     String currentVersion = version;
  //     String updateVersion = data.version ?? "";
  //     if (currentVersion != "" &&
  //         !StringUtil.compareLowerCaseValue(currentVersion, updateVersion)) {
  //       ViewUtil.showVersionUpdateDialog(
  //           baseActivityState.context, data.url ?? "", "com.lekeaudiobt.app",
  //           child: VersionUpdateTipsView(
  //             title: AppConfig.appS.version_update_view_find_new_version_title,
  //             versionTips:
  //                 AppConfig.appS.version_update_view_find_new_version_tips +
  //                     " " +
  //                     updateVersion,
  //             content: data.description ?? "",
  //           ),
  //           jump: DeviceUtil.isIOS(),
  //           canCancel: !(data.force_update ?? false));
  //     } else {
  //       noNewVersionCallback?.call(updateVersion);
  //     }
  //   }, errorCallback: (e) async {
  //     ToastUtil.showShortToast(e.msg);
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
