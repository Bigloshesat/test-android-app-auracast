import 'dart:async';

import 'package:base_flutter/configs/router_config.dart';
import 'package:base_flutter/utils/navigator_util.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';

import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class SplashActivityController extends BaseController {
  late ApplicationController applicationController;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    applicationController.init();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await Bluebridge.requestPermissions();
      await BluetoothController.getInstance().initBluebridge();
      await Future.delayed(Duration(milliseconds: 3000));
      goToJump();
    });
  }

  void goToJump() async {
    NavigatorUtil.replaceTo(context, ActivityName.MainActivity);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
