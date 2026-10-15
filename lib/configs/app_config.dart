import 'package:base_flutter/configs/response_config.dart';
import 'package:base_flutter/configs/router_config.dart';
import 'package:base_flutter/configs/url_config.dart';
import 'package:base_flutter/controllers/extra/application_controller.dart';
import 'package:base_flutter/generated/l10n.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:framework/utils/device_util.dart';
import 'package:framework/utils/log_util.dart';
import 'package:framework/utils/network/entity_factory.dart';
import 'package:framework/utils/network/http_manager.dart';
import 'package:framework/utils/router_manager.dart';
import 'package:framework/utils/screen_util.dart';
import 'package:framework/utils/shared_preferences_manager.dart';

import 'key_config.dart';

class AppConfig {
  static final GlobalKey<NavigatorState> navigatorStateKey =
      GlobalKey<NavigatorState>();

  static final int maxTextLines = 99999;

  static final int defaultCloseDialogDelay = 500;
  static final int connectDialogDelay = 1000;

  static final int sendTimeout = 30000;
  static final int connectTimeout = 30000;
  static final int receiveTimeout = 30000;

  static S get appS => S.of(navigatorStateKey.currentContext!);

  static bool isInit = false;

  static Future<bool> initBase() async {
    if (isInit) {
      return true;
    }
    isInit = true;
    AppConfig.initLog();
    AppConfig.initRoutes();
    await AppConfig.initSharedPreferences();
    ScreenUtil.init(Dimens.s_target_width,
        isDpi: true, screenTargetType: ScreenTargetType.UseMinFromWidthHeight);
    return true;
  }

  static Future<void> initApplication() async {
    ApplicationController applicationController =
        ApplicationController.getInstance();
    await applicationController.init();
  }

  static void initLog() {
    LogUtil.init(isDebug: DeviceUtil.isDebug());
  }

  static void initRoutes() {
    RouterManager().initRoutes(FlutterRouterConfig.activityRoutes);
  }

  static Future<void> initSharedPreferences() async {
    await SharedPreferencesManager().init();
  }

  static Future<void> initHttpManager(String version) async {
    Map<String, String> headers = {};
    headers["app-version"] = version;
    headers["os"] = DeviceUtil.osName();
    HttpManager().initDio(
      BaseOptions(
          baseUrl: DeviceUtil.isDebug()
              ? UrlConfig.debug_url
              : UrlConfig.release_url,
          sendTimeout: Duration(milliseconds: sendTimeout),
          connectTimeout: Duration(milliseconds: connectTimeout),
          receiveTimeout: Duration(milliseconds: receiveTimeout),
          followRedirects:true,
          contentType: "application/json; charset=utf-8",
          responseType: ResponseType.json,
          headers: headers),
    );
    HttpManager().addInterceptor(HeaderInterceptors());
    EntityFactory.registerConvertResponse(ResponseConfig.convertResponse);
  }
}

class HeaderInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? token =
        SharedPreferencesManager().getString(KeyConfig.sp_token_key);
    if (token != null) {
      options.headers["token"] = token;
    }
    super.onRequest(options, handler);
  }
}
