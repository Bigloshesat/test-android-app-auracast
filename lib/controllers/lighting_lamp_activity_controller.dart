

import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/models/extra/key_value.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/eventbus_manager.dart';

import '../activitys/views/switch_status_view.dart';
import '../configs/blue_command_config.dart';
import '../configs/event_config.dart';
import '../configs/key_config.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class LightingLampActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;
  List<KeyValue> lightStyles = [];

  final GlobalKey<SwitchStatusViewState> switchStatusStateKey =
  GlobalKey<SwitchStatusViewState>();
  bool isLightOn = true; //开关

  int lampBrightness = 0;  //亮度
  LightLampType selectedLightStyle = LightLampType.CUSTOM; //灯类型
  Color pickerColor = Colors.blue; //氛围灯颜色
  Color? selectedColor;

  @override
  void initController(State<StatefulWidget> state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    initLightStyles();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await checkLightLampStatus();
    });

    EventBusManager().on(EventConfig.event_update_equalizer_status, (arg) {
      updateLightingLampStatus();
    });
  }

  void initLightStyles() {
    lightStyles.clear();
    lightStyles.add(KeyValue(
        key: AppConfig.appS.lighting_lamp_activity_style_warm_light_text,
        value: LightLampType.PRESET2,
    ));

    lightStyles.add(KeyValue(
        key: AppConfig.appS.lighting_lamp_activity_style_cold_light_text,
        value: LightLampType.PRESET3,
    ));

    lightStyles.add(KeyValue(
        key: AppConfig.appS.lighting_lamp_activity_style_day_light_text,
        value: LightLampType.PRESET4,
    ));
  }

  Future<void> checkLightLampStatus() async {
    Map<String, dynamic> data = await bluetoothController.checkLightLampStatus();
    selectedLightStyle = data[KeyConfig.light_lamp_style_key];
    int lightLampRedColor = data[KeyConfig.light_lamp_red_color_key];
    int lightLampGreenColor = data[KeyConfig.light_lamp_green_color_key];
    int lightLampBlueColor = data[KeyConfig.light_lamp_blue_color_key];
    Color color = Color.fromRGBO(lightLampRedColor, lightLampGreenColor, lightLampBlueColor, 1);
    pickerColor = color;
    lampBrightness = data[KeyConfig.light_lamp_brightness_key];

    notifyListeners();
  }

  void updateLightingLampStatus() {
    selectedLightStyle = bluetoothController.lightLampStyle;
    int lightLampRedColor = bluetoothController.lightLampRedColor;
    int lightLampGreenColor = bluetoothController.lightLampGreenColor;
    int lightLampBlueColor = bluetoothController.lightLampBlueColor;
    Color color = Color.fromRGBO(lightLampRedColor, lightLampGreenColor, lightLampBlueColor, 1);
    pickerColor = color;
    lampBrightness = bluetoothController.lightLampBrightness;
    notifyListeners();
  }


  Future<void> changeLightStatus(bool status) async {
    if (status) {
      await BlueCommandConfig.LightLampStatus(LightLampType.ON, lampBrightness);
    } else {
      await BlueCommandConfig.LightLampStatus(LightLampType.OFF, lampBrightness);
    }
    isLightOn = status;
    bluetoothController.isPinOn = isLightOn;
    notifyListeners();
  }

  Future<void> changeLampBrightness(int lampBrightness) async {
    this.lampBrightness = lampBrightness;
    await BlueCommandConfig.LightLampStatus(selectedLightStyle, lampBrightness);
    notifyListeners();
  }

  Future<void> selectedCustomLightStyle(Color color) async {
    if(selectedLightStyle != LightLampType.CUSTOM) {
      selectedLightStyle = LightLampType.CUSTOM;
      notifyListeners();
    }
    selectedColor = color;
    // await BlueCommandConfig.LightLampStatus(
    //   selectedLightStyle,
    //   lampBrightness,
    //   redColor: color.red,
    //   greenColor: color.green,
    //   blueColor: color.blue
    // );
  }

  Future<void> setCustomLightColor() async{
    if(selectedColor != null) {
      await BlueCommandConfig.LightLampStatus(
          selectedLightStyle,
          lampBrightness,
          redColor: selectedColor!.red,
          greenColor: selectedColor!.green,
          blueColor: selectedColor!.blue
      );
    }
  }

  static int floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  Future<void> changeLightStyle(KeyValue keyValue) async {
    selectedLightStyle = keyValue.value;
    await BlueCommandConfig.LightLampStatus(selectedLightStyle, lampBrightness);
    notifyListeners();
  }

}