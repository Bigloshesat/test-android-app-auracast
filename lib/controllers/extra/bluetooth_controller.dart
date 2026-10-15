import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/configs/key_config.dart';
import 'package:base_flutter/configs/router_config.dart';
import 'package:base_flutter/utils/navigator_util.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/activity_manager.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/utils/eventbus_manager.dart';
import 'package:framework/utils/log_util.dart';
import 'package:framework/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../activitys/main_activity.dart';
import '../../activitys/manager_activity.dart';
import '../../activitys/views/check_password_or_tips_dialog.dart';
import '../../configs/blue_command_config.dart';
import '../../configs/event_config.dart';
import '../equalizer_activity_controller.dart';
import '../main_activity_controller.dart';
import '../manager_activity_controller.dart';

enum AdminPasswordStatus {
  UnKnow,
  HaveSet,
  UnSet,
}

enum LightLampType {
  OFF,
  ON,
  CUSTOM,
  RANDOM,
  PRESET2,
  PRESET3,
  PRESET4,
  PRESET5,
  PRESET6,
  PRESET7,
  PRESET8,
}

/// One Auracast broadcast host reported by BP1048 (param 0x32 notify).
class AuracastHost {
  AuracastHost({required this.name, required this.address});

  final String name;
  final Uint8List address; // 6 bytes

  String get addressKey {
    final b = StringBuffer();
    for (var i = 0; i < address.length; i++) {
      if (i > 0) b.write(':');
      b.write(address[i].toRadixString(16).padLeft(2, '0').toUpperCase());
    }
    return b.toString();
  }

  String get addressHex {
    final b = StringBuffer();
    for (final byte in address) {
      b.write(byte.toRadixString(16).padLeft(2, '0').toUpperCase());
    }
    return b.toString();
  }
}

class BluetoothController extends ChangeNotifier {
  bool isInit = false;

  bool isDiscovering = false;

  final List<BluetoothInfo> bluetoothInfos = [];
  final List<BluetoothInfo> bluetoothConnectInfos = [];
  final List<BluetoothInfo> otherBluetoothInfos = [];

  //StreamSubscription<BluetoothInfo> streamSubscriptionBluetoothInfo;
  StreamSubscription<ConnectResponse>? streamSubscriptionConnectResponse;

  AdminPasswordStatus adminPasswordStatus = AdminPasswordStatus.UnKnow;
  bool isVerificationAdminPassword = false;
  int volume = 0;
  bool isPlaying = false;
  bool isPinOn = false;
  bool isLitheLinkOn = false;
  bool isLitheLinkConnect = false;
  bool isInitPlayStatus = false;
  bool isInitSelectModeStatus = false;
  bool isInitPinStatus = false;
  bool isHaveAux = false;
  bool isEqualizerOn = false;
  bool isEqualizerReturn = false;
  bool isHaveLitheLink = false;
  bool isSoundTipsOn = false;
  bool isIndicatorLightOn = false;
  bool isMono = false;
  int volumeLimit = -1; //-1为未选中任何，也就是没有查询到结果
  List<int> playStatusList = []; //设备支持的播放状态  0：不支持， 1：支持

  bool receiveCheckPlayStatus = false;
  bool receiveCheckPingStatus = false;
  bool receiveCheckAdminStatus = false;
  bool receiveCheckAdminPassword = false;
  bool receiveCheckEqualizerStatus = false;
  bool receiveCheckLinkStatus = false;
  bool receiveCheckSoundTipsStatus = false;
  bool receiveCheckIndicatorLightStatus = false; //指示灯开关
  bool receiveCheckIndicatorLightIsMonoStatus = false; //指示灯模式
  bool receiveCheckVolumeLimitStatus = false; //音量限制
  bool receiveCheckProductStatus = false; //产品信息

  bool needShowRebootTips = false;

  BluetoothInfo? connectBluetoothInfo;
  String? selectMode;

  EqualizerType? selectEqualizerMode;
  int versionCode = 0;
  String? firmware; //固件版本
  String? hardware; //硬件版本
  String productModel = ""; //产品型号

  final List<int> equalizerValues = [];

