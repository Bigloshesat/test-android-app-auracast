import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterInstall {
  static const MethodChannel _channel = const MethodChannel('flutter_install');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> installApk(String filePath, String appId) async {
    if (kIsWeb == true ? false : Platform.isAndroid) {
      Map<String, String> params = {'filePath': filePath, 'appId': appId};
      return await _channel.invokeMethod('installApk', params);
    }
    return "";
  }



}
