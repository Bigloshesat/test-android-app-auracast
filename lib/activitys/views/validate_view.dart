import 'package:base_flutter/activitys/views/validate_code_input.dart';
import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/base/base_callback_function.dart';

class ValidateView extends StatefulWidget {
  final String? title;
  final String? content;
  final String? inputHint;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Decoration? inputDecoration;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? contentColor;
  final Color? inputTextColor;
  final double? titleFontSize;
  final double? contentFontSize;
  final double? inputFontSize;
  final bool showLeftButton;
  final bool showRightButton;
  final bool showInput;
  final bool showValidate;
  final int validateCount;
  final String? leftButtonTitle;
  final String? rightButtonTitle;
  final Color? buttonColor;
  final VoidStringCallback? leftButtonClick;
  final VoidCallback? rightButtonClick;
  final VoidStringCallback? textChanged;

  ValidateView(
      {Key? key,
      this.title,
      this.content,
      this.inputHint,
      this.width,
      this.margin,
      this.decoration,
      this.inputDecoration,
      this.backgroundColor,
      this.titleColor,
      this.contentColor,
      this.inputTextColor,
      this.titleFontSize,
      this.contentFontSize,
      this.inputFontSize,
      this.showLeftButton = true,
      this.showRightButton = true,
      this.showInput = true,
      this.showValidate = true,
      this.validateCount = 4,
      this.leftButtonTitle,
      this.rightButtonTitle,
      this.buttonColor,
      this.leftButtonClick,
      this.rightButtonClick,
      this.textChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ValidateViewState();
  }
}

class ValidateViewState extends State<ValidateView> {
  String text = "";


  @override
  Widget build(BuildContext context) {
    Color theBackgroundColor =
        widget.backgroundColor ?? SColors.validate_input_view_background;
    return Container(
      margin: widget.margin,
      decoration: widget.decoration,
      color: widget.decoration != null ? null : theBackgroundColor,
      child: _buildContentView(context),
    );
  }

  _buildContentView(BuildContext context) {
    Color theTitleColor = widget.titleColor ?? SColors.main_help;
    double theTitleFontSize = widget.titleFontSize ?? Dimens.font_normal;
    Color theContentColor = widget.contentColor ?? SColors.main_help;
    double theContentFontSize = widget.contentFontSize ?? Dimens.font_broad;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DimenBoxs.vBoxBroad,
        NormalTextView(
            content: widget.title,
            fontSize: theTitleFontSize,
            color: theTitleColor,
            maxLines: 2,
            height: 1.5,
            textAlign: TextAlign.center),
        DimenBoxs.vBoxBroad,
        widget.content != null
            ? NormalTextView(
                content: widget.content,
                fontSize: theContentFontSize,
                color: theContentColor,
                maxLines: 2,
                textAlign: TextAlign.center)
            : Container(),
        widget.content != null ? DimenBoxs.vBoxBroad : Container(),
        widget.showInput ? _buildPasswordInputView(context) : Container(),
        DimenBoxs.vBoxBroad,
        _buildButtonView()
      ],
    );
  }

  _buildPasswordInputView(BuildContext context) {
    double inputViewWidth = (widget.width ?? MediaQuery.of(context).size.width) -
        (widget.margin?.horizontal ?? 0) -
        Dimens.margin_normal * 8 -
        Dimens.margin_super_narrow * 2 -
        (widget.decoration?.padding.horizontal ?? 0) -
        (widget.inputDecoration?.padding.horizontal ?? 0);
    Color theTextColor = widget.inputTextColor ?? SColors.main_help;
    double theFontSize = widget.inputFontSize ?? Dimens.font_max_broad;
    return Container(
      decoration: widget.inputDecoration,
      padding: EdgeInsets.all(Dimens.margin_super_narrow),
      margin: EdgeInsets.fromLTRB(
          Dimens.margin_super_broad,
          Dimens.margin_narrow,
          Dimens.margin_super_broad,
          Dimens.margin_narrow),
      child: widget.showValidate
          ? ValidateCodeInput(
              count: widget.validateCount,
              width: inputViewWidth,
              textColor: theTextColor,
              fontSize: theFontSize,
              onTextChange: (value) {
                text = value;
                widget.textChanged?.call(value);
              },
            )
          : _buildInputView(),
    );
  }

  Widget _buildInputView() {
    Color theTextColor = widget.inputTextColor ?? SColors.main_help;
    double theFontSize = widget.inputFontSize ?? Dimens.font_max_broad;
    return Container(
      padding: EdgeInsets.only(
          left: Dimens.margin_narrow, right: Dimens.margin_narrow),
      child: TextField(
          keyboardType: TextInputType.text,
          autofocus: true,
          cursorColor: theTextColor,
          cursorWidth: Dimens.line_normal,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(27)
          ],
          style: TextStyle(color: theTextColor, fontSize: theFontSize),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                  color: SColors.transparent_text_content,
                  fontSize: theFontSize),
              hintText: widget.inputHint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none),
          onChanged: (String value) {
            text = value;
            widget.textChanged?.call(value);
          }),
    );
  }

  Widget _buildButtonView() {
    Color theButtonColor = widget.buttonColor ?? SColors.main_help;
    Widget contentView = Row(
      children: [
        widget.showLeftButton
            ? Expanded(
                flex: 1,
                child: GestureDetector(
                    child: NormalTextView(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(Dimens.margin_broad),
                        content: widget.leftButtonTitle ?? AppConfig.appS.ok,
                        fontSize: Dimens.font_broad,
                        color: theButtonColor),
                    onTap: () {
                      widget.leftButtonClick?.call(text);
                    },
                    behavior: HitTestBehavior.translucent),
              )
            : Container(),
        (widget.showLeftButton && widget.showRightButton)
            ? Container(
                height: Dimens.password_input_view_line_height,
                width: Dimens.line_normal,
                color: SColors.password_input_view_line)
            : Container(),
        widget.showRightButton
            ? Expanded(
                flex: 1,
                child: GestureDetector(
                    child: NormalTextView(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(Dimens.margin_normal),
                        content: widget.rightButtonTitle ?? AppConfig.appS.cancel,
                        fontSize: Dimens.font_broad,
                        color: theButtonColor),
                    onTap: () {
                      widget.rightButtonClick?.call();
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
