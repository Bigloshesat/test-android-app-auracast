import 'package:base_flutter/models/extra/key_value.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../controllers/rename_speaker_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_button_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'items/choose_type_item.dart';
import 'new_base_activity.dart';

class RenameSpeakerActivity extends NewBaseActivity {
  RenameSpeakerActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => RenameSpeakerActivityState();
}

class RenameSpeakerActivityState
    extends NewBaseActivityState<RenameSpeakerActivity> {
  RenameSpeakerActivityController _controller =
      RenameSpeakerActivityController();

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
    Widget contentView = GridView.builder(
      padding: EdgeInsets.only(
        left: Dimens.margin_normal,
        right: Dimens.margin_normal,
      ),
      itemCount: _controller.names.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: Dimens.margin_narrow,
          crossAxisSpacing: Dimens.margin_narrow,
          childAspectRatio: 3),
      itemBuilder: (BuildContext context, int index) {
        KeyValue item = _controller.names[index];
        return ChooseTypeItem(
          data: item,
          checkedColor: SColors.item_background,
          isChecked: true,
          checkedTextColor: SColors.text_title,
          borderRadius: Dimens.radius_normal * 4,
          onClick: () {
            _controller.changeSpeakerName(false, item);
          },
        );
      },
    );
    return Column(
      children: [
        // DimenBoxs.vBoxNormal,
        // NormalTextView(
        //     content: AppConfig.appS.rename_speaker_activity_tips,
        //     fontSize: Dimens.font_broad,
        //     color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        Expanded(child: contentView),
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.or,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
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
              content: AppConfig.appS.device_name_custom,
            ),
          ),
          onTap: () {
            _controller.changeSpeakerName(true, null);
          },
        )
      ],
    );
  }
}
