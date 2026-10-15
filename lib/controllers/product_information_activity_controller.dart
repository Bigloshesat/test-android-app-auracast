import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/key_config.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class ProductInformationActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;

  @override
  void initController(State<StatefulWidget> state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);


    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await getProductInfo();
    });
  }

  //获取产品信息（就不在产品详情页面里面拿了，因为信息基本是固定的，不会变动）
  Future<void> getProductInfo() async {
    await BlueCommandConfig.checkProductStatus();
    notifyListeners();
  }



  String getAppVersion() {
    return "v"+applicationController.version;
  }

  String? getBluetoothName() {
    return bluetoothInfo?.device?.name;
  }

  String? getFirmwareVersion() {
    return bluetoothController.firmware != null ? "v${bluetoothController.firmware}"  : "";
  }

  String? getHardwareVersion() {
    return bluetoothController.hardware != null ? "v${bluetoothController.hardware}"  : "";
  }

  String? getProductModel() {
    return bluetoothController.productModel;
  }
  // String? getProductModel() {
  //   return bluetoothController.hareWare != null ? "v${bluetoothController.hareWare}"  : "";
  // }

}