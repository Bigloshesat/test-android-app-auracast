import 'dart:convert';
import 'dart:typed_data';

import 'package:base_flutter/activitys/views/update_success_dialog.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/toast_util.dart';

import '../activitys/views/confirm_tips_dialog.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/key_config.dart';
import '../configs/router_config.dart';
import '../resources/dimens.dart';
import '../utils/navigator_util.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class RenameCustomSpeakerActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;

  BluetoothInfo? bluetoothInfo;

  String name = "";

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();

    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    WidgetsBinding.instance.addPostFrameCallback((callback) async {});
  }

  Future<void> showConfirmDialog(String name, VoidCallback result) async {
    await showDialog(
      context: context,
      builder: (_) {
        return ConfirmTipsDialog(
          title: AppConfig.appS.dialog_update_device_name_title,
          content: name,
          contentFontSize: Dimens.font_success_dialog_content,
          topButtonText: AppConfig.appS.dialog_update_speaker_now_button_text,
          bottomButtonText: AppConfig.appS.dialog_update_pin_code_button_text,
          topButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            changeNameAndShowUpdateSuccessDialog(name, result);
          },
          bottomButtonClick: () async {
            // 先修改name 再跳转pin设置
            baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
            await BlueCommandConfig.rename(name);
            bluetoothController.setNewConnectDeviceName(name);
            baseActivityState.baseDialogController?.hide();
            //
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            Bundle bundle = Bundle();
            bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
            NavigatorUtil.jumpTo(context, ActivityName.UpdatePinActivity,
                bundle: bundle);
          },
        );
      },
    );
  }

  Future<void> changeNameAndShowUpdateSuccessDialog(
      String name, VoidCallback result) async {
    baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
    await BlueCommandConfig.rename(name);
    bluetoothController.setNewConnectDeviceName(name);
    baseActivityState.baseDialogController?.hide();

    await BluetoothController.getInstance().reboot();
    // ToastUtil.showShortToast(AppConfig.appS.disconnect_tips);

    await showDialog(
      context: context,
      builder: (_) {
        return UpdateSuccessDialog(
          title: AppConfig.appS.dialog_update_rename_success_title,
          content: name,
          contentFontSize: Dimens.font_success_dialog_content,
          tips: AppConfig.appS.dialog_update_rename_success_tips,
          nextButtonText: AppConfig.appS.dialog_bluetooth_settings_text,
          nextClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            result.call();
            // _checkRebootTips(name, result);
          },
        );
      },
    );
  }

  Future<void> _checkRebootTips(String text, VoidCallback result) async {
    await BluetoothController.showRebootTipsDialog(baseActivityState, context,
        () async {
      result.call();
    }, () {
      bluetoothController.needShowRebootTips = true;
    });
  }

  Future<void> changeSpeakerName() async {
    Uint8List nameData = Utf8Encoder().convert(name);
    if (nameData.length == 0 || nameData.length > 27) {
      ToastUtil.showShortToast(
          AppConfig.appS.rename_speaker_activity_length_error);
      return;
    }
    await showConfirmDialog(name, () async {
      await Bluebridge.openSettings();
      await BluetoothController.updateReconnectStatus(
          baseActivityState, context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
