import 'package:base_flutter/configs/assets_config.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:base_flutter/widgets/normal/normal_image_view.dart';
import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VersionUpdateTipsView extends StatelessWidget {
  final String? title;
  final String? versionTips;
  final String? content;

  VersionUpdateTipsView({Key? key, this.title, this.versionTips, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageView(),
            DimenBoxs.vBoxNarrow,
            _buildTitleView(),
            DimenBoxs.vBoxNarrow,
            _buildVersionTipsView(),
            DimenBoxs.vBoxNarrow,
            _buildContentView()
          ],
        ),
      ),
    );
  }

  Widget _buildImageView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radius_normal),
      child: NormalImageView(
          assetUrl: AssetImageConfig.update_version_background,
          width: double.infinity,
          fit: BoxFit.fitWidth),
    );
  }

  Widget _buildTitleView() {
    return NormalTextView(
      margin: EdgeInsets.symmetric(horizontal: Dimens.margin_broad),
      content: title,
      color: SColors.text_title,
      fontSize: Dimens.font_broad,
    );
  }

  Widget _buildVersionTipsView() {
    return NormalTextView(
      margin: EdgeInsets.symmetric(horizontal: Dimens.margin_broad),
      content: versionTips,
      color: SColors.text_hint,
      fontSize: Dimens.font_narrow,
    );
  }

  Widget _buildContentView() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Dimens.margin_normal, horizontal: Dimens.margin_broad),
      child: Column(children: [
        NormalTextView(
          content: content,
          color: SColors.text_content,
          fontSize: Dimens.font_normal,
          maxLines: 20,
        )
      ]),
    );
  }
}
