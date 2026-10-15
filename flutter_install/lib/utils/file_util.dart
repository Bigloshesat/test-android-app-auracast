import 'dart:io';

import 'package:framework/utils/exception_util.dart';

class FileUtil {
  static String formatSize(double size, {int scale = 2}) {
    double kb = 1024;
    double mb = kb * 1024;
    double gb = mb * 1024;
    double tb = gb * 1024;
    if (size >= tb) {
      return (size / tb).toStringAsFixed(scale) + "TB";
    }

    if (size >= gb) {
      return (size / gb).toStringAsFixed(scale) + "GB";
    }

    if (size >= mb) {
      return (size / mb).toStringAsFixed(scale) + "MB";
    }

    if (size >= kb) {
      return (size / kb).toStringAsFixed(scale) + "KB";
    }

    return size.toStringAsFixed(scale) + "B";
  }

  static void deleteFile(String path) {
    try {
      File file = File(path);
      file.deleteSync();
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
  }
}
