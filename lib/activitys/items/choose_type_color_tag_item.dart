import 'package:base_flutter/models/extra/key_value.dart';
import 'package:flutter/material.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';
import '../../widgets/normal/normal_text_view.dart';

class ChooseTypeColorTagItem extends StatelessWidget {
  final KeyValue data;
  final bool isChecked;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onClick;
  final Color? checkedTextColor;
  final Color? unCheckedTextColor;
  final Color? checkedColor;
  final Color? unCheckedColor;

  ChooseTypeColorTagItem(
      {Key? key,
      required this.data,
      this.isChecked = false,
      this.width,
      this.height,
      this.margin,
      this.padding,
      this.onClick,
      this.checkedTextColor,
      this.unCheckedTextColor,
      this.checkedColor,
      this.unCheckedColor,
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
    double height = this.height ?? Dimens.choose_type_color_tag_item_height;
    Color theCheckedColor =
        this.checkedColor ?? SColors.default_button_select_background;
    Color theUnCheckedColor = this.unCheckedColor ?? SColors.line;
    Color theCheckedTextColor = this.checkedTextColor ?? SColors.main_help;
    Color theUnCheckedTextColor = this.checkedTextColor ?? SColors.text_content;

    Widget iconView = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isChecked ? SColors.choose_type_color_tag_item_box_select_ball_background_color
                : SColors.choose_type_color_tag_item_box_un_select_ball_background_color,
            borderRadius: BorderRadius.circular(Dimens.choose_type_color_tag_item_box_icon_width / 2)
          ),
          width: Dimens.choose_type_color_tag_item_box_icon_width,
          height: Dimens.choose_type_color_tag_item_box_icon_width,
        ),
        Positioned(
          child: Container(
            decoration: BoxDecoration(
                color: SColors.text_title,
                borderRadius: BorderRadius.circular(Dimens.choose_type_color_tag_item_box_icon_small_width / 2)
            ),
            width: Dimens.choose_type_color_tag_item_box_icon_small_width,
            height: Dimens.choose_type_color_tag_item_box_icon_small_width,
          ),
          bottom: 0,
          right: Dimens.choose_type_color_tag_item_box_icon_small_width,
        )
      ],
    );

    Widget contentView = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: Dimens.margin_normal),
      child: NormalTextView(
          content: data.key,
          fontSize: Dimens.font_normal,
          color: isChecked ? theCheckedTextColor : theUnCheckedTextColor),
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: isChecked ? theCheckedColor : theUnCheckedColor,
        borderRadius: BorderRadius.circular(Dimens.radius_super_narrow * 7),
        boxShadow: [
          BoxShadow(
            color: SColors.choose_type_color_tag_item_box_show_color,
            offset: Offset(0, 3),
            blurRadius: Dimens.margin_normal,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          iconView,
          Expanded(child: contentView),
          SizedBox(
            width: Dimens.choose_type_color_tag_item_box_icon_width,
            height: Dimens.choose_type_color_tag_item_box_icon_width,
          )
        ],
      ),
    );
  }
}
