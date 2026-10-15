import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/key_config.dart';
import 'extra/application_controller.dart';

class WrongPasswordTipsActivityController extends BaseController {
  late ApplicationController applicationController;
  BluetoothInfo? bluetoothInfo;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    WidgetsBinding.instance.addPostFrameCallback((callback) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
