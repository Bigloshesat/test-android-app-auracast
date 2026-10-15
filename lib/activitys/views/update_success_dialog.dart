import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

import '../../configs/app_config.dart';
import '../../widgets/normal/normal_button_view.dart';
import '../../widgets/normal/normal_text_view.dart';

class UpdateSuccessDialog extends Dialog {
  final String? title;
  final String? content;
  final String? tips;
  final double? titleFontSize;
  final double? contentFontSize;
  final double? tipsFontSize;
  final String? nextButtonText;
  final VoidCallback? nextClick;
  final bool showSplitLine;

  UpdateSuccessDialog(
      {Key? key,
      this.title,
      this.content,
      this.tips,
      this.titleFontSize,
      this.contentFontSize,
      this.tipsFontSize,
      this.nextButtonText,
      this.nextClick,
      this.showSplitLine = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: _buildContentView(context),
        ),
      ),
    );
  }

  Widget _buildContentView(BuildContext context) {
    double theTitleFontSize = titleFontSize ?? Dimens.font_super_broad;
    double theContentFontSize = contentFontSize ?? Dimens.font_max_broad;
    double theTipsFontSize = tipsFontSize ?? Dimens.font_broad;

    Widget contentView = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DimenBoxs.vBoxSuperBroad,
        NormalTextView(
            content: title,
            fontSize: theTitleFontSize,
            color: SColors.text_title,
            maxLines: 2,
            textAlign: TextAlign.center),
        content != null ? DimenBoxs.vBoxSuperBroad : Container(),
        content != null
            ? NormalTextView(
                content: content,
                fontSize: theContentFontSize,
                color: SColors.main_help,
                maxLines: 2,
                textAlign: TextAlign.center)
            : Container(),
        DimenBoxs.vBoxSuperBroad,
        showSplitLine
            ? Container(
                width: Dimens.update_success_dialog_split_line_width,
                height: Dimens.line_narrow,
                color: SColors.main_help)
            : Container(),
        showSplitLine ? DimenBoxs.vBoxSuperBroad : Container(),
        tips != null
            ? NormalTextView(
                content: tips,
                fontSize: theTipsFontSize,
                color: SColors.text_title,
                maxLines: AppConfig.maxTextLines,
                textAlign: TextAlign.center)
            : Container(),
        tips != null ? DimenBoxs.vBoxSuperBroad : Container(),
        NormalButtonView(
          margin: EdgeInsets.all(Dimens.margin_super_broad),
          text: nextButtonText,
          showStroke: false,
          color: SColors.default_button_select_background,
          radius: Dimens.radius_narrow,
          fontSize: Dimens.font_normal,
          textColor: SColors.text_title,
          height: Dimens.button_height_normal,
          onClick: () {
            nextClick?.call();
          },
        ),
        DimenBoxs.vBoxBroad,
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.margin_broad),
      decoration: ShapeDecoration(
        color: SColors.validate_input_view_background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.radius_normal),
          ),
        ),
      ),
      child: contentView,
    );
  }
}