  bool isLightLampOn = false; //照明灯开
  LightLampType lightLampStyle = LightLampType.OFF; //照明灯关
  int lightLampRedColor = 0; //照明灯颜色
  int lightLampGreenColor = 0;
  int lightLampBlueColor = 0;
  int lightLampBrightness = 0; //照明灯亮度
  int lightLampColorTemperature = 0; //照明灯色温
  bool receiveCheckLightLampStatus = false; //获取照明灯/氛围灯

  /// Auracast hosts from 0x32 notifies (cleared when a new scan starts).
  final List<AuracastHost> auracastHosts = [];

  static BluetoothController getInstance() {
    return Provider.of<BluetoothController>(
        AppConfig.navigatorStateKey.currentContext!,
        listen: false);
  }

  Future<void> initBluebridge() async {
    await Bluebridge.requestEnable();
    await Bluebridge.init();
    isInit = true;
  }

  Future<void> destoryBluebridge() async {
    cancelStreamSubscription();
    await Bluebridge.destory();
  }

  Future<void> reboot() async {
    // if (Platform.isIOS) {
    //   await iosDisConnectBluetooth(null, clearAll: true);
    // } else {
    //   await disConnectBluetooth(null, clearAll: true,sendDisConnectCmd: false);
    // }
    await disConnectBluetooth(null, clearAll: true, sendDisConnectCmd: false);
    await BlueCommandConfig.reboot();
  }

  void cancelStreamSubscription() {
    if (streamSubscriptionConnectResponse != null) {
      streamSubscriptionConnectResponse!.cancel();
      streamSubscriptionConnectResponse = null;
    }
  }

  // 临时做法，先copy一份，做ios调用逻辑，后续再修改
  // 2023-06-10 废弃，ios android 统一，disConnect通过参数传递
  Future<void> iosDisConnectBluetooth(BluetoothInfo? bluetoothInfo,
      {bool clearAll = false}) async {
    // await Bluebridge.disConnect();
    if (clearAll) {
      bluetoothConnectInfos.clear();
    } else {
      _removeConnectBluetoothInfos(bluetoothInfo);
    }
    _resetConnectInfo();
    _updateOtherInfos();
    connectBluetoothInfo = null;
    notifyListeners();
  }

  Future<void> disConnectBluetooth(BluetoothInfo? bluetoothInfo,
      {bool clearAll = false, bool sendDisConnectCmd = true}) async {
    if (sendDisConnectCmd) {
      await Bluebridge.disConnect();
    }
    if (clearAll) {
      bluetoothConnectInfos.clear();
    } else {
      _removeConnectBluetoothInfos(bluetoothInfo);
    }
    _resetConnectInfo();
    _updateOtherInfos();
    connectBluetoothInfo = null;
    notifyListeners();
  }

  Future<void> startDiscovery() async {
    if (isDiscovering) {
      return;
    }
    isDiscovering = true;
    notifyListeners();
    List<BluetoothInfo> searchBluetoothInfos = await Bluebridge.searchDevices();
    bluetoothInfos.clear();
    searchBluetoothInfos.forEach((item) {
      String mac = item.device?.address ?? "";
      if (Platform.isIOS) {
        bluetoothInfos.add(item);
      } else {
        // if (mac.toLowerCase().startsWith("4c:55") ||
        //     mac.toLowerCase().startsWith("b3:aa")) {
        if (mac.toLowerCase().startsWith("b3:aa")) {
          bluetoothInfos.add(item);
        }
        // if (mac.toLowerCase().startsWith("b3:aa")) {
        //   bluetoothInfos.add(item);
        // }
        // bluetoothInfos.add(item);
      }
    });
    _updateConnectBluetoothInfos();
    _updateOtherInfos();

    (ActivityManager().getTargetActivity<MainActivityState>()?.baseController
            as MainActivityController)
        .showBluetoothInfoList();

    isDiscovering = false;
    notifyListeners();
//    streamSubscriptionBluetoothInfo =Bluebridge.startDiscovery().listen((result) {
//      if(!bluetoothInfos.contains(result)){
//        bluetoothInfos.add(result);
//        notifyListeners();
//      }
//    });
//    streamSubscriptionBluetoothInfo.onDone(() {
//      isDiscovering = false;
//      notifyListeners();
//    });
//    streamSubscriptionBluetoothInfo.onError((Object error) {
//      isDiscovering = false;
//      notifyListeners();
//    });
  }

