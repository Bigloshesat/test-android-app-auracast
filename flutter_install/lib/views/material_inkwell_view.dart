import 'package:flutter/material.dart';

class MaterialInkwellView extends StatelessWidget {
  final Widget? child;
  final Color color;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onClick;

  MaterialInkwellView(
      {@required this.child,
      this.color = Colors.transparent,
      this.margin,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: color,
        child: InkWell(
          child: child,
          onTap: onClick,
        ),
      ),
    );
  }
}
