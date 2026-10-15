import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:framework/utils/log_util.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';

typedef PointsChangeCallback = Function(List<Offset>);

class TouchableLineChartView extends StatefulWidget {
  final List<Offset> points;
  final double maxX;
  final double maxY;
  final double? canvasWidth;
  final double? canvasHeight;
  final double? canvasPadding;
  final List<String>? splitPositionXTexts;
  final double? lineWidth;
  final Color? lineColor;
  final Color? pointColor;
  final double? pointRadius;
  final double? checkPointArea;
  final PointsChangeCallback? pointsChangeCallback;
  final bool canEdit;
  final bool showXCoordinateAxis;
  final bool showYCoordinateAxis;
  final bool pointsChangeCallbackWithMove;

  TouchableLineChartView(
      {Key? key,
      required this.points,
      required this.maxX,
      required this.maxY,
      this.canvasWidth,
      this.canvasHeight,
      this.canvasPadding,
      this.splitPositionXTexts,
      this.lineWidth,
      this.lineColor,
      this.pointColor,
      this.pointRadius,
      this.checkPointArea,
      this.pointsChangeCallback,
      this.canEdit = true,
      this.showXCoordinateAxis = true,
      this.showYCoordinateAxis = true,
      this.pointsChangeCallbackWithMove=false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TouchableLineChartViewState();
  }
}

class TouchableLineChartViewState extends State<TouchableLineChartView> {
  late List<Offset> points;
  late List<Offset> oldPoints;
  late double maxX;
  late double maxY;
  late double canvasWidth;
  late double canvasHeight;
  late double canvasPadding;
  late double pointRadius;
  late double checkPointArea;
  late double unitX;
  late double unitY;
  int touchSelectIndex = -1;
  DragUpdateDetails? dragUpdateDetails;
  bool isChange=false;

  void _updateValue() {
    points = widget.points;
    maxX = widget.maxX;
    maxY = widget.maxY;
    canvasWidth = widget.canvasWidth ?? Dimens.touchable_line_chart_view_canvas_width;
    canvasHeight =
        widget.canvasHeight ?? Dimens.touchable_line_chart_view_canvas_height;
    canvasPadding=widget.canvasPadding ?? Dimens.touchable_line_chart_view_canvas_padding;
    pointRadius =
        widget.pointRadius ?? Dimens.touchable_line_chart_view_point_radius;
    checkPointArea=
        widget.checkPointArea ?? Dimens.touchable_line_chart_view_check_point_area;
    unitX = canvasWidth / maxX;
    unitY = canvasHeight / maxY;
    _checkPointsValue();
  }

  void _checkPointsValue() {
    for (int i = 0; i < points.length; i++) {
      Offset offset = points[i];
      if (offset.dx > maxX) {
        points[i] = Offset(maxX, points[i].dy);
      }
      if (offset.dx < 0) {
        points[i] = Offset(0, points[i].dy);
      }
      if (offset.dy > maxY) {
        points[i] = Offset(points[i].dx, maxY);
      }
      if (offset.dy < 0) {
        points[i] = Offset(points[i].dx, 0);
      }
    }
  }

  List<Offset> getPointPositions() {
    List<Offset> positions = [];
    points.forEach((item) {
      positions.add(Offset(item.dx * unitX+canvasPadding, (canvasHeight+canvasPadding) - item.dy * unitY));
    });
    return positions;
  }

  @override
  void initState() {
    super.initState();
    _updateValue();
  }

  void updatePoints(List<Offset> value) {
    this.points =value;
    _checkPointsValue();
    setState(() {});
  }

  @override
  void didUpdateWidget(TouchableLineChartView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentView();
  }

  Widget _buildContentView() {
    double theLineWidth = widget.lineWidth ?? Dimens.line_normal;

    Color theLineColor = widget.lineColor ?? SColors.line;
    Color thePointColor =
        widget.pointColor ?? SColors.default_button_select_background;
    Widget contentView = Column(
      children: [
        CustomPaint(
          size: Size(canvasWidth+canvasPadding*2, canvasHeight+canvasPadding*2),
          painter: LineChartPainter(
              getPointPositions(),
              canvasWidth,
              canvasHeight,
              canvasPadding,
              theLineColor,
              thePointColor,
              theLineWidth,
              pointRadius,
              widget.showXCoordinateAxis,
              widget.showYCoordinateAxis),
        ),
        Container(
          child: buildXUnitTextsView(),
          width: canvasWidth+canvasPadding*2,
          height: Dimens.font_narrow,
        )
      ],
    );
    return widget.canEdit
        ? GestureDetector(
            // behavior: HitTestBehavior.deferToChild,
            onPanUpdate: (details) {
              dragUpdateDetails=details;
              checkSelectPointAndUpdatePosition(details.localPosition.dx,details.localPosition.dy, pointRadius);
              setState(() {
              });
            },
            onPanEnd: (details) {
              if(dragUpdateDetails!=null&&isChange){
                widget.pointsChangeCallback?.call(points);
              }
              touchSelectIndex = -1;
              dragUpdateDetails=null;
              isChange=false;
            },
            onPanCancel: () {
              if(dragUpdateDetails!=null&&isChange){
                widget.pointsChangeCallback?.call(points);
              }
              touchSelectIndex = -1;
              dragUpdateDetails=null;
              isChange=false;
            },
            child: contentView,
          )
        : contentView;
  }

