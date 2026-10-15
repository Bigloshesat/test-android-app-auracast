import 'package:base_flutter/models/extra/key_value.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/extension/widget_extension.dart';

import '../configs/app_config.dart';
import '../controllers/set_language_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_button_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'items/choose_type_item.dart';
import 'items/set_language_activity_menu_item.dart';
import 'new_base_activity.dart';

class SetLanguageActivity extends NewBaseActivity {
  SetLanguageActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => SetLanguageActivityState();
}

class SetLanguageActivityState
    extends NewBaseActivityState<SetLanguageActivity> {
  SetLanguageActivityController _controller = SetLanguageActivityController();

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
        finish(_controller.isLanguageChange);
      },
      body: _buildBodyView(),
    ).addBackIntercept(() async {
      finish(_controller.isLanguageChange);
      return Future.value(true);
    });
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
    return Column(
      children: [
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.set_language_activity_tips,
            fontSize: Dimens.font_super_broad,
            color: SColors.text_title),
        DimenBoxs.vBoxNormal,
        Expanded(child: _buildContentView()),
        DimenBoxs.vBoxNormal,
        // NormalButtonView(
        //   margin: EdgeInsets.all(Dimens.margin_normal),
        //   text: AppConfig.appS.save,
        //   showStroke: false,
        //   color: SColors.default_button_select_background,
        //   radius: Dimens.radius_narrow,
        //   fontSize: Dimens.font_normal,
        //   textColor: SColors.main_help,
        //   height: Dimens.button_height_normal,
        //   onClick: () {
        //     _controller.changeLanguage();
        //   },
        // )
      ],
    );
  }

  Widget _buildContentView() {
    Widget contentView = ListView.builder(
        itemCount: _controller.languages.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          KeyValue item = _controller.languages[index];
          return SetLanguageActivityMenuItem(
            isTop: index == 0,
            isSelected: index == _controller.selectLanguageIndex,
            data: item,
            onClick: () {
              _controller.updateSelectLanguageIndex(index);
              // _controller.onMenuClick(menu);
            },
          );
        });

    return contentView;
  }
}
