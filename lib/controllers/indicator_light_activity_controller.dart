import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../activitys/views/switch_status_view.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/key_config.dart';
import '../models/extra/key_value.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class IndicatorLightActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;

  final GlobalKey<SwitchStatusViewState> indicatorLightSwitchStatusStateKey =
  GlobalKey<SwitchStatusViewState>();
  bool isIndicatorLightOn = false;

  final GlobalKey<SwitchStatusViewState> sereoSwitchStatusStateKey =
  GlobalKey<SwitchStatusViewState>();
  bool isSereoOn = false;

  final GlobalKey<SwitchStatusViewState> monoSwitchStatusStateKey =
  GlobalKey<SwitchStatusViewState>();
  bool isMonoOn = false;

  final List<KeyValue> milits = [];
  int limit = -1;
  // int limit = 0;

  final GlobalKey<SwitchStatusViewState> switchStatusViewStateKey =
  GlobalKey<SwitchStatusViewState>();
  bool isSoundTipsOn = false;

  @override
  void initController(State<StatefulWidget> state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    initMilits();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
      await checkSoundTipsStatus();
      await checkIndicatorLightStatus();
      await checkIndicatorLightModelStatus();
      await checkVolumeLimitStatus();
      baseActivityState.baseDialogController?.hide();
    });

  }

  Future<void> checkIndicatorLightStatus() async {
    isIndicatorLightOn = await bluetoothController.checkIndicatorLightStatus();
    indicatorLightSwitchStatusStateKey.currentState?.updateEnable(isIndicatorLightOn);
    notifyListeners();
  }

  Future<void> checkIndicatorLightModelStatus() async {
    isMonoOn = await bluetoothController.checkIndicatorLightIsMonoStatus();
    isSereoOn = !isMonoOn;
    sereoSwitchStatusStateKey.currentState?.updateEnable(isSereoOn);
    monoSwitchStatusStateKey.currentState?.updateEnable(isMonoOn);
    notifyListeners();
  }

  Future<void> checkVolumeLimitStatus() async {
    limit = await bluetoothController.checkVolumeLimitStatus();
    initMilits();
    notifyListeners();
    // isIndicatorLightOn = await bluetoothController.checkIndicatorLightStatus();
    // indicatorLightSwitchStatusStateKey.currentState?.updateEnable(isIndicatorLightOn);
    // notifyListeners();
  }


  void initMilits() {
    milits.clear();

    milits.add(KeyValue(
        key: "25%",
        value: 1,
        object: limit == 1
    ));

    milits.add(KeyValue(
        key: "50%",
        value: 2,
        object: limit == 2
    ));

    milits.add(KeyValue(
        key: "75%",
        value: 3,
        object: limit == 3
    ));


    milits.add(KeyValue(
        key: "100%",
        value: 0,
        object: limit == 0
    ));
  }


  Future<void> changeIndicatorLightStatus(bool status) async {
    if (status) {
      await BlueCommandConfig.indicatorLightON();
    } else {
      await BlueCommandConfig.indicatorLightOFF();
    }
    isIndicatorLightOn = status;
    bluetoothController.isIndicatorLightOn = isIndicatorLightOn;
    notifyListeners();
  }

  Future<void> changeIndicatorLightModeIsMonoStatus(bool status) async {
    if (status) {
      await BlueCommandConfig.indicatorLightMonoModel();
    } else {
      await BlueCommandConfig.indicatorLightSereoModel();
    }
    isMonoOn = status;
    isSereoOn = !isMonoOn;
    sereoSwitchStatusStateKey.currentState?.updateEnable(isSereoOn);
    monoSwitchStatusStateKey.currentState?.updateEnable(isMonoOn);
    bluetoothController.isMono = isMonoOn;
    notifyListeners();
  }

  Future<void> selectedLimiterMenu(KeyValue limiter) async {
    baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
    await BlueCommandConfig.indicatorLightMinLimit(limiter.value);
    baseActivityState.baseDialogController?.hide();
    limit = limiter.value;
    initMilits();
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

  Future<void> checkSoundTipsStatus() async {
    isSoundTipsOn = await bluetoothController.checkSoundTipsStatus();
    switchStatusViewStateKey.currentState?.updateEnable(isSoundTipsOn);
    notifyListeners();
  }


}