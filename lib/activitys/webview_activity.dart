import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/log_util.dart';

import '../configs/assets_config.dart';
import '../controllers/webview_activity_controller.dart';
import '../resources/dimens.dart';
import '../resources/s_colors.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class WebViewActivity extends NewBaseActivity {
  WebViewActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => WebViewActivityState();
}

class WebViewActivityState extends NewBaseActivityState<WebViewActivity>
    with TickerProviderStateMixin {
  WebViewActivityController _controller = WebViewActivityController();

  @override
  BaseController initController() {
    _controller.initAnimationController(this);
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return NormalToolbarView(
      systemUiOverlayStyle: SystemUiOverlayStyle.light,
      showBack: true,
      backgroundColor: SColors.primary,
      contentColor: SColors.main_help,
      bodyColor: SColors.main_help,
      middle: _buildMiddleTitleView(),
      actions: _buildRightTitleView(),
      onBackClick: () {
        _controller.doBack();
      },
      body: _buildBodyView(),
    );
  }

  Widget _buildMiddleTitleView() {
    return NormalTextView(
        alignment: Alignment.center,
        content: _controller.title,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.main_help);
  }

  Widget _buildRightTitleView() {
    Widget contentView = Row(
      children: [
        DimenBoxs.hBoxNormal,
        RotationTransition(
          alignment: Alignment.center,
          turns: _controller.animationController,
          child: NormalImageView(
            useMaterial: false,
            assetUrl: AssetImageConfig.webview_refresh,
            width: Dimens.web_view_activity_menu_icon_width,
            height: Dimens.web_view_activity_menu_icon_width,
            onClick: () {
              _controller.doRefresh();
            },
          ),
        ),
        Container(
          child: Container(
            width: Dimens.line_normal,
            height: Dimens.web_view_activity_menu_icon_width,
            color: SColors.main_help,
          ),
          margin: EdgeInsets.symmetric(horizontal: Dimens.margin_normal),
        ),
        NormalImageView(
          useMaterial: false,
          assetUrl: AssetImageConfig.webview_close,
          width: Dimens.web_view_activity_menu_icon_width,
          height: Dimens.web_view_activity_menu_icon_width,
          onClick: () {
            finish();
          },
        ),
        DimenBoxs.hBoxNormal,
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.margin_normal,
          vertical: Dimens.margin_super_narrow),
      child: contentView,
      decoration: BoxDecoration(
        color: SColors.primary,
        borderRadius: BorderRadius.all(
            Radius.circular(Dimens.web_view_activity_menu_icon_width)),
      ),
    );
  }

  Widget _buildProgressBarView(int progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.transparent,
      value: progress == 1.0 ? 0 : progress / 100.0,
      valueColor: AlwaysStoppedAnimation<Color>(SColors.primary),
    );
  }

  Widget _buildBodyView() {
    bool isHaveHtmlData = _controller.htmlData != null;
    Widget contentView = InAppWebView(
      // initialOptions: InAppWebViewGroupOptions(),
      initialUserScripts:
      UnmodifiableListView<UserScript>([_controller.userScript]),
      initialUrlRequest: !isHaveHtmlData && _controller.url != null
          ? URLRequest(url: WebUri.uri(Uri.parse(_controller.url!)))
      // ? URLRequest(url: Uri.parse(_controller.url!))
          : null,
      initialData: isHaveHtmlData
          ? InAppWebViewInitialData(data: _controller.htmlData!)
          : null,
      onWebViewCreated: (InAppWebViewController controller) {
        _controller.initInAppWebViewController(controller);
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        _controller.updateProgress(progress);
      },
      onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        LogUtil.v('WebView log info: $consoleMessage');
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final String url = navigationAction.request.url.toString();
        if (url.contains('https://www.jhz.com')) {
          // 阻止跳转
          finish();
          return NavigationActionPolicy.CANCEL;
        } else {
          // 允许跳转
          return NavigationActionPolicy.ALLOW;
        }
      },
    );

    return Column(
      children: [
        PreferredSize(
          child: _buildProgressBarView(_controller.lineProgress, context),
          preferredSize: Size.fromHeight(Dimens.line_broad),
        ),
        Expanded(child: contentView)
      ],
    );
  }
}