  void connectDevice(BluetoothInfo bluetoothInfo) {
    String mac = bluetoothInfo.device?.address ?? "";
    connectBluetoothInfo = bluetoothInfo;
    cancelStreamSubscription();
    streamSubscriptionConnectResponse =
        Bluebridge.connect(mac).listen((result) {
      if (result.operate == null) {
        return;
      }
      int operate = result.operate!;
      switch (operate) {
        case ConnectResponse.onWriteInitDescriptorStatus:
          break;
        case ConnectResponse.onNotifyInitStatus:
          break;
        case ConnectResponse.onNotify:
          _processNotify(result);
          break;
        case ConnectResponse.onConnectStatusChanged:
          break;
        case ConnectResponse.onConnected:
          LogUtil.v("connencted");
          _sendConnectResponse(mac, bluetoothInfo, true);
          //if use callback will lead to mainActivity memory leakage so use eventbus instand of

          _addConnectBluetoothInfos(bluetoothInfo);
          _updateOtherInfos();
          _resetConnectInfo();
          notifyListeners();
          break;
        case ConnectResponse.onDisconnected:
          LogUtil.v("disconnencted");
          // add disconnect
          ToastUtil.showShortToast(AppConfig.appS.disconnect_tips);

          _removeConnectBluetoothInfos(bluetoothInfo);
          _updateOtherInfos();
          notifyListeners();
          break;
        case ConnectResponse.onConnectedError:
          _sendConnectResponse(mac, bluetoothInfo, false);
          break;
        default:
          break;
      }
    });
    streamSubscriptionConnectResponse?.onDone(() {
      notifyListeners();
    });
  }

