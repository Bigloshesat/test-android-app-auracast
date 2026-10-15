import 'package:base_flutter/activitys/views/switch_status_view.dart';
import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/assets_config.dart';
import '../controllers/lithe_link_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class LitheLinkActivity extends NewBaseActivity {
  LitheLinkActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => LitheLinkActivityState();
}

class LitheLinkActivityState extends NewBaseActivityState<LitheLinkActivity> {
  LitheLinkActivityController _controller = LitheLinkActivityController();

  @override
  BaseController initController() {
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return NormalToolbarView(
      showBack: true,
      showLeftTitle: true,
      backgroundColor: SColors.toolbar_background,
      bodyColor: SColors.background,
      contentColor: SColors.main_help,
      middle: _buildMiddleTitleView(),
      onBackClick: () {
        finish();
      },
      body: _buildBodyView(),
    );
  }

  Widget _buildMiddleTitleView() {
    return NormalTextView(
        alignment: Alignment.center,
        content: AppConfig.appS.manager_activity_menu_lithe_link,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.main_help);
  }

  Widget _buildBodyView() {
    return Column(
      children: [
        Expanded(
          child: _buildContentView(),
        ),
        DimenBoxs.vBoxNormal,
        NormalImageView(
          assetUrl: AssetImageConfig.logo,
          width: Dimens.manager_activity_bottom_logo_width,
          fit: BoxFit.fitWidth,
        ),
        DimenBoxs.vBoxNormal,
      ],
    );
  }

  Widget _buildContentView() {
    Widget contentView = Column(
      children: [_buildSwitchLitheLinkStatusView(), _buildTipsView()],
    );
    return SingleChildScrollView(child: contentView);
  }

  Widget _buildSwitchLitheLinkStatusView() {
    Widget contentView = Row(
      children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            NormalTextView(
                content: AppConfig.appS.manager_activity_menu_lithe_link,
                fontSize: Dimens.font_broad,
                color: SColors.text_content),
            _buildConnectStatus()
          ]),
        ),
        Container(
          child: SwitchStatusView(
            key: _controller.switchStatusViewStateKey,
            isEnable: _controller.isLitheLinkOn,
            enableTitle: AppConfig.appS.on,
            unEnableTitle: AppConfig.appS.off,
            onStatusChange: (value) {
              _controller.changeLitheLinkStatus(value);
            },
          ),
          margin: EdgeInsets.symmetric(vertical:Dimens.margin_narrow),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Dimens.margin_normal,
          horizontal: Dimens.margin_super_broad),
      child: contentView,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: SColors.line,
            width: Dimens.line_narrow,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectStatus() {
    return Row(children: [
      NormalTextView(
          content: _controller.isLitheLinkConnect
              ? AppConfig.appS.lithe_link_activity_lithe_connect_text
              : AppConfig.appS.lithe_link_activity_lithe_disconnect_text,
          fontSize: Dimens.font_normal,
          color: SColors.text_content),
      Container(
          width: Dimens.margin_normal,
          height: Dimens.margin_normal,
          margin: EdgeInsets.all(Dimens.margin_super_narrow),
          color: _controller.isLitheLinkConnect
              ? SColors.lithe_link_connect
              : SColors.lithe_link_dis_connect)
    ]);
  }

  Widget _buildTipsView() {
    return Column(
      children: [
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.lithe_link_activity_note,
            fontSize: Dimens.font_normal,
            color: SColors.validate_input_view_background,
            fontWeight: FontWeight.w600),
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.lithe_link_activity_tips,
            fontSize: Dimens.font_normal,
            textAlign: TextAlign.center,
            maxLines: AppConfig.maxTextLines,
            color: SColors.validate_input_view_background),
        DimenBoxs.vBoxNormal,
      ],
    );
  }
}
