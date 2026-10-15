import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';

class VolumeOrientationControlView extends StatefulWidget {
  final int volume;
  final int volumeTotalCount;
  final double? volumeWidth;
  final double? volumeHeight;
  final double? volumeSpace;
  final double? viewWidth;
  final VoidIntCallback? volumeChange;
  final bool isVertical;
  final double tagViewPercent;

  VolumeOrientationControlView({
    Key? key,
    this.volume = 0,
    this.volumeTotalCount = 50,
    this.volumeWidth,
    this.volumeHeight,
    this.volumeSpace,
    this.volumeChange,
    this.viewWidth,
    this.isVertical = true,
    this.tagViewPercent = 0.05,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VolumeOrientationControlViewState();
  }
}

class _VolumeOrientationControlViewState
    extends State<VolumeOrientationControlView> {
  late int volume;
  late int volumeTotalCount;
  late double volumeWidth;
  late double volumeHeight;
  late double volumeSpace;
  late int nowVolumeCount;
  late double tagViewPercent;
  double lastMoveY = 0;
  double lastMoveX = 0;
  int lastUpdateTime = 0;

  void _updateValue() {
    volume = widget.volume;
    volumeTotalCount = widget.volumeTotalCount;
    volumeWidth = widget.volumeWidth ?? Dimens.volume_control_view_width;
    volumeHeight =
        widget.volumeHeight ?? Dimens.volume_control_view_line_height;
    volumeSpace = widget.volumeSpace ?? Dimens.volume_control_view_space;
    tagViewPercent = widget.tagViewPercent;
    nowVolumeCount = getVolumeCountByVolume(volume);
  }

  @override
  void initState() {
    super.initState();
    _updateValue();
  }

  @override
  void didUpdateWidget(VolumeOrientationControlView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _updateValue();
    });
  }

  void _updateVolume() {
    volume = getVolumeByVolumeCount(nowVolumeCount);
    widget.volumeChange?.call(volume);
  }

  void _checkAndUpdateVolume() {
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    if (lastUpdateTime - timeNow > 500) {
      lastUpdateTime = timeNow;
      _updateVolume();
    }
  }

  @override
  Widget build(BuildContext context) {
    double viewWidth = widget.viewWidth ?? MediaQuery.of(context).size.width;
    Widget contentView = widget.isVertical
        ? Stack(
            children: [
              Align(alignment: Alignment.topCenter, child: _buildVolumeView()),
              Positioned(
                left: viewWidth / 2 + volumeWidth / 2,
                top: getTagViewHeight(),
                child: _volumeTextView(),
              ),
            ],
          )
        : Column(
            children: [
              DimenBoxs.vBoxNormal,
              _volumeTextView(),
              DimenBoxs.vBoxNormal,
              _buildVolumeView(),
            ],
          );
    return Container(
      width: widget.viewWidth,
      padding: EdgeInsets.only(
          left: Dimens.margin_broad, right: Dimens.margin_broad),
      child: contentView,
    );
  }

  double getTagViewHeight() {
    return volumeTotalCount * (volumeHeight + volumeSpace * 2) * tagViewPercent;
  }

  void _onVerticalDragStart(DragStartDetails details) async {
    lastMoveY = details.globalPosition.dy;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    double volumeItemHeight = volumeHeight + 2 * volumeSpace;
    double newMoveY = details.globalPosition.dy;
    double change = newMoveY - lastMoveY;
    int count = (change / volumeItemHeight).abs().floor();
    if (change >= volumeItemHeight) {
      nowVolumeCount = nowVolumeCount - count;
      if (nowVolumeCount < 0) {
        nowVolumeCount = 0;
      }
      lastMoveY = lastMoveY + count * volumeItemHeight;
      _checkAndUpdateVolume();
      setState(() {});
    } else if (change <= -volumeItemHeight) {
      nowVolumeCount = nowVolumeCount + count;
      if (nowVolumeCount > volumeTotalCount) {
        nowVolumeCount = volumeTotalCount;
      }
      lastMoveY = lastMoveY - count * volumeItemHeight;
      _checkAndUpdateVolume();
      setState(() {});
    } else {}
  }

  void _onVerticalDragEnd(_) async {
    _updateVolume();
  }

  void _onHorizontalDragStart(DragStartDetails details) async {
    lastMoveX = details.globalPosition.dx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    double volumeItemHeight = volumeHeight + 2 * volumeSpace;
    double newMoveX = details.globalPosition.dx;
    double change = newMoveX - lastMoveX;
    int count = (change / volumeItemHeight).abs().floor();
    if (change >= volumeItemHeight) {
      nowVolumeCount = nowVolumeCount + count;
      if (nowVolumeCount > volumeTotalCount) {
        nowVolumeCount = volumeTotalCount;
      }
      lastMoveX = lastMoveX + count * volumeItemHeight;
      _checkAndUpdateVolume();
      setState(() {});
    } else if (change <= -volumeItemHeight) {
      nowVolumeCount = nowVolumeCount - count;
      if (nowVolumeCount < 0) {
        nowVolumeCount = 0;
      }
      lastMoveX = lastMoveX - count * volumeItemHeight;
      _checkAndUpdateVolume();
      setState(() {});
    } else {}
  }

  void _onHorizontalDragEnd(_) async {
    _updateVolume();
  }

  Widget _volumeTextView() {
    int value = getVolumeByVolumeCount(nowVolumeCount);
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: SColors.line, width: Dimens.line_narrow),
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.radius_narrow),
          ),
        ),
        padding: EdgeInsets.all(Dimens.margin_super_narrow),
        child: NormalTextView(
            content: value.toString(),
            fontSize: Dimens.font_narrow,
            color: SColors.line));
  }

  Widget _buildVolumeView() {
    double tagViewHeight = getTagViewHeight();
    double leaveVolumeHeight =
        (volumeTotalCount - nowVolumeCount) * (volumeHeight + volumeSpace * 2);
    double selectVolumeHeight =
        nowVolumeCount * (volumeHeight + volumeSpace * 2);
    Widget contentView = Container(
      child: widget.isVertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildVolumeValueLeaveView(),
                _buildVolumeValueSelectView()
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildVolumeValueSelectView(),
                _buildVolumeValueLeaveView(),
                Container(width: tagViewHeight)
              ],
            ),
      margin: widget.isVertical
          ? EdgeInsets.only(top: tagViewHeight)
          : EdgeInsets.only(left: 0),
    );
    Widget tagView = Container(
      width: widget.isVertical ? volumeWidth : tagViewHeight,
      height: widget.isVertical ? tagViewHeight : volumeWidth,
      color: SColors.volume_control_tag_view_background,
      margin: widget.isVertical
          ? EdgeInsets.only(top: leaveVolumeHeight)
          : EdgeInsets.only(left: selectVolumeHeight),
    );
    return widget.isVertical
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragStart: _onVerticalDragStart,
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Stack(children: [contentView, tagView])
                ],
              ),
            ),
          )
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Container(
              child: Column(
                children: [
                  Stack(children: [contentView, tagView])
                ],
              ),
            ),
          );
  }

  Widget _buildVolumeValueLeaveView() {
    List<Widget> widgets = [];
    int leaveVolumeCount = volumeTotalCount - nowVolumeCount;
    if (widget.isVertical) {
      for (int i = 0; i < leaveVolumeCount; i++) {
        widgets.add(_buildVolumeItemView(i, false));
      }
    } else {
      for (int i = 0; i < leaveVolumeCount; i++) {
        widgets.add(_buildVolumeItemView(nowVolumeCount + i, false));
      }
    }
    return Container(
        child: widget.isVertical
            ? Column(mainAxisSize: MainAxisSize.min, children: widgets)
            : Row(mainAxisSize: MainAxisSize.min, children: widgets),
        color: SColors.volume_control_item_disable_background);
  }

  Widget _buildVolumeValueSelectView() {
    List<Widget> widgets = [];
    if (widget.isVertical) {
      int leaveVolumeCount = volumeTotalCount - nowVolumeCount;
      for (int i = 0; i < nowVolumeCount; i++) {
        widgets.add(_buildVolumeItemView(leaveVolumeCount + i, true));
      }
    } else {
      for (int i = 0; i < nowVolumeCount; i++) {
        widgets.add(_buildVolumeItemView(i, true));
      }
    }
    return Container(
        child: widget.isVertical
            ? Column(mainAxisSize: MainAxisSize.min, children: widgets)
            : Row(mainAxisSize: MainAxisSize.min, children: widgets),
        color: SColors.volume_control_item_background);
  }

  Widget _buildVolumeItemView(int index, bool isSelect) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: Container(
            width: widget.isVertical ? volumeWidth : volumeHeight,
            height: widget.isVertical ? volumeHeight : volumeWidth,
            color: isSelect
                ? SColors.volume_control_item_background
                : SColors.volume_control_item_disable_background),
        padding: widget.isVertical
            ? EdgeInsets.symmetric(vertical: volumeSpace)
            : EdgeInsets.symmetric(horizontal: volumeSpace),
      ),
      onTap: () {
        int newVolumeCount = volumeTotalCount - index;
        nowVolumeCount = widget.isVertical ? newVolumeCount : index;
        _updateVolume();
        setState(() {});
      },
    );
  }

  int getVolumeCountByVolume(int volume) {
    return (volume / 100.0 * volumeTotalCount).round();
  }

  int getVolumeByVolumeCount(int nowVolumeCount) {
    return (nowVolumeCount * 100.0 / volumeTotalCount).round();
  }
}
