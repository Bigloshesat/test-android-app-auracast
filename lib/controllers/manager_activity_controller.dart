import 'dart:async';

import 'package:base_flutter/configs/key_config.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:framework/base/base_callback_function.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/toast_util.dart';

import '../activitys/views/check_password_or_tips_dialog.dart';
import '../configs/app_config.dart';
import '../configs/blue_command_config.dart';
import '../configs/router_config.dart';
import '../models/extra/key_value.dart';
import '../utils/navigator_util.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

enum ManagerMenu {
  RENAME_OR_CHANGE_PIN,
  VOLUME_CONTROL,
  EQUALIZER,
  LITHE_LINK,
  SPEAKER_MODE,
  QR_CONNECT,
  SET_LANGUAGE,
  VIST_SUPPORT_FORTAL,
  LITHE_AUDIO_WEBSITE,
  RATE_SHARE_APP,
  REGISTER_YOUR_PRODUCT,
  INDICATOR_LIGHT,
  LIGHTING_LAMP,
  PRODUCT_INFORMATION
}

class ManagerActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;

  final List<KeyValue> menus = [];

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);

    initMenus();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await getProductInfo();
    });
  }

  //获取产品信息（就不在产品详情页面里面拿了，因为信息基本是固定的，不会变动）
  Future<void> getProductInfo() async {
    await BlueCommandConfig.checkProductStatus();
  }

  void initMenus() {
    menus.clear();
    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_rename_or_change_pin,
        value: ManagerMenu.RENAME_OR_CHANGE_PIN));
    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_volume_control,
        value: ManagerMenu.VOLUME_CONTROL));
    // 产品识别码 大于等于 0x83显示eq功能
    // if (bluetoothController.versionCode >= 131) {
    //   if (bluetoothController.versionCode != 132) {
    //     //83 ，86 都显示，84都不显示，85显示EQ不显示lithe
    //     menus.add(KeyValue(
    //         key: AppConfig.appS.manager_activity_menu_equalizer,
    //         value: ManagerMenu.EQUALIZER));

    //   }
    //   // menus.add(KeyValue(
    //   //     key: AppConfig.appS.manager_activity_menu_qr_connect,
    //   //     value: ManagerMenu.QR_CONNECT));
    // }
    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_equalizer,
        value: ManagerMenu.EQUALIZER));
    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_speaker_mode,
        value: ManagerMenu.SPEAKER_MODE));
    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_set_language,
        value: ManagerMenu.SET_LANGUAGE));


    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_indicator_light,
        value: ManagerMenu.INDICATOR_LIGHT));

    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_lighting_lamp,
        value: ManagerMenu.LIGHTING_LAMP));

    menus.add(KeyValue(
        key: AppConfig.appS.manager_activity_menu_product_information,
        value: ManagerMenu.PRODUCT_INFORMATION));

    // menus.add(KeyValue(
    //     key: AppConfig.appS.manager_activity_menu_visit_support_portal,
    //     value: ManagerMenu.VIST_SUPPORT_FORTAL));
    // menus.add(KeyValue(
    //     key: AppConfig.appS.manager_activity_menu_lithe_audio_website,
    //     value: ManagerMenu.LITHE_AUDIO_WEBSITE));
    // menus.add(KeyValue(
    //     key: AppConfig.appS.manager_activity_menu_rate_share_app,
    //     value: ManagerMenu.RATE_SHARE_APP));
    // menus.add(KeyValue(
    //     key: AppConfig.appS.manager_activity_menu_register_your_product,
    //     value: ManagerMenu.REGISTER_YOUR_PRODUCT));
  }

  void onMenuClick(KeyValue menu) {
    switch (menu.value) {
      case ManagerMenu.RENAME_OR_CHANGE_PIN:
        checkAdminPasswordAndJump(menu, ManagerMenu.RENAME_OR_CHANGE_PIN);
        break;
      case ManagerMenu.VOLUME_CONTROL:
        checkAdminPasswordAndJump(menu, ManagerMenu.VOLUME_CONTROL);
        break;
      case ManagerMenu.EQUALIZER:
        checkAdminPasswordAndJump(menu, ManagerMenu.EQUALIZER);
        break;
      case ManagerMenu.LITHE_LINK:
        checkAdminPasswordAndJump(menu, ManagerMenu.LITHE_LINK);
        break;
      case ManagerMenu.SPEAKER_MODE:
        checkAdminPasswordAndJump(menu, ManagerMenu.SPEAKER_MODE);
        break;
      case ManagerMenu.QR_CONNECT:
        break;
      case ManagerMenu.SET_LANGUAGE:
        Bundle bundle = Bundle();
        bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
        NavigatorUtil.jumpTo(context, ActivityName.SetLanguageActivity,
            bundle: bundle, dataCallback: (value) {
          if (value != null && value == true) {
            initMenus();
            notifyListeners();
          }
        });
        break;
      case ManagerMenu.VIST_SUPPORT_FORTAL:
        Bundle bundle = Bundle();
        bundle.putString(KeyConfig.web_view_title_key,
            AppConfig.appS.manager_activity_menu_visit_support_portal);
        bundle.putString(KeyConfig.web_view_url_key,
            "https://support.litheaudio.com/portal/en/kb/lithe-audio/bluetooth-ceiling-speaker");
        NavigatorUtil.jumpTo(context, ActivityName.WebViewActivity,
            bundle: bundle);
        break;
      case ManagerMenu.LITHE_AUDIO_WEBSITE:
        Bundle bundle = Bundle();
        bundle.putString(KeyConfig.web_view_title_key,
            AppConfig.appS.manager_activity_menu_lithe_audio_website);
        bundle.putString(
            KeyConfig.web_view_url_key, "https://www.litheaudio.com");
        NavigatorUtil.jumpTo(context, ActivityName.WebViewActivity,
            bundle: bundle);
        break;
      case ManagerMenu.RATE_SHARE_APP:
        Bundle bundle = Bundle();
        bundle.putString(KeyConfig.web_view_title_key,
            AppConfig.appS.manager_activity_menu_rate_share_app);
        bundle.putString(
            KeyConfig.web_view_url_key, "https://www.litheaudio.com");
        NavigatorUtil.jumpTo(context, ActivityName.WebViewActivity,
            bundle: bundle);
        break;
      case ManagerMenu.REGISTER_YOUR_PRODUCT:
        Bundle bundle = Bundle();
        bundle.putString(KeyConfig.web_view_title_key,
            AppConfig.appS.manager_activity_menu_register_your_product);
        bundle.putString(KeyConfig.web_view_url_key,
            "https://www.litheaudio.com/register-product.html");
        NavigatorUtil.jumpTo(context, ActivityName.WebViewActivity,
            bundle: bundle);
        break;
      case ManagerMenu.INDICATOR_LIGHT:
        checkAdminPasswordAndJump(menu, ManagerMenu.INDICATOR_LIGHT);
        break;
      case ManagerMenu.LIGHTING_LAMP:
        checkAdminPasswordAndJump(menu, ManagerMenu.LIGHTING_LAMP);
        break;
      case ManagerMenu.PRODUCT_INFORMATION:
        Bundle bundle = Bundle();
        bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
        NavigatorUtil.jumpTo(context, ActivityName.ProductInformationActivity,
            bundle: bundle);
        // checkAdminPasswordAndJump(menu, ManagerMenu.PRODUCT_INFORMATION);
        break;
      default:
        break;
    }
  }

  void checkAdminPasswordAndJump(KeyValue menu, ManagerMenu managerMenu) {
    showCheckAdminPasswordDialog((value) {
      if (!value) {
        Bundle bundle = Bundle();
        bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
        NavigatorUtil.jumpTo(context, ActivityName.WrongPasswordTipsActivity,
            bundle: bundle, dataCallback: (value) {
          if (value == true) {
            onMenuClick(menu);
          }
        });
        return;
      }
      switch (managerMenu) {
        case ManagerMenu.RENAME_OR_CHANGE_PIN:
          Bundle bundle = Bundle();
          bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
          NavigatorUtil.jumpTo(context, ActivityName.RenameOrChangePinActivity,
              bundle: bundle);
          break;
        case ManagerMenu.VOLUME_CONTROL:
          Bundle bundle = Bundle();
          bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
          NavigatorUtil.jumpTo(context, ActivityName.VolumeControlActivity,
              bundle: bundle);
          break;
        case ManagerMenu.EQUALIZER:
          Bundle bundle = Bundle();
          bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
          NavigatorUtil.jumpTo(context, ActivityName.EqualizerActivity,
              bundle: bundle);
          break;
        case ManagerMenu.LITHE_LINK:
          Bundle bundle = Bundle();
          bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
          NavigatorUtil.jumpTo(context, ActivityName.LitheLinkActivity,
              bundle: bundle);
          break;
        case ManagerMenu.SPEAKER_MODE:
          Bundle bundle = Bundle();
          bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
          NavigatorUtil.jumpTo(context, ActivityName.SpeakerModeActivity,
              bundle: bundle);
          break;
        case ManagerMenu.INDICATOR_LIGHT:
          Bundle bundle = Bundle();
          bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
          NavigatorUtil.jumpTo(context, ActivityName.IndicatorLightActivity,
              bundle: bundle);
          break;
        case ManagerMenu.LIGHTING_LAMP:
          Bundle bundle = Bundle();
          bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
          NavigatorUtil.jumpTo(context, ActivityName.LightingLampActivity,
              bundle: bundle);
          break;
        default:
          break;
      }
    });
  }

  void refresh() {
    notifyListeners();
  }

  Future<void> showCheckAdminPasswordDialog(VoidBoolCallback result) async {
    await showDialog(
      context: context,
      builder: (_) {
        Widget contentView = CheckPasswordOrTipsDialog(
          title: AppConfig.appS.dialog_administrator_password_title,
          leftButtonClick: (text) async {
            if (text.length < 4) {
              ToastUtil.showShortToast(AppConfig.appS.password_length_error);
              return;
            }
            NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
            baseActivityState.baseDialogController
                ?.show(AppConfig.appS.loading);
            try{
              await BlueCommandConfig.checkAdminPassword(text);
            } catch (e) {
              FlutterBugly.log(tag: "这是获取密码回调报错", message: e.toString(),level:LogLevel.ERROR);
            } finally {
              baseActivityState.baseDialogController?.hide();
            }

            WidgetsBinding.instance.addPostFrameCallback((callback) async {
              result.call(bluetoothController.isVerificationAdminPassword);
            });
          },
          rightButtonClick: () async {
            NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
          },
        );
        return contentView;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