  Widget buildXUnitTextsView() {
    if (widget.splitPositionXTexts == null ||
        widget.splitPositionXTexts!.length == 0 ||
        widget.splitPositionXTexts!.length != points.length) {
      return Container();
    }
    List<Offset> pointPositions = getPointPositions();
    List<Widget> views = [];
    int length = widget.splitPositionXTexts!.length;

    double unitXWidth = pointPositions[1].dx - pointPositions[0].dx;
    for (int i = 0; i < length; i++) {
      String unitText = widget.splitPositionXTexts![i];
      Widget textView = NormalTextView(
          content: unitText,
          fontSize: Dimens.font_narrow,
          color: SColors.text_content);
      if (i == 0) {
        views.add(
          Positioned(
            left: canvasPadding,
            child: textView,
          ),
        );
      } else if (i == length - 1) {
        views.add(
          Positioned(
            right: canvasPadding,
            child: textView,
          ),
        );
      } else {
        //i>1
        views.add(
          Positioned(
            left: pointPositions[i - 1].dx,
            child: Container(
              child: textView,
              width: unitXWidth * 2,
              alignment: Alignment.topCenter,
            ),
          ),
        );
      }
    }
    return Stack(
      children: views,
    );
  }

  void checkSelectPointAndUpdatePosition(double localPositionX, double localPositionY, double pointRadius) {
    List<Offset> positions = getPointPositions();
    if (touchSelectIndex != -1) {
      double distanceY =localPositionY - positions[touchSelectIndex].dy;
      if (distanceY.abs() >= unitY) {
        int change = distanceY ~/ unitY;
        points[touchSelectIndex] = Offset(
            points[touchSelectIndex].dx, points[touchSelectIndex].dy - change);
        _checkPointsValue();
        isChange=true;
        if(widget.pointsChangeCallbackWithMove){
          widget.pointsChangeCallback?.call(points);
        }
      }
      return;
    }
    for (int i = 0; i < points.length; i++) {
      //获取触摸区域最近的点并改变Y值
      double positionX = positions[i].dx;
      double positionY = positions[i].dy;

      double distanceX = localPositionX - positionX;
      double distanceY = localPositionY - positionY;
      if ((distanceX.abs() < checkPointArea && distanceY.abs() < checkPointArea)) {
        LogUtil.e("positionX" +
            positionX.toString() +
            ";positionY" +
            positionX.toString());
        LogUtil.e("detailsX" +localPositionX.toString() +
            ";detailsY" +localPositionY.toString());
        touchSelectIndex = i;
        if (distanceY.abs() >= unitY) {
          int change = distanceY ~/ unitY;
          points[i] = Offset(points[i].dx, points[i].dy - change);
          _checkPointsValue();
          isChange=true;
          if(widget.pointsChangeCallbackWithMove) {
            widget.pointsChangeCallback?.call(points);
          }
        }
        break;
      }
    }
  }
}

class LineChartPainter extends CustomPainter {
  final List<Offset> positions;
  final double canvasWidth;
  final double canvasHeight;
  final double canvasPadding;
  final Color lineColor;
  final Color pointColor;
  final double lineWidth;
  final double pointRadius;
  final bool showXCoordinateAxis;
  final bool showYCoordinateAxis;

  LineChartPainter(this.positions, this.canvasWidth, this.canvasHeight,this.canvasPadding, this.lineColor,
      this.pointColor, this.lineWidth, this.pointRadius,this.showXCoordinateAxis,this.showYCoordinateAxis);

  @override
  void paint(Canvas canvas, Size size) {
    if(showXCoordinateAxis) {
      drawXCoordinateAxis(canvas);
    }
    if(showYCoordinateAxis) {
      drawYCoordinateAxis(canvas);
    }
    drawShadow(canvas);
    drawLines(canvas);
    drawCirclePoints(canvas);
  }

  void drawXCoordinateAxis(Canvas canvas) {
    Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    path.moveTo(0+canvasPadding, canvasHeight+canvasPadding);
    path.lineTo(canvasWidth+canvasPadding, canvasHeight+canvasPadding);
    canvas.drawPath(path, paint);
  }

  void drawYCoordinateAxis(Canvas canvas) {
    Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    path.moveTo(0+canvasPadding, 0+canvasPadding);
    path.lineTo(0+canvasPadding, canvasHeight+canvasPadding);
    canvas.drawPath(path, paint);
  }

  void drawLines(Canvas canvas) {
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    path.moveTo(positions[0].dx, positions[0].dy);

    for (int i = 1; i < positions.length; i++) {
      path.lineTo(positions[i].dx, positions[i].dy);
    }
    canvas.drawPath(path, linePaint);
  }

  void drawCirclePoints(Canvas canvas) {
    Paint pointPaint = Paint()
      ..color = pointColor
      ..strokeWidth = pointRadius * 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    for (int i = 0; i < positions.length; i++) {
      canvas.drawCircle(
          Offset(positions[i].dx, positions[i].dy), pointRadius, pointPaint);
    }
  }

  void drawShadow(Canvas canvas) {
    Paint shadowPaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..color = lineColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    Path shadowPath = Path();
    shadowPath.moveTo(0+canvasPadding, canvasHeight+canvasPadding);
    shadowPath.lineTo(positions[0].dx, positions[0].dy);
    for (int i = 1; i < positions.length; i++) {
      shadowPath.lineTo(positions[i].dx, positions[i].dy);
    }
    shadowPath.lineTo(canvasWidth+canvasPadding, canvasHeight+canvasPadding);
    shadowPath.lineTo(0+canvasPadding, canvasHeight+canvasPadding);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
