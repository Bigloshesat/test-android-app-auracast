import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/extension/widget_extension.dart';

import '../configs/app_config.dart';
import '../configs/assets_config.dart';
import '../controllers/wrong_password_tips_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_button_view.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class WrongPasswordTipsActivity extends NewBaseActivity {
  WrongPasswordTipsActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => WrongPasswordTipsActivityState();
}

class WrongPasswordTipsActivityState
    extends NewBaseActivityState<WrongPasswordTipsActivity> {
  WrongPasswordTipsActivityController _controller =
      WrongPasswordTipsActivityController();

  @override
  BaseController initController() {
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return NormalToolbarView(
      showBack: true,
      showLeftTitle: true,
      backgroundColor: SColors.main_help,
      bodyColor: SColors.main_help,
      contentColor: SColors.text_title,
      onBackClick: () {
        finish();
      },
      body: _buildBodyView(),
    ).addBackIntercept(() async {
      finish(false);
      return Future.value(true);
    });
  }

  Widget _buildBodyView() {
    return Column(
      children: [
        NormalImageView(
          assetUrl: AssetImageConfig.logo,
          width: Dimens.manager_activity_bottom_logo_width,
          fit: BoxFit.fitWidth,
        ),
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        Expanded(
          child: _buildContentView(),
        ),
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        // NormalImageView(
        //   assetUrl: AssetImageConfig.bluetooth,
        //   width: Dimens.bluetooth_logo_width,
        //   fit: BoxFit.fitWidth,
        // ),
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
      ],
    );
  }

  Widget _buildContentView() {
    Widget contentView = Column(
      children: [
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        NormalTextView(
            content: AppConfig.appS.wrong_password_tips_activity_tips,
            fontSize: Dimens.font_normal,
            color: SColors.text_title),
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        GestureDetector(
          child: Container(
            width: double.maxFinite,
            margin: EdgeInsets.all(Dimens.margin_super_broad),
            decoration: BoxDecoration(
              color: SColors.primary,
              borderRadius: BorderRadius.circular(Dimens.margin_normal * 2)
            ),
            child: NormalTextView(
              textAlign: TextAlign.center,
              color: SColors.text_title,
              padding: EdgeInsets.symmetric(vertical: Dimens.margin_normal),
              content: AppConfig.appS.wrong_password_tips_activity_button_text,
            ),
          ),
          onTap: () {
            finish(true);
          },
        )
      ],
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: contentView,
            decoration: BoxDecoration(
              color: SColors.main_help,
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.margin_less_broad),
              ),
              boxShadow: [
                BoxShadow(
                  color: SColors.box_show_color,
                  offset: Offset(0, 3),
                  blurRadius: Dimens.margin_normal,
                  spreadRadius: 0,
                ),
              ],
            ),
            margin: EdgeInsets.all(Dimens.margin_broad),
          )
        ],
      ),
    );
  }
}
