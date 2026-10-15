import 'package:base_flutter/models/extra/key_value.dart';
import 'package:flutter/material.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';
import '../../widgets/normal/normal_icon_view.dart';
import '../../widgets/normal/normal_text_view.dart';

class SetLanguageActivityMenuItem extends StatelessWidget {
  final KeyValue data;
  final VoidCallback? onClick;
  final bool isTop;
  final bool isSelected;

  SetLanguageActivityMenuItem(
      {Key? key, required this.data, this.onClick, this.isTop = false, this.isSelected = false})
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
        // DimenBoxs.hBoxNormal,
        // NormalIconView(
        //   icon: -1,
        //   iconData: Icons.arrow_forward_ios,
        //   fontSize: Dimens.font_normal,
        //   color: SColors.text_content,
        // ),
      ],
    );
    return Container(
      padding: EdgeInsets.all(Dimens.margin_less_broad),
      margin: EdgeInsets.symmetric(horizontal: Dimens.margin_super_broad * 2),
      child: contentView,
      decoration: BoxDecoration(
        color: isSelected ? SColors.set_language_activity_menu_item_selected_color: null,
        border: Border(
          top: isTop ? BorderSide(
            color: SColors.line,
            width: Dimens.line_narrow,
          ) : BorderSide.none,
          bottom: BorderSide(
            color: SColors.line,
            width: Dimens.line_narrow,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsView() {
    return NormalTextView(
        textAlign: TextAlign.center,
        content: data.key,
        fontSize: Dimens.font_broad,
        color: SColors.text_title);
  }
}
