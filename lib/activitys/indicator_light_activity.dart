import 'package:base_flutter/activitys/views/switch_status_view.dart';
import 'package:base_flutter/utils/view_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../controllers/indicator_light_activity_controller.dart';
import '../models/extra/key_value.dart';
import '../resources/dimens.dart';
import '../resources/s_colors.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'items/choose_type_item.dart';
import 'new_base_activity.dart';

class IndicatorLightActivity extends NewBaseActivity {
  IndicatorLightActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => IndicatorLightActivityState();
}

class IndicatorLightActivityState extends NewBaseActivityState<IndicatorLightActivity> {

  IndicatorLightActivityController _controller = IndicatorLightActivityController();

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
    return Column(
      children: [
        DimenBoxs.vBox10,
        _buildPilotLampView(),
        _buildSereoView(),
        _buildMonoView(),
        _buildMilitView(),
        _buildVoicePromptView(),
      ],
    );
  }

  Widget _buildPilotLampView() {
    Widget contentView = Row(
      children: [
        Expanded(child:NormalTextView(
            content: AppConfig.appS.indicator_light_activity_indicator_light,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),),
        Container(
          child: SwitchStatusView(
            key: _controller.indicatorLightSwitchStatusStateKey,
            isEnable: _controller.isIndicatorLightOn,
            enableTitle: AppConfig.appS.on,
            unEnableTitle: AppConfig.appS.off,
            onStatusChange: (value) {
              _controller.changeIndicatorLightStatus(value);
            },
          ),
          margin: EdgeInsets.symmetric(vertical:Dimens.margin_narrow),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.margin_super_broad),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.margin_normal,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: Dimens.line_normal, color: SColors.line),
          bottom: BorderSide(width: Dimens.line_normal, color: SColors.line),
        )
      ),
      child: contentView,
    );
  }

  Widget _buildSereoView() {
    Widget contentView = Row(
      children: [
        Expanded(child:NormalTextView(
            content: AppConfig.appS.indicator_light_activity_sereo,
            fontSize: Dimens.font_broad,
            color: _controller.isSereoOn ? SColors.text_content : SColors.text_transparent),),
        Container(
          child: SwitchStatusView(
            key: _controller.sereoSwitchStatusStateKey,
            isEnable: _controller.isSereoOn,
            enableTitle: AppConfig.appS.on,
            unEnableTitle: AppConfig.appS.off,
            onStatusChange: (value) {
              _controller.changeIndicatorLightModeIsMonoStatus(!value);
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
    );
  }


  Widget _buildMonoView() {
    Widget contentView = Row(
      children: [
        Expanded(child:NormalTextView(
            content: AppConfig.appS.indicator_light_activity_mono,
            fontSize: Dimens.font_broad,
            color: _controller.isMonoOn ? SColors.text_content : SColors.text_transparent),),
        Container(
          child: SwitchStatusView(
            key: _controller.monoSwitchStatusStateKey,
            isEnable: _controller.isMonoOn,
            enableTitle: AppConfig.appS.on,
            unEnableTitle: AppConfig.appS.off,
            onStatusChange: (value) {
              _controller.changeIndicatorLightModeIsMonoStatus(value);
            },
          ),
          margin: EdgeInsets.symmetric(vertical:Dimens.margin_narrow),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.margin_super_broad),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.margin_normal,
      ),
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: Dimens.line_normal, color: SColors.line),
          )
      ),
      child: contentView,
    );
  }


  Widget _buildMilitView() {
    Widget contentView = Column(
      children: [
        DimenBoxs.vBoxNormal,
        NormalTextView(
            alignment: Alignment.centerLeft,
            content: AppConfig.appS.indicator_light_activity_milit,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        DimenBoxs.vBoxNormal,
        GridView.builder(
          padding: EdgeInsets.only(
            left: Dimens.margin_normal,
            right: Dimens.margin_normal,
          ),
          itemCount: _controller.milits.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: Dimens.margin_narrow,
              crossAxisSpacing: Dimens.margin_narrow,
              childAspectRatio: 3),
          itemBuilder: (BuildContext context, int index) {
            KeyValue item = _controller.milits[index];
            return ChooseTypeItem(
              data: item,
              checkedColor: SColors.item_background,
              isChecked: item.object,
              checkedTextColor: SColors.text_title,
              borderRadius: Dimens.radius_normal * 4,
              onClick: () {
                _controller.selectedLimiterMenu(item);
                // _controller.changeSpeakerName(false, item);
              },
            );
          },
        ),
        DimenBoxs.vBoxNormal
      ],
    );

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.margin_super_broad),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.margin_normal,
      ),
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: Dimens.line_normal, color: SColors.line),
          )
      ),
      child: contentView,
    );
  }

  Widget _buildVoicePromptView() {
    Widget contentView = Row(
      children: [
        Expanded(child:NormalTextView(
            content: AppConfig.appS.indicator_light_activity_voice_prompt,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),),
        Container(
          child:  SwitchStatusView(
            key: _controller.switchStatusViewStateKey,
            isEnable: _controller.isSoundTipsOn,
            enableTitle: AppConfig.appS.on,
            unEnableTitle: AppConfig.appS.off,
            onStatusChange: (value) {
              _controller.changeVoicePromptStatus(value);
            },
          ),
          margin: EdgeInsets.symmetric(vertical:Dimens.margin_narrow),
        )
      ],
    );

    // Widget contentView = Column(
    //   children: [
    //     DimenBoxs.vBoxNormal,
    //     NormalTextView(
    //         alignment: Alignment.centerLeft,
    //         content: AppConfig.appS.indicator_light_activity_voice_prompt,
    //         fontSize: Dimens.font_broad,
    //         color: SColors.text_content),
    //     DimenBoxs.vBoxNormal,
    //     DimenBoxs.vBoxNormal,
    //     Row(
    //       children: [
    //         Spacer(),
    //         SwitchStatusView(
    //           key: _controller.switchStatusViewStateKey,
    //           isEnable: _controller.isSoundTipsOn,
    //           enableTitle: AppConfig.appS.on,
    //           unEnableTitle: AppConfig.appS.off,
    //           onStatusChange: (value) {
    //             _controller.changeVoicePromptStatus(value);
    //           },
    //         ),
    //       ],
    //     )
    //   ],
    // );

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.margin_super_broad),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.margin_normal,
      ),
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: Dimens.line_normal, color: SColors.line),
          )
      ),
      child: contentView,
    );
  }


}