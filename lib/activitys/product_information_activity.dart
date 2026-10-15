import 'package:base_flutter/utils/view_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:framework/base/base_activity.dart';
import 'package:framework/base/controllers/base_controller.dart';

import '../configs/app_config.dart';
import '../controllers/product_information_activity_controller.dart';
import '../resources/dimens.dart';
import '../resources/s_colors.dart';
import '../widgets/normal/normal_text_view.dart';
import '../widgets/normal/normal_toolbar_view.dart';
import 'new_base_activity.dart';

class ProductInformationActivity extends NewBaseActivity {
  ProductInformationActivity(bundle) : super(bundle: bundle);

  @override
  BaseActivityState getState() => ProductInformationActivityState();
}

class ProductInformationActivityState extends NewBaseActivityState<ProductInformationActivity> {

  ProductInformationActivityController _controller = ProductInformationActivityController();

  @override
  BaseController initController() {
    return _controller;
  }

  @override
  Widget buildViews(BuildContext context) {
    return NormalToolbarView(
      showBack: true,
      showLeftTitle: true,
      backgroundColor: SColors.main_help,
      bodyColor: SColors.main_help,
      contentColor: SColors.text_title,
      middle: _buildMiddleTitleView(),
      middleFlex: 3,
      onBackClick: () {
        finish();
      },
      body: _buildBodyView(),
    );
  }

  Widget _buildMiddleTitleView() {
    return NormalTextView(
        alignment: Alignment.center,
        content: AppConfig.appS.manager_activity_menu_product_information,
        fontSize: Dimens.font_broad,
        fontWeight: FontWeight.w600,
        color: SColors.text_title);
  }

  Widget _buildBodyView() {
    Widget contentView =  Column(
      children: [
        DimenBoxs.vBox10,
        ViewUtil.getDefaultLine(),
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.product_information_activity_product_model_text,
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBox6,
        NormalTextView(
            content: _controller.getProductModel(),
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        ViewUtil.getDefaultLine(),
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.product_information_activity_bluetooth_name_text,
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBox6,
        NormalTextView(
            content: _controller.getBluetoothName(),
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        ViewUtil.getDefaultLine(),
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.product_information_activity_firmware_version_text,
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBox6,
        NormalTextView(
            content: _controller.getFirmwareVersion(),
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        ViewUtil.getDefaultLine(),
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.product_information_activity_hardware_version_text,
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBox6,
        NormalTextView(
            content: _controller.getHardwareVersion(),
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        ViewUtil.getDefaultLine(),
        DimenBoxs.vBoxNormal,
        NormalTextView(
            content: AppConfig.appS.product_information_activity_app_version_text,
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBox6,
        NormalTextView(
            content: _controller.getAppVersion(),
            fontSize: Dimens.font_narrow,
            color: SColors.text_content),
        DimenBoxs.vBoxNormal,
        ViewUtil.getDefaultLine(),
      ],
    );
    
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.margin_super_broad),
      child: contentView,
    );
  }
  
}