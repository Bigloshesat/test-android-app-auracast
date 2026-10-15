import 'package:base_flutter/activitys/views/validate_view.dart';
import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/assets_config.dart';
import '../controllers/update_admin_password_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_image_view.dart';
import 'new_base_activity.dart';

class UpdateAdminPasswordActivity extends NewBaseActivity {
  UpdateAdminPasswordActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => UpdateAdminPasswordActivityState();
}

class UpdateAdminPasswordActivityState
    extends NewBaseActivityState<UpdateAdminPasswordActivity> {
  UpdateAdminPasswordActivityController _controller =
      UpdateAdminPasswordActivityController();

  @override
  BaseController initController() {
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: SColors.primary,
      body: SafeArea(
        top: true,
        child: _buildBodyView(),
      ),
    );
  }

  Widget _buildBodyView() {
    return Column(
      children: [
        // DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        NormalImageView(
          assetUrl: AssetImageConfig.logo1,
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
        NormalImageView(
          assetUrl: AssetImageConfig.bluetooth,
          height: Dimens.splash_activity_blue_tooth_width,
          fit: BoxFit.fitHeight,
        ),
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
      ],
    );
  }

  Widget _buildContentView() {
    Widget contentView = ValidateView(
        margin: EdgeInsets.all(Dimens.margin_broad),
        title: AppConfig.appS.update_admin_password_activity_title,
        leftButtonTitle: AppConfig.appS.set,
        inputTextColor: SColors.text_content,
        textChanged: (value) {
          _controller.adminPassword = value;
        },
        inputDecoration: BoxDecoration(
          color: SColors.main_help,
          border: Border.all(color: SColors.line, width: Dimens.line_narrow),
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.radius_super_narrow),
          ),
        ),
        leftButtonClick: (value) {
          _controller.changeAdminPassword();
        },
        rightButtonClick: () {
          finish();
        },
        showValidate: true);
    return SingleChildScrollView(
      child: Column(
        children: [contentView],
      ),
    );
  }
}
