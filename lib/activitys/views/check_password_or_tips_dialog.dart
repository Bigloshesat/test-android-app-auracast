import 'package:base_flutter/activitys/views/validate_view.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

class CheckPasswordOrTipsDialog extends Dialog {
  final String? title;
  final String? content;
  final bool showLeftButton;
  final bool showRightButton;
  final bool showInput;
  final bool showValidate;
  final String? inputHint;
  final String? leftButtonTitle;
  final String? rightButtonTitle;
  final VoidStringCallback? leftButtonClick;
  final VoidCallback? rightButtonClick;
  final VoidStringCallback? textChanged;

  CheckPasswordOrTipsDialog(
      {Key? key,
      this.title,
      this.content,
      this.showLeftButton = true,
      this.showRightButton = true,
      this.showInput = true,
      this.showValidate = true,
      this.inputHint,
      this.leftButtonTitle,
      this.rightButtonTitle,
      this.leftButtonClick,
      this.rightButtonClick,
      this.textChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: GestureDetector(
            child: _buildContentView(context),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildContentView(BuildContext context) {
    double validateViewWidth =
        MediaQuery.of(context).size.width - 2 * Dimens.margin_broad;
    Widget contentView = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DimenBoxs.vBoxBroad,
        ValidateView(
            title: this.title,
            content: this.content,
            width: validateViewWidth,
            inputDecoration: BoxDecoration(
              color: SColors.main_help,
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.margin_normal),
              ),
            ),
            backgroundColor: Colors.transparent,
            titleColor: SColors.text_title,
            contentColor: SColors.text_title,
            inputTextColor: SColors.text_title,
            titleFontSize: Dimens.font_super_broad,
            contentFontSize: Dimens.font_normal,
            inputFontSize: Dimens.font_super_broad,
            showLeftButton: this.showLeftButton,
            showRightButton: this.showRightButton,
            showInput: this.showInput,
            showValidate: this.showValidate,
            inputHint: this.inputHint,
            buttonColor: SColors.text_title,
            leftButtonTitle: this.leftButtonTitle,
            rightButtonTitle: this.rightButtonTitle,
            leftButtonClick: this.leftButtonClick,
            rightButtonClick: this.rightButtonClick,
            textChanged: this.textChanged),
        DimenBoxs.vBoxBroad,
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.margin_super_narrow * 11),
      decoration: ShapeDecoration(
        color: SColors.validate_input_view_background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.radius_super_broad * 2),
          ),
        ),
      ),
      child: contentView,
    );
  }
}
