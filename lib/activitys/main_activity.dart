import 'package:base_flutter/configs/assets_config.dart';
import 'package:base_flutter/controllers/main_activity_controller.dart';
import 'package:base_flutter/resources/dimens.dart';
import 'package:base_flutter/resources/s_colors.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../widgets/normal/normal_choose_list_view.dart';
import '../widgets/normal/normal_icon_view.dart';
import '../widgets/normal/normal_image_view.dart';
import '../widgets/normal/normal_text_view.dart';
import 'new_base_activity.dart';

class MainActivity extends NewBaseActivity {
  MainActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => MainActivityState();
}

class MainActivityState extends NewBaseActivityState<MainActivity> {
  MainActivityController _controller = MainActivityController();

  @override
  BaseController initController() {
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return Scaffold(
        backgroundColor: SColors.main_help,
        body: _buildBodyView()
    );
  }

  Widget _buildBodyView() {
    return GestureDetector(
      child: _buildContentView(),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _controller.startSearch();
      },
    );
  }

  Widget _buildContentView() {
    return Column(
      children: [
        DimenBoxs.vBox30,
        DimenBoxs.vBox30,
        DimenBoxs.vBox30,
        Container(
          alignment: Alignment.center,
          child: NormalImageView(
            assetUrl: AssetImageConfig.logo,
            width: Dimens.splash_activity_logo_width,
            fit: BoxFit.fitWidth,
          ),
        ),
        DimenBoxs.vBox30,
        Expanded(child: Container(
          color: SColors.main_activity_blue_tooth_list_view,
          margin: EdgeInsets.symmetric(horizontal: Dimens.margin_super_narrow * 11),
          child: _buildBlueToothBottomView(),
        )),
      ],
    );
  }

  Widget _buildBlueToothBottomView() {
    return Container(
      child: Column(
        children: [
          DimenBoxs.vBox30,
          Container(
            alignment: Alignment.center,
            child: NormalImageView(
              assetUrl: AssetImageConfig.bluetooth1,
              height: Dimens.splash_activity_blue_tooth_width,
              fit: BoxFit.fitHeight,
            ),
          ),
          DimenBoxs.vBox10,
          NormalTextView(
            content: AppConfig.appS.blue_tooth_text,
            fontSize: Dimens.font_narrow,
            color: SColors.text_hint,
            height: Dimens.font_more_broad / Dimens.font_narrow,
          ),
          DimenBoxs.vBox10,
          if(_controller.searchStatus == SearchStatus.EMPTY)
            Expanded(child: _buildSearchNotFoundView()),
          if(_controller.searchStatus == SearchStatus.SEARCHING)
            Expanded(child: _buildSearchingView()),
          if(_controller.searchStatus == SearchStatus.SUCCESS)
            Expanded(child: _buildSuccessView()),
        ],
      ),
    );
  }

  Widget _buildSearchingView() {
    Widget contentView = Column(mainAxisSize: MainAxisSize.min, children: [
      NormalTextView(
        content: "${AppConfig.appS.searching}${_controller.getSearchStatusTips()}",
        fontSize: Dimens.font_more_narrow,
        height: Dimens.font_normal / Dimens.font_more_narrow,
        color: SColors.text_hint,
      )
    ]);
    return Container(
      child: contentView,
    );
  }


  Widget _buildSuccessView() {
    return Container(
      child: NormalChooseListView<BluetoothInfo>(
        objects: _controller.bluetoothInfos,
        useListView: false,
        itemHeight: Dimens.normal_choose_list_view_item_height,
        builder:  (BuildContext context, int index) {
          BluetoothInfo bluetoothInfo = _controller.bluetoothInfos[index];
          Widget contentView = Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimens.margin_normal
            ),
            width: double.infinity,
            child: NormalTextView(
                alignment: Alignment.center,
                content: bluetoothInfo.device?.name,
                fontSize: Dimens.font_broad,
                height: Dimens.font_narrow * 2 / Dimens.font_broad,
                margin: EdgeInsets.all(Dimens.margin_super_narrow),
                color: SColors.text_hint),
            decoration: BoxDecoration(
              color: SColors.main_activity_blue_tooth_list_view_item_background,
              border: Border(bottom: BorderSide(color: SColors.primary, width: Dimens.line_normal))
              // color: index == _controller.selectedIndex ?
              //     SColors.main_activity_blue_tooth_list_view_item_background :
              //     null
            ),
          );
          return GestureDetector(
            child: contentView,
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              setState(() {
                _controller.selectedIndex = index;
              });
              await _controller.connectDevice(bluetoothInfo);
            },
          );
        },
        showBorder: false
      )
    );
  }

  Widget _buildSearchNotFoundView() {
    Widget contentView = Column(mainAxisSize: MainAxisSize.min, children: [
      NormalTextView(
          content: AppConfig.appS.main_activity_search_not_found_text,
          fontSize: Dimens.font_narrow,
          maxLines: AppConfig.maxTextLines,
          textAlign: TextAlign.center,
          color: SColors.text_hint),
      DimenBoxs.vBoxBroad,
      NormalTextView(
          content: AppConfig.appS.tip,
          fontSize: Dimens.font_narrow,
          color: SColors.text_hint),
      NormalTextView(
          content: AppConfig.appS.main_activity_search_not_found_tips_content,
          fontSize: Dimens.font_narrow,
          maxLines: AppConfig.maxTextLines,
          textAlign: TextAlign.center,
          color: SColors.text_hint),
    ]);
    return Container(
      child: contentView,
    );
  }

}
