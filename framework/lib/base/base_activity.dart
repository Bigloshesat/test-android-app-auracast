/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:framework/base/state_cache.dart';
import 'package:framework/utils/log_util.dart';
import 'package:framework/utils/screen_util.dart';

import 'activity_manager.dart';
import 'base_activity_function.dart';
import 'bundle.dart';
import 'controllers/base_controller.dart';
import 'controllers/base_dialog_controller.dart';

abstract class BaseActivity extends StatefulWidget {
  final Bundle? bundle;
  final StateCache<BaseActivityState> stateCache = StateCache<BaseActivityState>();

  BaseActivity({Key? key, this.bundle}) : super(key: key);

  @override
  BaseActivityState createState() {
    BaseActivityState baseActivityState = getState();
    stateCache.state = baseActivityState;
    return baseActivityState;
  }

  BaseActivityState getState();
}

abstract class BaseActivityState<T extends BaseActivity> extends State<T>
    with WidgetsBindingObserver, BaseActivityFunction {
  BaseController? baseController;
  BaseDialogController? baseDialogController;
  bool needDestroyController = false;

  @override
  void initState() {
    initFunction(this);
    ActivityManager().addActivity(this);
    WidgetsBinding.instance.addObserver(this);
    onCreate();
    baseController = initController();
    needDestroyController = isNeedDestroyController();
    if (baseController != null) {
      baseController!.context = context;
      baseController!.state = this;
      baseController!.baseActivityState = this;
      baseController!.key = key;
      baseController!.initController(this, widget.bundle);
    }
    baseDialogController = initDialogController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    ActivityManager().removeActivity(this);
    if (baseController != null && needDestroyController) {
      baseController!.dispose();
    }
    if (baseDialogController != null) {
      baseDialogController!.dispose();
    }
    LogUtil.v("onDestroy" + this.toString());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (ActivityManager().isTopActivity(this)) {
        onForeground();
        onResume();
      }
    } else if (state == AppLifecycleState.paused) {
      if (ActivityManager().isTopActivity(this)) {
        onBackground();
        onPause();
      }
    }
    super.didChangeAppLifecycleState(state);
  }
}
