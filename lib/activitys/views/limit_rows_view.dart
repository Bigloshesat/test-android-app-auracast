import 'package:flutter/material.dart';

class LimitRowsView extends StatelessWidget {
  final int maxRows;
  final int totalItems;
  final IndexedWidgetBuilder builder;

  LimitRowsView(
      {Key? key,
      required this.maxRows,
      required this.totalItems,
      required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: _buildContentView(context),
    );
  }

  _buildContentView(BuildContext context) {
    int oneRowCount = totalItems ~/ maxRows;
    List<Row> rowViews = [];
    List<Widget> itemViews = [];

    for (int i = 0; i < totalItems; i++) {
      itemViews.add(builder(context, i));
      if (itemViews.length >= oneRowCount || i == totalItems - 1) {
        rowViews.add(Row(children: itemViews));
        itemViews = []; //需要赋值新的地址,不能clear
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowViews,
    );
  }
}
