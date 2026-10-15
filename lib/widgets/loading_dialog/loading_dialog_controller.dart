import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/controllers/base_dialog_controller.dart';
import 'package:framework/utils/router_manager.dart';
import 'package:framework/utils/time_util.dart';

import 'loading_dialog_view.dart';

class LoadingDialogController implements BaseDialogController {
  BuildContext context;
  TextController? _textController;
  bool _isShowing = false;
  BuildContext? dialogContext;
  String dialogKey = "";

  LoadingDialogController(this.context);

  @override
  bool isShowing() {
    return _isShowing;
  }

  @override
  void show(String title, {bool releaseFocus = true}) {
    if (!_isShowing) {
      _textController ?? TextController();
      _isShowing = true;
      dialogKey = "dialog_" + TimeUtil.getUniqueTimestamp().toString();
      if (!RouterManager()
          .routeHistory
          .hasActiveRoute(ModalRoute.withName(dialogKey))) {
        showDialog<bool>(
            context: context,
            routeSettings: RouteSettings(name: dialogKey),
            builder: (BuildContext context) {
              dialogContext = context;
              Widget contentView = LoadingDialogView(
                title: title,
                background: SColors.loading_dialog_background,
                textController: _textController,
                disposeTextController: false,
              );
              return contentView;
            });
      }
    } else {
      _textController?.setNewText(title);
    }
  }

  @override
  void hide() {
    if (_isShowing) {
      _isShowing = false;
      RouterManager().routeHistory.removeRoute(ModalRoute.withName(dialogKey));
    }
  }

  @override
  void dispose() {
    _textController?.dispose();
    _textController = null;
  }
}
