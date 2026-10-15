/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'dart:ui';

import 'package:flutter/material.dart';

import '../bundle.dart';

abstract class BaseViewController with ChangeNotifier {
  final List<dynamic> coverObjects = [];
  final List<dynamic> cacheObjects = [];

  bool _disposed = false;

  late BuildContext context;
  late State state;
  late String key;

  BaseViewController();

  void initController(State state, Bundle? bundle);

  void putCoverObject(dynamic coverObject) {
    if (coverObject == null) {
      return;
    }
    coverObjects.add(coverObject);
  }

  void removeCoverObject(dynamic coverObject) {
    if (coverObject == null) {
      return;
    }
    coverObjects.remove(coverObject);
  }

  bool isHaveCoverObject() {
    return coverObjects.length > 0;
  }

  void putCacheObject(dynamic cacheObject) {
    if (cacheObject == null) {
      return;
    }
    cacheObjects.add(cacheObject);
  }

  void removeCacheObject(dynamic cacheObject) {
    if (cacheObject == null) {
      return;
    }
    cacheObjects.remove(cacheObject);
  }

  bool isHaveCacheObject() {
    return cacheObjects.length > 0;
  }

  void postFrameCallback(FrameCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
