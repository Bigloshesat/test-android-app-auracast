/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/time_util.dart';

import 'base_fragment.dart';

abstract mixin class BaseFragmentFunction {
  late BuildContext buildContext;
  late String key;

  void initFunction(BaseFragmentState baseFragmentState) {
    buildContext = baseFragmentState.context;
    key = "FragmentKey__" + TimeUtil.getUniqueTimestamp().toString();
  }

  String getKey() {
    return key;
  }

  void onCreate() {}

  BaseController initController();

  bool isNeedDestroyController() {
    return true;
  }

  Widget buildWidget(BuildContext context);

  void onDestroy() {}

  void onForeground(){}

  double getScreenWidth() {
    return MediaQuery.of(buildContext).size.width;
  }

  double getScreenHeight() {
    return MediaQuery.of(buildContext).size.height;
  }
}
