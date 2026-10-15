import 'package:base_flutter/activitys/views/update_success_dialog.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../activitys/views/confirm_tips_dialog.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/key_config.dart';
import '../configs/router_config.dart';
import '../models/extra/key_value.dart';
import '../utils/navigator_util.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

enum DeviceNameType {
  KITCHEN,
  BEDROOM,
  BATHROOM,
  ENSUITE,
  LOUNGE,
  DINING_ROOM,
  GAMES_ROOM,
  OFFICE,
  FAMILY_ROOM,
  LIBRARY,
  GARDEN,
  HALLWAY,
  GYM,
  MASTER_BEDROOM
}

class RenameSpeakerActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;

  BluetoothInfo? bluetoothInfo;

  final List<KeyValue> names = [];

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();

    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    initNames();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {});
  }

  void initNames() {
    names.clear();
    names.add(KeyValue(
        key: AppConfig.appS.device_name_kitchen,
        value: DeviceNameType.KITCHEN));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_bedroom,
        value: DeviceNameType.BEDROOM));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_bathroom,
        value: DeviceNameType.BATHROOM));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_ensuite,
        value: DeviceNameType.ENSUITE));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_lounge, value: DeviceNameType.LOUNGE));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_dining_room,
        value: DeviceNameType.DINING_ROOM));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_games_room,
        value: DeviceNameType.GAMES_ROOM));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_office, value: DeviceNameType.OFFICE));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_family_room,
        value: DeviceNameType.FAMILY_ROOM));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_library,
        value: DeviceNameType.LIBRARY));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_garden, value: DeviceNameType.GARDEN));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_hallway,
        value: DeviceNameType.HALLWAY));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_GYM, value: DeviceNameType.GYM));
    names.add(KeyValue(
        key: AppConfig.appS.device_name_master_bedroom,
        value: DeviceNameType.MASTER_BEDROOM));
  }

  // Future<void> showCustomNameDialog(VoidCallback result) async {
  //   await showDialog(
  //     context: context,
  //     builder: (_) {
  //       return CheckPasswordOrTipsDialog(
  //         title: AppConfig.appS.dialog_update_custom_name_tips,
  //         content: AppConfig.appS.dialog_update_custom_name_hint,
  //         showValidate: false,
  //         inputHint: AppConfig.appS.dialog_update_custom_name_input_hint,
  //         leftButtonClick: (text) async {
  //           if (text.length == 0 || text.length > 12) {
  //             ToastUtil.showShortToast(
  //                 AppConfig.appS.rename_speaker_activity_length_error);
  //             return;
  //           }
  //           NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
  //           changeNameAndShowUpdateSuccessDialog(text, result);
  //         },
  //         rightButtonClick: () async {
  //           NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
  //         },
  //       );
  //     },
  //   );
  // }

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

  Future<void> changeSpeakerName(bool isAddItem, KeyValue? value) async {
    if (isAddItem) {
      Bundle bundle = Bundle();
      bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
      NavigatorUtil.jumpTo(context, ActivityName.RenameCustomSpeakerActivity,
          bundle: bundle);
      // await showCustomNameDialog(() async {
      //   await Bluebridge.openSettings();
      //   await BluetoothController.reconnectTips(baseActivityState, context);
      // });
    } else {
      if (value == null || value.key == null) {
        return;
      }
      await showConfirmDialog(value.key!, () async {
        await Bluebridge.openSettings();
        await BluetoothController.updateReconnectStatus(
            baseActivityState, context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
