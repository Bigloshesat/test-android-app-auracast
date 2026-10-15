import 'package:base_flutter/resources/dimens.dart';
import 'package:flutter/material.dart';

import 'normal_text_view.dart';

class NormalButtonView extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final Color disableColor;
  final Color textColor;
  final double? fontSize;
  final bool showStroke;
  final double? strokeWidth;
  final Color strokeColor;
  final bool enable;
  final bool haveBorderRadius;
  final bool useMaterialButton;
  final double? radius;
  final Widget? loadingView;
  final Widget? loadingSuccessView;
  final VoidCallback? onClick;

  NormalButtonView({
    Key? key,
    this.text,
    this.textStyle,
    this.width,
    this.height,
    this.margin,
    this.color = Colors.black,
    this.disableColor = Colors.grey,
    this.textColor = Colors.white,
    this.fontSize,
    this.showStroke = false,
    this.strokeWidth,
    this.strokeColor = Colors.transparent,
    this.enable = true,
    this.haveBorderRadius = true,
    this.useMaterialButton = true,
    this.radius,
    this.loadingView,
    this.loadingSuccessView,
    this.onClick,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NormalButtonViewState();
  }
}

class NormalButtonViewState extends State<NormalButtonView> {
  late bool enable;

  @override
  void initState() {
    super.initState();
    _updateValue();
  }

  void _updateValue() {
    enable = widget.enable;
  }

  @override
  void didUpdateWidget(NormalButtonView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _updateValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    double theWidth = widget.width ?? double.infinity;
    double theHeight = widget.height ?? Dimens.button_height_normal;
    double theRadius = widget.radius ?? theHeight / 2;
    double theFontSize = widget.fontSize ?? Dimens.font_normal;
    TextStyle theTextStyle = widget.textStyle ??
        TextStyle(color: widget.textColor, fontSize: theFontSize);
    Widget contentView = Container(
      width: theWidth,
      child: widget.showStroke
          ? _showStrokeView(theTextStyle, theHeight, theRadius)
          : _showSolidView(theTextStyle, theHeight, theRadius),
    );
    return Container(
      margin: widget.margin,
      height: theHeight,
      child: contentView,
    );
  }

  Widget _showStrokeView(TextStyle textStyle, double height, double radius) {
    double theStrokeWidth = widget.strokeWidth ?? Dimens.line_normal;
    Widget contentView = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: widget.strokeColor, width: theStrokeWidth),
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: NormalTextView(
        content: widget.text,
        alignment: Alignment.center,
        textStyle: textStyle,
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enable ? widget.onClick : null,
      child: contentView,
    );
  }

  Widget _showSolidView(TextStyle textStyle, double height, double radius) {
    return widget.useMaterialButton
        ? _buildMaterialSolidButton(textStyle, height, radius)
        : _buildSolidButton(textStyle, height, radius);
  }

  Widget _buildMaterialSolidButton(
      TextStyle textStyle, double height, double radius) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: enable ? widget.onClick : null,
      disabledColor: widget.disableColor,
      color: widget.color,
      child: NormalTextView(
        content: widget.text,
        alignment: Alignment.center,
        textStyle: textStyle,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildSolidButton(TextStyle textStyle, double height, double radius) {
    Widget contentView = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enable ? widget.color : widget.disableColor,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: NormalTextView(
        content: widget.text,
        alignment: Alignment.center,
        textStyle: textStyle,
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enable ? widget.onClick : null,
      child: contentView,
    );
  }

  void setEnable(bool enable) {
    setState(() {
      this.enable = enable;
    });
  }
}
