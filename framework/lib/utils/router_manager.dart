/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:fluro/fluro.dart' as FRouter;
import 'package:flutter/cupertino.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/utils/exception_util.dart';
import 'package:framework/utils/toast_util.dart';

import 'log_util.dart';

typedef Widget BuilderFunction(Bundle? bundle);

typedef Widget HandlerFunction(
    BuildContext context, Map<String, List<String>> parameters);

class RouterManager {
  static RouterManager? _routerManager;

  Map<dynamic, ActivityBuilder>? _activityRoutes;
  FRouter.FluroRouter _router = FRouter.FluroRouter();
  RouteHistory routeHistory = RouteHistory();
  late RouteRecorder routeRecorder = RouteRecorder(routeHistory);

  RouterManager._internal();

  factory RouterManager() => _routerManager ??= RouterManager._internal();

  Map<dynamic, ActivityBuilder>? get activityRoutes => _activityRoutes;

  FRouter.FluroRouter get router => _router;

  void initRoutes(Map<dynamic, ActivityBuilder> activityRoutes) {
    _activityRoutes = activityRoutes;
    _router.notFoundHandler = FRouter.Handler(handlerFunc:
        (BuildContext? context, Map<String, List<String>> parameters) {
      LogUtil.e("route is not find !");
      return;
    });
    Map<String, ActivityBuilder> theActivityRoutes =
        _activityRoutes!.map((k, v) => MapEntry("/" + k.toString(), v));
    theActivityRoutes.forEach((path, builder) {
      _router.define(path,
          handler: builder.getHandler(),
          transitionType: builder.transitionType);
    });
  }
}

class ActivityBuilder {
  BuilderFunction builderFunction;
  FRouter.TransitionType transitionType;

  ActivityBuilder(
      {required this.builderFunction,
      this.transitionType = FRouter.TransitionType.inFromRight});

  FRouter.Handler getHandler() {
    return FRouter.Handler(handlerFunc: (context, _) {
      Object? object = ModalRoute.of(context!)?.settings.arguments;
      Bundle? bundle;
      if (object != null && object is Bundle) {
        bundle = object;
      }
      return this.builderFunction(bundle);
    });
  }
}

class RouteHistory with ChangeNotifier {
  final List<Route<dynamic>> history = [];

  void add(Route<dynamic>? route) {
    if (route == null) {
      return;
    }
    history.add(route);
    notifyListeners();
  }

  void remove(Route<dynamic>? route) {
    if (route == null) {
      return;
    }
    history.remove(route);
    notifyListeners();
  }

  Route<dynamic>? filter(bool Function(dynamic) isMatch) {
    try {
      return history.firstWhere((element) => isMatch(element));
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
      return null;
    }
  }

  bool isActive(String routeSettingName) {
    return filter((route) => route.settings.name == routeSettingName)
            ?.isActive ??
        false;
  }

  bool hasRoute(RoutePredicate predicate) {
    return history.any((e) => predicate(e));
  }

  bool hasActiveRoute(RoutePredicate predicate) {
    return history.any((e) => predicate(e) && e.isActive);
  }

  void removeRoute<T>(RoutePredicate predicate, [T? result]) {
    List.of(history.where((e) => predicate(e))).forEach((route) {
      if (result != null) {
        route.didPop(result);
      }
      route.navigator?.removeRoute(route);
    });
  }

  void popUntil(RoutePredicate predicate,
      {required dynamic Function(Route) popResult}) {
    while (history.isNotEmpty && !predicate(history.last)) {
      history.last.navigator?.pop(popResult.call(history.last));
    }
  }

  void checkDispose() {
    List.of(history.where((element) => !element.isActive)).forEach((element) {
      history.remove(element);
    });
    if (LogUtil.DEBUG) {
      String page = "";
      history.forEach((element) {
        page = page + (element.settings.name ?? "");
      });
      LogUtil.v("route length:" + history.length.toString() + "  " + page);
    }
  }
}

class RouteRecorder extends NavigatorObserver {
  final RouteHistory history;

  RouteRecorder(this.history);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.add(route);
    history.checkDispose();
  }

  @override
  void didStopUserGesture() {}

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    history.remove(oldRoute);
    history.add(newRoute);
    history.checkDispose();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.remove(route);
    history.checkDispose();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.remove(route);
    history.checkDispose();
  }
}
