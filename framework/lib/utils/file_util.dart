import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'exception_util.dart';

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

  static Future<void> deleteFile(String path) async{
    try {
      File file = File(path);
      await file.delete();
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
  }


  static void deleteFileSync(String path) {
    try {
      File file = File(path);
      file.deleteSync();
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
  }

  static Future<String> saveData(
      String saveDirPath, String fileName, String content) async {
    try {
      Directory directory=new Directory(saveDirPath);
      if(!await directory.exists()){
        await directory.create();
      }
      String filePath = "$saveDirPath/$fileName.txt";
      File file = new File(filePath);
      await file.create();
      IOSink slink = file.openWrite(mode: FileMode.write); //替换写入
      slink.write(content);
      await slink.close();
      return filePath;
    } catch (e) {
      print(e);
    }
    return "";
  }

  static Future<String> readData(String filePath) async {
    try {
      File file = new File(filePath);
      String data = "";
      if (await file.exists()) {
        data = await file.readAsString();
      }
      return data;
    } catch (e) {
      print(e);
    }
    return "";
  }

  static String generateMd5(String data) {
    Uint8List content = Utf8Encoder().convert(data);
    dynamic digest = crypto.md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
