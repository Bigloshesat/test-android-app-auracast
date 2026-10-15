import 'package:flutter/material.dart';

class NormalPopupView extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClick;
  final VoidCallback? onOutsideClick;
  final bool closeOutside;
  final double left;
  final double top;

  const NormalPopupView(
      {Key? key,
      required this.child,
      this.onClick,
      this.onOutsideClick,
      this.closeOutside = true,
      this.left = 0,
      this.top = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: _buildContentView(context),
        onTap: () {
          onOutsideClick?.call();
          if (closeOutside) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget _buildContentView(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
        ),
        Positioned(
          child: GestureDetector(
              child: child,
              onTap: () {
                onClick?.call();
              }),
          left: left,
          top: top,
        ),
      ],
    );
  }
}
