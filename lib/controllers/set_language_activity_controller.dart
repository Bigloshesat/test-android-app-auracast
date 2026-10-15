import 'package:base_flutter/resources/s_colors.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/eventbus_manager.dart';
import 'package:framework/utils/toast_util.dart';

import '../activitys/views/confirm_selected_language_dialog.dart';
import '../configs/app_config.dart';
import '../configs/event_config.dart';
import '../configs/key_config.dart';
import '../models/extra/key_value.dart';
import '../utils/language_util.dart';
import '../utils/navigator_util.dart';
import 'extra/application_controller.dart';

enum LanguageType {
  ENGLISH,
  SPANISH,
  FRENCH,
  ITALIAN,
  GERMAN,
  DUTCH,
  RUSSIAN,
  POLISH,
  SWEDISH,
  DANISH,
  PORTUGUESE,
  JAPANESE,
  ARABIC,
  CHINESE
}

class SetLanguageActivityController extends BaseController {
  late ApplicationController applicationController;
  BluetoothInfo? bluetoothInfo;

  final List<KeyValue> languages = [];
  int selectLanguageIndex = 0;

  bool isLanguageChange = false;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    initLanguages();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {});
  }

  void initLanguages() {
    languages.clear();
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_english,
        value: LanguageType.ENGLISH,
        object: "en"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_spanish,
        value: LanguageType.SPANISH,
        object: "es"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_french,
        value: LanguageType.FRENCH,
        object: "fr"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_italian,
        value: LanguageType.ITALIAN,
        object: "it"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_german,
        value: LanguageType.GERMAN,
        object: "de"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_dutch,
        value: LanguageType.DUTCH,
        object: "nl"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_russian,
        value: LanguageType.RUSSIAN,
        object: "ru"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_polish,
        value: LanguageType.POLISH,
        object: "pl"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_swedish,
        value: LanguageType.SWEDISH,
        object: "sv"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_danish,
        value: LanguageType.DANISH,
        object: "da"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_portuguese,
        value: LanguageType.DANISH,
        object: "pt"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_japanese,
        value: LanguageType.DANISH,
        object: "ja"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_arabic,
        value: LanguageType.ARABIC,
        object: "ar"));
    languages.add(KeyValue(
        key: AppConfig.appS.language_name_chinese,
        value: LanguageType.CHINESE,
        object: "zh"));
    String currentLanguageCode =
        LanguageUtil.getSelectLanguageLocale().languageCode;
    for (int i = 0; i < languages.length; i++) {
      KeyValue keyValue = languages[i];
      if (currentLanguageCode == keyValue.object) {
        selectLanguageIndex = i;
        break;
      }
    }
  }

  void updateSelectLanguageIndex(int index) {
    selectLanguageIndex = index;
    notifyListeners();
    showConfirmSelectedLanguageDialog(selectLanguageIndex);
  }

  Future<void> showConfirmSelectedLanguageDialog(int index) async {
    await showDialog(context: context, builder: (_) {
      return ConfirmSelectedLanguageDialog(
        title: AppConfig.appS.confirm_selected_language_dialog_content.replaceFirst("%x", languages[index].key.toString()),
        buttonColor: SColors.text_title,
        leftButtonTitle: AppConfig.appS.sure,
        leftButtonClick: () {
          NavigatorUtil.pop(context, NavigatorResultType.SUCCESS);
          changeLanguage();
        },
        rightButtonClick: () {
          NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
        },
      );
    });
  }


  Future<void> changeLanguage() async {
    if (languages.length <= selectLanguageIndex) {
      return;
    }
    KeyValue keyValue = languages[selectLanguageIndex];
    String languageCode = keyValue.object;
    Locale locale = LanguageUtil.getLanguageLocale(languageCode);
    if (locale.languageCode ==
        LanguageUtil.getSelectLanguageLocale().languageCode) {
      return;
    }
    isLanguageChange = true;
    await LanguageUtil.updateSelectLanguageLocale(locale);
    EventBusManager().send(EventConfig.event_update_locale, locale);
    postFrameCallback((callback) async {
      await Future.delayed(Duration(milliseconds: 100));
      ToastUtil.showShortToast(
          AppConfig.appS.set_language_activity_success_tips);
      initLanguages();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
