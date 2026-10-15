import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';
import 'package:framework/utils/time_util.dart';
import 'package:framework/widgets/keep_alive_view.dart';

class NormalTabView extends StatefulWidget {
  final List<TabViewItem> tabViewItems;
  final Color? selectedLabelColor;
  final TextStyle? selectedLabelStyle;
  final Color? unSelectedLabelColor;
  final TextStyle? unSelectedLabelStyle;
  final bool isScrollable;
  final bool keepAlive;
  final double? tabFontSize;
  final double? tabBarHeight;
  final EdgeInsetsGeometry? tabPadding;
  final EdgeInsetsGeometry? contentMargin;
  final EdgeInsetsGeometry? labelPadding;
  final Color? tabBarBackground;
  final double? bottomLineHeight;
  final AlignmentGeometry alignment;
  final Color? bottomLineBackground;
  final Decoration? indicator;
  final double? underlineTabIndicatorWidth;
  final Color? underlineTabIndicatorColor;
  final Widget? leftTabWidget;
  final Widget? rightTabWidget;
  final VoidIntCallback? onTabClick;

  NormalTabView(
      {Key? key,
      required this.tabViewItems,
      this.selectedLabelColor,
      this.selectedLabelStyle,
      this.unSelectedLabelColor,
      this.unSelectedLabelStyle,
      this.isScrollable = true,
      this.keepAlive = true,
      this.tabFontSize,
      this.tabBarHeight,
      this.tabPadding,
      this.contentMargin,
      this.labelPadding,
      this.tabBarBackground,
      this.bottomLineHeight,
      this.bottomLineBackground,
      this.indicator,
      this.alignment = Alignment.centerLeft,
      this.underlineTabIndicatorWidth,
      this.underlineTabIndicatorColor,
      this.leftTabWidget,
      this.rightTabWidget,
      this.onTabClick})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NormalTabViewState();
  }
}

