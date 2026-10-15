import 'package:base_flutter/configs/key_config.dart';
import 'package:base_flutter/utils/view_util.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/log_util.dart';
import 'package:framework/utils/toast_util.dart';

import '../activitys/views/check_password_or_tips_dialog.dart';
import '../activitys/views/confirm_password_or_tips_dialog.dart';
import '../activitys/views/update_success_dialog.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/router_config.dart';
import '../resources/dimens.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class ConnectedActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;
  int retryCheckAdminStatusCount = 0;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    WidgetsBinding.instance.addPostFrameCallback((callback) async {});
  }

  void goToManagerActivity() async {
    Bundle bundle = Bundle();
    bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
    NavigatorUtil.jumpTo(context, ActivityName.ManagerActivity,
        bundle: bundle, dataCallback: (data) {});
  }

  String? getBluetoothName() {
    return bluetoothInfo?.device?.name;
  }

  Future<void> checkAdminPassword() async {
    if (bluetoothInfo == null) {
      return;
    }
    baseActivityState.baseDialogController?.show(AppConfig.appS.loading);
    await Future.delayed(Duration(milliseconds: 200));
    AdminPasswordStatus adminPasswordStatus =
        await bluetoothController.checkAdminStatus();
    LogUtil.e("adminPasswordStatus:" + adminPasswordStatus.toString());
    baseActivityState.baseDialogController?.hide();
    if (adminPasswordStatus == AdminPasswordStatus.HaveSet) {
      goToManagerActivity();
    } else if (adminPasswordStatus == AdminPasswordStatus.UnSet) {
      await _firstSetAdminPassword();
    } else if (adminPasswordStatus == AdminPasswordStatus.UnKnow) {
      retryCheckAdminStatusCount++;
      if (retryCheckAdminStatusCount > 10) {
        retryCheckAdminStatusCount = 0;
        return;
      }
      await checkAdminPassword();
    }
  }

  Future<void> _firstSetAdminPassword() async {
    await showFirstSetAdminPasswordDialog(() {
      // ToastUtil.showShortToast(AppConfig.appS.first_set_admin_password_success);
      goToManagerActivity();
    });
  }

  Future<void> showFirstSetAdminPasswordDialog(VoidCallback result) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        Widget contentView = CheckPasswordOrTipsDialog(
          title: AppConfig.appS.update_admin_password_activity_title,
          leftButtonTitle:
              AppConfig.appS.update_admin_password_activity_set_text,
          leftButtonClick: (text) async {
            if (text.length < 4) {
              ToastUtil.showShortToast(AppConfig.appS.password_length_error);
              return;
            }
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            baseActivityState.baseDialogController
                ?.show(AppConfig.appS.loading);
            await BlueCommandConfig.changeAdminPassword(text);
            bluetoothController.adminPasswordStatus =
                AdminPasswordStatus.HaveSet;
            baseActivityState.baseDialogController?.hide();
            showUpdateAdminPasswordSuccessDialog(text,result);

            // WidgetsBinding.instance.addPostFrameCallback((callback) async {
            //   result.call();
            // });
          },
          rightButtonClick: () {
            NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
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


  Future<void> showUpdateAdminPasswordSuccessDialog(
      String code, VoidCallback result) async {
      await showDialog<void>(
        context: context,
        builder: (_) {
          Widget contentView = ConfirmPasswordOrTipsDialog(
            title: AppConfig.appS.dialog_update_admin_success_title,
            content: AppConfig.appS.dialog_update_admin_success_tips,
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

  @override
  void dispose() {
    super.dispose();
  }
}
