import 'package:base_flutter/models/extra/key_value.dart';
import 'package:flutter/material.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';
import '../../widgets/normal/normal_text_view.dart';

class ChooseTypeItem extends StatelessWidget {
  final KeyValue data;
  final bool isChecked;
  final double? width;
  final double? borderRadius;
  final bool? throughoutShowBorder;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onClick;
  final Color? checkedTextColor;
  final Color? unCheckedTextColor;
  final Color? checkedColor;
  final Color? unCheckedColor;
  final Color? checkedBorderColor;
  final Color? unCheckedBorderColor;

  ChooseTypeItem(
      {Key? key,
      required this.data,
      this.isChecked = false,
      this.width,
      this.borderRadius,
      this.throughoutShowBorder,
      this.margin,
      this.onClick,
      this.checkedTextColor,
      this.unCheckedTextColor,
      this.checkedColor,
      this.unCheckedColor,
      this.checkedBorderColor,
      this.unCheckedBorderColor,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: _buildContentView(),
      onTap: onClick,
    );
  }

  Widget _buildContentView() {
    Color theCheckedColor =
        this.checkedColor ?? SColors.default_button_select_background;
    Color theUnCheckedColor = this.unCheckedColor ?? SColors.line;
    Color theCheckedTextColor = this.checkedTextColor ?? SColors.main_help;
    Color theUnCheckedTextColor = this.checkedTextColor ?? SColors.text_content;
    bool showBorder = throughoutShowBorder ?? isChecked;


    Widget contentView = Container(
      width: width,
      alignment: Alignment.center,
      margin: margin,
      padding: EdgeInsets.all(Dimens.margin_normal),
      child: NormalTextView(
          content: data.key,
          fontSize: Dimens.font_normal,
          color: isChecked ? theCheckedTextColor : theUnCheckedTextColor),
      decoration: BoxDecoration(
        color: isChecked ? theCheckedColor : null,
        border: showBorder
            ? Border.all(color: Colors.transparent, width: Dimens.line_normal)
            : Border.all(
                color: isChecked ? (checkedBorderColor ?? theCheckedColor) : (unCheckedBorderColor ?? theUnCheckedColor),
                width: Dimens.line_normal),
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? Dimens.radius_narrow),
        ),
      ),
    );
    return Container(
      width: width,
      child: contentView,
    );
  }
}