class NormalTabViewState extends State<NormalTabView>
    with TickerProviderStateMixin {
  final List<TabViewItem> tabViewItems = [];
  TabController? tabController;
  bool isTabViewActive = false;

  @override
  void initState() {
    super.initState();
    updateTabViewItems(widget.tabViewItems);
    tabController = TabController(length: tabViewItems.length, vsync: this);
  }

  @override
  void didUpdateWidget(NormalTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((!isTabViewActive && tabViewItems.length == 0) ||
        (isTabViewActive &&
            TabViewItem.isTabViewItemsChange(
                widget.tabViewItems, tabViewItems))) {
      updateTabController(isTabViewActive, widget.tabViewItems);
    }
  }

  void updateTabViewItems(List<TabViewItem> newTabViewItems) {
    tabViewItems.clear();
    tabViewItems.addAll(newTabViewItems);
    if (newTabViewItems.length > 0) {
      isTabViewActive = true;
    }
  }

  void updateTabController(bool hasActive, List<TabViewItem> newTabViewItems) {
    updateTabViewItems(newTabViewItems);
    tabController?.dispose();
    tabController = TabController(
        initialIndex:
            hasActive == false ? 0 : (tabViewItems.length > 1 ? 1 : 0),
        length: tabViewItems.length,
        vsync: this);
    if (hasActive) {
      setState(() {
        tabController?.animateTo(0,
            duration: Duration(milliseconds: 1)); //fix tabbar bug
      });
    }
  }

  void selectTab(int index) {
    if (tabViewItems.length > index) {
      tabController?.index = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            widget.leftTabWidget ?? Container(),
            Expanded(child: _buildTabBar()),
            widget.rightTabWidget ?? Container()
          ],
        ),
        Expanded(
          child: _buildTabView(),
        )
      ],
    );
  }

  Widget _buildTabBar() {
    double theTabFontSize = widget.tabFontSize ?? Dimens.font_normal;
    double theTabBarHeight =
        widget.tabBarHeight ?? Dimens.normal_tab_view_height;
    Color theTabBarBackground = widget.tabBarBackground ?? Colors.transparent;
    Color theBottomLineBackground =
        widget.bottomLineBackground ?? SColors.primary;
    EdgeInsetsGeometry theLabelPadding = widget.labelPadding ?? EdgeInsets.zero;
    Color theSelectedLabelColor =
        widget.selectedLabelColor ?? SColors.text_title;
    TextStyle theSelectedLabelStyle = widget.selectedLabelStyle ??
        TextStyle(
            color: theSelectedLabelColor,
            fontSize: theTabFontSize,
            fontWeight: FontWeight.w600);
    Color theUnselectedLabelColor =
        widget.unSelectedLabelColor ?? SColors.text_hint;
    TextStyle theUnSelectedLabelStyle = widget.unSelectedLabelStyle ??
        TextStyle(color: theUnselectedLabelColor, fontSize: theTabFontSize);
    double theUnderlineTabIndicatorWidth =
        widget.underlineTabIndicatorWidth ?? Dimens.line_broad;
    Color theUnderlineTabIndicatorColor =
        widget.underlineTabIndicatorColor ?? SColors.primary;

    Widget contentView = TabBar(
        labelPadding: theLabelPadding,
        controller: tabController,
        isScrollable: widget.isScrollable,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: theSelectedLabelColor,
        labelStyle: theSelectedLabelStyle,
        unselectedLabelColor: theUnselectedLabelColor,
        unselectedLabelStyle: theUnSelectedLabelStyle,
        indicator: widget.indicator ??
            UnderlineTabIndicator(
              borderSide: BorderSide(
                width: theUnderlineTabIndicatorWidth,
                color: theUnderlineTabIndicatorColor,
              ),
            ),
        onTap: widget.onTabClick,
        tabs: tabViewItems.map((tab) {
          return Tab(text: tab.name);
        }).toList());
    return Container(
      height: theTabBarHeight,
      padding: widget.tabPadding,
      alignment: widget.alignment,
      decoration: BoxDecoration(
        color: theTabBarBackground,
        border: widget.bottomLineHeight != null
            ? Border(
                bottom: BorderSide(
                    width: widget.bottomLineHeight!,
                    color: theBottomLineBackground),
              )
            : null,
      ),
      child: contentView,
    );
  }

  Widget _buildTabView() {
    EdgeInsetsGeometry theContentMargin =
        widget.contentMargin ?? EdgeInsets.zero;
    return Container(
      margin: theContentMargin,
      child: TabBarView(
        controller: tabController,
        children: tabViewItems.map((tab) {
          return widget.keepAlive ? KeepAliveView(tab.view) : tab.view;
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    tabController?.dispose();
    tabController = null;
    super.dispose();
  }
}

class TabViewItem {
  dynamic name;
  Widget view;
  dynamic? object;
  late int uniqueTimestamp;

  TabViewItem(this.name, this.view, {this.object}) {
    this.uniqueTimestamp = TimeUtil.getUniqueTimestamp();
  }

  static bool isTabViewItemsChange(
      List<TabViewItem>? newTabViewItems, List<TabViewItem>? oldTabViewItems) {
    if (newTabViewItems == null ||
        oldTabViewItems == null ||
        newTabViewItems.length != oldTabViewItems.length) {
      return true;
    }
    for (int i = 0; i < newTabViewItems.length; i++) {
      TabViewItem newTabViewItem = newTabViewItems[i];
      TabViewItem oldTabViewItem = oldTabViewItems[i];
      int newUniqueTimestamp = newTabViewItem.uniqueTimestamp;
      int oldUniqueTimestamp = oldTabViewItem.uniqueTimestamp;
      if (newUniqueTimestamp != 0 && newUniqueTimestamp != oldUniqueTimestamp) {
        return true;
      }
    }
    return false;
  }
}
