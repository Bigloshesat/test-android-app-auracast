import 'package:flutter/material.dart';

class NormalStatefulView extends StatefulWidget {
  final Widget child;

  NormalStatefulView({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NormalStatefulViewState();
  }
}

class NormalStatefulViewState extends State<NormalStatefulView> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
