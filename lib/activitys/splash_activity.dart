import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/configs/assets_config.dart';
import 'package:base_flutter/controllers/splash_activity_controller.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:base_flutter/widgets/normal/normal_image_view.dart';
import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import 'new_base_activity.dart';

class SplashActivity extends NewBaseActivity {
  SplashActivity() : super();

  @override
  BaseActivityState getState() => SplashActivityState();
}

class SplashActivityState extends NewBaseActivityState<SplashActivity> {
  SplashActivityController _controller = SplashActivityController();

  @override
  BaseController initController() {
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return Scaffold(
      backgroundColor: SColors.main_help,
      body: _buildBodyView(),
    );
  }

  Widget _buildBodyView() {
    Widget contentView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height:  Dimens.normal_toolbar_height,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(
                width: Dimens.line_broad, color: SColors.line))
          ),
          child: NormalTextView(
            content: AppConfig.appS.splash_activity_welcome_text,
            fontSize: Dimens.splash_activity_welcome_text_size,
            color: SColors.text_title,
            fontWeight: FontWeight.bold,
          ),
        ),
        NormalTextView(
          content: AppConfig.appS.splash_activity_lecovita_text,
          fontSize: Dimens.font_more_narrow,
          height: Dimens.font_super_broad / Dimens.font_more_narrow,
          color: SColors.text_title,
        ),
        NormalTextView(
          content: AppConfig.appS.splash_activity_since_text,
          fontSize: Dimens.font_more_narrow,
          height: Dimens.font_super_broad / Dimens.font_more_narrow,
          color: SColors.text_title,
        ),
        NormalTextView(
          content: AppConfig.appS.splash_activity_install_text,
          fontSize: Dimens.font_more_narrow,
          height: Dimens.font_super_broad / Dimens.font_more_narrow,
          color: SColors.text_title,
        ),
        NormalTextView(
          content: AppConfig.appS.splash_activity_designer_text,
          fontSize: Dimens.font_more_narrow,
          height: Dimens.font_super_broad / Dimens.font_more_narrow,
          color: SColors.text_title,
        ),
        NormalTextView(
          content: AppConfig.appS.splash_activity_pro_text,
          fontSize: Dimens.font_more_narrow,
          height: Dimens.font_super_broad / Dimens.font_more_narrow,
          color: SColors.text_title,
        ),
        DimenBoxs.vBox30,
        Container(
          alignment: Alignment.center,
          child: NormalImageView(
            assetUrl: AssetImageConfig.logo,
            width: Dimens.splash_activity_logo_width,
            fit: BoxFit.fitWidth,
          ),
        ),
        Spacer(),
        Container(
          alignment: Alignment.center,
          child: NormalImageView(
            assetUrl: AssetImageConfig.bluetooth1,
            height: Dimens.splash_activity_blue_tooth_width,
            fit: BoxFit.fitHeight,
          ),
        ),
        DimenBoxs.vBox10,
        NormalTextView(
          alignment: Alignment.center,
          content: AppConfig.appS.blue_tooth_text,
          fontSize: Dimens.font_more_narrow,
          height: Dimens.font_more_broad / Dimens.font_normal,
          color: SColors.text_hint,
        ),
        DimenBoxs.vBox30,
      ],
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.margin_normal * 2),
      child: contentView,
    );
  }

  // Widget _buildBackgroundView() {
  //   return NormalImageView(
  //     assetUrl: AssetImageConfig.splash_background,
  //     fit: BoxFit.cover,
  //   );
  // }

  Widget _buildBottomView() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      NormalImageView(
        assetUrl: AssetImageConfig.bluetooth,
        width: Dimens.splash_activity_splash_logo_width,
        fit: BoxFit.fitWidth,
      ),
      DimenBoxs.vBoxNormal,
    ]);
  }
}
