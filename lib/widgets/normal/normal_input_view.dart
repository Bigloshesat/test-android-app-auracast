import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/base/base_callback_function.dart';

class NormalInputView extends StatefulWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final String? text;
  final bool enable;
  final bool showBorder;
  final bool showDisabledBorder;
  final Color textColor;
  final String? hintText;
  final Color hintColor;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextInputType? textInputType;
  final bool autoFocus;
  final bool obscureText;
  final int? maxLength;
  final Color cursorColor;
  final Color bottomLineSelectColor;
  final Color bottomLineUnSelectColor;
  final double? bottomLineSelectWidth;
  final double? bottomLineUnSelectWidth;
  final double? cursorWidth;
  final Widget? prefixView;
  final Widget? suffixView;
  final bool disposeFocusNode;
  final bool disposeTextEditingController;
  final bool showCursorToLast;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final VoidBoolCallback? onFocusChange;
  final VoidStringCallback? onTextChange;
  final VoidCallback? onEditingComplete;

  NormalInputView(
      {Key? key,
      this.textEditingController,
      this.focusNode,
      this.text,
      this.enable = true,
      this.showBorder = true,
      this.showDisabledBorder = true,
      this.textColor = SColors.text_content,
      this.hintText,
      this.hintColor = SColors.text_hint,
      this.fontSize,
      this.textAlign,
      this.textInputType,
      this.autoFocus = false,
      this.obscureText = false,
      this.maxLength,
      this.cursorColor = SColors.text_content,
      this.bottomLineSelectColor = SColors.primary,
      this.bottomLineUnSelectColor = SColors.text_content,
      this.bottomLineSelectWidth,
      this.bottomLineUnSelectWidth,
      this.cursorWidth,
      this.prefixView,
      this.suffixView,
      this.disposeTextEditingController = true,
      this.disposeFocusNode = true,
      this.showCursorToLast = false,
      this.maxLines = 1,
      this.inputFormatters,
      this.contentPadding,
      this.onFocusChange,
      this.onTextChange,
      this.onEditingComplete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NormalInputViewState();
  }
}

class NormalInputViewState extends State<NormalInputView> {
  late FocusNode focusNode;
  late TextEditingController textEditingController;
  String currentValue = "";

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    textEditingController =
        widget.textEditingController ?? TextEditingController();
    textEditingController.addListener(_textEditingListener);
    focusNode.addListener(_focusListener);
    textEditingController.text = widget.text ?? "";
  }

  void updateText(String text,
      {bool updateCurrentValue = true, bool moveSelectionToLast = true}) {
    if (textEditingController.text != text) {
      if (updateCurrentValue) {
        currentValue = text;
      }
      textEditingController.text = text;
      if (moveSelectionToLast) {
        textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: textEditingController.text.length));
      }
    }
  }

  void _textEditingListener() {
    if (widget.maxLength != null &&
        textEditingController.text.length > widget.maxLength!) {
      textEditingController.text =
          textEditingController.text.substring(0, widget.maxLength);
      if (widget.showCursorToLast) {
        textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: textEditingController.text.length));
      }
    }
    bool lengthChange =
        currentValue != textEditingController.text ? true : false;
    if (lengthChange && widget.showCursorToLast) {
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
    if (currentValue != textEditingController.text) {
      currentValue = textEditingController.text;
      widget.onTextChange?.call(currentValue);
    }
  }

  void _focusListener() {
    widget.onFocusChange?.call(focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    double theFontSize = widget.fontSize ?? Dimens.font_normal;
    double theBottomLineUnSelectWidth =
        widget.bottomLineUnSelectWidth ?? Dimens.line_narrow;
    double theBottomLineSelectWidth =
        widget.bottomLineSelectWidth ?? Dimens.line_normal;
    double theCursorWidth = widget.cursorWidth ?? Dimens.line_normal;
    EdgeInsetsGeometry theContentPadding =
        widget.contentPadding ?? EdgeInsets.all(0);
    Widget contentView = TextField(
      textAlign: widget.textAlign ?? TextAlign.start,
      controller: textEditingController,
      style: TextStyle(
          color: widget.textColor,
          fontSize: theFontSize,
          textBaseline: TextBaseline.alphabetic),
      keyboardType: widget.textInputType,
      autofocus: widget.autoFocus,
      cursorColor: widget.cursorColor,
      cursorWidth: theCursorWidth,
      focusNode: focusNode,
      maxLines: widget.maxLines,
      inputFormatters: widget.inputFormatters ??
          (widget.maxLength != null
              ? <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(widget.maxLength)
                ]
              : null),
      obscureText: widget.obscureText,
      onEditingComplete: widget.onEditingComplete,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        enabled: widget.enable,
        isDense: true,
        hintStyle: TextStyle(
            color: widget.hintColor,
            fontSize: theFontSize,
            textBaseline: TextBaseline.alphabetic),
        hintText: widget.hintText,
        prefixIcon: widget.prefixView,
        contentPadding: theContentPadding,
        prefixIconConstraints: widget.prefixView != null
            ? BoxConstraints(
                minHeight: Dimens.font_broad,
                minWidth: Dimens.font_broad,
              )
            : null,
        suffixIcon: widget.suffixView,
        suffixIconConstraints: widget.suffixView != null
            ? BoxConstraints(
                minHeight: Dimens.font_broad,
                minWidth: Dimens.font_broad,
              )
            : null,
        focusedBorder: widget.showBorder
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.bottomLineSelectColor,
                    width: theBottomLineSelectWidth),
              )
            : OutlineInputBorder(borderSide: BorderSide.none),
        border: widget.showBorder
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.bottomLineUnSelectColor,
                    width: theBottomLineUnSelectWidth),
              )
            : OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: widget.showBorder
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.bottomLineUnSelectColor,
                    width: theBottomLineUnSelectWidth),
              )
            : OutlineInputBorder(borderSide: BorderSide.none),
        disabledBorder: widget.showDisabledBorder
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.bottomLineUnSelectColor,
                    width: theBottomLineUnSelectWidth),
              )
            : OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
    return contentView;
  }

  @override
  void dispose() {
    textEditingController.removeListener(_textEditingListener);
    focusNode.removeListener(_focusListener);
    if (widget.disposeFocusNode) {
      focusNode.dispose();
    }
    if (widget.disposeTextEditingController) {
      textEditingController.dispose();
    }
    super.dispose();
  }
}
