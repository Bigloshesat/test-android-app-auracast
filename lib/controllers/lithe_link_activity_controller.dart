import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/eventbus_manager.dart';

import '../activitys/views/confirm_tips_dialog.dart';
import '../activitys/views/switch_status_view.dart';
import '../activitys/views/update_success_dialog.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/event_config.dart';
import '../configs/key_config.dart';
import '../utils/navigator_util.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class LitheLinkActivityController extends BaseController {
  final GlobalKey<SwitchStatusViewState> switchStatusViewStateKey =GlobalKey<SwitchStatusViewState>();

  late ApplicationController applicationController;
  BluetoothInfo? bluetoothInfo;
  late BluetoothController bluetoothController;

  bool isLitheLinkOn = false;
  bool isLitheLinkConnect = false;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    bluetoothController = BluetoothController.getInstance();
    getLitheLinkStatusInfo();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await checkLitheLinkStatus();
    });
    EventBusManager().on(EventConfig.event_update_lithe_link_status, (arg) {
      getLitheLinkStatusInfo();
      notifyListeners();
    });
  }


  void getLitheLinkStatusInfo() {
    isLitheLinkOn = bluetoothController.isLitheLinkOn ?? false;
    isLitheLinkConnect = bluetoothController.isLitheLinkConnect ?? false;
  }

  Future<void> checkLitheLinkStatus() async {
    isLitheLinkOn = await bluetoothController.checkLitheLinkStatus();
    getLitheLinkStatusInfo();
    switchStatusViewStateKey.currentState?.updateEnable(isLitheLinkOn);
    notifyListeners();
  }

  Future<void> changeLitheLinkStatus(bool status) async {
    if (status) {
      await BlueCommandConfig.litheLinkOn();
    } else {
      await BlueCommandConfig.litheLinkOff();
    }
    isLitheLinkOn = status;
    bluetoothController.isLitheLinkOn = isLitheLinkOn;
    notifyListeners();
    // if (!status) {
    //   await showLitheLinkOffConfirmDialog(() async {
    //     await Bluebridge.openSettings();
    //     await BluetoothController.updateReconnectStatus(
    //         baseActivityState, context);
    //   });
    // }
  }

  Future<void> showLitheLinkOffConfirmDialog(VoidCallback result) async {
    await showDialog(
      context: context,
      builder: (_) {
        return ConfirmTipsDialog(
          title: AppConfig.appS.lithe_link_activity_will_lithe_link_off_title,
          topButtonText: AppConfig.appS.lithe_link_activity_lithe_link_now_button_text,
          bottomButtonText: AppConfig.appS.cancel,
          topButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            showLitheLinkOffSuccessDialog(result);
          },
          bottomButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
          },
        );
      },
    );
  }

  Future<void> showLitheLinkOffSuccessDialog(VoidCallback result) async {
    await BluetoothController.getInstance().reboot();
    await showDialog(
      context: context,
      builder: (_) {
        return UpdateSuccessDialog(
          title: AppConfig.appS.dialog_pin_off_title,
          tips: AppConfig.appS.dialog_pin_off_tips,
          nextButtonText: AppConfig.appS.dialog_bluetooth_settings_text,
          showSplitLine: false,
          nextClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            result.call();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    EventBusManager().off(EventConfig.event_update_lithe_link_status);
    super.dispose();
  }
}
