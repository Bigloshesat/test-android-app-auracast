import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

class Md5Util {
  static String generateMd5(String data) {
    Uint8List content = Utf8Encoder().convert(data);
    dynamic digest = crypto.md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
