import 'package:flutter/material.dart';

class KeepAliveView extends StatefulWidget {
  final Widget child;

  KeepAliveView(this.child);

  @override
  State<StatefulWidget> createState() {
    return KeepAliveViewState();
  }
}

class KeepAliveViewState extends State<KeepAliveView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
