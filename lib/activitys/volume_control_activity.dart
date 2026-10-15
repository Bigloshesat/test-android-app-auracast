
import 'package:base_flutter/activitys/views/volume_control_slider_theme_shape.dart';
import 'package:base_flutter/activitys/views/volume_orientation_control_view.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/assets_config.dart';
import '../controllers/volume_control_activity_controller.dart';
import '../resources/dimens.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class VolumeControlActivity extends NewBaseActivity {
  VolumeControlActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => VolumeControlActivityState();
}

class VolumeControlActivityState
    extends NewBaseActivityState<VolumeControlActivity> {
  VolumeControlActivityController _controller =
      VolumeControlActivityController();

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
      iconSize: Dimens.font_max_broad,
      // middle: _buildMiddleTitleView(),
      onBackClick: () {
        finish();
      },
      body: _buildBodyView(),
    );
  }

  Widget _buildMiddleTitleView() {
    return NormalTextView(
        alignment: Alignment.center,
        content: _controller.getDeviceName(),
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.text_title);
  }

  Widget _buildBodyView() {
    Widget contentView = Column(
      children: [
        DimenBoxs.vBoxNormal,
        ValueListenableBuilder<double>(
            valueListenable: _controller.volumeCounter,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value,
                child: NormalImageView(
                  assetUrl: AssetImageConfig.volume_control,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.fitWidth,
                ),
              );
            },
        ),
        Expanded(
          child: Column(
            children: [
              _buildSoundView(),
              NormalTextView(content: _controller.volume.toString()),
            ],
          ),
        ),
        DimenBoxs.vBoxNormal,
        _buildPlayView()
      ],
    );
    return Container(
        margin: EdgeInsets.only(top: Dimens.margin_normal), child: contentView);
  }


  Widget _buildSoundView() {
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
        Expanded(child: _buildContentView(),),
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
  }

  Widget _buildContentView() {
    return SliderTheme(
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
  }

  Widget _buildPlayView() {
    Widget contentView = Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(),
              flex: 1,
            ),
            NormalImageView(
                padding: EdgeInsets.all(Dimens.margin_narrow),
                onClick: () {
                  _controller.prevMusic();
                },
                assetUrl: AssetImageConfig.volume_control_prev,
                width: Dimens.volume_control_activity_prev_width,
                fit: BoxFit.fitWidth,
                useMaterial: false),
            Expanded(
              child: Container(),
              flex: 2,
            ),
            NormalImageView(
                padding: EdgeInsets.all(Dimens.margin_narrow),
                onClick: () {
                  _controller.playMusic();
                },
                assetUrl: _controller.isPlaying
                    ? AssetImageConfig.volume_control_stop
                    : AssetImageConfig.volume_control_play,
                width: Dimens.volume_control_activity_play_width,
                fit: BoxFit.fitWidth,
                useMaterial: false),
            Expanded(
              child: Container(),
              flex: 2,
            ),
            NormalImageView(
                padding: EdgeInsets.all(Dimens.margin_narrow),
                onClick: () {
                  _controller.nextMusic();
                },
                assetUrl: AssetImageConfig.volume_control_next,
                width: Dimens.volume_control_activity_next_width,
                fit: BoxFit.fitWidth,
                useMaterial: false),
            Expanded(
              child: Container(),
              flex: 1,
            ),
          ],
        ),
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        Container(height: Dimens.line_normal, color: SColors.main_help),
        DimenBoxs.vBoxSuperBroad,
        DimenBoxs.vBoxSuperBroad,
        NormalImageView(
          assetUrl: AssetImageConfig.logo1,
          width: Dimens.manager_activity_bottom_logo_width,
          fit: BoxFit.fitWidth,
        ),
        DimenBoxs.vBoxSuperBroad,
      ],
    );
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 2 * Dimens.margin_super_broad),
        child: contentView);
  }
}
