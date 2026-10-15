import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NormalTextView extends StatelessWidget {
  final String? content;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final AlignmentGeometry? alignment;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextStyle? textStyle;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextDecoration? decoration;
  final TextBaseline? textBaseline;

  NormalTextView(
      {Key? key,
      required this.content,
      this.color,
      this.margin,
      this.fontSize,
      this.alignment,
      this.maxLines = 1,
      this.textOverflow = TextOverflow.ellipsis,
      this.textStyle,
      this.fontWeight,
      this.fontFamily,
      this.decoration = TextDecoration.none,
      this.textBaseline = TextBaseline.alphabetic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double theFontSize = fontSize ?? 12;
    Color theColor = color ?? Colors.black;

    TextStyle theTextStyle = textStyle ??
        TextStyle(
          fontSize: theFontSize,
          color: theColor,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          decoration: decoration,
          textBaseline: textBaseline,
          // height: FontConfig.font_size_scale
        );
    Widget contentView = Text(
      content ?? "",
      maxLines: maxLines,
      overflow: textOverflow,
      style: theTextStyle,
    );
    return Container(
      margin: margin,
      alignment: alignment,
      child: contentView,
    );
  }
}
