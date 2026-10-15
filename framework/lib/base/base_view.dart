/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:framework/base/state_cache.dart';

import 'base_view_function.dart';
import 'bundle.dart';
import 'controllers/base_view_controller.dart';

abstract class BaseView extends StatefulWidget {
  final Bundle? bundle;
  final StateCache<BaseViewState> stateCache = StateCache<BaseViewState>();

  BaseView({Key? key, this.bundle}) : super(key: key);

  @override
  BaseViewState createState() {
    BaseViewState baseViewState = getState();
    stateCache.state = baseViewState;
    return baseViewState;
  }

  BaseViewState getState();
}

abstract class BaseViewState<T extends BaseView> extends State<T>
    with BaseViewFunction {
  BaseViewController? baseController;
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
      baseController!.key = key;
      baseController!.initController(this, widget.bundle);
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
    if (baseController != null && needDestroyController) {
      baseController!.dispose();
    }
    super.dispose();
  }
}
