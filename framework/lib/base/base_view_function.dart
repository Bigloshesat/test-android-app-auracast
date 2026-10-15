/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framework/utils/time_util.dart';

import 'controllers/base_view_controller.dart';

abstract mixin class BaseViewFunction {
  late BuildContext buildContext;
  late String key;

  void initFunction(State state) {
    buildContext = state.context;
    key = "ViewKey__" + TimeUtil.getUniqueTimestamp().toString();
  }

  String getKey() {
    return key;
  }

  void onCreate() {}

  BaseViewController initController();

  bool isNeedDestroyController() {
    return true;
  }

  Widget buildWidget(BuildContext context);

  void onDestroy() {}
}
