import 'dart:async';

import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/eventbus_manager.dart';

import '../activitys/views/switch_status_view.dart';
import '../activitys/views/touchable_single_line_chart_view.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/event_config.dart';
import '../configs/key_config.dart';
import '../models/extra/key_value.dart';
import '../resources/dimens.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

enum EqualizerType {
  CUSTOM,
  POP,
  CLASSICAL,
  LOUNGE,
  DANCE,
  JAZZ,
  HIP_HOP,
  ACOUSTIC,
  ROCK,
  VOCAL, // 0x0A
  FLAT //0x0B
}

class EqualizerActivityController extends BaseController {
  final GlobalKey<SwitchStatusViewState> switchStatusViewStateKey =
      GlobalKey<SwitchStatusViewState>();
  final GlobalKey<TouchableSingleLineChartViewState> touchableLineChartViewStateKey =
      GlobalKey<TouchableSingleLineChartViewState>();

  final double maxX = 100;
  final double maxEqualizerValue = 24;

  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;

  bool isPlaying = false;
  int volume = 0;
  bool isEqualizerOn = false;

  final List<KeyValue> equalizerTypes = [];
  final List<String> splitPositionXUnitText = [
    "60",
    "150",
    "400",
    "1k",
    "2.4k",
    "15k"
  ];

  int selectEqualizerTypeIndex = 0;