  void _processNotify(ConnectResponse result) {
    Uint8List bytes = result.bytes!;
    bool isIndicate = result.isIndicate ?? false;
    if (!isIndicate) {
      return;
    }
    if (bytes[0] == 0xA5 && bytes[1] == 0x5A) {
      print(bytes);
      int command1 = bytes[2];
      switch (command1) {
        case 0x00: // 固件信息
          if (bytes[9] == 0xff) {
            //need set password
            adminPasswordStatus = AdminPasswordStatus.UnSet;
          } else {
            adminPasswordStatus = AdminPasswordStatus.HaveSet;
          }
          // 固件版本  bytes[4].bytes[5].bytes[6]
          // 客户识别码 bytes[8]
          firmware = "${bytes[4]}.${bytes[5]}.${bytes[6]}";
          versionCode = bytes[7]; // 产品识别码
          receiveCheckAdminStatus = true;
          break;
        case 0x01:
          // 修改、设置eq的返回值处理；Auracast 扫描主机回报亦走控制字 0x01
          int dataLength = bytes[3];
          int command2 = bytes[4];
          if (command2 == 0x32) {
            // Auracast scan result: name + " : " + 6-byte addr (§5.2.3)
            _parseAuracastHostNotify(bytes, dataLength);
            break;
          }
          int type = bytes[5];
          if (command2 == 0x27) {
            // eq处理
            if (dataLength == 8) {
              _convertEqualizerType(type);
              _convertEqualizerValues(bytes);
              // 增益字节带上的时候都要更新状态，不带的时候不需要更新
              updateEqualizerStatus();
            } else if (dataLength == 3) {
              // eq修改和关闭eq的返回，暂时不用返回的状态。
            }
            // if(type!=0x01){
            //   updateEqualizerStatus();
            // }
          }
          isEqualizerReturn = true;
          break;
        case 0x02:
          int command2 = bytes[4];
          if (command2 == 0x00) {
            // 播放状态
            int type = bytes[5];

            int vol = 0;
            // 产品识别码 大于等于 0x82 直接使用蓝牙的音量字段
            // if (versionCode >= 130) {
            //   // 这里暂时判定都为true
            //   vol = bytes[7];
            // } else {
            //   if (type == 0) {
            //     vol = bytes[7];
            //   }
            //   if (type == 1 || type == 2) {
            //     vol = bytes[8];
            //   }
            //   if (type == 3) {
            //     vol = bytes[7];
            //   }
            // }
            vol = bytes[7];
            // if (type == 0 || type == 1 || type == 2 || type == 3|| type == 4) {
            selectMode = type.toString();
            // }
            volume = vol;
            LogUtil.v("volume_notify$volume");

            int playStatus = bytes[6];
            if (playStatus == 1) {
              isPlaying = true;
            } else {
              isPlaying = false;
            }

            /// 音量都改成bytes[7]了 ！！！！！
            /// 音源模式为bytes[9]（高8位） 和bytes[8]（低8位） 拼成的16位 比特运算获取是否显示对应的10个音源模式
            if (bytes.length >= 10) {
              List<int> lowList = decimalToBinaryArray(bytes[8]);
              List<int> highList = decimalToBinaryArray(bytes[9]);
              playStatusList = (highList + lowList).reversed.toList();
              // // 00000000 8位比特位计算，是否为1： (number & (1 << bitPosition)) != 0
              // if ((bytes[9] & (1 << 0)) != 0) {
              //   isHaveAux = true;
              // } else {
              //   isHaveAux = false;
              // }
              // if ((bytes[9] & (1 << 1)) != 0) {
              //   isHaveLitheLink = true;
              // } else {
              //   isHaveLitheLink = false;
              // }
            }

            isInitPlayStatus = true;
            receiveCheckPlayStatus = true;
            updateVolumeManagerStatus();
          } else if (command2 == 0x01) {
            // 蓝牙密码查询状态
            if (bytes[5] == 0xff) {
              isPinOn = false;
            } else {
              isPinOn = true;
            }
            isInitPinStatus = true;
            receiveCheckPingStatus = true;
          } else if (command2 == 0x02) {
            // 管理员密码校对
            if (bytes[5] == 0x01) {
              //validate admin password success
              isVerificationAdminPassword = true;
            } else {
              isVerificationAdminPassword = false;
            }
            receiveCheckAdminPassword = true;
          } else if (command2 == 0x03) {
            // 查询当前EQ
            if (bytes[5] == 0x00) {
              isEqualizerOn = false;
              clearEqualizerValuesWhenClose();
            } else {
              isEqualizerOn = true;
              _convertEqualizerType(bytes[5]);
              _convertEqualizerValues(bytes);
            }
            updateEqualizerStatus();
            receiveCheckEqualizerStatus = true;
          } else if (command2 == 0x04) {
            // 查询菊花链
            switch (bytes[5]) {
              case 0x00:
                isLitheLinkOn = false;
                isLitheLinkConnect = false;
                break;
              case 0x01:
                isLitheLinkOn = true;
                isLitheLinkConnect = false;
                break;
              case 0x10:
                isLitheLinkOn = false;
                isLitheLinkConnect = true;
                break;
              case 0x11:
                isLitheLinkOn = true;
                isLitheLinkConnect = true;
                break;
            }
            updateLitheLinkStatus();
            receiveCheckLinkStatus = true;
          } else if (command2 == 0x05) {
            // 查询提示音状态
            switch (bytes[5]) {
              case 0x00:
                isSoundTipsOn = false;
                break;
              case 0x01:
                isSoundTipsOn = true;
                break;
            }
            updateSoundTipsStatus();
            receiveCheckSoundTipsStatus = true;
          } else if (command2 == 0x06) {
            // 获取指示灯状态
            switch (bytes[5]) {
              case 0x00:
                isIndicatorLightOn = false;
                break;
              case 0x01:
                isIndicatorLightOn = true;
                break;
            }
            updateIndicatorLightStatus();
            receiveCheckIndicatorLightStatus = true;
          } else if (command2 == 0x07) {
            // 获取Sereo/Mono状态
            switch (bytes[5]) {
              case 0x00:
                isMono = false;
                break;
              case 0x01:
                isMono = true;
                break;
            }
            updateIndicatorLightIsMonoStatus();
            receiveCheckIndicatorLightIsMonoStatus = true;
          } else if (command2 == 0x08) {
            // 获取指示Limit状态
            switch (bytes[5]) {
              case 0x00:
                volumeLimit = 0;
                break;
              case 0x01:
                volumeLimit = 1;
                break;
              case 0x10:
                volumeLimit = 2;
                break;
              case 0x11:
                volumeLimit = 3;
                break;
            }
            updateVolumeLimitStatus();
            receiveCheckVolumeLimitStatus = true;
          } else if (command2 == 0x09) {
            switch (bytes[5]) {
              case 0x02:
                lightLampStyle = LightLampType.CUSTOM;
                break;
              case 0x04:
                lightLampStyle = LightLampType.PRESET2;
                break;
              case 0x05:
                lightLampStyle = LightLampType.PRESET3;
                break;
              case 0x06:
                lightLampStyle = LightLampType.PRESET4;
                break;
              default:
                lightLampStyle = LightLampType.CUSTOM;
                break;
            }
            lightLampRedColor = bytes[6];
            lightLampGreenColor = bytes[7];
            lightLampBlueColor = bytes[8];
            lightLampBrightness = bytes[9];
            lightLampColorTemperature = bytes[10];
            lightLampColorTemperature = bytes[10];
            updateLightLampStatus();
            receiveCheckLightLampStatus = true;
          }
          break;
        case 0xfe: // 产品信息获取
          int dataLength = bytes[3];
          int command2 = bytes[4];
          if (command2 == 0xa0) {
            // 硬件版号
            hardware = "${bytes[5]}.${bytes[6]}.${bytes[7]}";
            //产品型号
            if (bytes.length > 9) {
              productModel = "";
              for (var i = 8; i < bytes.length - 1; ++i) {
                productModel = productModel + String.fromCharCode(bytes[i]);
              }
            }
          }
          receiveCheckProductStatus = true;
      }
    }
  }

