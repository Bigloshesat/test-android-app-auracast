import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:framework/base/base_callback_function.dart';
import 'package:framework/utils/device_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'clear_over_scroll_behavior_view.dart';

typedef WidgetCallback = Widget Function();

typedef WidgetIntCallback = Widget Function(int itemLength);

typedef WidgetFunction = Widget Function();

typedef HeaderWidgetBuilder = Widget Function(BuildContext context);

typedef FooterWidgetBuilder = Widget Function(BuildContext context);

enum PullRefreshViewListType { ListView, GridView, StaggeredGridView }

class PullRefreshController<T> extends RefreshController with ChangeNotifier {
  final List<T> datas = [];
  bool noMore = false;
  bool isLoading = true;
  bool isInit = false;
  int index = 1;
  bool _disposed = false;

  void checkResetIndex(bool isRefresh) {
    if (isRefresh) {
      resetIndex();
    }
  }

  void resetIndex() {
    index = 1;
    noMore = false;
  }

  Future<void> addPage(bool isRefresh, List<T> items, bool noMore) async {
    this.noMore = noMore;
    isRefresh
        ? refreshData(items, noMore: this.noMore)
        : addData(items, noMore: this.noMore);
    index++;
  }

  Future<void> refreshData(List<T>? data,
      {bool firstInitDelay = false, bool? noMore}) async {
    if (_disposed) {
      return;
    }
    this.datas.clear();
    this.datas.addAll(data ?? []);
    if (!isInit) {
      if (firstInitDelay) {
        await Future.delayed(Duration(milliseconds: 200));
      }
      isInit = true;
    }
    if (super.isRefresh) {
      super.refreshCompleted();
    }
    super.resetNoData();
    if (noMore == null) {
      noMore = this.noMore;
    }
    if (noMore) {
      super.loadNoData();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addData(List<T>? data, {bool noMore = false}) async {
    if (_disposed) {
      return;
    }
    this.datas.addAll(data ?? []);
    if (super.isLoading) {
      super.loadComplete();
    }
    if (noMore) {
      super.loadNoData();
    }
    isLoading = false;
    notifyListeners();
  }

  void startLoading() {
    if (_disposed) {
      return;
    }
    isLoading = true;
    notifyListeners();
  }

  void stopLoading(bool isRefresh) {
    if (_disposed) {
      return;
    }
    if (isRefresh) {
      if (!isInit) {
        isInit = true;
      }
    }
    super.refreshCompleted();
    if (noMore) {
      super.loadComplete();
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (_disposed) {
      return;
    }
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class PullRefreshView extends StatefulWidget {
  final PullRefreshController pullRefreshController;
  final IndexedWidgetBuilder builder;
  final EdgeInsetsGeometry? padding;
  final VoidFutureCallback? onRefresh;
  final VoidFutureCallback? onLoad;
  final bool canRefresh;
  final bool canLoadMore;
  final bool showEmptyWhenZeroItems;
  final bool expandLaveSpace;
  final bool showFooter;
  final bool clearOverScroll;
  final Color themeColor;
  final Widget? emptyView;
  final Widget? initLoadingView;
  final HeaderWidgetBuilder? headerWidgetBuilder;
  final FooterWidgetBuilder? footerWidgetBuilder;
  final ScrollPhysics? physics;
  final PullRefreshViewListType pullRefreshViewListType;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final IndexedStaggeredTileBuilder? staggeredTileBuilder;
  final WidgetIntCallback? topViewBuilder;
  final WidgetCallback? bottomViewBuilder;

  PullRefreshView(
      {Key? key,
      required this.pullRefreshController,
      required this.builder,
      this.padding,
      this.onRefresh,
      this.onLoad,
      this.canRefresh = true,
      this.canLoadMore = true,
      this.showEmptyWhenZeroItems = false,
      this.expandLaveSpace = false,
      this.showFooter = true,
      this.clearOverScroll = true,
      this.themeColor = Colors.black,
      this.emptyView,
      this.initLoadingView,
      this.headerWidgetBuilder,
      this.footerWidgetBuilder,
      this.physics,
      this.pullRefreshViewListType = PullRefreshViewListType.ListView,
      this.crossAxisCount = 1,
      this.mainAxisSpacing = 0,
      this.crossAxisSpacing = 0,
      this.staggeredTileBuilder,
      this.topViewBuilder,
      this.bottomViewBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PullRefreshViewState();
  }
}

class _PullRefreshViewState extends State<PullRefreshView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.pullRefreshController.addListener(() {
      if (mounted) {
        setState(() {
          _isLoading = widget.pullRefreshController.isLoading;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> datas = widget.pullRefreshController.datas;
    bool showRefreshView =
        widget.pullRefreshController.isInit || widget.initLoadingView == null;
    bool showEmptyView = !_isLoading &&
        datas.isEmpty &&
        (widget.topViewBuilder == null || widget.showEmptyWhenZeroItems);
    SmartRefresher smartRefresher = SmartRefresher(
      controller: widget.pullRefreshController,
      enablePullDown: widget.canRefresh,
      enablePullUp: widget.canLoadMore,
      header: _buildHeaderView(),
      footer: _buildFooterView(datas.isEmpty, widget.showFooter),
      child: getChildBuilderView(showRefreshView, datas),
      onRefresh: widget.canRefresh
          ? () async {
        widget.pullRefreshController.startLoading();
              await widget.onRefresh?.call();
            }
          : null,
      onLoading: widget.canLoadMore
          ? () async {
              if (datas.length > 0) {
                widget.pullRefreshController.startLoading();
                await widget.onLoad?.call();
              } else {
                await Future.delayed(Duration(milliseconds: 1000));
                widget.pullRefreshController.stopLoading(false);
              }
            }
          : null,
    );
    return Stack(
      children: [
        !showRefreshView
            ? (widget.initLoadingView ?? Container())
            : Container(),
        showEmptyView ? (widget.emptyView ?? Container()) : Container(),
        widget.clearOverScroll
            ? ClearOverScrollBehaviorView(child: smartRefresher)
            : smartRefresher,//if cover with emptyView will got error
      ],
    );
  }

  Widget _buildHeaderView() {
    if (widget.headerWidgetBuilder != null) {
      return widget.headerWidgetBuilder!.call(context);
    }
    return MaterialClassicHeader(color: widget.themeColor);
  }

  Widget _buildFooterView(bool isEmpty, bool showFooter) {
    if (isEmpty || !showFooter) {
      return CustomFooter(
        loadStyle: LoadStyle.HideAlways,
        height: 0,
        builder: (BuildContext context, LoadStatus? mode) {
          return Container();
        },
      );
    }
    if (widget.footerWidgetBuilder != null) {
      return widget.footerWidgetBuilder!.call(context);
    }
    return ClassicFooter(
      loadingIcon: SizedBox(
        child: DeviceUtil.isAndroid()
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(widget.themeColor))
            : CupertinoActivityIndicator(),
      ),
    );
  }

  Widget splitListViewItem(BuildContext context, int position,
      IndexedWidgetBuilder itemBuilder, int count, int lastCrossCount) {
    List<Widget> views = [];
    if (position < count - 1) {
      for (int i = 0; i < widget.crossAxisCount; i++) {
        views.add(
          Expanded(
            flex: 1,
            child: Container(
              child: itemBuilder(context, widget.crossAxisCount * position + i),
              margin: EdgeInsets.only(bottom: widget.crossAxisSpacing),
            ),
          ),
        );
        if (i < widget.crossAxisCount - 1) {
          views.add(
            Container(
              width: widget.mainAxisSpacing,
              margin: EdgeInsets.only(bottom: widget.crossAxisSpacing),
            ),
          );
        }
      }
    } else {
      for (int i = 0; i < widget.crossAxisCount; i++) {
        if (i < lastCrossCount) {
          views.add(
            Expanded(
              flex: 1,
              child: Container(
                child:
                    itemBuilder(context, widget.crossAxisCount * position + i),
                margin: EdgeInsets.only(bottom: widget.crossAxisSpacing),
              ),
            ),
          );
        } else {
          widget.expandLaveSpace
              ? Container()
              : views.add(
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(bottom: widget.crossAxisSpacing),
                    ),
                  ),
                );
        }
        if (i < widget.crossAxisCount - 1) {
          views.add(
            Container(
              width: widget.mainAxisSpacing,
              margin: EdgeInsets.only(bottom: widget.crossAxisSpacing),
            ),
          );
        }
      }
    }
    return Row(
      children: views,
    );
  }

  Widget getChildBuilderView(bool showRefreshView, List<dynamic> data) {
    Widget view;
    bool addTopItem = widget.topViewBuilder != null ? true : false;
    bool addBottomItem = widget.bottomViewBuilder != null ? true : false;
    int itemLength = data.length;
    switch (widget.pullRefreshViewListType) {
      case PullRefreshViewListType.GridView:
        int count = itemLength ~/ widget.crossAxisCount;
        int lastCrossCount = itemLength - count * widget.crossAxisCount;
        if (lastCrossCount > 0) {
          count = count + 1;
        } else {
          lastCrossCount = widget.crossAxisCount;
        }
        int totalCount = count + (addTopItem ? 1 : 0) + (addBottomItem ? 1 : 0);
        view = ListView.builder(
            physics: widget.physics,
            padding: widget.padding,
            itemCount: totalCount,
            shrinkWrap: true,
            itemBuilder: (context, position) {
              if (!showRefreshView) {
                return Container();
              }
              Widget itemView = Container();
              if (addTopItem) {
                if (position == 0) {
                  return widget.topViewBuilder!(itemLength);
                } else {
                  itemView = splitListViewItem(context, position - 1,
                      widget.builder, count, lastCrossCount);
                }
              } else {
                itemView = splitListViewItem(
                    context, position, widget.builder, count, lastCrossCount);
              }

              if (widget.bottomViewBuilder != null &&
                  position == totalCount - 1) {
                return Column(
                  children: [
                    itemView,
                    widget.bottomViewBuilder!(),
                  ],
                );
              } else {
                return itemView;
              }
            });
        break;
      case PullRefreshViewListType.StaggeredGridView:
        view = StaggeredGridView.countBuilder(
          physics: widget.physics,
          padding: widget.padding,
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
          itemCount: itemLength,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int position) {
            if (!showRefreshView) {
              return Container();
            }
            return widget.builder(context, position);
          },
          staggeredTileBuilder: widget.staggeredTileBuilder ??
              (int index) => StaggeredTile.fit(1),
        );
        break;
      case PullRefreshViewListType.ListView:
      default:
        int totalCount = itemLength + (addTopItem ? 1 : 0);
        view = ListView.builder(
            physics: widget.physics,
            padding: widget.padding,
            itemCount: totalCount,
            shrinkWrap: true,
            itemBuilder: (context, position) {
              if (!showRefreshView) {
                return Container();
              }
              Widget itemView = Container();
              if (addTopItem) {
                if (position == 0) {
                  return widget.topViewBuilder!(itemLength);
                } else {
                  itemView = widget.builder(context, position - 1);
                }
              } else {
                itemView = widget.builder(context, position);
              }
              if (widget.bottomViewBuilder != null &&
                  position == totalCount - 1) {
                return Column(
                  children: [
                    itemView,
                    widget.bottomViewBuilder!(),
                  ],
                );
              } else {
                return itemView;
              }
            });
        break;
    }
    return view;
  }
}
