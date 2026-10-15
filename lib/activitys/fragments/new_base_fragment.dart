import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/base_fragment.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/network/http_manager.dart';
import 'package:framework/widgets/provider_widget.dart';

abstract class NewBaseFragment extends BaseFragment {
  NewBaseFragment(BaseActivityState baseActivityState,
      {Key? key, Bundle? bundle})
      : super(baseActivityState, key: key, bundle: bundle);
}

abstract class NewBaseFragmentState<T extends NewBaseFragment>
    extends BaseFragmentState<T> {
  bool needCancelRequest = true;

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
  void onDestroy() {
    if (needCancelRequest) {
      HttpManager().cancelHttp(getKey());
    }
    super.onDestroy();
  }
}
