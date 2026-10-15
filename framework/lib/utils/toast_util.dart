/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static showToast(String? content,
      {Toast? toastLength,
        int timeInSecForIosWeb = 1,
        double? fontSize,
        ToastGravity? gravity = ToastGravity.BOTTOM,
        Color? backgroundColor,
        Color? textColor}) {
    Fluttertoast.showToast(
      msg: content ?? "",
      toastLength: toastLength,
      timeInSecForIosWeb: timeInSecForIosWeb,
      fontSize: fontSize,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  static showShortToast(String? content) {
    if(content==null||content==""){
      return;
    }
    showToast(content, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
  }

  static showLongToast(String? content) {
    if(content==null||content==""){
      return;
    }
    showToast(content, toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
  }

  static showCenterShortToast(String? content,
      {double? fontSize, Color? backgroundColor, Color? textColor}) {
    showToast(
      content,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      fontSize: fontSize,
      gravity: ToastGravity.CENTER,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