  void _convertEqualizerType(int type) {
    switch (type) {
      case 1:
        selectEqualizerMode = EqualizerType.CUSTOM;
        break;
      case 2:
        selectEqualizerMode = EqualizerType.POP;
        break;
      case 3:
        selectEqualizerMode = EqualizerType.CLASSICAL;
        break;
      case 4:
        selectEqualizerMode = EqualizerType.LOUNGE;
        break;
      case 5:
        selectEqualizerMode = EqualizerType.DANCE;
        break;
      case 6:
        selectEqualizerMode = EqualizerType.JAZZ;
        break;
      case 7:
        selectEqualizerMode = EqualizerType.HIP_HOP;
        break;
      case 8:
        selectEqualizerMode = EqualizerType.ACOUSTIC;
        break;
      case 9:
        selectEqualizerMode = EqualizerType.ROCK;
        break;
      case 10:
        selectEqualizerMode = EqualizerType.VOCAL;
        break;
      case 11:
        selectEqualizerMode = EqualizerType.FLAT;
        break;
      default:
        break;
    }
  }

  void _convertEqualizerValues(Uint8List bytes) {
    if (bytes.length < 12) {
      return;
    }
    equalizerValues.clear();
    for (int i = 6; i < 12; i++) {
      equalizerValues.add(bytes[i]);
    }
  }

  void updateEqualizerValues(List<int> bytes) {
    _convertEqualizerValues(Uint8List.fromList(bytes));
  }

  void clearEqualizerValuesWhenClose() {
    equalizerValues.clear();
  }

  void _sendConnectResponse(
      String mac, BluetoothInfo bluetoothInfo, bool result) {
    Map<String, dynamic> response = {};
    response[KeyConfig.blue_bridge_mac_key] = mac;
    response[KeyConfig.blue_bridge_bluetooth_key] = bluetoothInfo;
    response[KeyConfig.blue_bridge_connect_result_key] = result;
    EventBusManager().send(EventConfig.event_connect_response, response);
  }

  void _resetConnectInfo() {
    adminPasswordStatus = AdminPasswordStatus.UnKnow;
    isVerificationAdminPassword = false;
    volume = 0;
    isPlaying = false;
    isPinOn = false;
    isLitheLinkOn = false;
    isLitheLinkConnect = false;
    isInitPlayStatus = false;
    isInitSelectModeStatus = false;
    isInitPinStatus = false;
    selectMode = null;
    isEqualizerOn = false;
    isEqualizerReturn = false;
    selectEqualizerMode = null;
    versionCode = 0;
    equalizerValues.clear();
  }

  void _addConnectBluetoothInfos(BluetoothInfo bluetoothInfo) {
    bluetoothConnectInfos.clear();
    bluetoothConnectInfos.add(bluetoothInfo);
  }

