import 'package:flutter/cupertino.dart';
import 'package:framework/utils/shared_preferences_manager.dart';

import '../configs/key_config.dart';

class LanguageUtil {
  static Future<void> updateSelectLanguageLocale(Locale locale) async {
    String language = locale.languageCode;
    await SharedPreferencesManager()
        .putString(KeyConfig.language_key, language);
  }

  static Locale getSelectLanguageLocale() {
    String? languageCode =
        SharedPreferencesManager().getString(KeyConfig.language_key);
    if (languageCode == null) {
      languageCode = "en";
    }
    return getLanguageLocale(languageCode);
  }

  static String getLanguageCode(Locale locale) {
    return locale.languageCode;
  }

  static Locale getLanguageLocale(String languageCode) {
    return Locale(languageCode);
  }
}
