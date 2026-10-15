import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';

class VolumeControlSliderThemeShape extends SliderComponentShape {
  final double width = Dimens.volume_control_slider_theme_shape_color_width; // 椭圆长轴
  final double height = Dimens.volume_control_slider_theme_shape_color_height; // 椭圆短轴
  final double cornerRadius = Dimens.volume_control_slider_theme_shape_color_width / 2; // 圆角半径

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // 创建圆角矩形
    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(cornerRadius),
    );

    // 填充画笔
    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor ?? SColors.volume_control_slider_theme_shape_color // 优先使用主题色
      ..style = PaintingStyle.fill;


    // 绘制圆角矩形
    canvas.drawRRect(rrect, fillPaint);
  }


}