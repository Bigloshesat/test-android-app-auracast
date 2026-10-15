import 'package:base_flutter/configs/key_config.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../configs/router_config.dart';
import '../models/extra/key_value.dart';
import '../utils/navigator_util.dart';
import 'extra/application_controller.dart';

enum RenameOrChangePinMenu { RENAME, UPDATE_PIN, UPDATE_ADMIN_PASSWORD }

class RenameOrChangePinActivityController extends BaseController {
  late ApplicationController applicationController;
  BluetoothInfo? bluetoothInfo;
  final List<KeyValue> menus = [];

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    initMenus();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {});
  }

  void initMenus() {
    menus.clear();
    menus.add(KeyValue(
        key: AppConfig.appS.rename_or_change_pin_activity_menu_rename,
        value: RenameOrChangePinMenu.RENAME));
    menus.add(KeyValue(
        key: AppConfig.appS.rename_or_change_pin_activity_menu_update_pin,
        value: RenameOrChangePinMenu.UPDATE_PIN));
    menus.add(KeyValue(
        key: AppConfig
            .appS.rename_or_change_pin_activity_menu_update_admin_password,
        value: RenameOrChangePinMenu.UPDATE_ADMIN_PASSWORD));
  }

  void onMenuClick(KeyValue menu) {
    switch (menu.value) {
      case RenameOrChangePinMenu.RENAME:
        Bundle bundle = Bundle();
        bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
        NavigatorUtil.jumpTo(context, ActivityName.RenameSpeakerActivity,
            bundle: bundle);
        break;
      case RenameOrChangePinMenu.UPDATE_PIN:
        Bundle bundle = Bundle();
        bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
        NavigatorUtil.jumpTo(context, ActivityName.UpdatePinActivity,
            bundle: bundle);
        break;
      case RenameOrChangePinMenu.UPDATE_ADMIN_PASSWORD:
        Bundle bundle = Bundle();
        bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
        NavigatorUtil.jumpTo(context, ActivityName.UpdateAdminPasswordActivity,
            bundle: bundle);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
