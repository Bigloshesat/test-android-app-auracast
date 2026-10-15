import 'package:base_flutter/utils/string_util.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/toast_util.dart';

import '../activitys/views/confirm_password_or_tips_dialog.dart';
import '../activitys/views/update_success_dialog.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/key_config.dart';
import '../resources/dimens.dart';
import '../utils/navigator_util.dart';
import 'extra/application_controller.dart';

class UpdateAdminPasswordActivityController extends BaseController {
  late ApplicationController applicationController;
  BluetoothInfo? bluetoothInfo;
  String adminPassword = "";

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    WidgetsBinding.instance.addPostFrameCallback((callback) async {});
  }

  Future<void> changeAdminPasswordAndShowUpdateSuccessDialog(
      String code, VoidCallback result) async {
    baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
    await BlueCommandConfig.changeAdminPassword(adminPassword);
    baseActivityState.baseDialogController?.hide();

    await showDialog<void>(
      context: context,
      builder: (_) {
        Widget contentView = ConfirmPasswordOrTipsDialog(
          title: AppConfig.appS.dialog_update_admin_success_title,
          content: AppConfig.appS.dialog_update_admin_success_tips,
          buttonTitle: AppConfig.appS.ok,
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

  Future<void> changeAdminPassword() async {
    if (adminPassword.length < 4) {
      ToastUtil.showShortToast(AppConfig.appS.password_length_error);
      return;
    }
    await changeAdminPasswordAndShowUpdateSuccessDialog(adminPassword,
        () async {
      baseActivityState.finish();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
