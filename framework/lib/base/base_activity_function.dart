/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/time_util.dart';

import 'base_activity.dart';
import 'base_fragment.dart';
import 'controllers/base_dialog_controller.dart';

abstract mixin class BaseActivityFunction {
  final List<BaseFragment> fragments = [];
  late BuildContext buildContext;
  late String key;
  bool isFinish = false;

  void initFunction(BaseActivityState baseActivityState) {
    buildContext = baseActivityState.context;
    key = "ActivityKey__" + TimeUtil.getUniqueTimestamp().toString();
  }

  String getKey() {
    return key;
  }

  void putFragment(BaseFragment baseFragment) {
    if (fragments.contains(baseFragment)) {
      return;
    }
    fragments.add(baseFragment);
  }

  void removeFragment(BaseFragment baseFragment) {
    fragments.remove(baseFragment);
  }

  T? getTargetFragment<T extends BaseFragment>() {
    T? targetFragment;
    fragments.forEach((baseFragment) {
      if (baseFragment is T) {
        targetFragment = baseFragment;
      }
    });
    return targetFragment;
  }

  BaseFragment? getTopFragment() {
    BaseFragment? baseFragment;
    if (fragments.length > 0) {
      baseFragment = fragments[fragments.length - 1];
    }
    return baseFragment;
  }

  BaseFragment? popFragment() {
    BaseFragment? baseFragment;
    if (fragments.length > 0) {
      int last = fragments.length - 1;
      baseFragment = fragments[last];
      fragments.removeAt(last);
    }
    return baseFragment;
  }

  void clearFragments() {
    fragments.clear();
  }

  void onCreate() {}

  BaseController initController();

  BaseDialogController? initDialogController() {
    return null;
  }

  bool isNeedDestroyController() {
    return true;
  }

  Widget buildWidget(BuildContext context);

  void onResume() {}

  void onPause() {}

  void onBackground() {}

  void onForeground() {}

  void onDestroy() {}

  double getScreenWidth() {
    return MediaQuery.of(buildContext).size.width;
  }

  double getScreenHeight() {
    return MediaQuery.of(buildContext).size.height;
  }

  double getTopBarHeight() {
    return MediaQuery.of(buildContext).padding.top;
  }

  double getAppBarHeight() {
    return kToolbarHeight;
  }

  void finish<T extends Object>([T? result]) {
    isFinish = true;
    Navigator.pop<T>(buildContext, result);
  }
}
