import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatefulWidget {
  final bool animating;
  final double radius;
  final Color color;

  const CustomLoadingIndicator(
      {Key? key,
      this.animating = true,
      this.radius = 10.0,
      this.color = Colors.white70})
      : assert(radius > 0),
        super(key: key);

  @override
  CustomLoadingIndicatorState createState() => CustomLoadingIndicatorState();
}

class CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isDispose = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    if (widget.animating) _controller.repeat();
  }

  @override
  void didUpdateWidget(CustomLoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!isDispose && widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    isDispose = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: CupertinoActivityIndicatorPainter(
          position: _controller,
          activeColor: widget.color,
          radius: widget.radius,
        ),
      ),
    );
  }
}

class CupertinoActivityIndicatorPainter extends CustomPainter {
  final double _kTwoPI = math.pi * 2.0;
  final int _kTickCount = 12;
  final List<int> _alphaValues = <int>[
    147,
    131,
    114,
    97,
    81,
    64,
    47,
    47,
    47,
    47,
    47,
    47
  ];
  final Animation<double> position;
  final Color activeColor;
  final double defaultIndicatorRadius;
  final RRect tickFundamentalRRect;

  CupertinoActivityIndicatorPainter(
      {required this.position,
      required this.activeColor,
      required double radius,
      this.defaultIndicatorRadius = 10})
      : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          radius / defaultIndicatorRadius,
          -radius / 2.0,
          -radius / defaultIndicatorRadius,
          radius / defaultIndicatorRadius,
          radius / defaultIndicatorRadius,
        ),
        super(repaint: position);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position.value).floor();
    for (int i = 0; i < _kTickCount; ++i) {
      final int t = (i + activeTick) % _kTickCount;
      paint.color = activeColor.withAlpha(_alphaValues[t]);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position ||
        oldPainter.activeColor != activeColor;
  }
}
