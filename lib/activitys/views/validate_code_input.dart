import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/base/base_callback_function.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';

typedef CompleteCallback(String content);

enum InputType {
  password,
  number,
  text,
}

class ValidateCodeInput extends StatefulWidget {
  final int count;
  final InputType inputType;
  final bool autofocus;
  final double spaceRate;
  final double heightRate;
  final Color? bottomLineColor;
  final Color? textColor;
  final double? width;
  final double? fontSize;
  final VoidStringCallback? onTextChange;

  ValidateCodeInput({
    Key? key,
    this.count = 6,
    this.inputType = InputType.number,
    this.autofocus = true,
    this.spaceRate = 0.2,
    this.heightRate = 1.0,
    this.bottomLineColor = SColors.main_help,
    this.textColor = SColors.main_help,
    this.width,
    this.fontSize,
    this.onTextChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ValidateCodeInputState();
  }
}

class ValidateCodeInputState extends State<ValidateCodeInput> {
  String inputContent = "";
  TextEditingController _textEditingController = TextEditingController();

  String getInputText() {
    return _textEditingController.text;
  }

  ValidateCodeInputState();

  @override
  Widget build(BuildContext context) {
    double width = 0;
    if (widget.width != null) {
      width = widget.width!;
    } else {
      width = MediaQuery.of(context).size.width;
    }
    double itemTotalWidth = width / widget.count;
    double spaceMargin = 0;
    double itemWidth = 0;
    if (widget.spaceRate > 0 && widget.spaceRate <= 0.5) {
      spaceMargin = itemTotalWidth * widget.spaceRate;
      itemWidth = itemTotalWidth - 2 * spaceMargin;
    }
    double itemHeight = itemWidth * widget.heightRate;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          width: width,
          height: itemHeight,
          child: _buildContentView(
              itemWidth, itemHeight, spaceMargin, itemTotalWidth)),
    );
  }

  Widget _buildContentView(double itemWidth, double itemHeight,
      double spaceMargin, double itemTotalWidth) {
    Widget contentView = Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _getItems(itemWidth, itemHeight, spaceMargin),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(itemTotalWidth / 2, 0, 0, 0),
          child: TextField(
            keyboardType: _keyboardType(),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(widget.count)
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: TextStyle(color: Colors.transparent),
            controller: _textEditingController,
            showCursor: false,
            autofocus: widget.autofocus,
            onChanged: (value) {
              setState(() {
                inputContent = value;
              });
              widget.onTextChange?.call(inputContent);
            },
          ),
        ),
      ],
    );
    return contentView;
  }

  void clear() {
    Future.microtask(() {
      _textEditingController.clear();
      setState(() {
        inputContent = "";
      });
    });
  }

  List<Widget> _getItems(
      double itemWidth, double itemHeight, double spaceMargin) {
    var widgets = <Widget>[];
    for (var i = 0; i < widget.count; i++) {
      widgets.add(Container(
        width: itemWidth,
        height: itemHeight,
        margin: EdgeInsets.fromLTRB(spaceMargin, 0, spaceMargin, 0),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: SColors.line,
            width: Dimens.line_narrow,
          ),
        )),
        alignment: Alignment.center,
        child: Text(
          _getIndexString(i),
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
          ),
        ),
      ));
    }
    return widgets;
  }

  String _getIndexString(int index) {
    if (inputContent.isEmpty) return "";
    if (inputContent.length > index) {
      if (widget.inputType == InputType.password) {
        return "●";
      } else {
        return inputContent[index];
      }
    } else {
      return "";
    }
  }

  TextInputType _keyboardType() {
    if (widget.inputType == InputType.number) {
      return TextInputType.number;
    } else if (widget.inputType == InputType.password) {
      return TextInputType.text;
    } else {
      return TextInputType.text;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
