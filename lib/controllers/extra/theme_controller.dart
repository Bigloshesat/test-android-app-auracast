import 'package:flutter/cupertino.dart';

class ThemeController extends ChangeNotifier {
  Color? themeColor;

  void updateTheme(Color color) {
    this.themeColor = color;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
