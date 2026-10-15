import 'package:base_flutter/models/extra/key_value.dart';
import 'package:flutter/material.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';
import '../../widgets/normal/normal_icon_view.dart';
import '../../widgets/normal/normal_text_view.dart';

class ManagerActivityMenuItem extends StatelessWidget {
  final KeyValue data;
  final VoidCallback? onClick;
  final bool isTop;

  ManagerActivityMenuItem(
      {Key? key, required this.data, this.onClick, this.isTop = false})
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
    Widget contentView = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildDetailsView()),
        DimenBoxs.hBoxNormal,
        NormalIconView(
          icon: -1,
          iconData: Icons.arrow_forward_ios,
          fontSize: Dimens.font_normal,
          color: SColors.text_content,
        ),
        DimenBoxs.hBox20,
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.margin_super_broad),
      margin: EdgeInsets.symmetric(vertical: Dimens.margin_normal, horizontal: Dimens.margin_less_normal * 3),
      child: contentView,
      decoration: BoxDecoration(
        color: SColors.main_help,
        borderRadius: BorderRadius.circular(Dimens.margin_less_broad),
        boxShadow: [
          BoxShadow(
            color: SColors.box_show_color,
            offset: Offset(0, 30),
            blurRadius: Dimens.margin_normal,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsView() {
    return NormalTextView(
        textAlign: TextAlign.center,
        content: data.key,
        fontSize: Dimens.font_broad,
        color: SColors.text_content);
  }
}
