import 'package:base_flutter/activitys/views/limit_rows_view.dart';
import 'package:base_flutter/activitys/views/switch_status_view.dart';
import 'package:base_flutter/activitys/views/touchable_single_line_chart_view.dart';
import 'package:base_flutter/activitys/views/volume_control_slider_theme_shape.dart';
import 'package:base_flutter/models/extra/key_value.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../configs/assets_config.dart';
import '../controllers/equalizer_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'items/choose_type_item.dart';
import 'new_base_activity.dart';

class EqualizerActivity extends NewBaseActivity {
  EqualizerActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => EqualizerActivityState();
}

class EqualizerActivityState extends NewBaseActivityState<EqualizerActivity> {
  EqualizerActivityController _controller = EqualizerActivityController();

  // 控制父滚动视图是否可滚动
  bool _allowParentScroll = true;

  // 记录滑动器是否正在被操作
  bool _isSliderDragging = false;

  @override
  BaseController initController() {
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return NormalToolbarView(
      showBack: true,
      showLeftTitle: true,
      iconSize: Dimens.font_max_broad,
      backgroundColor: SColors.main_help,
      bodyColor: SColors.main_help,
      contentColor: SColors.text_title,
      middle: _buildMiddleTitleView(),
      actions: _buildActionsView(),
      onBackClick: () {
        finish();
      },
      body: _buildBodyView(),
    );
  }

  Widget _buildMiddleTitleView() {
    return NormalTextView(
        alignment: Alignment.center,
        content: AppConfig.appS.equalizer_activity_title,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.text_title);
  }

  Widget _buildActionsView() {
    return SwitchStatusView(
      key: _controller.switchStatusViewStateKey,
      isEnable: _controller.isEqualizerOn,
      enableTitle: AppConfig.appS.on,
      unEnableTitle: AppConfig.appS.off,
      onStatusChange: (value) {
        _controller.changeEqualizerStatus(value);
      },
    );
  }



