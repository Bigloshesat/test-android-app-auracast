import 'dart:convert';
import 'dart:typed_data';

import 'package:bluebridge/bluebridge_library.dart';
import 'package:framework/utils/log_util.dart';

import '../controllers/extra/bluetooth_controller.dart';

class BlueCommandConfig {
  static const int defaultRetryCount = 5;
  static const int defaultDelay = 400;

  static Uint8List intToByteArray(int value) {
    Uint8List byteList = Uint8List(4);
    byteList[0] = ((value >> 24) & 0xFF);
    byteList[1] = ((value >> 16) & 0xFF);
    byteList[2] = ((value >> 8) & 0xFF);
    byteList[3] = (value & 0xFF);
    return byteList;
  }

  static Future<bool> prevMusic() async {
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x01;
    data[4] = 0x00;
    data[5] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> nextMusic() async {
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x01;
    data[4] = 0x01;
    data[5] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> playMusic() async {
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x01;
    data[4] = 0x02;
    data[5] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> changeVolume(int volume) async {
    Uint8List data = Uint8List(7);
    int value = intToByteArray(volume)[3];
    LogUtil.v("volume$value");
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x20;
    data[5] = intToByteArray(volume)[3];
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> reboot() async {
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x01;
    data[4] = 0x03;
    data[5] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> pingOff() async {
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x21;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> pingOn() async {
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x21;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> litheLinkOff() async {
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x28;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> litheLinkOn() async {
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x28;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> bluetoothMode() async {
    LogUtil.v("bluetoothMode");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x25;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> rcaMode() async {
    LogUtil.v("rcaMode");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x25;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> auxMode() async {
    LogUtil.v("auxMode");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x25;
    data[5] = 0x02;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> autoMode() async {
    LogUtil.v("autoMode");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x25;
    data[5] = 0x03;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> opticalMode() async {
    LogUtil.v("opticalMode");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x25;
    data[5] = 0x04;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }



  static Future<bool> speakerMode(int speakerModel) async {
    LogUtil.v("speakerMode");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x25;
    data[5] = speakerModel;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> changeAdminPassword(String password) async {
    Uint8List passwordData = Utf8Encoder().convert(password);
    if (passwordData.length <= 14) {
      Uint8List data = Uint8List(passwordData.length + 6);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x01;
      data[3] = passwordData.length + 1;
      data[4] = 0x24;
      int i = 5;
      passwordData.forEach((byte) {
        data[i] = byte;
        i++;
      });
      data[i] = 0x16;
      return await Bluebridge.sendMessage(data);
    } else {
      Uint8List data = Uint8List(20);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x01;
      data[3] = passwordData.length + 1;
      data[4] = 0x24;
      int i = 5;
      passwordData.forEach((byte) {
        if (i < 19) {
          data[i] = byte;
          i++;
        }
      });
      data[i] = 0x16;
      Uint8List data2 = Uint8List(6 + passwordData.length - 14);
      data2[0] = 0xA5;
      data2[1] = 0x5A;
      data2[2] = 0x01;
      data2[3] = (passwordData.length - 14 + 1);
      data2[4] = 0x24;
      i = 5;
      for (int j = 14; j < passwordData.length; j++) {
        data2[i] = passwordData[j];
        i++;
      }
      data2[i] = 0x16;
      await Bluebridge.sendMessage(data);
      return await Bluebridge.sendMessage(data2);
    }
  }

  static Future<bool> changePinPassword(String password) async {
    Uint8List passwordData = Utf8Encoder().convert(password);
    if (passwordData.length <= 14) {
      Uint8List data = Uint8List(passwordData.length + 6);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x01;
      data[3] = passwordData.length + 1;
      data[4] = 0x22;
      int i = 5;
      passwordData.forEach((byte) {
        data[i] = byte;
        i++;
      });
      data[i] = 0x16;
      return await Bluebridge.sendMessage(data);
    } else {
      Uint8List data = Uint8List(20);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x01;
      data[3] = passwordData.length + 1;
      data[4] = 0x22;
      int i = 5;
      passwordData.forEach((byte) {
        if (i < 19) {
          data[i] = byte;
          i++;
        }
      });
      data[i] = 0x16;
      Uint8List data2 = Uint8List(6 + passwordData.length - 14);
      data2[0] = 0xA5;
      data2[1] = 0x5A;
      data2[2] = 0x01;
      data2[3] = (passwordData.length - 14 + 1);
      data2[4] = 0x22;
      i = 5;
      for (int j = 14; j < passwordData.length; j++) {
        data2[i] = passwordData[j];
        i++;
      }
      data2[i] = 0x16;
      await Bluebridge.sendMessage(data);
      return await Bluebridge.sendMessage(data2);
    }
  }

  static Future<bool> rename(String name) async {
    Uint8List nameData = Utf8Encoder().convert(name);
    if (nameData.length <= 14) {
      Uint8List data = Uint8List(nameData.length + 6);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x01;
      data[3] = nameData.length + 1;
      data[4] = 0x23;
      int i = 5;
      nameData.forEach((byte) {
        data[i] = byte;
        i++;
      });
      data[i] = 0x16;
      return await Bluebridge.sendMessage(data);
    } else if (nameData.length < 29) {
      Uint8List data = Uint8List(20);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x01;
      data[3] = nameData.length + 1;
      data[4] = 0x23;
      int i = 5;
      nameData.forEach((byte) {
        if (i < 19) {
          data[i] = byte;
          i++;
        }
      });
      data[i] = 0x16;
      Uint8List data2 = Uint8List(6 + nameData.length - 14);
      data2[0] = 0xA5;
      data2[1] = 0x5A;
      data2[2] = 0x01;
      data2[3] = (nameData.length - 14 + 1);
      data2[4] = 0x23;
      i = 5;
      for (int j = 14; j < nameData.length; j++) {
        data2[i] = nameData[j];
        i++;
      }
      data2[i] = 0x16;
      await Bluebridge.sendMessage(data);
      return await Bluebridge.sendMessage(data2);
    } else {
      Uint8List data = Uint8List(20);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x01;
      data[3] = (nameData.length + 1);
      data[4] = 0x23;
      int i = 5;
      nameData.forEach((byte) {
        if (i < 19) {
          data[i] = byte;
          i++;
        }
      });
      data[i] = 0x16;

      Uint8List data2 = Uint8List(20);
      data2[0] = 0xA5;
      data2[1] = 0x5A;
      data2[2] = 0x01;
      data2[3] = 0x0F;
      data2[4] = 0x23;
      i = 5;
      for (int j = 14; j < 28; j++) {
        data2[i] = nameData[j];
        i++;
      }
      data2[i] = 0x16;

      // Uint8List data3 = Uint8List(7);
      Uint8List data3 = Uint8List(nameData.length - 28 + 6);
      data3[0] = 0xA5;
      data3[1] = 0x5A;
      data3[2] = 0x01;
      // data3[3] = 0x02;
      data3[3] = (nameData.length - 28 + 1);
      data3[4] = 0x23;
      // data3[5] = nameData[28];
      // data3[6] = 0x16;
      i = 5;
      for (int j = 28; j < nameData.length; j++) {
        data3[i] = nameData[j];
        i++;
      }
      data3[i] = 0x16;

      await Bluebridge.sendMessage(data);
      await Bluebridge.sendMessage(data2);
      return await Bluebridge.sendMessage(data3);
    }
  }


  //查看播放状态
  static Future<void> checkPlayStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x00;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckPlayStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckPlayStatus) {
        break;
      }
    }
  }

  static Future<void> checkPingStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x01;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckPingStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckPingStatus) {
        break;
      }
    }
  }

  static Future<void> checkLitheLinkStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x04;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckLinkStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckLinkStatus) {
        break;
      }
    }
  }

  static Future<void> checkAdminStatus(
      // 这个指令不仅仅是 查看 管理员的 密码状态的，是查整个固件信息的
      {int retryCount = defaultRetryCount,
      int delay = defaultDelay}) async {
    Uint8List data = Uint8List(5);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x00;
    data[3] = 0x00;
    data[4] = 0x16;
    BluetoothController.getInstance().receiveCheckAdminStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckAdminStatus) {
        break;
      }
    }
  }




  //查看产品状态
  static Future<void> checkProductStatus(
          {int retryCount = defaultRetryCount,
        int delay = defaultDelay}) async {
    LogUtil.v("checkProductStatus");
    Uint8List data = Uint8List(5);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0xFE;
    data[3] = 0x00;
    data[4] = 0x16;
    BluetoothController.getInstance().receiveCheckProductStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckProductStatus) {
        break;
      }
    }
  }

  static Future<void> checkAdminPassword(String password,
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    Uint8List passwordData = Utf8Encoder().convert(password);
    BluetoothController.getInstance().receiveCheckAdminPassword = false;
    if (passwordData.length <= 14) {
      Uint8List data = Uint8List(passwordData.length + 6);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x02;
      data[3] = passwordData.length + 1;
      data[4] = 0x02;
      int i = 5;
      passwordData.forEach((byte) {
        data[i] = byte;
        i++;
      });
      data[i] = 0x16;
      for (int i = 0; i < retryCount; i++) {
        await Bluebridge.sendMessage(data);
        await Future.delayed(Duration(milliseconds: delay));
        if (BluetoothController.getInstance().receiveCheckAdminPassword) {
          break;
        }
      }
    } else {
      Uint8List data = Uint8List(20);
      data[0] = 0xA5;
      data[1] = 0x5A;
      data[2] = 0x02;
      data[3] = passwordData.length + 1;
      data[4] = 0x02;
      int i = 5;
      passwordData.forEach((byte) {
        if (i < 19) {
          data[i] = byte;
          i++;
        }
      });
      data[i] = 0x16;
      Uint8List data2 = Uint8List(6 + passwordData.length - 14);
      data2[0] = 0xA5;
      data2[1] = 0x5A;
      data2[2] = 0x02;
      data2[3] = (passwordData.length - 14 + 1);
      data2[4] = 0x02;
      i = 5;
      for (int j = 14; j < passwordData.length; j++) {
        data2[i] = passwordData[j];
        i++;
      }
      data2[i] = 0x16;
      for (int i = 0; i < retryCount; i++) {
        await Bluebridge.sendMessage(data);
        await Bluebridge.sendMessage(data2);
        await Future.delayed(Duration(milliseconds: delay));
        if (BluetoothController.getInstance().receiveCheckAdminPassword) {
          break;
        }
      }
    }
  }

  static Future<bool> equalizerOn() async {
    LogUtil.v("equalizerOn");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0xFF;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> equalizerOFF() async {
    LogUtil.v("equalizerOFF");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> customEqualizer() async {
    LogUtil.v("customEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> popEqualizer() async {
    LogUtil.v("popEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x02;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> classicalEqualizer() async {
    LogUtil.v("classicalEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x03;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> loungeEqualizer() async {
    LogUtil.v("loungeEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x04;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> danceEqualizer() async {
    LogUtil.v("danceEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x05;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> jazzEqualizer() async {
    LogUtil.v("jazzEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x06;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> hipHopEqualizer() async {
    LogUtil.v("hipHopEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x07;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> acousticEqualizer() async {
    LogUtil.v("acousticEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x08;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> rockEqualizer() async {
    LogUtil.v("rockEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x09;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> vocalEqualizer() async {
    LogUtil.v("vocalEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x0A;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }


  static Future<bool> flatEqualizer() async {
    LogUtil.v("flatEqualizer");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x27;
    data[5] = 0x0B;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<void> checkEqualizerStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    LogUtil.v("checkEqualizerStatus");
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x03;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckEqualizerStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckEqualizerStatus) {
        break;
      }
    }
  }

  static Future<void> checkSoundTipsStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    LogUtil.v("checkSoundTipsStatus");
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x05;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckSoundTipsStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckSoundTipsStatus) {
        break;
      }
    }
  }

  //提示灯开关查询
  static Future<void> checkIndicatorLightStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    LogUtil.v("checkIndicatorLightStatus");
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x06;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckIndicatorLightStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckIndicatorLightStatus) {
        break;
      }
    }
  }

  // Sereo/Mono 状态查询
  static Future<void> checkIndicatorLightIsMonoStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    LogUtil.v("checkIndicatorLightIsMonoStatus");
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x07;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckIndicatorLightIsMonoStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckIndicatorLightIsMonoStatus) {
        break;
      }
    }
  }


  static Future<void> checkVolumeLimitStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    LogUtil.v("checkVolumeLimitStatus");
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x08;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckVolumeLimitStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckVolumeLimitStatus) {
        break;
      }
    }
  }



