import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';

import 'keyboard_util.dart';

typedef DataCallback<T> = void Function(T? value);

enum NavigatorResultType { SUCCESS, ERROR, BACK, CANCEL }

class NavigatorUtil {
  static Future<void> checkHiddenKeyboard(BuildContext context,
      {bool hiddenKeyboard = false}) async {
    if (hiddenKeyboard) {
      KeyBoardUtil.hideKeyboard(context);
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  static jumpTo<T extends Object?>(BuildContext context, dynamic path,
      {Bundle? bundle,
      DataCallback<T>? dataCallback,
      bool hiddenKeyboard = true}) async {
    await checkHiddenKeyboard(context, hiddenKeyboard: hiddenKeyboard);
    T? result =
        await Navigator.pushNamed(context, path.toString(), arguments: bundle);
    if (dataCallback != null) {
      dataCallback(result);
    }
  }

  static replaceTo<T extends Object?>(BuildContext context, dynamic path,
      {Bundle? bundle,
      DataCallback<T>? dataCallback,
      bool hiddenKeyboard = true}) async {
    await checkHiddenKeyboard(context, hiddenKeyboard: hiddenKeyboard);
    T? result = await Navigator.pushReplacementNamed(context, path.toString(),
        arguments: bundle);
    if (dataCallback != null) {
      dataCallback(result);
    }
  }

  static clearTo(BuildContext context, dynamic path,
      {Bundle? bundle, bool hiddenKeyboard = true}) async {
    await checkHiddenKeyboard(context, hiddenKeyboard: hiddenKeyboard);
    Navigator.pushNamedAndRemoveUntil(
        context, path.toString(), (Route route) => false,
        arguments: bundle);
  }

  static popUntil(BuildContext context, dynamic path,
      {bool hiddenKeyboard = true}) async {
    await checkHiddenKeyboard(context, hiddenKeyboard: hiddenKeyboard);
    Navigator.popUntil(context, ModalRoute.withName(path.toString()));
  }

  static pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