  Widget _buildBodyView() {
    // Widget contentView = SingleChildScrollView(child: _buildContentView());
    return Column(
      children: [
        Expanded(child: _buildContentView()),
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
    Widget contentView = _controller.isEqualizerOn
        ? _buildEqualizerView()
        : _buildEqualizerOffTipsView();
    return Container(child: contentView);
  }


  Widget _buildEqualizerView() {
    return NotificationListener(
      onNotification: (notification) {
        return !_allowParentScroll;
        // 根据需要拦截滚动事件
        // if (notification is ScrollStartNotification && !_controller.isParentScrollable) {
        //   return true; // 拦截事件
        // }
        // return false;
      },
      child: SingleChildScrollView(
        physics: _allowParentScroll
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        child: Column(
          children: [
              _buildEqualizerTypeChooseView(),
              _buildCustomEqualizerTypeChooseView(),
              DimenBoxs.vBoxNormal,
              // 音量滑动器区域
              Listener(
                onPointerDown: (details) {
                  // 当触摸到滑动器时，禁用父滚动
                  setState(() {
                    _isSliderDragging = true;
                    _allowParentScroll = false;
                  });
                },
                onPointerUp: (details) {
                  // 当手指离开时，恢复父滚动
                  setState(() {
                    _isSliderDragging = false;
                    _allowParentScroll = true;
                  });
                },
                onPointerCancel: (details) {
                  // 当触摸被取消时，恢复父滚动
                  setState(() {
                    _isSliderDragging = false;
                    _allowParentScroll = true;
                  });
                },
                child: _buildLineChartView(),
              ),
              DimenBoxs.vBoxNormal,
              Container(height: Dimens.line_narrow,color: SColors.line,width: _controller.getLineChartWidth(),margin: EdgeInsets.symmetric(vertical:Dimens.margin_normal)),
              _buildVolumeView(),
              NormalTextView(content: _controller.volume.toString()),
          ],
        ),
      )
    );
  }

  Widget _buildEqualizerTypeChooseView() {
    double leaveWidth=Dimens.margin_narrow * 2;
    double width =
        (MediaQuery.of(context).size.width -leaveWidth) / 2;
    return Container(
      child: LimitRowsView(
          maxRows: 3,
          totalItems: _controller.equalizerTypes.length,
          builder: (BuildContext context, int index) {
            KeyValue item = _controller.equalizerTypes[index];
            return ChooseTypeItem(
              data: item,
              isChecked: _controller.selectEqualizerTypeIndex == index,
              width: width,
              borderRadius: Dimens.radius_broad * 5,
              throughoutShowBorder: false,
              checkedBorderColor: SColors.equalizer_type_choose_view_border,
              unCheckedBorderColor: SColors.equalizer_type_choose_view_border,
              checkedTextColor: SColors.text_title,
              unCheckedTextColor: SColors.text_title,
              margin: EdgeInsets.all(Dimens.margin_normal / 2),
              onClick: () {
                _controller.changeEqualizerType(item, index);
              },
            );
          }),
    );
  }

  Widget _buildCustomEqualizerTypeChooseView() {
    KeyValue item = KeyValue(
        key: AppConfig.appS.equalizer_activity_custom_eq_mode_custom,
        value: EqualizerType.CUSTOM,
        object: "");
    double width = MediaQuery.of(context).size.width - Dimens.margin_broad * 2;
    return ChooseTypeItem(
      data: item,
      isChecked: _controller.selectEqualizerTypeIndex == -1,
      width: width,
      margin: EdgeInsets.symmetric(vertical: Dimens.margin_narrow),
      throughoutShowBorder: false,
      borderRadius: Dimens.radius_broad * 5,
      checkedBorderColor: SColors.equalizer_type_choose_view_border,
      unCheckedBorderColor: SColors.equalizer_type_choose_view_border,
      checkedTextColor: SColors.text_title,
      unCheckedTextColor: SColors.text_title,
      onClick: () {
        _controller.changeEqualizerType(item, -1);
      },
    );
  }

  Widget _buildLineChartView() {
    Widget contentView = TouchableSingleLineChartView(
        key: _controller.touchableLineChartViewStateKey,
        points: _controller.getPoints(),
        lineColor: SColors.touchable_line_chart_view_line,
        maxX: _controller.maxX,
        maxY: _controller.maxEqualizerValue,
        canvasWidth: _controller.getLineChartWidth(),
        canvasHeight: _controller.getLineChartHeight(),
        canvasPadding: Dimens.touchable_line_chart_view_canvas_padding,
        pointRadius: Dimens.touchable_line_chart_view_point_radius,
        splitPositionXTexts:_controller.splitPositionXUnitText,
        canEdit: _controller.selectEqualizerTypeIndex == -1,
        showYCoordinateAxis:false,
        pointsChangeCallback: (value) {
          _controller.updateCustomPoints(value);
        });
    return Container(child: contentView);
  }


  Widget _buildVolumeView() {
    return Row(
      children: [
        GestureDetector(
          child: NormalImageView(
            assetUrl: AssetImageConfig.volume_control_down,
            height: Dimens.volume_control_sound_icon_width,
            fit: BoxFit.fitHeight,
          ),
          onTap: () {
            if(_controller.volume > 0) {
              int volume = -- _controller.volume;
              _controller.changeVolume(volume);
              setState(() {
              });
            }
          },
          onLongPressStart: (details) {
            _controller.isSoundUp = false;
            _controller.playSoundTimer();
          },
          onLongPressEnd: (details) {
            _controller.cancelSoundTimer();
          },
        ),
        Expanded(child: _buildVolumeSliderView(),),
        GestureDetector(
          child: NormalImageView(
            assetUrl: AssetImageConfig.volume_control_up,
            height: Dimens.volume_control_sound_icon_width,
            fit: BoxFit.fitHeight,
          ),
          onTap: () {
            if(_controller.volume < 100) {
              int volume = ++ _controller.volume;
              _controller.changeVolume(volume);
              setState(() {
              });
            }
          },
          onLongPressStart: (details) {
            _controller.isSoundUp = true;
            _controller.playSoundTimer();
          },
          onLongPressEnd: (details) {
            _controller.cancelSoundTimer();
          },
        ),
      ],
    );

    // return VolumeOrientationControlView(
    //     volume: _controller.volume,
    //     volumeWidth: Dimens.equalizer_activity_volume_control_view_width,
    //     volumeChange: (int volume) async {
    //       await _controller.changeVolume(volume);
    //     },
    //     isVertical: false);
  }

  Widget _buildVolumeSliderView() {
    Widget contentView = SliderTheme(
      data: SliderThemeData(
          thumbShape: VolumeControlSliderThemeShape(),
          thumbColor: SColors.volume_control_slider_theme_shape_color,
          activeTrackColor: SColors.volume_control_slider_theme_shape_color,
          inactiveTrackColor: SColors.volume_control_item_disable_background,
          trackHeight: Dimens.volume_orientation_control_view_progress_height
      ), child: Slider(
        min: 0,
        max: 100,
        divisions: 100,
        value: _controller.volume.toDouble(),
        onChangeEnd: (double volume) {
          _controller.changeVolume(volume.toInt());
          setState(() {
          });
        },
        onChanged: (double volume) {
          setState(() {
            _controller.volume = volume.toInt();
          });
        }),
    );

    return contentView;
  }

  Widget _buildEqualizerOffTipsView() {
    return Column(
      children: [
        DimenBoxs.vBox30,
        DimenBoxs.vBox30,
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
  }
}
