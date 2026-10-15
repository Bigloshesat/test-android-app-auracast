import 'package:flutter/material.dart';

class KeyBoardUtil {
  static void showKeyboard(GlobalKey<State<TextField>> editableKey) {
    dynamic textFieldState = editableKey.currentState;
    dynamic editTextState = textFieldState?.editableTextKey?.currentState;
    editTextState?.requestKeyboard();
  }

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
