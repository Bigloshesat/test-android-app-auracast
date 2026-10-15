/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui show window;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/utils/router_manager.dart';

enum ScreenTargetType {
  UseMinFromWidthHeight,
  UseMaxFromWidthHeight,
  UseWidth,
  UseHeight,
  UnDo
}

enum SizeType { Floor, Round, Ceil, UnDo }

typedef ScreenChangeCallback = Function(
    bool isPortrait, double width, double height);

class ScreenUtil {
  static double _ratio = 1;

  static double? oldTargetWidth;
  static bool oldIsDpi = true;
  static ScreenTargetType oldScreenTargetType =
      ScreenTargetType.UseMinFromWidthHeight;
  static double? oldWidth;
  static double? oldHeight;

  static void init(double targetWidth,
      {bool isDpi = true,
      ScreenTargetType screenTargetType =
          ScreenTargetType.UseMinFromWidthHeight}) {
    oldTargetWidth = targetWidth;
    oldIsDpi = isDpi;
    oldScreenTargetType = screenTargetType;
    double screenWidth;
    switch (screenTargetType) {
      case ScreenTargetType.UseMinFromWidthHeight:
        screenWidth =
            isDpi ? min(width, height) : min(physicalWidth, physicalHeight);
        break;
      case ScreenTargetType.UseMaxFromWidthHeight:
        screenWidth =
            isDpi ? max(width, height) : max(physicalWidth, physicalHeight);
        break;
      case ScreenTargetType.UseWidth:
        screenWidth = isDpi ? width : physicalWidth;
        break;
      case ScreenTargetType.UseHeight:
        screenWidth = isDpi ? height : physicalHeight;
        break;
      case ScreenTargetType.UnDo:
      default:
        screenWidth = targetWidth;
        break;
    }
    _ratio = screenWidth / targetWidth;
  }

  static double getSize(double value, {SizeType sizeType = SizeType.Floor}) {
    double size = _ratio * value;
    switch (sizeType) {
      case SizeType.Floor:
        size = size.floorToDouble();
        break;
      case SizeType.Round:
        size = size.roundToDouble();
        break;
      case SizeType.Ceil:
        size = size.ceilToDouble();
        break;
      case SizeType.UnDo:
      default:
        break;
    }
    return size;
  }

  static double revertSize(double size) {
    return size / _ratio;
  }

  static double get width {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.width;
  }

  static double get height {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.height;
  }

  static double get getOnePx {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return 1 / mediaQuery.devicePixelRatio;
  }

  static double get physicalWidth {
    return ui.window.physicalSize.width;
  }

  static double get physicalHeight {
    return ui.window.physicalSize.height;
  }

  static double get scale {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.devicePixelRatio;
  }

  static double get textScaleFactor {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.textScaleFactor;
  }

  static double get navigationBarHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top + kToolbarHeight;
  }

  static double get topSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top;
  }

  static double get bottomSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.bottom;
  }

  static void updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static Widget buildScreenChangeRefreshWidget(
      Widget view, ScreenChangeCallback? screenChangeCallback) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if(width==oldWidth&&oldHeight==height){
          return view;
        }
        oldWidth=width;
        oldHeight=height;
        if (oldTargetWidth != null) {
          init(oldTargetWidth!,isDpi: oldIsDpi, screenTargetType: oldScreenTargetType);
          if (screenChangeCallback != null) {
            WidgetsBinding.instance?.addPostFrameCallback((callback) async {
              screenChangeCallback.call(
                  orientation == Orientation.portrait, width, height);
            });
          }
        }
        return view;
      },
    );
  }
}
