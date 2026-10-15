import 'package:flutter/cupertino.dart';
import 'package:framework/utils/eventbus_manager.dart';

import '../../configs/event_config.dart';
import '../../utils/language_util.dart';

class LocaleController extends ChangeNotifier {
  LocaleController() {
    EventBusManager().on(EventConfig.event_update_locale, eventCallback);
  }

  void eventCallback(dynamic arg) {
    processEvent(arg as Locale);
  }

  void processEvent(Locale? locale) {
    if (locale == null) {
      return;
    }
    notifyListeners();
  }

  Locale getLocale() {
    return LanguageUtil.getSelectLanguageLocale();
  }

  @override
  void dispose() {
    EventBusManager().off(EventConfig.event_update_locale, eventCallback);
    super.dispose();
  }
}
