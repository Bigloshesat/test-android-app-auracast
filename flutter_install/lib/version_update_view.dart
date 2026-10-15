import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_install/flutter_install.dart';
import 'package:flutter_install/utils/download_manager.dart';
import 'package:flutter_install/utils/file_util.dart';
import 'package:flutter_install/utils/md5_util.dart';
import 'package:flutter_install/views/material_inkwell_view.dart';
import 'package:flutter_install/views/normal_button_view.dart';
import 'package:flutter_install/views/normal_text_view.dart';
import 'package:framework/utils/device_util.dart';
import 'package:framework/utils/exception_util.dart';
import 'package:framework/utils/log_util.dart';
import 'package:framework/utils/permission_manager.dart';
import 'package:framework/utils/toast_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

enum DownloadStatus {
  UN_INIT,
  PERMISSION_NOT_GRANTED,
  DOWNLOADING,
  DOWNLOADING_ERROR,
  DOWNLOADING_SUCCESS,
}

class VersionUpdateView extends StatefulWidget {
  final String downloadUrl;
  final String? appId;
  final Widget? child;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Decoration? decoration;
  final bool jump;
  final String? saveDirPath;
  final bool needRequestPermission;
  final bool canCancel;
  final bool cleanWhenInit;
  final double defaultBroadMargin;
  final double defaultNarrowMargin;
  final Color primary;
  final double buttonRadius;
  final double buttonHeight;
  final double fontNarrow;
  final double fontNormal;
  final double progressHeight;
  final Color progressBackground;
  final Color textContent;
  final Color textHint;
  final VoidCallback? onCancel;
  final String versionUpdateViewCancelText;
  final String versionUpdateViewUnInitText;
  final String versionUpdateViewPermissionNotGrantedText;
  final String versionUpdateViewDownloadingText;
  final String versionUpdateViewDownloadErrorText;
  final String versionUpdateViewDownloadSuccessText;
  final String versionUpdateViewFindNewVersionTitle;
  final String versionUpdateViewFindNewVersionTips;
  final String versionUpdateViewLaunchErrorText;

  VersionUpdateView(this.downloadUrl,
      {Key? key,
      this.appId,
      this.child,
      this.width,
      this.height,
      this.backgroundColor = Colors.transparent,
      this.decoration,
      this.jump = true,
      this.saveDirPath,
      this.needRequestPermission = false,
      this.canCancel = true,
      this.cleanWhenInit = true,
      this.defaultBroadMargin = 16,
      this.defaultNarrowMargin = 8,
      this.primary = Colors.black,
      this.buttonRadius = 8,
      this.buttonHeight = 35,
      this.fontNarrow = 12,
      this.fontNormal = 14,
      this.progressHeight = 6,
      this.progressBackground = Colors.black12,
      this.textContent = Colors.black,
      this.textHint = Colors.grey,
      this.onCancel,
      this.versionUpdateViewCancelText = "取消",
      this.versionUpdateViewUnInitText = "立即更新",
      this.versionUpdateViewPermissionNotGrantedText = "获取文件访问权限失败",
      this.versionUpdateViewDownloadingText = "正在下载...",
      this.versionUpdateViewDownloadErrorText = "下载失败,请重新下载",
      this.versionUpdateViewDownloadSuccessText = "下载完成,请安装",
      this.versionUpdateViewFindNewVersionTitle = "发现新版本",
      this.versionUpdateViewFindNewVersionTips = "版本",
      this.versionUpdateViewLaunchErrorText = "启动失败"})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VersionUpdateState();
  }
}

class VersionUpdateState extends State<VersionUpdateView> {
  DownloadStatus _downloadStatus = DownloadStatus.UN_INIT;
  int? _receivedBytes;
  int? _totalBytes;
  double? _downloadedValue = 0;
  String? _downloadedFilePath;
  String? _apkSize;

  bool needClear = false;

  @override
  void initState() {
    super.initState();
    if (widget.cleanWhenInit) {
      needClear = true;
    }
  }