  void _removeConnectBluetoothInfos(BluetoothInfo? bluetoothInfo) {
    if (bluetoothInfo == null) {
      return;
    }
    for (int i = 0; i < bluetoothConnectInfos.length; i++) {
      BluetoothInfo bluetoothConnectInfo = bluetoothConnectInfos[i];
      if (bluetoothInfo.device?.address ==
          bluetoothConnectInfo.device?.address) {
        bluetoothConnectInfos.remove(bluetoothConnectInfo);
        break;
      }
    }
  }

  void _updateOtherInfos() {
    otherBluetoothInfos.clear();
    otherBluetoothInfos.addAll(bluetoothInfos);
    List<BluetoothInfo> needRemoveBluetoothInfos = [];
    bluetoothConnectInfos.forEach((bluetoothConnectInfo) {
      bluetoothInfos.forEach((bluetoothInfo) {
        if (bluetoothConnectInfo.device?.address ==
            bluetoothInfo.device?.address) {
          needRemoveBluetoothInfos.add(bluetoothInfo);
        }
      });
    });
    needRemoveBluetoothInfos.forEach((bluetoothInfo) {
      otherBluetoothInfos.remove(bluetoothInfo);
    });
  }

  void _updateConnectBluetoothInfos() {
    List<BluetoothInfo> needUpdateBluetoothInfos = [];
    bluetoothConnectInfos.forEach((bluetoothConnectInfo) {
      bluetoothInfos.forEach((bluetoothInfo) {
        if (bluetoothConnectInfo.device?.address ==
            bluetoothInfo.device?.address) {
          needUpdateBluetoothInfos.add(bluetoothInfo);
        }
      });
    });
    bluetoothConnectInfos.clear();
    bluetoothConnectInfos.addAll(needUpdateBluetoothInfos);
  }

  bool get isEmpty =>
      isInit &&
      !isDiscovering &&
      bluetoothInfos.length == 0 &&
      bluetoothConnectInfos.length == 0;

  Future<AdminPasswordStatus> checkAdminStatus() async {
    if (adminPasswordStatus != AdminPasswordStatus.UnKnow) {
      return adminPasswordStatus;
    }
    await BlueCommandConfig.checkAdminStatus(retryCount: 2);
    return adminPasswordStatus;
  }

  Future<bool> checkAdminPassword(String password) async {
    isVerificationAdminPassword = false;
    await BlueCommandConfig.checkAdminPassword(password);
    return isVerificationAdminPassword;
  }

  Future<Map<String, dynamic>> checkPlayStatus() async {
    await BlueCommandConfig.checkPlayStatus();
    return getResponseStatus();
  }

  Future<Map<String, dynamic>> checkPlayAndEqualizerStatus() async {
    await BlueCommandConfig.checkPlayStatus();
    await BlueCommandConfig.checkEqualizerStatus();
    return getResponseStatus();
  }

  Future<Map<String, dynamic>> checkLightLampStatus() async {
    await BlueCommandConfig.checkLightLampStatus();
    return getLightLampStatus();
  }

  Future<bool> checkPinStatus() async {
    await BlueCommandConfig.checkPingStatus();
    return isPinOn;
  }

  Future<bool> checkLitheLinkStatus() async {
    await BlueCommandConfig.checkLitheLinkStatus();
    return isLitheLinkOn;
  }

  Future<bool> checkSoundTipsStatus() async {
    await BlueCommandConfig.checkSoundTipsStatus();
    return isSoundTipsOn;
  }

  Future<bool> checkIndicatorLightStatus() async {
    await BlueCommandConfig.checkIndicatorLightStatus();
    return isIndicatorLightOn;
  }

  Future<bool> checkIndicatorLightIsMonoStatus() async {
    await BlueCommandConfig.checkIndicatorLightIsMonoStatus();
    return isMono;
  }

  Future<int> checkVolumeLimitStatus() async {
    await BlueCommandConfig.checkVolumeLimitStatus();
    return volumeLimit;
  }

