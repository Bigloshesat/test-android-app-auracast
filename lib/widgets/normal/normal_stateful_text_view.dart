import 'package:flutter/material.dart';

import 'normal_text_view.dart';

class NormalStatefulTextView extends StatefulWidget {
  final String? text;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final AlignmentGeometry? alignment;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextStyle? textStyle;
  final FontWeight? fontWeight;
  final String? fontFamily;

  NormalStatefulTextView(
      {Key? key,
      this.text,
      this.color,
      this.margin,
      this.fontSize,
      this.alignment,
      this.maxLines,
      this.textOverflow,
      this.textStyle,
      this.fontWeight,
      this.fontFamily})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NormalStatefulTextViewState();
  }
}

class NormalStatefulTextViewState extends State<NormalStatefulTextView> {
  String? text;

  @override
  void initState() {
    super.initState();
    this.text = widget.text;
  }

  void updateText(String text) {
    this.text = text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NormalTextView(
      content: text,
      color: widget.color,
      margin: widget.margin,
      fontSize: widget.fontSize,
      alignment: widget.alignment,
      maxLines: widget.maxLines,
      textOverflow: widget.textOverflow,
      textStyle: widget.textStyle,
      fontWeight: widget.fontWeight,
      fontFamily: widget.fontFamily,
    );
  }
}
