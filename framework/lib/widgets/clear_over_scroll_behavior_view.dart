import 'package:flutter/material.dart';
import 'package:framework/utils/device_util.dart';

class ClearOverScrollBehaviorView extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  ClearOverScrollBehaviorView({required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ScrollConfiguration(
        behavior: ClearOverScrollBehavior(),
        child: child,
      ),
    );
  }
}

class ClearOverScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    if(DeviceUtil.isAndroid() || DeviceUtil.isFuchsia()){
      return child;
    }else{
      return super.buildOverscrollIndicator(context,child,details);
    }
  }
}