  Map<String, dynamic> getLightLampStatus() {
    Map<String, dynamic> response = {};
    response[KeyConfig.light_lamp_is_on_key] = isLightLampOn;
    response[KeyConfig.light_lamp_style_key] = lightLampStyle;
    response[KeyConfig.light_lamp_red_color_key] = lightLampRedColor;
    response[KeyConfig.light_lamp_green_color_key] = lightLampGreenColor;
    response[KeyConfig.light_lamp_blue_color_key] = lightLampBlueColor;
    response[KeyConfig.light_lamp_brightness_key] = lightLampBrightness;
    response[KeyConfig.light_lamp_color_temperature_key] =
        lightLampColorTemperature;
    return response;
  }

  Map<String, dynamic> getResponseStatus() {
    Map<String, dynamic> response = {};
    response[KeyConfig.blue_bridge_is_playing_key] = isPlaying;
    response[KeyConfig.blue_bridge_volume_key] = volume;
    response[KeyConfig.blue_bridge_bluetooth_mode_key] = selectMode;
    response[KeyConfig.blue_bridge_is_equalizer_on_key] = isEqualizerOn;
    response[KeyConfig.blue_bridge_equalizer_mode_key] = selectEqualizerMode;
    response[KeyConfig.blue_bridge_equalizer_value_key] = equalizerValues;
    response[KeyConfig.blue_bridge_is_sound_tips_on_key] = isSoundTipsOn;
    response[KeyConfig.indicator_light_is_indicator_light_on_key] =
        isIndicatorLightOn;
    response[KeyConfig.indicator_light_is_mono_on_key] = isMono;
    response[KeyConfig.indicator_light_volume_limit_key] = volumeLimit;
    return response;
  }

  void updateVolumeManagerStatus() {
    EventBusManager()
        .send(EventConfig.event_update_play_status, getResponseStatus());
  }

  void updateEqualizerStatus() {
    EventBusManager()
        .send(EventConfig.event_update_equalizer_status, getResponseStatus());
  }

  void updateLitheLinkStatus() {
    EventBusManager()
        .send(EventConfig.event_update_lithe_link_status, getResponseStatus());
  }

  void updateSoundTipsStatus() {
    EventBusManager()
        .send(EventConfig.event_update_sound_tips_status, getResponseStatus());
  }

  void updateIndicatorLightStatus() {
    EventBusManager().send(
        EventConfig.event_update_indicator_light_status, getResponseStatus());
  }

  void updateIndicatorLightIsMonoStatus() {
    EventBusManager().send(
        EventConfig.event_update_indicator_light_is_mono_status,
        getResponseStatus());
  }

  void updateVolumeLimitStatus() {
    EventBusManager().send(
        EventConfig.event_update_indicator_light_video_limit_status,
        getResponseStatus());
  }

  void updateLightLampStatus() {
    EventBusManager()
        .send(EventConfig.event_update_light_lamp_status, getLightLampStatus());
  }

  void clearAuracastHosts() {
    auracastHosts.clear();
    updateAuracastHosts();
  }

  void updateAuracastHosts() {
    EventBusManager().send(EventConfig.event_update_auracast_hosts, null);
    notifyListeners();
  }

  /// Parse notify: A5 5A 01 Len 32 <name> 20 3A 20 <6-byte addr> 16
  void _parseAuracastHostNotify(Uint8List bytes, int dataLength) {
    // Need: header(4) + dataLength + end(1)
    if (bytes.length < 4 + dataLength + 1) {
      LogUtil.v("auracast notify truncated len=$dataLength bytes=${bytes.length}");
      return;
    }
    if (dataLength < 1 + 3 + 6) {
      // min: param + " : " + addr
      LogUtil.v("auracast notify dataLength too small $dataLength");
      return;
    }
    final data = bytes.sublist(4, 4 + dataLength);
    if (data[0] != 0x32) return;
    // Find ASCII separator " : " (0x20 0x3A 0x20)
    var sep = -1;
    for (var i = 1; i + 2 < data.length - 6; i++) {
      if (data[i] == 0x20 && data[i + 1] == 0x3A && data[i + 2] == 0x20) {
        sep = i;
        break;
      }
    }
    if (sep < 0) {
      LogUtil.v("auracast notify missing name/addr separator");
      return;
    }
    final nameBytes = data.sublist(1, sep);
    final addrStart = sep + 3;
    if (addrStart + 6 > data.length) {
      LogUtil.v("auracast notify address truncated");
      return;
    }
    final name = String.fromCharCodes(nameBytes);
    final address = Uint8List.fromList(data.sublist(addrStart, addrStart + 6));
    final host = AuracastHost(name: name, address: address);
    final key = host.addressKey;
    final existing = auracastHosts.indexWhere((h) => h.addressKey == key);
    if (existing >= 0) {
      auracastHosts[existing] = host;
    } else {
      auracastHosts.add(host);
    }
    LogUtil.v("auracast host name=$name addr=$key");
    updateAuracastHosts();
  }

