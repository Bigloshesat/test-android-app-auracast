import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class LoadingDialogView extends StatefulWidget {
  final Color background;
  final String? title;
  final TextController? textController;
  final bool disposeTextController;

  LoadingDialogView(
      {Key? key,
      this.background = SColors.loading_dialog_background,
      this.title,
      this.textController,
      this.disposeTextController = true});

  @override
  State<StatefulWidget> createState() {
    return _LoadingDialogViewState();
  }

  static Widget dialogView(
      {Color background = SColors.loading_dialog_background, String? title}) {
    Widget contentView = SizedBox(
      width: Dimens.loading_dialog_width,
      height: Dimens.loading_dialog_height,
      child: Container(
          decoration: ShapeDecoration(
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.loading_dialog_radius),
            ),
          ),
          child: _buildDialogIndicatorView(title)),
    );
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: contentView,
      ),
    );
  }

  static Widget _buildDialogIndicatorView(String? title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: Dimens.loading_dialog_indicator_width,
          height: Dimens.loading_dialog_indicator_width,
          child: CustomLoadingIndicator(
            radius: Dimens.loading_dialog_indicator_half_width,
          ),
        ),
        DimenBoxs.vBoxNarrow,
        Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.margin_narrow),
            child: Text(title ?? "",
                maxLines: 2,
                style: TextStyle(
                    fontSize: Dimens.font_more_narrow,
                    color: SColors.main_help))),
      ],
    );
  }
}

class _LoadingDialogViewState extends State<LoadingDialogView> {
  String? _title;

  @override
  void initState() {
    super.initState();
    if (widget.textController != null) {
      widget.textController!.addListener(() {
        setState(() {
          _title = widget.textController!.value;
        });
      });
    }
    _title = widget.title;
  }

  @override
  void dispose() {
    if (widget.textController != null && widget.disposeTextController) {
      widget.textController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future<bool>.value(false),
        child: LoadingDialogView.dialogView(title: _title));
  }
}

class TextController extends ChangeNotifier {
  String _value = "";
  bool _hasFocus = false;
  bool _valueChange = true;

  get value => _value;

  get hasFocus => _hasFocus;

  get valueChange => _valueChange;

  void updateFocus(bool focus) {
    _hasFocus = focus;
    _valueChange = false;
    notifyListeners();
  }

  void setNewText(String text) {
    _valueChange = true;
    _value = text;
    notifyListeners();
  }

  void clear() {
    _valueChange = true;
    setNewText("");
  }

  void deleteOne() {
    _valueChange = true;
    if (_value.length == 0) {
      setNewText("");
    } else {
      setNewText(_value.substring(0, _value.length - 1));
    }
  }

  void addText(String text) {
    _valueChange = true;
    setNewText(_value + text);
  }
}
