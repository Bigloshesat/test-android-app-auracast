import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';

class VolumeControlView extends StatefulWidget {
  final int volume; // 0-100
  final int volumeTotalCount; // 滑块总份数
  final double? lineWidth; // 滑块宽度
  final double? lineHeight; // 滑块高度
  final double? space; // 间隔（未使用）
  final VoidIntCallback? volumeChange; // 音量变化回调
  final double? viewWidth; // 组件总宽度

  const VolumeControlView({
    Key? key,
    this.volume = 0,
    this.volumeTotalCount = 100,
    this.lineWidth,
    this.lineHeight,
    this.space,
    this.viewWidth,
    this.volumeChange,
  }) : super(key: key);

  @override
  State<VolumeControlView> createState() => VolumeControlViewState();
}

class VolumeControlViewState extends State<VolumeControlView> {
  late int _volume; // 当前音量（0-100）
  late int _volumeTotalCount; // 滑块总份数
  late double _lineWidth; // 滑块宽度
  late double _lineHeight; // 滑块高度
  late int _volumeCount; // 当前音量对应的份数
  late double _viewWidth; // 组件总宽度

  // 用于通知UI更新的监听器
  final ValueNotifier<int> _volumeCountNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _updateConfiguration();
  }

  @override
  void didUpdateWidget(covariant VolumeControlView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当父组件传入的音量变化时更新状态
    if (widget.volume != oldWidget.volume ||
        widget.viewWidth != oldWidget.viewWidth) {
      _updateConfiguration();
    }
  }

  /// 更新配置参数
  void _updateConfiguration() {
    _volume = widget.volume.clamp(0, 100); // 确保音量在0-100范围内
    _volumeTotalCount = widget.volumeTotalCount;
    _lineWidth = widget.lineWidth ?? Dimens.volume_control_slider_theme_shape_color_width;
    _lineHeight = widget.lineHeight ?? Dimens.volume_control_view_line_height * 5;
    _viewWidth = widget.viewWidth ?? MediaQuery.of(context).size.width;

    // 计算当前音量对应的份数
    _volumeCount = _getVolumeCountByVolume(_volume);
    _volumeCountNotifier.value = _volumeCount;
  }

  /// 从父组件设置音量值
  void setVolumeValue(int volumeValue) {
    final clampedVolume = volumeValue.clamp(0, 100);
    _volumeCount = _getVolumeCountByVolume(clampedVolume);
    _volumeCountNotifier.value = _volumeCount;
    _notifyVolumeChange();
  }

  /// 通知父组件音量变化
  void _notifyVolumeChange() {
    final newVolume = _getVolumeByVolumeCount(_volumeCount);
    if (newVolume != _volume) {
      _volume = newVolume;
      widget.volumeChange?.call(newVolume);
    }
  }

  /// 处理拖拽开始
  void _onDragStart(DragStartDetails details) {}

  /// 处理拖拽更新
  void _onDragUpdate(DragUpdateDetails details) {
    // 计算拖拽距离占总宽度的比例
    final dragRatio = (details.localPosition.dx / _viewWidth).clamp(0.0, 1.0);
    // 根据比例计算对应的音量份数
    final newVolumeCount = (dragRatio * _volumeTotalCount).round();

    if (newVolumeCount != _volumeCount) {
      _volumeCount = newVolumeCount;
      _volumeCountNotifier.value = _volumeCount;
      // 实时通知更新（可根据需求添加节流）
      _notifyVolumeChange();
    }
  }

  /// 处理拖拽结束
  void _onDragEnd(DragEndDetails details) {
    _notifyVolumeChange(); // 确保最终值同步
  }

  /// 构建音量文本显示
  Widget _buildVolumeText() {
    return ValueListenableBuilder<int>(
      valueListenable: _volumeCountNotifier,
      builder: (context, volumeCount, child) {
        final volume = _getVolumeByVolumeCount(volumeCount);
        return NormalTextView(
          content: volume.toString(),
          fontSize: Dimens.font_normal,
          color: SColors.text_title,
        );
      },
    );
  }

  /// 构建音量控制滑块
  Widget _buildVolumeSlider() {
    return Container(
      width: _viewWidth,
      height: _lineHeight,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 滑块背景
          Container(
            width: _viewWidth,
            height: _lineHeight / 3,
            decoration: BoxDecoration(
              color: SColors.equalizer_tips_background,
              borderRadius: BorderRadius.circular(_lineWidth / 2),
            ),
          ),
          // 滑块指示器
          ValueListenableBuilder<int>(
            valueListenable: _volumeCountNotifier,
            builder: (context, volumeCount, child) {
              // 计算滑块位置（基于当前音量比例）
              final sliderPosition = (volumeCount / _volumeTotalCount) * _viewWidth;
              return Positioned(
                left: sliderPosition,
                child: Container(
                  width: _lineWidth,
                  height: _lineHeight,
                  decoration: BoxDecoration(
                    color: SColors.volume_control_slider_theme_shape_color,
                    borderRadius: BorderRadius.circular(_lineWidth / 2),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.margin_broad),
      child: Column(
        children: [
          DimenBoxs.vBoxNormal,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            child: _buildVolumeSlider(),
          ),
          DimenBoxs.vBoxNormal,
          _buildVolumeText(),
        ],
      ),
    );
  }

  /// 将音量值（0-100）转换为对应的份数
  int _getVolumeCountByVolume(int volume) {
    return (volume / 100.0 * _volumeTotalCount).round().clamp(0, _volumeTotalCount);
  }

  int _getVolumeByVolumeCount(int volumeCount) {
    return (volumeCount * 100.0 / _volumeTotalCount).round().clamp(0, 100);
  }
}
