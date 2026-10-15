/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'dart:io';

import 'package:flutter/foundation.dart';

class DeviceUtil {
  static bool isDebug() {
    return kDebugMode == true;
  }

  static bool isWeb() {
    return kIsWeb == true;
  }

  static String osName() {
    return isWeb() ? "" : Platform.operatingSystem;
  }

  static bool isAndroid() {
    return isWeb() ? false : Platform.isAndroid;
  }

  static bool isIOS() {
    return isWeb() ? false : Platform.isIOS;
  }

  static bool isMacOS() {
    return isWeb() ? false : Platform.isMacOS;
  }

  static bool isWindows() {
    return isWeb() ? false : Platform.isWindows;
  }

  static bool isFuchsia() {
    return isWeb() ? false : Platform.isFuchsia;
  }

  static bool isLinux() {
    return isWeb() ? false : Platform.isLinux;
  }


}
