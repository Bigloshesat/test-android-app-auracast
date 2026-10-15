import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../configs/assets_config.dart';
import '../controllers/connected_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_button_view.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class ConnectedActivity extends NewBaseActivity {
  ConnectedActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => ConnectedActivityState();
}

class ConnectedActivityState extends NewBaseActivityState<ConnectedActivity> {
  ConnectedActivityController _controller = ConnectedActivityController();

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
      bodyColor: SColors.primary,
      contentColor: SColors.text_title,
      middle: _buildMiddleTitleView(),
      middleFlex: 3,
      onBackClick: () {
        finish();
      },
      body: _buildBodyView(),
    );
  }

  Widget _buildMiddleTitleView() {
    return NormalTextView(
        alignment: Alignment.center,
        content: AppConfig.appS.connected_activity_title,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.text_title);
  }

  Widget _buildBodyView() {
    Widget contentView = Column(
      children: [
        DimenBoxs.vBox20,
        Expanded(child: _buildContentView()),
        DimenBoxs.vBoxNormal,
        NormalImageView(
          assetUrl: AssetImageConfig.logo,
          width: Dimens.manager_activity_bottom_logo_width,
          fit: BoxFit.fitWidth,
        ),
        DimenBoxs.vBoxNormal,
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.margin_super_broad),
      child: contentView,
    );
  }

  Widget _buildContentView() {
    Widget contentView = Column(
      children: [
        _buildBluetoothInfoView(),
        DimenBoxs.vBox20,
        _buildBluetoothButtonView(),
        DimenBoxs.vBoxSuperBroad,
      ],
    );
    return SingleChildScrollView(
        child: Container(
      child: contentView,
      // color: SColors.main_help,
    ));
  }
  
  Widget _buildBluetoothInfoView() {
    Widget contentView = Column(
      children: [
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        NormalImageView(
          assetUrl: AssetImageConfig.bluetooth1,
          height: Dimens.connected_activity_bluetooth_logo_width,
          fit: BoxFit.fitWidth,
        ),
        DimenBoxs.vBoxSuperBroad,
        NormalTextView(
          content: AppConfig.appS.blue_tooth_text,
          fontSize: Dimens.font_normal,
          color: SColors.text_hint,
          height: Dimens.font_more_broad / Dimens.font_normal,
        ),
        DimenBoxs.vBox4,
        NormalTextView(
            content: _controller.getBluetoothName(),
            fontSize: Dimens.font_more_broad,
            color: SColors.text_hint,
            height: Dimens.font_narrow * 2 / Dimens.font_more_broad,),
        DimenBoxs.vBox8,
        NormalTextView(
            content: AppConfig.appS.connected_activity_connected_tips,
            fontSize: Dimens.font_normal,
            color: SColors.text_hint,
            height: Dimens.font_more_broad / Dimens.font_normal,),
        DimenBoxs.vBoxSuperBroad,
      ],
    );
    return Container(
      child: contentView,
      decoration: BoxDecoration(
        color: SColors.main_help,
        borderRadius: BorderRadius.circular(Dimens.margin_normal),
        boxShadow: [
          BoxShadow(
            color: SColors.box_show_color,
            offset: Offset(0, 3),
            blurRadius: Dimens.margin_normal,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildBluetoothButtonView() {
    Widget contentView  = Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: SColors.main_help,
        borderRadius: BorderRadius.circular(Dimens.margin_normal),
        boxShadow: [
          BoxShadow(
            color: SColors.box_show_color,
            offset: Offset(0, 3),
            blurRadius: Dimens.margin_normal,
            spreadRadius: 0,
          ),
        ],
      ),
      child: NormalTextView(
        margin: EdgeInsets.symmetric(vertical: Dimens.margin_normal),
        alignment: Alignment.center,
        content: AppConfig.appS.connected_activity_connected_setup_device_button_text,
        fontSize: Dimens.font_super_broad,
        height: Dimens.font_normal * 2 / Dimens.font_super_broad,
        color: SColors.text_title,
      ),
    );


    return GestureDetector(
      child: contentView,
      onTap: () {
        _controller.checkAdminPassword();
      },
    );
  }
}
