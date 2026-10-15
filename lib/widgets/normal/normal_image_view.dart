import 'package:flutter/material.dart';

import 'normal_material_inkwell_view.dart';

class NormalImageView extends StatelessWidget {
  final String assetUrl;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool useMaterial;
  final BoxFit fit;
  final VoidCallback? onClick;

  NormalImageView({
    Key? key,
    required this.assetUrl,
    this.color,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.useMaterial = true,
    this.fit = BoxFit.fill,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget view = Container(
      margin: padding,
      width: width,
      height: height,
      child: Image.asset(
        assetUrl,
        fit: fit,
        color: color,
      ),
    );
    return Container(
      margin: margin,
      child: useMaterial
          ? NormalMaterialInkwellView(onClick: onClick, child: view)
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onClick,
              child: view,
            ),
    );
  }
}
