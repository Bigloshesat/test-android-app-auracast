/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

extension WidgetExtension on Widget {
  Widget addBackIntercept(BoolFutureCallback function) {
    return WillPopScope(
      onWillPop: function,
      child: this,
    );
  }

  Widget addClick(Function() function) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: function,
      child: this,
    );
  }
}
