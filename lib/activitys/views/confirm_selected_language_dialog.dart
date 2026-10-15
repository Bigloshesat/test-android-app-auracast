import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

import '../../configs/app_config.dart';
import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';
import '../../widgets/normal/normal_text_view.dart';

class ConfirmSelectedLanguageDialog extends Dialog {
  final String? title;
  final String? content;
  final bool showLeftButton;
  final bool showRightButton;
  final bool showInput;
  final bool showValidate;
  final String? inputHint;
  final String? leftButtonTitle;
  final String? rightButtonTitle;
  final VoidCallback? leftButtonClick;
  final VoidCallback? rightButtonClick;
  final Color? buttonColor;

  ConfirmSelectedLanguageDialog(
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
        this.buttonColor,
      })
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
    Widget contentView = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DimenBoxs.vBox30,
        DimenBoxs.vBox24,
        NormalTextView(
            content: title,
            fontSize: Dimens.font_super_broad,
            color: SColors.text_title,
            maxLines: 99,
            height: 1.5,
            textAlign: TextAlign.center
        ),
        DimenBoxs.vBox30,
        _buildButtonView(),
        DimenBoxs.vBox30,
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.margin_normal * 2),
      padding: EdgeInsets.symmetric(horizontal: Dimens.margin_normal),
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


  Widget _buildButtonView() {
    Color theButtonColor = buttonColor ?? SColors.main_help;
    Widget contentView = Row(
      children: [
        showLeftButton
            ? Expanded(
          flex: 1,
          child: GestureDetector(
              child: NormalTextView(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(Dimens.margin_broad),
                  content: leftButtonTitle ?? AppConfig.appS.ok,
                  fontSize: Dimens.font_super_broad,
                  color: theButtonColor),
              onTap: () {
                leftButtonClick?.call();
              },
              behavior: HitTestBehavior.translucent),
        )
            : Container(),
        (showLeftButton && showRightButton)
            ? Container(
            height: Dimens.password_input_view_line_height,
            width: Dimens.line_normal,
            color: SColors.password_input_view_line)
            : Container(),
        showRightButton
            ? Expanded(
          flex: 1,
          child: GestureDetector(
              child: NormalTextView(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(Dimens.margin_normal),
                  content: rightButtonTitle ?? AppConfig.appS.cancel,
                  fontSize: Dimens.font_super_broad,
                  color: theButtonColor),
              onTap: () {
                rightButtonClick?.call();
              },
              behavior: HitTestBehavior.translucent),
        )
            : Container(),
      ],
    );
    return Container(
        margin: EdgeInsets.all(Dimens.margin_normal), child: contentView);
  }

}