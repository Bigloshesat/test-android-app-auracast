import 'package:base_flutter/activitys/views/switch_status_view.dart';
import 'package:base_flutter/activitys/views/volume_orientation_control_view.dart';
import 'package:base_flutter/configs/app_config.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:base_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/assets_config.dart';
import '../controllers/speaker_mode_activity_controller.dart';
import '../controllers/volume_control_activity_controller.dart';
import '../models/extra/key_value.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'items/choose_type_color_tag_item.dart';
import 'items/choose_type_item.dart';
import 'new_base_activity.dart';

class SpeakerModeActivity extends NewBaseActivity {
  SpeakerModeActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => SpeakerModeActivityState();
}

class SpeakerModeActivityState
    extends NewBaseActivityState<SpeakerModeActivity> {
  SpeakerModeActivityController _controller = SpeakerModeActivityController();

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
        content: AppConfig.appS.manager_activity_menu_speaker_mode,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.text_title);
  }

  Widget _buildBodyView() {
    return Column(
      children: [
        DimenBoxs.vBoxNormal,
        NormalTextView(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: Dimens.margin_super_broad),
            content: AppConfig.appS.speaker_mode_activity_bluetooth_select_tips,
            // fontSize: Dimens.font_broad,
            fontWeight: FontWeight.w600,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
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
    int length = _controller.speakerModes.length;
    Widget contentView = ListView.builder(
      padding: EdgeInsets.only(
        left: Dimens.margin_normal,
        right: Dimens.margin_normal,
      ),
      itemCount: length + 1,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        bool isLastItem = index == length;
        KeyValue? item = isLastItem ? null : _controller.speakerModes[index];
        return isLastItem
            ? _buildSwitchView()
            : ChooseTypeColorTagItem(
                data: item!,
                isChecked: _controller.selectSpeakerModeIndex == index,
                margin: EdgeInsets.all(Dimens.margin_narrow),
                checkedColor: SColors.choose_type_color_tag_item_box_select_background_color,
                unCheckedColor: SColors.main_help,
                checkedTextColor: SColors.text_title,
                unCheckedTextColor: SColors.text_title,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.margin_normal * 2,
                ),
                // tagColor: _controller.getSpeakerModeTagColor(item),
                onClick: () {
                  _controller.changeMode(index, item);
                },
              );
      },
    );
    return contentView;
  }

  Widget _buildSwitchView() {
    return Container();
    // Widget contentView = Row(
    //   children: [
    //     Expanded(child: _buildSwitchTipsView()),
    //     SwitchStatusView(
    //       key: _controller.switchStatusViewStateKey,
    //       isEnable: _controller.isSoundTipsOn,
    //       enableTitle: AppConfig.appS.on,
    //       unEnableTitle: AppConfig.appS.off,
    //       onStatusChange: (value) {
    //         _controller.changeVoicePromptStatus(value);
    //       },
    //     ),
    //   ],
    // );
    // return _controller.isSupportSoundTips()
    //     ? Container(
    //         margin: EdgeInsets.all(Dimens.margin_narrow),
    //         child: Column(
    //           children: [
    //             DimenBoxs.vBoxNormal,
    //             ViewUtil.getDefaultLine(color: SColors.text_title),
    //             DimenBoxs.vBoxBroad,
    //             contentView,
    //             DimenBoxs.vBoxBroad,
    //           ],
    //         ),
    //       )
    //     : Container();
  }

  // Widget _buildSwitchTipsView() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       NormalTextView(
  //           content: AppConfig.appS.speaker_mode_activity_voice_prompt_text,
  //           fontSize: Dimens.font_more_broad,
  //           color: SColors.text_content),
  //       NormalTextView(
  //           content: AppConfig.appS.speaker_mode_activity_voice_prompt_tips,
  //           maxLines: 2,
  //           fontSize: Dimens.font_normal,
  //           color: SColors.text_title),
  //     ],
  //   );
  // }
}
