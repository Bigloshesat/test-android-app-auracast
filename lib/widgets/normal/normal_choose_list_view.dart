import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';

class NormalChooseListView<T> extends StatelessWidget {
  final List<T> objects;
  final IndexedWidgetBuilder builder;
  final bool useListView;
  final double? height;
  final double? itemWidth;
  final double? itemHeight;
  final double? borderLineHeight;
  final int maxShowItemCount;
  final bool showBorder;
  final Color? borderLineColor;
  final Color? background;

  NormalChooseListView({
    Key? key,
    required this.objects,
    required this.builder,
    this.useListView = true,
    this.height,
    this.itemWidth,
    this.itemHeight,
    this.borderLineHeight,
    this.maxShowItemCount = 5,
    this.showBorder = true,
    this.borderLineColor,
    this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int itemCount = objects.length;
    double theItemHeight =
        itemHeight ?? Dimens.normal_choose_list_view_item_height;
    double theWidth = itemWidth ?? double.infinity;
    double theHeight = height ??
        (itemCount > maxShowItemCount
            ? theItemHeight * maxShowItemCount
            : theItemHeight * itemCount);
    Color theBorderLineColor = borderLineColor ?? SColors.line;
    Color theBackgroundColor = background ?? Colors.transparent;

    Widget contentView = Container(
      width: theWidth,
      height: theHeight,
      color: theBackgroundColor,
      child: useListView
          ? ListView.builder(
              itemCount: objects.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemBuilder: (context, position) {
                return builder(context, position);
              })
          : SingleChildScrollView(
              child: Column(
                children: _buildItems(context),
              ),
            ),
    );
    return showBorder
        ? Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: borderLineHeight ?? Dimens.line_narrow,
                    color: theBorderLineColor)),
            child: contentView,
          )
        : contentView;
  }

  List<Widget> _buildItems(BuildContext context) {
    List<Widget> itemViews = [];
    for (int i = 0; i < objects.length; i++) {
      itemViews.add(builder(context, i));
    }
    return itemViews;
  }
}
