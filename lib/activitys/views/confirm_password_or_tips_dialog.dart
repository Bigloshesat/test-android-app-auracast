import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

import '../../configs/app_config.dart';
import '../../widgets/normal/normal_button_view.dart';

class ConfirmPasswordOrTipsDialog extends Dialog {
  final String? title;
  final String? content;
  final List<String> password;
  final String? buttonTitle;
  final VoidCallback? buttonClick;
  final bool showButton;
  final EdgeInsets? margin;
  final bool showDoubleButton;
  final String? topButtonText;
  final String? bottomButtonText;
  final VoidCallback? topButtonClick;
  final VoidCallback? bottomButtonClick;
  final Color? buttonColor;
  final double? buttonTextSize;

  ConfirmPasswordOrTipsDialog(
      {Key? key,
      this.title,
      this.content,
      required this.password,
      this.buttonTitle,
      this.buttonClick,
      this.showButton = true,
      this.showDoubleButton = false,
      this.margin,
      this.topButtonText,
      this.bottomButtonText,
      this.topButtonClick,
      this.bottomButtonClick,
      this.buttonColor,
      this.buttonTextSize
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
        DimenBoxs.vBoxBroad,
        DimenBoxs.vBoxBroad,
        NormalTextView(
          content: title,
          fontSize: Dimens.font_super_broad,
          color: SColors.text_title,
        ),
        DimenBoxs.vBoxBroad,
        _buildPasswordView(context),
        // NormalTextView(content: password),
        DimenBoxs.vBoxBroad,
        NormalTextView(
          textAlign: TextAlign.center,
          content: content,
          fontSize: Dimens.font_normal,
          color: SColors.text_title,
          maxLines: null,
        ),
        DimenBoxs.vBoxBroad,
        if(showButton) _buildButtonView(),
        if(showDoubleButton) _buildDoubleButtonView(),
        DimenBoxs.vBoxBroad,
        DimenBoxs.vBoxBroad,
      ],
    );
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: Dimens.margin_super_narrow * 11),
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

  Widget _buildPasswordView(BuildContext context) {
    double validateViewWidth =
        MediaQuery.of(context).size.width - 2 * Dimens.margin_broad;

    double inputViewWidth = validateViewWidth -
        Dimens.margin_normal * 8 -
        Dimens.margin_super_narrow * 2;

    double itemTotalWidth = inputViewWidth / 4;
    double spaceMargin = 0;
    double itemWidth = 0;
    spaceMargin = itemTotalWidth * 0.2;
    itemWidth = itemTotalWidth - 2 * spaceMargin;
    double itemHeight = itemWidth;

    List<Widget> passwordItem = [];
    for (var i = 0; i < password.length; ++i) {
      passwordItem.add(
        Expanded(child: NormalTextView(
          content: password[i],
          textAlign: TextAlign.center,
          fontSize: Dimens.font_super_broad,
          color: SColors.text_title,
        ))
      );
    }

    return  Container(
      padding: EdgeInsets.all(Dimens.margin_super_narrow),
      margin: EdgeInsets.fromLTRB(
          Dimens.margin_super_broad,
          Dimens.margin_narrow,
          Dimens.margin_super_broad,
          Dimens.margin_narrow),
      width: inputViewWidth,
      height: itemHeight,
      decoration: BoxDecoration(
        color: SColors.main_help,
        borderRadius: BorderRadius.circular(Dimens.margin_normal),
      ),
      child: Row(
        children: passwordItem,
      ),
      // child: NormalTextView(content: "1 2 3 4"),
    );
  }

  Widget _buildButtonView() {
    Color theButtonColor = buttonColor ?? SColors.main_help;
    Widget contentView =  Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.margin_narrow, horizontal: Dimens.margin_normal * 4),
      decoration: BoxDecoration(
        color: theButtonColor,
        borderRadius: BorderRadius.circular(Dimens.margin_normal),
      ),
      child: NormalTextView(
        content: buttonTitle ?? AppConfig.appS.ok,
        fontSize: buttonTextSize ?? Dimens.font_super_broad,
        color: SColors.text_title,
      ),
    );

    return GestureDetector(
      child: contentView,
      onTap: buttonClick,
    );
  }


  Widget _buildDoubleButtonView() {
    return Column(
      children: [
        NormalButtonView(
          margin: EdgeInsets.all(Dimens.margin_super_broad),
          text: topButtonText,
          showStroke: false,
          color: SColors.main_help,
          radius: Dimens.radius_narrow,
          fontSize: Dimens.font_normal,
          textColor: SColors.text_title,
          height: Dimens.button_height_normal,
          onClick: () {
            topButtonClick?.call();
          },
        ),
        NormalButtonView(
          margin: EdgeInsets.symmetric(horizontal: Dimens.margin_super_broad),
          text: bottomButtonText,
          showStroke: true,
          strokeColor: SColors.main_help,
          color: SColors.main_help,
          radius: Dimens.radius_narrow,
          fontSize: Dimens.font_normal,
          textColor: SColors.text_title,
          height: Dimens.button_height_normal,
          onClick: () {
            bottomButtonClick?.call();
          },
        ),
      ],
    );
  }

}