  Future<String> getSaveDirPath() async {
    String? saveDirPath = widget.saveDirPath;
    if (saveDirPath == null) {
      Directory? directory = await getExternalStorageDirectory();
      saveDirPath = directory?.path;
    }
    return saveDirPath ?? "";
  }

  Future<String> getDownloadFilePath() async {
    String fileName = Md5Util.generateMd5(widget.downloadUrl);
    String saveDirPath = await getSaveDirPath();
    return "$saveDirPath/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(child: _buildBodyView()),
    );
  }

  Widget _buildBodyView() {
    if (_apkSize == null && _totalBytes != null) {
      _apkSize = FileUtil.formatSize(_totalBytes!.toDouble());
    }
    double width = widget.width ?? double.infinity;
    double height = widget.height ?? double.infinity;
    return Container(
      width: width,
      height: height,
      decoration: widget.decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: widget.child ?? Container(),
          ),
          _buildProgressView(),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.defaultBroadMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProgressBar(),
          _buildProgressText(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (_receivedBytes != null && _totalBytes != null) {
      _downloadedValue = _receivedBytes! / _totalBytes!;
    }
    return Opacity(
      opacity: _totalBytes == null ? 0 : 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: widget.defaultNarrowMargin),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.progressHeight / 2),
          child: SizedBox(
            height: widget.progressHeight,
            child: LinearProgressIndicator(
              backgroundColor: widget.progressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(widget.primary),
              value: _downloadedValue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressText() {
    String percentage = "0";
    if (_downloadedValue != null) {
      percentage = (_downloadedValue! * 100).toStringAsFixed(2);
    }
    return Opacity(
      opacity: _receivedBytes == null || _totalBytes == null ? 0 : 1,
      child: NormalTextView(
          content: widget.versionUpdateViewDownloadingText + "$percentage%",
          fontSize: widget.fontNarrow,
          color: widget.textContent),
    );
  }

  Widget _buildButton() {
    bool enable = true;
    String text = "";
    switch (_downloadStatus) {
      case DownloadStatus.UN_INIT:
        text = widget.versionUpdateViewUnInitText;
        break;
      case DownloadStatus.PERMISSION_NOT_GRANTED:
        text = widget.versionUpdateViewPermissionNotGrantedText;
        break;
      case DownloadStatus.DOWNLOADING:
        enable = false;
        text = widget.versionUpdateViewDownloadingText;
        break;
      case DownloadStatus.DOWNLOADING_ERROR:
        text = widget.versionUpdateViewDownloadErrorText;
        break;
      case DownloadStatus.DOWNLOADING_SUCCESS:
        text = widget.versionUpdateViewDownloadSuccessText;
        break;
      default:
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: widget.defaultNarrowMargin,
          vertical: widget.defaultNarrowMargin),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(widget.defaultNarrowMargin),
            child: NormalButtonView(
              enable: enable,
              text: text,
              color: widget.primary,
              radius: widget.buttonRadius,
              height: widget.buttonHeight,
              fontSize: widget.fontNarrow,
              onClick: enable
                  ? () {
                      if (_downloadStatus == DownloadStatus.UN_INIT ||
                          _downloadStatus ==
                              DownloadStatus.PERMISSION_NOT_GRANTED ||
                          _downloadStatus == DownloadStatus.DOWNLOADING_ERROR) {
                        _init();
                      } else if (_downloadStatus ==
                          DownloadStatus.DOWNLOADING_SUCCESS) {
                        _openFile(_downloadedFilePath);
                      }
                    }
                  : null,
            ),
          ),
          widget.canCancel ? _buildCancelView() : Container()
        ],
      ),
    );
  }

  Widget _buildCancelView() {
    return MaterialInkwellView(
      onClick: widget.onCancel,
      child: NormalTextView(
          content: widget.versionUpdateViewCancelText,
          margin: EdgeInsets.all(widget.defaultNarrowMargin / 2),
          fontSize: widget.fontNarrow,
          color: widget.textHint),
    );
  }

  bool isNeedRequestPermission() {
    return widget.saveDirPath != null && widget.needRequestPermission;
  }

  Future<void> _init() async {
    if (widget.jump) {
      await _launchUrl(widget.downloadUrl);
      return;
    }
    bool isGranted = await _checkPermissionAndStart();
    if (!isGranted) {
      try {
        bool canShowDialog = await PermissionManager()
            .shouldShowRequestPermissionRationale(Permission.storage);
        if (!canShowDialog) {
          await PermissionManager().openAppSettings();
          await _checkPermissionAndStart();
        }
      } catch (e, s) {
        ExceptionUtil.printException(e, s);
      }
    }
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null) {
      return;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showShortToast(widget.versionUpdateViewLaunchErrorText);
    }
  }

  Future<bool> _checkPermissionAndStart() async {
    if (!isNeedRequestPermission()) {
      _startDownload();
      return true;
    }
    try {
      bool isGranted = await _checkPermission();
      if (!isGranted) {
        isGranted = await _requestPermission();
      }
      if (isGranted) {
        _startDownload();
        return true;
      } else {
        _onPermissionNotGranted();
      }
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
    return false;
  }

  Future<bool> _checkPermission() async {
    try {
      PermissionStatus permissionStatus =
          await PermissionManager().checkPermissionStatus(Permission.storage);
      if (permissionStatus == PermissionStatus.granted) {
        return true;
      }
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
    return false;
  }

  Future<bool> _requestPermission() async {
    try {
      Map<Permission, PermissionStatus> results =
          await PermissionManager().requestPermissions([Permission.storage]);
      if (results[Permission.storage] == PermissionStatus.granted) {
        return true;
      }
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
    return false;
  }

  void _onPermissionNotGranted() {
    if (!mounted) return;
    setState(() => _downloadStatus = DownloadStatus.PERMISSION_NOT_GRANTED);
  }

  void _startDownload() async {
    if (widget.downloadUrl == "") {
      _onDownloadError();
      return;
    }
    _onDownloadStarted();
    String? path = await _downloadFile(widget.downloadUrl);
    if (path == null) {
      _onDownloadError();
      return;
    } else {
      _downloadStatus = DownloadStatus.DOWNLOADING_SUCCESS;
    }
    await Future.delayed(Duration(milliseconds: 200));
    _openFile(path);
  }

  void _onDownloadStarted() {
    if (!mounted) return;
    setState(() => _downloadStatus = DownloadStatus.DOWNLOADING);
  }

  void _onDownloadError() {
    if (!mounted) return;
    setState(() => _downloadStatus = DownloadStatus.DOWNLOADING_ERROR);
  }

  Future<String?> _downloadFile(String url) async {
    String? result;
    try {
      String downloadFilePath = await getDownloadFilePath();
      if (needClear) {
        needClear = false;
        FileUtil.deleteFile(downloadFilePath);
      }
      await DownloadManager().download(url, downloadFilePath,
          onReceiveProgress: (int receivedBytes, int totalBytes) {
        if (!mounted) return;
        setState(() {
          _receivedBytes = receivedBytes;
          _totalBytes = totalBytes;
        });
      }, onSuccess: (value) {
        if (!mounted) return null;
        setState(() {
          _downloadedFilePath = downloadFilePath;
          _downloadedValue = 1;
        });
        result = downloadFilePath;
      }, onError: (error) {
        LogUtil.e(error);
      });
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
    return result;
  }

  void _openFile(String? path) {
    if (path == null || widget.appId == null) {
      return;
    }
    if (!DeviceUtil.isAndroid()) {
      return;
    }
    // AppInstaller.installApk(path);
    // OpenFile.open(path);
    FlutterInstall.installApk(path, widget.appId!).then((result) {
      LogUtil.e("install apk $result");
    }).catchError((error) {
      LogUtil.e("install apk error: $error");
    });
  }

  @override
  void dispose() {
    DownloadManager().stop(widget.downloadUrl);
    super.dispose();
  }
}
