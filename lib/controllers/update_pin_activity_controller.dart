import 'package:base_flutter/activitys/views/switch_status_view.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/toast_util.dart';

import '../activitys/views/confirm_password_or_tips_dialog.dart';
import '../activitys/views/confirm_tips_dialog.dart';
import '../activitys/views/update_success_dialog.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/key_config.dart';
import '../configs/router_config.dart';
import '../resources/dimens.dart';
import '../resources/s_colors.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import '../widgets/normal/normal_text_view.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class UpdatePinActivityController extends BaseController {
  final GlobalKey<SwitchStatusViewState> switchStatusViewStateKey =
      GlobalKey<SwitchStatusViewState>();

  late ApplicationController applicationController;
  BluetoothInfo? bluetoothInfo;
  late BluetoothController bluetoothController;

  bool isPinOn = false;
  String pinCode = "";

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    bluetoothController = BluetoothController.getInstance();
    isPinOn = bluetoothController.isPinOn;

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await checkPinStatus();
    });
  }

  Future<void> checkPinStatus() async {
    isPinOn = await bluetoothController.checkPinStatus();
    switchStatusViewStateKey.currentState?.updateEnable(isPinOn);
    notifyListeners();
  }

  Future<void> changePinStatus(bool status) async {
    if (status) {
      await BlueCommandConfig.pingOn();
    } else {
      await BlueCommandConfig.pingOff();
    }
    isPinOn = status;
    bluetoothController.isPinOn = isPinOn;
    notifyListeners();
    if (!status) {
      await showPinOffConfirmDialog(() async {
        await Bluebridge.openSettings();
        await BluetoothController.updateReconnectStatus(
            baseActivityState, context);
      });
    }
  }

  Future<void> showPinOffConfirmDialog(VoidCallback result) async {
    await showDialog(
      context: context,
      builder: (_) {
        return ConfirmTipsDialog(
          title: AppConfig.appS.dialog_will_pin_off_title,
          // tips: AppConfig.appS.dialog_pin_off_tips,
          topButtonText: AppConfig.appS.dialog_update_pin_code_now_button_text,
          bottomButtonText: AppConfig.appS.cancel,
          topButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            showPinOffSuccessDialog(result);
          },
          bottomButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
          },
        );
      },
    );
  }

  Future<void> showPinOffSuccessDialog(VoidCallback result) async {
    await BluetoothController.getInstance().reboot();
    // ToastUtil.showShortToast(AppConfig.appS.disconnect_tips);
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

  Future<void> changePinCodeAndShowUpdateSuccessDialog(
      String code, VoidCallback result) async {
    baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
    await BlueCommandConfig.changePinPassword(code);
    baseActivityState.baseDialogController?.hide();

    await BluetoothController.getInstance().reboot();
    // ToastUtil.showShortToast(AppConfig.appS.disconnect_tips);

    await showDialog<void>(
      context: context,
      builder: (_) {
        Widget contentView = ConfirmPasswordOrTipsDialog(
          title: AppConfig.appS.dialog_update_pin_success_title,
          content: AppConfig.appS.dialog_update_pin_success_tips,
          buttonTitle: AppConfig.appS.dialog_bluetooth_settings_text,
          buttonTextSize: Dimens.font_normal,
          password: code.split(""),
          buttonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            result.call();
          },
        );
        return GestureDetector(
          child: contentView,
          onTap: () {
            NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
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

  Future<void> changePinCode() async {
    if (pinCode.length < 4) {
      ToastUtil.showShortToast(AppConfig.appS.password_length_error);
      return;
    }
    await showConfirmDialog(pinCode, () async {
      await Bluebridge.openSettings();
      await BluetoothController.updateReconnectStatus(
          baseActivityState, context);
    });
  }

  Future<void> showConfirmDialog(String code, VoidCallback result) async {
    await showDialog(
      context: context,
      builder: (_) {
        return ConfirmPasswordOrTipsDialog(
          title: AppConfig.appS.dialog_update_pin_code_title,
          content: AppConfig.appS.dialog_update_pin_code_tips,
          password: code.split(""),
          showButton: false,
          showDoubleButton: true,
          margin: EdgeInsets.symmetric(horizontal: Dimens.margin_broad),
          topButtonText: AppConfig.appS.dialog_update_pin_code_now_button_text,
          bottomButtonText: AppConfig.appS.dialog_update_speaker_button_text,
          topButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            changePinCodeAndShowUpdateSuccessDialog(code, result);
          },
          bottomButtonClick: () async {
            // 先更新pin，再跳转
            baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
            await BlueCommandConfig.changePinPassword(code);
            baseActivityState.baseDialogController?.hide();
            //
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            Bundle bundle = Bundle();
            bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
            NavigatorUtil.jumpTo(context, ActivityName.RenameSpeakerActivity,
                bundle: bundle);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