  @override
  void dispose() async {
    await destoryBluebridge();
    super.dispose();
  }

  static Future<void> showRebootTipsDialog(BaseActivityState baseActivityState,
      BuildContext context, VoidCallback ok, VoidCallback cancel,
      {bool showDialogTips = false, bool showRightButton = true}) async {
    if (showDialogTips) {
      await showDialog(
        context: context,
        builder: (_) {
          return CheckPasswordOrTipsDialog(
            title: AppConfig.appS.tip,
            content: AppConfig.appS.dialog_reboot_tips,
            showInput: false,
            showRightButton: showRightButton,
            leftButtonClick: (text) async {
              NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);

              baseActivityState.baseDialogController
                  ?.show(AppConfig.appS.loading);
              await BluetoothController.getInstance().reboot();
              baseActivityState.baseDialogController?.hide();

              BluetoothController.getInstance().needShowRebootTips = false;

              WidgetsBinding.instance.addPostFrameCallback((callback) async {
                ok.call();
              });
            },
            rightButtonClick: () async {
              NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
              cancel.call();
            },
          );
        },
      );
    } else {
      baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
      await BluetoothController.getInstance().reboot();
      baseActivityState.baseDialogController?.hide();

      BluetoothController.getInstance().needShowRebootTips = false;

      WidgetsBinding.instance.addPostFrameCallback((callback) async {
        ok.call();
      });
    }
  }

  static Future<void> showReconnectDialog(BaseActivityState baseActivityState,
      BuildContext context, VoidCallback result) async {
    await showDialog(
      context: context,
      builder: (_) {
        return CheckPasswordOrTipsDialog(
          title: AppConfig.appS.dialog_reconnect_tips,
          content: AppConfig.appS.dialog_reconnect_hint,
          showInput: false,
          showRightButton: true,
          leftButtonClick: (text) async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            WidgetsBinding.instance.addPostFrameCallback((callback) async {
              result.call();
            });
          },
          rightButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
          },
        );
      },
    );
  }

  static Future<void> updateReconnectStatus(
      BaseActivityState baseActivityState, BuildContext context,
      {bool showDialog = false}) async {
    if (showDialog) {
      await showReconnectDialog(baseActivityState, context, () async {
        NavigatorUtil.popUntil(context, ActivityName.MainActivity);
        await (ActivityManager()
                .getTargetActivity<MainActivityState>()
                ?.baseController as MainActivityController)
            .startSearch();
        // BluetoothController.getInstance().startDiscovery();
      });
    } else {
      NavigatorUtil.popUntil(context, ActivityName.MainActivity);
      await (ActivityManager()
              .getTargetActivity<MainActivityState>()
              ?.baseController as MainActivityController)
          .startSearch();
    }
  }

  void setNewConnectDeviceName(String text) {
    connectBluetoothInfo?.device?.name = text;
    (ActivityManager().getTargetActivity<ManagerActivityState>()?.baseController
            as ManagerActivityController)
        .refresh();
    notifyListeners();
  }

  //将10进制转化为二进制数组
  List<int> decimalToBinaryArray(int decimal) {
    if (decimal < 0) return [];

    // 转换为二进制字符串
    String binaryStr = decimal.toRadixString(2);

    // 计算需要补零的数量
    int padding = (4 - binaryStr.length % 4) % 4;
    if (padding == 0 && binaryStr.isEmpty) padding = 4; // 处理0的情况

    // 高位补零
    String padded = '0' * padding + binaryStr;

    // 转换为整数数组
    return padded.split('').map((s) => int.parse(s)).toList();
  }
}
