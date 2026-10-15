import 'package:base_flutter/utils/keyboard_util.dart';
import 'package:base_flutter/widgets/loading_dialog/loading_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/base/controllers/base_dialog_controller.dart';
import 'package:framework/utils/network/http_manager.dart';
import 'package:framework/widgets/provider_widget.dart';

abstract class NewBaseActivity extends BaseActivity {
  NewBaseActivity({Key? key, Bundle? bundle}) : super(key: key, bundle: bundle);
}

abstract class NewBaseActivityState<T extends NewBaseActivity>
    extends BaseActivityState<T> {
  bool needCancelRequest = true;

  @override
  BaseDialogController initDialogController() {
    return LoadingDialogController(context);
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (baseController != null) {
      return ProviderWidget<BaseController>(
          model: baseController!,
          onModelReady: (model) => {},
          builder: (BuildContext context, BaseController model, Widget? child) {
            return buildViews(context);
          });
    } else {
      return buildViews(context);
    }
  }

  Widget buildViews(BuildContext context);

  @override
  void finish<T extends Object>([T? result]) {
    KeyBoardUtil.hideKeyboard(context);
    super.finish(result);
  }

  @override
  void onDestroy() {
    if (needCancelRequest) {
      HttpManager().cancelHttp(getKey());
    }
    super.onDestroy();
  }
}