  static Future<bool> updateCustomEqualizerValue(List<int> values) async {
    if (values.length != 6) {
      LogUtil.v("updateCustomEqualizerValue values length error");
      return false;
    }

    LogUtil.v("updateCustomEqualizerValue" + values.toString());
    Uint8List data = Uint8List(13);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x08;
    data[4] = 0x27;
    data[5] = 0x01;
    data[6] = values[0];
    data[7] = values[1];
    data[8] = values[2];
    data[9] = values[3];
    data[10] = values[4];
    data[11] = values[5];
    data[12] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> soundTipsON() async {
    LogUtil.v("soundTipsON");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x29;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  static Future<bool> soundTipsOFF() async {
    LogUtil.v("soundTipsOFF");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x29;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  //指示灯打开
  static Future<bool> indicatorLightON() async {
    LogUtil.v("indicatorLightON");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x2A;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  //指示灯关闭
  static Future<bool> indicatorLightOFF() async {
    LogUtil.v("indicatorLightOFF");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x2A;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }


  //指示灯 Sereo 模式
  static Future<bool> indicatorLightSereoModel() async {
    LogUtil.v("indicatorLightSereoModel");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x2B;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  //指示灯 Mono 模式
  static Future<bool> indicatorLightMonoModel() async {
    LogUtil.v("indicatorLightMonoModel");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x2B;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  //指示灯 Min Limit 模式  0: 0%   1: 25%   2:50%  3:75%
  static Future<bool> indicatorLightMinLimit(int type) async {
    LogUtil.v("indicatorLightMinLimit");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x2C;
    switch (type) {
      case 0:
        data[5] = 0x00;
        break;
      case 1:
        data[5] = 0x01;
        break;
      case 2:
        data[5] = 0x02;
        break;
      case 3:
        data[5] = 0x03;
        break;
      default:
        LogUtil.v("indicatorLightMinLimit invalid type $type");
        return false;
    }
    LogUtil.v("indicatorLightMinLimit type=$type payload=${data[5]}");
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }


  static Future<bool> LightLampStatus(LightLampType lightLampType,
      int lampBrightness, {
      int? redColor,
      int? greenColor,
      int? blueColor,
  }) async {
    LogUtil.v("LightLampStatus");
    Uint8List data = Uint8List(12);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x2D;
    switch(lightLampType) {
      case LightLampType.OFF:
        data[5] = 0x00;
        break;
      case LightLampType.ON:
        data[5] = 0xFF;
        break;
      case LightLampType.CUSTOM:
        data[5] = 0x02;
        break;
      default:
        data[5] = 0x01;
        break;
    }
    data[6] = redColor ?? 0x00;
    data[7] = greenColor ?? 0x00;
    data[8] = blueColor ?? 0x00;
    data[9] = lampBrightness;
    data[10] = 0x06;
    data[11] = 0x16;
    return await Bluebridge.sendMessage(data);
  }


  //查看照明灯/氛围灯播放状态
  static Future<void> checkLightLampStatus(
      {int retryCount = defaultRetryCount, int delay = defaultDelay}) async {
    LogUtil.v("checkLightLampStatus");
    Uint8List data = Uint8List(6);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x02;
    data[3] = 0x01;
    data[4] = 0x06;
    data[5] = 0x16;
    BluetoothController.getInstance().receiveCheckLightLampStatus = false;
    for (int i = 0; i < retryCount; i++) {
      await Bluebridge.sendMessage(data);
      await Future.delayed(Duration(milliseconds: delay));
      if (BluetoothController.getInstance().receiveCheckLightLampStatus) {
        break;
      }
    }
  }

  /// Start Auracast host scan (BP1048 → QCC3095): `A5 5A 01 02 32 01 16`
  /// (confirmed 2026-10-15). Stop is `0x32 0x00`.
  static Future<bool> auracastStartScan() async {
    LogUtil.v("auracastStartScan");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x32;
    data[5] = 0x01;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  /// Stop Auracast scan: `A5 5A 01 02 32 00 16` (protocol §5.2.3).
  static Future<bool> auracastStopScan() async {
    LogUtil.v("auracastStopScan");
    Uint8List data = Uint8List(7);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x32;
    data[5] = 0x00;
    data[6] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

  /// Select Auracast host address: `A5 5A 01 07 2E` + 6-byte addr + `16`.
  static Future<bool> auracastSelectHost(Uint8List address6) async {
    LogUtil.v("auracastSelectHost");
    if (address6.length != 6) {
      LogUtil.v("auracastSelectHost invalid address length ${address6.length}");
      return false;
    }
    Uint8List data = Uint8List(12);
    data[0] = 0xA5;
    data[1] = 0x5A;
    data[2] = 0x01;
    data[3] = 0x07;
    data[4] = 0x2E;
    data[5] = address6[0];
    data[6] = address6[1];
    data[7] = address6[2];
    data[8] = address6[3];
    data[9] = address6[4];
    data[10] = address6[5];
    data[11] = 0x16;
    return await Bluebridge.sendMessage(data);
  }

}
