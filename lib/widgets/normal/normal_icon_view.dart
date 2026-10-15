import 'package:base_flutter/widgets/normal/normal_material_inkwell_view.dart';
import 'package:flutter/material.dart';

import '../../configs/font_config.dart';
import '../../resources/dimens.dart';

class NormalIconView extends StatelessWidget {
  final int icon;
  final IconData? iconData;
  final double? width;
  final double? height;
  final String fontFamily;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final bool useMaterial;
  final VoidCallback? onClick;

  NormalIconView({
    Key? key,
    required this.icon,
    this.iconData,
    this.width,
    this.height,
    this.fontFamily = FontConfig.font_base,
    this.color,
    this.margin,
    this.padding,
    this.fontSize,
    this.useMaterial = true,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double theFontSize = fontSize ?? Dimens.font_normal;
    double size = FontConfig.font_size_scale * theFontSize;
    Widget view = Container(
      margin: padding,
      child: Icon(
        iconData ??
            IconData(
              icon,
              fontFamily: fontFamily,
            ),
        color: color,
        size: size,
      ),
    );
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: useMaterial
          ? NormalMaterialInkwellView(onClick: onClick, child: view)
          : GestureDetector(
              onTap: onClick,
              child: view,
            ),
    );
  }
}
