import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs/app_config.dart';
import '../configs/key_config.dart';
import '../utils/view_util.dart';
import 'extra/application_controller.dart';

class WebViewActivityController extends BaseController {
  late ApplicationController applicationController;
  late AnimationController animationController;

  InAppWebViewController? inAppWebViewController;
  String? title;
  String? htmlData;
  String? url;

  bool isInitSuccess = false;
  int lineProgress = 0;

  final UserScript userScript = UserScript(
      groupName: "myUserScripts",
      source: """
                window.addEventListener('message', function(event) {
                    window.flutter_inappwebview.callHandler("myHandlerName", event.data)
                });
            """,
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START);

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    title = bundle?.getString(KeyConfig.web_view_title_key);
    htmlData = bundle?.getString(KeyConfig.web_view_html_data_key);
    url = bundle?.getString(KeyConfig.web_view_url_key);
    postFrameCallback((callback) async {});
  }

  void initAnimationController(TickerProvider tickerProvider) {
    animationController = AnimationController(
        vsync: tickerProvider, duration: Duration(seconds: 1));
    animationController.forward();
  }

  void initInAppWebViewController(InAppWebViewController controller) {
    inAppWebViewController = controller;
    controller.setSettings(settings: InAppWebViewSettings(
        allowFileAccessFromFileURLs: true,
        useHybridComposition: true,
        applicationNameForUserAgent: "app_embed",
        useShouldOverrideUrlLoading: true
    ));
  }

  void updateProgress(int value) {
    this.lineProgress = value;
    notifyListeners();
  }

  void doRefresh() {
    isInitSuccess = false;
    animationController.reset();
    animationController.forward();
    inAppWebViewController?.reload();
  }

  Future<void> launchURL(Uri? uri) async {
    List<String> supportSchemes = [
      "http",
      "https",
      "file",
      "chrome",
      "data",
      "javascript",
      "about"
    ];
    if (uri == null ||
        !supportSchemes.contains(uri.scheme.toLowerCase()) ||
        !await canLaunchUrl(uri)) {
      ViewUtil.showErrorToast(AppConfig.appS.web_view_activity_uri_error_tips + uri.toString());
      return;
    }
    await launchUrl(uri);
  }

  Future<bool> doBack() async {
    bool canBack = await inAppWebViewController?.canGoBack() ?? false;
    if (canBack) {
      inAppWebViewController?.goBack();
    } else {
      baseActivityState.finish();
    }
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
