import 'package:base_flutter/activitys/views/validate_view.dart';
import 'package:base_flutter/controllers/rename_custom_speaker_activity_controller.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class RenameCustomSpeakerActivity extends NewBaseActivity {
  RenameCustomSpeakerActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => RenameCustomSpeakerActivityState();
}

class RenameCustomSpeakerActivityState
    extends NewBaseActivityState<RenameCustomSpeakerActivity> {
  RenameCustomSpeakerActivityController _controller =
      RenameCustomSpeakerActivityController();

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
        content: AppConfig.appS.rename_custom_speaker_activity_title,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.main_help);
  }

  Widget _buildBodyView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DimenBoxs.vBoxBroad,
          NormalTextView(
              content: AppConfig.appS.rename_or_change_pin_activity_menu_rename,
              fontSize: Dimens.font_super_broad,
              color: SColors.text_content),
          _buildContentView(),
          DimenBoxs.vBoxBroad,
        ],
      ),
    );
  }

  Widget _buildContentView() {
    Widget contentView = ValidateView(
        showInput: true,
        showValidate: false,
        margin: EdgeInsets.all(Dimens.margin_broad),
        title: AppConfig.appS.rename_custom_speaker_activity_input_title,
        leftButtonTitle: AppConfig.appS.confirm,
        inputTextColor: SColors.text_content,
        titleColor: SColors.text_title,
        buttonColor: SColors.text_title,
        decoration: BoxDecoration(
          border: Border.all(
              color: SColors.password_input_view_line,
              width: Dimens.line_narrow),
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.radius_narrow),
          ),
        ),
        inputDecoration: BoxDecoration(
          color: SColors.main_help,
          border: Border.all(color: SColors.line, width: Dimens.line_narrow),
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.radius_super_narrow),
          ),
        ),
        textChanged: (value) {
          _controller.name = value;
        },
        leftButtonClick: (value) {
          _controller.changeSpeakerName();
        },
        rightButtonClick: () {
          finish();
        });
    return Container(child: contentView);
  }
}
