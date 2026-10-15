import 'package:base_flutter/models/extra/key_value.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../configs/assets_config.dart';
import '../controllers/rename_or_change_pin_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'items/manager_activity_menu_item.dart';
import 'new_base_activity.dart';

class RenameOrChangePinActivity extends NewBaseActivity {
  RenameOrChangePinActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => RenameOrChangePinActivityState();
}

class RenameOrChangePinActivityState
    extends NewBaseActivityState<RenameOrChangePinActivity> {
  RenameOrChangePinActivityController _controller =
      RenameOrChangePinActivityController();

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
        content: AppConfig.appS.manager_activity_title,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.text_title);
  }

  Widget _buildBodyView() {
    Widget contentView = ListView.builder(
        itemCount: _controller.menus.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          KeyValue menu = _controller.menus[position];
          return ManagerActivityMenuItem(
            data: menu,
            onClick: () {
              _controller.onMenuClick(menu);
            },
          );
        });
    return Column(
      children: [
        Expanded(
          child: Container(
            child: contentView,
            margin: EdgeInsets.all(Dimens.margin_normal),
          ),
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
}