  //控制音量
  Timer? soundTimer;
  bool isSoundUp = true;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);

    getBluetoothStatusInfo();
    initEqualizerTypes();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      // if (volume == 0 || selectEqualizerTypeIndex == 0) {
      //防止延时返回导致的重置,只在第一次进入(默认0)或者0时候执行checkPlayStatus
      await checkPlayAndEqualizerStatus();

      // }
    });
    EventBusManager().on(EventConfig.event_update_equalizer_status, (arg) {
      updateEqualizerStatus();
    });
    EventBusManager().on(EventConfig.event_update_play_status, (arg) {
      getBluetoothStatusInfo();

    });
  }

  void updateEqualizerStatus() {
    isEqualizerOn = bluetoothController.isEqualizerOn ?? false;
    switchStatusViewStateKey.currentState?.updateEnable(isEqualizerOn);
    updateEqualizerTypeIndex();
    updatePoints();
    notifyListeners();
  }

  void getBluetoothStatusInfo() {
    isPlaying = bluetoothController.isPlaying ?? false;
    volume = bluetoothController.volume ?? 0;
    isEqualizerOn = bluetoothController.isEqualizerOn ?? false;
    switchStatusViewStateKey.currentState?.updateEnable(isEqualizerOn);
    updateEqualizerTypeIndex();
    notifyListeners();
  }

  Future<void> checkPlayAndEqualizerStatus() async {
    Map<String, dynamic> data =
        await bluetoothController.checkPlayAndEqualizerStatus();
    isPlaying = data[KeyConfig.blue_bridge_is_playing_key];
    volume = data[KeyConfig.blue_bridge_volume_key];
    isEqualizerOn = data[KeyConfig.blue_bridge_is_equalizer_on_key];
    switchStatusViewStateKey.currentState?.updateEnable(isEqualizerOn);
    updateEqualizerTypeIndex();
    updatePoints();
    notifyListeners();
  }

  void initEqualizerTypes() {
    equalizerTypes.clear();


    equalizerTypes.add(KeyValue(
        key: AppConfig.appS.equalizer_activity_custom_eq_mode_pop,
        value: EqualizerType.POP,
        object: ""));
    equalizerTypes.add(KeyValue(
        key: AppConfig.appS.equalizer_activity_custom_eq_mode_classical,
        value: EqualizerType.CLASSICAL,
        object: ""));
    // equalizerTypes.add(KeyValue(
    //     key: AppConfig.appS.equalizer_activity_custom_eq_mode_lounge,
    //     value: EqualizerType.LOUNGE,
    //     object: ""));
    // equalizerTypes.add(KeyValue(
    //     key: AppConfig.appS.equalizer_activity_custom_eq_mode_dance,
    //     value: EqualizerType.DANCE,
    //     object: ""));
    equalizerTypes.add(KeyValue(
        key: AppConfig.appS.equalizer_activity_custom_eq_mode_jazz,
        value: EqualizerType.JAZZ,
        object: ""));
    // equalizerTypes.add(KeyValue(
    //     key: AppConfig.appS.equalizer_activity_custom_eq_mode_hip_hop,
    //     value: EqualizerType.HIP_HOP,
    //     object: ""));
    // equalizerTypes.add(KeyValue(
    //     key: AppConfig.appS.equalizer_activity_custom_eq_mode_acoustic,
    //     value: EqualizerType.ACOUSTIC,
    //     object: ""));
    equalizerTypes.add(KeyValue(
        key: AppConfig.appS.equalizer_activity_custom_eq_mode_rock,
        value: EqualizerType.ROCK,
        object: ""));
    equalizerTypes.add(KeyValue(
        key: AppConfig.appS.equalizer_activity_custom_eq_mode_vocal,
        value: EqualizerType.VOCAL,
        object: ""));


    equalizerTypes.add(KeyValue(
        key: AppConfig.appS.equalizer_activity_custom_eq_mode_flat,
        value: EqualizerType.FLAT,
        object: ""));
    updateEqualizerTypeIndex();
  }

  void updateEqualizerTypeIndex() {
    EqualizerType? equalizerType = bluetoothController.selectEqualizerMode;
    if (equalizerType == null) {
      return;
    }
    if (equalizerType == EqualizerType.CUSTOM) {
      selectEqualizerTypeIndex = -1;
      return;
    }
    for (int i = 0; i < equalizerTypes.length; i++) {
      KeyValue keyValue = equalizerTypes[i];
      if (equalizerType == keyValue.value) {
        selectEqualizerTypeIndex = i;
        break;
      }
    }
  }

  String? getBluetoothName() {
    return bluetoothInfo?.device?.name;
  }

  Future<void> changeVolume(int volume) async {
    this.volume = volume;
    bluetoothController.volume = this.volume;
    await BlueCommandConfig.changeVolume(this.volume);
  }

  Future<void> changeEqualizerStatus(bool status) async {
    if (status) {
      await BlueCommandConfig.equalizerOn();
    } else {
      await BlueCommandConfig.equalizerOFF();
    }
    isEqualizerOn = status;
    bluetoothController.isEqualizerOn = isEqualizerOn;
    notifyListeners();
  }

  Future<void> changeEqualizerType(KeyValue keyValue, int index) async {
    baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
    switch (keyValue.value) {
      case EqualizerType.CUSTOM:
        await BlueCommandConfig.customEqualizer();
        break;
      case EqualizerType.POP:
        await BlueCommandConfig.popEqualizer();
        break;
      case EqualizerType.CLASSICAL:
        await BlueCommandConfig.classicalEqualizer();
        break;
      case EqualizerType.LOUNGE:
        await BlueCommandConfig.loungeEqualizer();
        break;
      case EqualizerType.DANCE:
        await BlueCommandConfig.danceEqualizer();
        break;
      case EqualizerType.JAZZ:
        await BlueCommandConfig.jazzEqualizer();
        break;
      case EqualizerType.HIP_HOP:
        await BlueCommandConfig.hipHopEqualizer();
        break;
      case EqualizerType.ACOUSTIC:
        await BlueCommandConfig.acousticEqualizer();
        break;
      case EqualizerType.ROCK:
        await BlueCommandConfig.rockEqualizer();
        break;
      case EqualizerType.VOCAL:
        await BlueCommandConfig.vocalEqualizer();
        break;
      case EqualizerType.FLAT:
        await BlueCommandConfig.flatEqualizer();
        break;
      default:
        break;
    }
    baseActivityState.baseDialogController?.hide();
    selectEqualizerTypeIndex = index;
    bluetoothController.selectEqualizerMode = keyValue.value;
    notifyListeners();
  }

  double getLineChartWidth() {
    return Dimens.touchable_line_chart_view_canvas_width;
  }

  double getLineChartHeight() {
    return Dimens.touchable_line_chart_view_canvas_height;
  }

  void updatePoints() {
    if (isEqualizerOn && isHaveEqualizerValues()) {
      touchableLineChartViewStateKey.currentState?.updatePoints(getPoints());
    }
  }

  bool isHaveEqualizerValues() {
    List<int> equalizerValues = bluetoothController.equalizerValues;
    if (equalizerValues.length == 6) {
      return true;
    }
    return false;
  }

  List<Offset> getPoints() {
    List<int> equalizerValues = bluetoothController.equalizerValues;
    List<double> yPositions = [];
    if (equalizerValues.length == 0 || equalizerValues.length != 6) {
      for (int i = 0; i < 6; i++) {
        yPositions.add(0);
      }
    } else {
      for (int i = 0; i < 6; i++) {
        yPositions.add(equalizerValues[i].toDouble());
      }
    }
    double unitX = maxX / 5;
    List<Offset> points = [];
    for (int i = 0; i < 6; i++) {
      points.add(Offset(i * unitX, yPositions[i]));
    }
    return points;
  }

  Future<void> updateCustomPoints(List<Offset> points) async {
    if (points.length != 6) {
      return;
    }
    List<int> values = [];
    points.forEach((item) {
      values.add(item.dy.floor());
    });
    // if(selectEqualizerTypeIndex != -1){
    //  await changeEqualizerType(KeyValue(
    //       key: AppConfig.appS.equalizer_activity_custom_eq_mode_custom,
    //       value: EqualizerType.CUSTOM,
    //       object: ""),-1);
    // }
    bluetoothController.updateEqualizerValues(values);
    await BlueCommandConfig.updateCustomEqualizerValue(values);
  }


  void playSoundTimer() {
    if(!(soundTimer?.isActive ?? false)) {
      soundTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if(isSoundUp) {
          if(volume < 100) volume ++;
        } else {
          if(volume > 0) volume --;
        }
        bluetoothController.volume = this.volume;
        notifyListeners();
        BlueCommandConfig.changeVolume(this.volume);
      });
    }
  }

  void cancelSoundTimer() {
    if((soundTimer?.isActive ?? false)) {
      soundTimer?.cancel();
    }
  }

  @override
  void dispose() {
    cancelSoundTimer();
    EventBusManager().off(EventConfig.event_update_equalizer_status);
    EventBusManager().off(EventConfig.event_update_play_status);
    super.dispose();
  }
}
