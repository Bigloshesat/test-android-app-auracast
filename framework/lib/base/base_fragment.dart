/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/base/state_cache.dart';

import 'base_fragment_function.dart';
import 'bundle.dart';

abstract class BaseFragment extends StatefulWidget {
  final BaseActivityState baseActivityState;
  final Bundle? bundle;
  final StateCache<BaseFragmentState> stateCache = StateCache<BaseFragmentState>();

  BaseFragment(this.baseActivityState, {Key? key, this.bundle})
      : super(key: key);

  @override
  BaseFragmentState createState() {
    BaseFragmentState baseFragmentState = getState();
    stateCache.state = baseFragmentState;
    return baseFragmentState;
  }

  BaseFragmentState getState();
}

abstract class BaseFragmentState<T extends BaseFragment> extends State<T>
    with BaseFragmentFunction {
  BaseController? baseController;
  bool needDestroyController = false;

  @override
  void initState() {
    initFunction(this);
    onCreate();
    baseController = initController();
    needDestroyController = isNeedDestroyController();
    if (baseController != null) {
      baseController!.context = context;
      baseController!.state = this;
      baseController!.baseActivityState = widget.baseActivityState;
      baseController!.key = key;
      baseController!.initController(this, widget.bundle);
      baseController!.baseActivityState.putFragment(widget);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  @override
  void dispose() {
    onDestroy();
    baseController?.baseActivityState.removeFragment(widget);
    if (baseController != null && needDestroyController) {
      baseController!.dispose();
    }
    super.dispose();
  }
}
