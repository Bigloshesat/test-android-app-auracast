import 'package:base_flutter/configs/assets_config.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:base_flutter/widgets/normal/normal_choose_list_view.dart';
import 'package:base_flutter/widgets/normal/normal_icon_view.dart';
import 'package:base_flutter/widgets/normal/normal_popup_route.dart';
import 'package:base_flutter/widgets/normal/normal_popup_view.dart';
import 'package:flutter/material.dart';
import 'package:framework/utils/toast_util.dart';

import '../widgets/normal/normal_text_view.dart';
import 'keyboard_util.dart';

class ViewUtil {

  static Widget getDefaultLine({Color color = SColors.line}) {
    return Divider(height: Dimens.line_narrow, color: color);
  }

  static Future<void> showBottomSheetView(
      BuildContext context, WidgetBuilder builder,
      {bool isScrollControlled = true,
      Color? backgroundColor,
      ShapeBorder? shape}) async {
    KeyBoardUtil.hideKeyboard(context);
    await showModalBottomSheet<bool>(
        context: context,
        builder: builder,
        clipBehavior: Clip.none,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        shape: shape);
  }

  // static Future<void> showVersionUpdateDialog(
  //     BuildContext context, String downloadUrl, String appId,
  //     {Widget? child,
  //     Color backgroundColor = Colors.transparent,
  //     bool jump = false,
  //     String? saveDirPath,
  //     bool needRequestPermission = false,
  //     bool canCancel = true,
  //     VoidCallback? onCancelClick,
  //     bool releaseFocus = true}) async {
  //   if (releaseFocus) {
  //     KeyBoardUtil.hideKeyboard(context);
  //   }
  //   double viewHeight = min(ScreenUtil.width, ScreenUtil.height);
  //   double viewWidth = viewHeight * 0.7;
  //   await showDialog(
  //     context: context,
  //     builder: (_) {
  //       Widget viewContent = VersionUpdateView(
  //         downloadUrl,
  //         appId: appId,
  //         child: child,
  //         width: viewWidth,
  //         height: viewHeight,
  //         backgroundColor: backgroundColor,
  //         jump: jump,
  //         saveDirPath: saveDirPath,
  //         needRequestPermission: needRequestPermission,
  //         decoration: ShapeDecoration(
  //           color: SColors.main_help,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(Dimens.radius_normal),
  //             ),
  //           ),
  //         ),
  //         canCancel: canCancel,
  //         onCancel: () {
  //           NavigatorUtil.pop(context, NavigatorResultType.CANCEL);
  //           onCancelClick?.call();
  //         },
  //         defaultBroadMargin: Dimens.margin_broad,
  //         defaultNarrowMargin: Dimens.margin_narrow,
  //         primary: SColors.primary,
  //         buttonRadius: Dimens.radius_normal,
  //         buttonHeight: Dimens.button_height_narrow,
  //         fontNarrow: Dimens.font_narrow,
  //         fontNormal: Dimens.font_normal,
  //         progressHeight: Dimens.version_update_view_progress_height,
  //         progressBackground: SColors.background,
  //         textContent: SColors.text_content,
  //         textHint: SColors.text_hint,
  //         versionUpdateViewCancelText: AppConfig.appS.cancel,
  //         versionUpdateViewUnInitText:
  //             AppConfig.appS.version_update_view_un_init_text,
  //         versionUpdateViewPermissionNotGrantedText:
  //             AppConfig.appS.version_update_view_permission_not_granted_text,
  //         versionUpdateViewDownloadingText:
  //             AppConfig.appS.version_update_view_downloading_text,
  //         versionUpdateViewDownloadErrorText:
  //             AppConfig.appS.version_update_view_download_error_text,
  //         versionUpdateViewDownloadSuccessText:
  //             AppConfig.appS.version_update_view_download_success_text,
  //         versionUpdateViewFindNewVersionTitle:
  //             AppConfig.appS.version_update_view_find_new_version_title,
  //         versionUpdateViewFindNewVersionTips:
  //             AppConfig.appS.version_update_view_find_new_version_tips,
  //         versionUpdateViewLaunchErrorText: AppConfig.appS.cancel,
  //       );
  //       return WillPopScope(
  //         onWillPop: () {
  //           return Future.value(canCancel);
  //         },
  //         child: viewContent,
  //       );
  //     },
  //   );
  // }

  static double getRenderedViewHeight(GlobalKey globalKey) {
    return globalKey.currentContext!.size!.height;
  }

  static double getRenderedViewWidth(GlobalKey globalKey) {
    return globalKey.currentContext!.size!.height;
  }

  static Offset getViewOffset(GlobalKey globalKey) {
    RenderBox renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  static void showListChooseRefreshPopupView<T>(
      BuildContext context, List<T> objects, IndexedWidgetBuilder builder,
      {double? width,
      double? height,
      String? title,
      VoidCallback? doRefresh,
      int maxShowItemCount = 5,
      double? itemHeight,
      double left = 0,
      double top = 0,
      BoxDecoration? decoration,
      Color background = Colors.white,
      bool releaseFocus = true}) {
    if (releaseFocus) {
      KeyBoardUtil.hideKeyboard(context);
    }
    Widget topView = Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: NormalTextView(
              margin: EdgeInsets.all(Dimens.margin_narrow),
              alignment: Alignment.center,
              content: title,
              fontSize: Dimens.font_normal,
              color: SColors.text_title),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.all(Dimens.margin_narrow),
            child: NormalIconView(
              icon: -1,
              iconData: Icons.refresh,
              width: Dimens.font_super_broad,
              height: Dimens.font_super_broad,
              onClick: doRefresh,
            ),
          ),
        ),
      ],
    );
    Widget chooseListView = NormalChooseListView<T>(
        objects: objects,
        useListView: false,
        builder: builder,
        maxShowItemCount: maxShowItemCount,
        itemHeight: itemHeight,
        showBorder: false);
    Widget contentView = NormalPopupView(
      left: left,
      top: top,
      child: Container(
          width: width,
          height: height,
          decoration: decoration ??
              BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(Dimens.radius_narrow),
              ),
          child: Column(
            children: [
              topView,
              getDefaultLine(),
              Expanded(
                child: chooseListView,
              )
            ],
          )),
    );
    Navigator.push(
      context,
      NormalPopupRoute(
        child: contentView,
      ),
    );
  }

  static BoxShadow getDefaultBoxShadow() {
    return BoxShadow(
        color: SColors.popup_view_shadow_background,
        blurRadius: Dimens.line_broad,
        spreadRadius: Dimens.line_broad);
  }

  static showErrorToast(String? content) {
    ToastUtil.showCenterShortToast(content,
        textColor: SColors.serious_waring_background);
  }
}
