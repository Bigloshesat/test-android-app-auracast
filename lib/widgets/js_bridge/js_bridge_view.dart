// /**
//  * @author snakeway
//  * @description:
//  * @date :2021/8/13
//  */
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// enum JsBridgeEvent {
//   ON_WEB_VIEW_CREATED,
//   ON_PAGE_STARTED,
//   ON_PAGE_FINISHED,
//   JS_SEND_MESSAGE
// }
//
// typedef JsBridgeEventCallback = void Function(JsBridgeEvent jsBridgeEvent,
//     bool isSuccess, String? messageKey, dynamic data);
// typedef ExecuteJavascriptCodeCallback = void Function(
//     bool isSuccess, String? messageKey, dynamic data);
//
// class JsBridgeView extends StatefulWidget {
//   final String url;
//   final bool showView;
//   final bool decodeMessageData;
//   final PageLoadingCallback? pageLoadingCallback;
//   final String? userAgent;
//   final List<String>? javaScriptChannels;
//   final JsBridgeEventCallback? jsBridgeEventCallback;
//   final String filePath;
//
//   JsBridgeView({
//     Key? key,
//     required this.url,
//     this.showView = true,
//     this.decodeMessageData = false,
//     this.pageLoadingCallback,
//     this.userAgent,
//     this.javaScriptChannels,
//     this.jsBridgeEventCallback,
//     this.filePath = "",
//   }) : super(key: key);
//
//   @override
//   JsBridgeViewState createState() => JsBridgeViewState();
// }
//
// class JsBridgeViewState extends State<JsBridgeView> {
//   WebViewController? _controller;
//   final List<JavascriptChannel> javascriptChannels = [];
//
//   @override
//   void initState() {
//     super.initState();
//     widget.javaScriptChannels?.forEach((item) {
//       if (item != "") {
//         javascriptChannels.add(getJavaScriptChannel(context, item));
//       }
//     });
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }
//
//   void executeJavascriptCode(String messageKey, String code,
//       ExecuteJavascriptCodeCallback executeJavascriptCodeCallback) {
//     _controller?.runJavascriptReturningResult(code).then((result) {
//       executeJavascriptCodeCallback.call(true, messageKey, result);
//     }, onError: (e) {
//       executeJavascriptCodeCallback.call(false, messageKey, e);
//     });
//   }
//
//   void reload() {
//     _controller?.reload();
//   }
//
//   Future<bool?> canGoBack() async {
//     return await _controller?.canGoBack();
//   }
//
//   Future<void> goBack() async {
//     await _controller?.goBack();
//   }
//
//   Future<void> goForward() async {
//     await _controller?.goForward();
//   }
//
//   void clearCache() {
//     _controller?.clearCache();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       userAgent: widget.userAgent,
//       initialUrl: widget.url,
//       javascriptMode: JavascriptMode.unrestricted,
//       onProgress: widget.pageLoadingCallback,
//       onWebViewCreated: (WebViewController webViewController) {
//         _controller = webViewController;
//         widget.jsBridgeEventCallback
//             ?.call(JsBridgeEvent.ON_WEB_VIEW_CREATED, true, null, null);
//         if (widget.filePath.isNotEmpty) {
//           _loadHtmlFromAssets(widget.filePath);
//         }
//       },
//       javascriptChannels: javascriptChannels.toSet(),
//       navigationDelegate: (NavigationRequest request) {
//         return NavigationDecision.navigate;
//       },
//       onPageStarted: (String url) {
//         widget.jsBridgeEventCallback
//             ?.call(JsBridgeEvent.ON_PAGE_STARTED, true, null, null);
//       },
//       onPageFinished: (String url) {
//         widget.jsBridgeEventCallback
//             ?.call(JsBridgeEvent.ON_PAGE_FINISHED, true, null, null);
//       },
//       gestureNavigationEnabled: true,
//     );
//   }
//
//   JavascriptChannel getJavaScriptChannel(
//       BuildContext context, String javaScriptChannelName) {
//     return JavascriptChannel(
//         name: javaScriptChannelName,
//         onMessageReceived: (JavascriptMessage message) {
//           print(message.message);
//           dynamic data;
//           String? messageKey;
//           try {
//             data = jsonDecode(message.message);
//             if (data != null) {
//               messageKey = data.messageKey;
//             }
//           } catch (e) {
//             print(e);
//           }
//           widget.jsBridgeEventCallback
//               ?.call(JsBridgeEvent.JS_SEND_MESSAGE, true, messageKey, data);
//         });
//   }
//
//   _loadHtmlFromAssets(String filePath) async {
//     String fileHtmlContents = await rootBundle.loadString(filePath);
//     _controller!.loadUrl(Uri.dataFromString(fileHtmlContents,
//             mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         .toString());
//   }
// }
