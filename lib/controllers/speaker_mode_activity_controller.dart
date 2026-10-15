import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/eventbus_manager.dart';

import '../activitys/views/switch_status_view.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/event_config.dart';
import '../configs/key_config.dart';
import '../models/extra/key_value.dart';
import '../resources/s_colors.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

enum SpeakerModeType { AUTOMATIC, BLUETOOTH, RCA, AUX, OPTICAL, WIFI, UDISK, HDMI, FM_RADIO, SAME_TRACK}

class SpeakerModeActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;

  final GlobalKey<SwitchStatusViewState> switchStatusViewStateKey =
      GlobalKey<SwitchStatusViewState>();
  final List<KeyValue> speakerModes = [];
  final List<KeyValue> normalSpeakerModes = [];
  List<int> playStatusList = [];

  bool isPlaying = false;
  String? selectMode;
  int selectSpeakerModeIndex = 0;
  bool isSoundTipsOn = false;



  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    getBluetoothStatusInfo();

    initNormalSpeakerModes();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {

      // if (selectMode == null) {
      baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
      await checkPlayStatus();
      baseActivityState.baseDialogController?.hide();
      if (isSupportSoundTips()) {
        await checkSoundTipsStatus();
      }
      updateSpeakerModes();
      // }
    });

    EventBusManager().on(EventConfig.event_update_play_status, (arg) {
      getBluetoothStatusInfo();
      updateSpeakerModes();
    });
  }

  bool isSupportSoundTips() {
    return true;
    // 85或者 86显示
    // return bluetoothController.versionCode == 133 ||
    //     bluetoothController.versionCode == 134;
  }

  Future<void> checkSoundTipsStatus() async {
    isSoundTipsOn = await bluetoothController.checkSoundTipsStatus();
    switchStatusViewStateKey.currentState?.updateEnable(isSoundTipsOn);
    notifyListeners();
  }

  Future<void> changeVoicePromptStatus(bool status) async {
    if (status) {
      await BlueCommandConfig.soundTipsON();
    } else {
      await BlueCommandConfig.soundTipsOFF();
    }
    isSoundTipsOn = status;
    bluetoothController.isSoundTipsOn = isSoundTipsOn;
    notifyListeners();
  }

  void updateSpeakerModes() {
    initSpeakerModes();
    notifyListeners();
  }

  //预留的播放状态列表
  void initNormalSpeakerModes() {
    normalSpeakerModes.clear();
    normalSpeakerModes.add(KeyValue(
      key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_bluetooth,
      value: SpeakerModeType.BLUETOOTH,
      object: "0"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_aux,
        value: SpeakerModeType.AUX,
        object: "1"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_rca,
        value: SpeakerModeType.RCA,
        object: "2"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_automatic,
        value: SpeakerModeType.AUTOMATIC,
        object: "3"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_optical,
        value: SpeakerModeType.OPTICAL,
        object: "4"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_wifi,
        value: SpeakerModeType.WIFI,
        object: "5"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_udisk,
        value: SpeakerModeType.UDISK,
        object: "6"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_hdmi,
        value: SpeakerModeType.HDMI,
        object: "7"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_fm,
        value: SpeakerModeType.FM_RADIO,
        object: "8"
    ));
    normalSpeakerModes.add(KeyValue(
        key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_same_track,
        value: SpeakerModeType.HDMI,
        object: "9"
    ));
  }

  void initSpeakerModes() {
    speakerModes.clear();
    for (var i = 0; i < playStatusList.length; ++i) {
      if(i >= normalSpeakerModes.length) break;
      if(playStatusList[i] == 1) {
        speakerModes.add(normalSpeakerModes[i]);
      }
    }
    // speakerModes.add(KeyValue(
    //     key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_automatic,
    //     value: SpeakerModeType.AUTOMATIC,
    //     object: "3"));
    // speakerModes.add(KeyValue(
    //     key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_bluetooth,
    //     value: SpeakerModeType.BLUETOOTH,
    //     object: "0"));
    // speakerModes.add(
    //   KeyValue(
    //       key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_rca,
    //       value: SpeakerModeType.RCA,
    //       object: "1"),
    // );
    // speakerModes.add(
    //   KeyValue(
    //       key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_aux,
    //       value: SpeakerModeType.AUX,
    //       object: "2"),
    // );
    // if (bluetoothController.isHaveLitheLink == true) {
    //   speakerModes.add(KeyValue(
    //       key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_optical,
    //       value: SpeakerModeType.OPTICAL,
    //       object: "4"));
    // }
    // if (bluetoothController.versionCode == 132 ||
    //     bluetoothController.versionCode == 133) {
    //   // 版本  0X84 0X85
    //   speakerModes.add(
    //     KeyValue(
    //         key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_aux,
    //         value: SpeakerModeType.AUX,
    //         object: "2"),
    //   );
    // } else {
    //   // 版本 0X83, 0X86 , 小于83的不用管，外面菜单进不来
    //   speakerModes.add(
    //     KeyValue(
    //         key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_rca,
    //         value: SpeakerModeType.RCA,
    //         object: "1"),
    //   );
    //   // 产品识别码 大于等于 0x83 并且菊花链开关要打开的才显示这个选项
    //   if (bluetoothController.isHaveLitheLink == true) {
    //     speakerModes.add(KeyValue(
    //         key: AppConfig.appS.speaker_mode_activity_bluetooth_mode_optical,
    //         value: SpeakerModeType.OPTICAL,
    //         object: "4"));
    //   }
    // }
    updateSpeakerModeIndex();
  }

  void updateSpeakerModeIndex() {
    if (selectMode == null) {
      return;
    }
    for (int i = 0; i < speakerModes.length; i++) {
      KeyValue keyValue = speakerModes[i];
      if (selectMode == keyValue.object) {
        selectSpeakerModeIndex = i;
        break;
      }
    }
  }

  Color? getSpeakerModeTagColor(KeyValue value) {
    Color? color;
    switch (value.object) {
      case "0":
        color = SColors.mode_tag_color_0;
        break;
      case "1":
        color = SColors.mode_tag_color_1;
        break;
      case "2":
        color = SColors.mode_tag_color_2;
        break;
      case "3":
        color = SColors.mode_tag_color_3;
        break;
      case "4":
        color = SColors.mode_tag_color_4;
        break;
      default:
        break;
    }
    return color;
  }

  void getBluetoothStatusInfo() {
    isPlaying = bluetoothController.isPlaying;
    selectMode = bluetoothController.selectMode;
  }

  String getDeviceName() {
    return bluetoothInfo?.device?.name ?? "";
  }

  Future<void> checkPlayStatus() async {
    Map<String, dynamic> data = await bluetoothController.checkPlayStatus();
    playStatusList = bluetoothController.playStatusList;
    isPlaying = data[KeyConfig.blue_bridge_is_playing_key];
    selectMode = data[KeyConfig.blue_bridge_bluetooth_mode_key];
    initSpeakerModes();
    notifyListeners();
  }

  Future<void> changeMode(int index, KeyValue keyValue) async {
    selectSpeakerModeIndex = index;
    String value = keyValue.object;
    bluetoothController.selectMode = value;
    int? speakModel = int.tryParse(value);
    if(speakModel != null) await BlueCommandConfig.speakerMode(speakModel);
    // switch (value) {
    //   case "0":
    //     await BlueCommandConfig.bluetoothMode();
    //     break;
    //   case "1":
    //     await BlueCommandConfig.rcaMode();
    //     break;
    //   case "2":
    //     await BlueCommandConfig.auxMode();
    //     break;
    //   case "3":
    //     await BlueCommandConfig.autoMode();
    //     break;
    //   case "4":
    //     await BlueCommandConfig.opticalMode();
    //     break;
    //   default:
    //
    //     break;
    // }
    notifyListeners();
  }

  @override
  void dispose() {
    EventBusManager().off(EventConfig.event_update_play_status);
    super.dispose();
  }
}
