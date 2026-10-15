import 'package:base_flutter/activitys/views/switch_status_view.dart';
import 'package:base_flutter/activitys/views/volume_control_slider_theme_shape.dart';
import 'package:base_flutter/controllers/extra/bluetooth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../controllers/lighting_lamp_activity_controller.dart';
import '../models/extra/key_value.dart';
import '../resources/dimens.dart';
import '../resources/s_colors.dart';
import '../utils/view_util.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'items/choose_type_item.dart';
import 'new_base_activity.dart';

class LightingLampActivity extends NewBaseActivity {
  LightingLampActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => LightingLampActivityState();
}

class LightingLampActivityState extends NewBaseActivityState<LightingLampActivity> {

  LightingLampActivityController _controller = LightingLampActivityController();

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
    return SingleChildScrollView(
      child: Column(
        children: [
          DimenBoxs.vBox10,
          _buildLightView(),
          if(_controller.isLightOn)
            _buildSettingsView(),
          DimenBoxs.vBoxNormal,
        ],
      ),
    );
  }

  Widget _buildLightView() {
    Widget contentView = Row(
      children: [
        Expanded(child:NormalTextView(
            content: AppConfig.appS.lighting_lamp_activity_title,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),),
        Container(
          child: SwitchStatusView(
            key: _controller.switchStatusStateKey,
            isEnable: _controller.isLightOn,
            enableTitle: AppConfig.appS.on,
            unEnableTitle: AppConfig.appS.off,
            onStatusChange: (value) {
              _controller.changeLightStatus(value);
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

  Widget _buildLightStylesView() {
    Widget contentView = Column(
      children: [
        DimenBoxs.vBoxNormal,
        GridView.builder(
          padding: EdgeInsets.only(
            left: Dimens.margin_normal,
            right: Dimens.margin_normal,
          ),
          itemCount: _controller.lightStyles.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: Dimens.margin_narrow,
              crossAxisSpacing: Dimens.margin_narrow,
              childAspectRatio: 3),
          itemBuilder: (BuildContext context, int index) {
            KeyValue item = _controller.lightStyles[index];
            return ChooseTypeItem(
              data: item,
              checkedColor: SColors.item_background,
              isChecked: item.value == _controller.selectedLightStyle,
              checkedTextColor: SColors.text_title,
              borderRadius: Dimens.radius_normal * 4,
              onClick: () {
                _controller.changeLightStyle(item);
                // _controller.changeSpeakerName(false, item);
              },
            );
          },
        ),
        DimenBoxs.vBoxNormal
      ],
    );

    return Container(
      child: contentView,
    );
  }

  Widget _buildSettingsView() {
    Widget contentView = Column(
      children: [
        DimenBoxs.vBoxNormal,
        _buildLightStylesView(),
        DimenBoxs.vBoxNormal,
        ViewUtil.getDefaultLine(),
        DimenBoxs.vBoxNormal,
        _buildCustomColorView(),
        DimenBoxs.vBoxNormal,
        ViewUtil.getDefaultLine(),
        DimenBoxs.vBoxNormal,
        _buildLampBrightnessView(),
      ],
    );

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.margin_super_broad),
      child: contentView,
    );
  }

  Widget _buildCustomColorView() {
    return Column(
      children: [
        DimenBoxs.vBoxNormal,
        NormalTextView(
            alignment: Alignment.centerLeft,
            content: AppConfig.appS.lighting_lamp_activity_custom_color_text,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        DimenBoxs.vBoxNormal,
        Listener(
          onPointerUp: (event) {
            // setState(() {
              // _controller.selectedLightStyle = LightLampType.CUSTOM;
            // });
            _controller.setCustomLightColor();
            // print('==================onPointerUp');
          },
          child: ColorPicker(
            enableAlpha: false,
            labelTypes: [
              ColorLabelType.rgb
            ],
            paletteType: PaletteType.hsvWithHue,
            pickerColor: _controller.pickerColor,
            onColorChanged: (Color color) {
              _controller.selectedCustomLightStyle(color);
          }),
        )
        // ColorPicker(
        //     enableAlpha: false,
        //     labelTypes: [
        //       ColorLabelType.rgb
        //     ],
        //     paletteType: PaletteType.hsvWithHue,
        //     pickerColor: _controller.pickerColor,
        //     onColorChanged: (Color color) {
        //       _controller.selectedCustomLightStyle(color);
        // })
        // BlockPicker(pickerColor: Colors.blue, onColorChanged: (Color color) {
        //
        // })
        // ColorPickerInput(color, onColorChanged)
      ],
    );
  }

  Widget _buildLampBrightnessView() {
    return Column(
      children: [
        DimenBoxs.vBoxNormal,
        NormalTextView(
            alignment: Alignment.centerLeft,
            content: AppConfig.appS.lighting_lamp_activity_lamp_brightness_text,
            fontSize: Dimens.font_broad,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        SliderTheme(
          data: SliderThemeData(
              thumbShape: VolumeControlSliderThemeShape(),
              thumbColor: SColors.volume_control_slider_theme_shape_color,
              activeTrackColor: SColors.volume_control_slider_theme_shape_color,
              inactiveTrackColor: SColors.volume_control_item_disable_background,
              trackHeight: Dimens.volume_orientation_control_view_progress_height
          ), child: Slider(
            min: 0,
            max: 100,
            divisions: 2,
            value: _controller.lampBrightness.toDouble(),
            onChanged: (double lampBrightness) async {
              await _controller.changeLampBrightness(lampBrightness.toInt());
            }),
        ),
        Row(
          children: [
            DimenBoxs.hBoxBroad,
            NormalTextView(content: "0"),
            Spacer(),
            NormalTextView(content: "   "),
            NormalTextView(content: "50"),
            Spacer(),
            NormalTextView(content: "100"),
            DimenBoxs.hBoxBroad,
          ],
        )
      ],
    );
  }

}