import 'package:base_flutter/activitys/views/switch_status_view.dart';
import 'package:base_flutter/activitys/views/validate_view.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../controllers/update_pin_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class UpdatePinActivity extends NewBaseActivity {
  UpdatePinActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => UpdatePinActivityState();
}

class UpdatePinActivityState extends NewBaseActivityState<UpdatePinActivity> {
  UpdatePinActivityController _controller = UpdatePinActivityController();

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
    return SingleChildScrollView(child: _buildContentView());
  }

  Widget _buildContentView() {
    Widget contentView = Column(
      children: [
        _buildSwitchPinStatusView(),
        _controller.isPinOn ? _buildSetPinView() : _buildOffTipsView()
      ],
    );
    return Container(child: contentView);
  }

  Widget _buildSwitchPinStatusView() {
    Widget contentView = Row(
      children: [
        Expanded(child:NormalTextView(
            content: AppConfig.appS.update_pin_activity_pin_status_text,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),),
        Container(
          child: SwitchStatusView(
            key: _controller.switchStatusViewStateKey,
            isEnable: _controller.isPinOn,
            enableTitle: AppConfig.appS.on,
            unEnableTitle: AppConfig.appS.off,
            onStatusChange: (value) {
              _controller.changePinStatus(value);
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
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(
      //       color: SColors.line,
      //       width: Dimens.line_narrow,
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildSetPinView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalTextView(
            margin: EdgeInsets.symmetric(horizontal: Dimens.margin_super_broad),
            content: AppConfig.appS.update_pin_activity_pin_status_set_text,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),
        ValidateView(
            margin: EdgeInsets.all(Dimens.margin_super_broad),
            title: AppConfig.appS.update_pin_activity_pin_set_pin_input_title,
            leftButtonTitle:
                AppConfig.appS.update_pin_activity_pin_status_set_button_text,
            inputTextColor: SColors.text_content,
            titleColor: SColors.text_title,
            buttonColor: SColors.text_title,
            decoration: BoxDecoration(
              color: SColors.validate_input_view_background,
              // border: Border.all(
              //     color: SColors.password_input_view_line,
              //     width: Dimens.line_narrow),
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.radius_super_broad * 2),
              ),
            ),
            inputDecoration: BoxDecoration(
              color: SColors.main_help,
              border:
                  Border.all(color: SColors.line, width: Dimens.line_narrow),
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.radius_super_broad * 2),
              ),
            ),
            textChanged: (value) {
              _controller.pinCode = value;
            },
            leftButtonClick: (value) {
              _controller.changePinCode();
            },
            rightButtonClick: () {
              finish();
            },
            showValidate: true)
      ],
    );
  }

  Widget _buildOffTipsView() {
    return Column(
      children: [
        DimenBoxs.vBox30,
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimens.margin_super_broad * 2),
          padding: EdgeInsets.symmetric(
            vertical: Dimens.margin_less_broad * 4,
            horizontal: Dimens.margin_broad,
          ),
          decoration: BoxDecoration(
              color: SColors.equalizer_tips_background,
              borderRadius: BorderRadius.circular(Dimens.radius_super_broad * 2)
          ),
          child: NormalTextView(
              content: AppConfig.appS.equalizer_activity_off_tips,
              fontSize: Dimens.font_normal,
              textAlign: TextAlign.center,
              height: 1.5,
              maxLines: AppConfig.maxTextLines,
              color: SColors.text_title),
        )

      ],
    );
    // return Column(
    //   children: [
    //     DimenBoxs.vBoxNormal,
    //     NormalTextView(
    //         content: AppConfig.appS.tip,
    //         fontSize: Dimens.font_normal,
    //         color: SColors.validate_input_view_background,
    //         fontWeight: FontWeight.w600),
    //     DimenBoxs.vBoxNormal,
    //     NormalTextView(
    //         content: AppConfig.appS.update_pin_activity_off_tips,
    //         fontSize: Dimens.font_normal,
    //         textAlign: TextAlign.center,
    //         maxLines: AppConfig.maxTextLines,
    //         color: SColors.validate_input_view_background),
    //     DimenBoxs.vBoxNormal,
    //   ],
    // );
  }
}
