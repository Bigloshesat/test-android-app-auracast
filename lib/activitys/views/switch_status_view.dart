import 'package:base_flutter/widgets/normal/normal_text_view.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base_callback_function.dart';

import '../../configs/app_config.dart';
import '../../resources/dimens.dart';
import '../../resources/s_colors.dart';
import '../../widgets/normal/normal_icon_view.dart';

class SwitchStatusView extends StatefulWidget {
  final String? enableTitle;
  final String? unEnableTitle;
  final Color? backgroundColor;
  final Color? enableBackgroundColor;
  final Color? enableTextColor;
  final Color? unEnableTextColor;
  final double? fontSize;
  final VoidBoolCallback? onStatusChange;
  final bool isEnable;

  SwitchStatusView(
      {Key? key,
      this.enableTitle,
      this.unEnableTitle,
      this.backgroundColor,
      this.enableBackgroundColor,
      this.enableTextColor,
      this.unEnableTextColor,
      this.fontSize,
      this.onStatusChange,
      this.isEnable = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SwitchStatusViewState();
  }
}

class SwitchStatusViewState extends State<SwitchStatusView> {
  bool isEnable = false;

  void _updateValue() {
    isEnable = widget.isEnable;
  }

  @override
  void initState() {
    super.initState();
    _updateValue();
  }

  @override
  void didUpdateWidget(SwitchStatusView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void updateEnable(bool value) {
    if (isEnable != value) {
      isEnable = value;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentView();
  }

  Widget _buildContentView() {
    Widget contentView = isEnable ?
          equalizerOnButtonView()
        : equalizerOffButtonView();
    return GestureDetector(
      child: contentView,
      onTap: () {
        isEnable = !isEnable;
        widget.onStatusChange?.call(isEnable);
        setState(() {});
      },
    );
  }

  Widget equalizerOnButtonView() {
    Widget contentView = Row(
      children: [
        NormalTextView(
          content: AppConfig.appS.off,
          fontSize: Dimens.font_more_narrow,
          color: SColors.main_help,
        ),
        DimenBoxs.hBox8,
        Container(
          width: Dimens.equalizer_button_icon_height,
          height: Dimens.equalizer_button_icon_height,
          decoration: BoxDecoration(
              color: SColors.main_help,
              borderRadius: BorderRadius.circular(Dimens.equalizer_button_icon_height),
              border: Border.all(color: SColors.equalizer_button_border, width: Dimens.line_normal)
          ),
          child: NormalIconView(
            icon: -1,
            iconData: Icons.arrow_back_outlined,
            color: SColors.equalizer_button_icon,
          ),
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.only(right: Dimens.margin_narrow),
      padding: EdgeInsets.all(Dimens.margin_super_narrow),
      height: Dimens.equalizer_button_height,
      decoration: BoxDecoration(
          color: SColors.equalizer_button_on_background,
          borderRadius: BorderRadius.circular(Dimens.equalizer_button_height / 2),
          border: Border.all(color: SColors.equalizer_button_border, width: Dimens.line_normal)
      ),
      child: contentView,
    );
  }

  Widget equalizerOffButtonView() {
    Widget contentView = Row(
      children: [
        Container(
          width: Dimens.equalizer_button_icon_height,
          height: Dimens.equalizer_button_icon_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.equalizer_button_icon_height),
              border: Border.all(color: SColors.equalizer_button_border, width: Dimens.line_normal)
          ),
          child: NormalIconView(
            icon: -1,
            iconData: Icons.arrow_forward,
            color: SColors.equalizer_button_icon,
          ),
        ),
        DimenBoxs.hBox8,
        NormalTextView(
          content: AppConfig.appS.on,
          fontSize: Dimens.font_more_narrow,
          color: SColors.text_title,
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.only(right: Dimens.margin_narrow),
      padding: EdgeInsets.all(Dimens.margin_super_narrow),
      height: Dimens.equalizer_button_height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.equalizer_button_height / 2),
          border: Border.all(color: SColors.equalizer_button_border, width: Dimens.line_normal)
      ),
      child: contentView,
    );
  }

  // Widget _buildStatusView(bool isOn) {
  //   Color theEnableBackgroundColor = widget.enableBackgroundColor ??
  //       SColors.switch_status_view_enable_background;
  //   Color theUnEnableTextColor = widget.unEnableTextColor ?? SColors.text_title;
  //   Color theEnableTextColor = widget.enableTextColor ?? SColors.main_help;
  //   double theFontSize = widget.fontSize ?? Dimens.font_normal;
  //   Widget contentView = NormalTextView(
  //     margin: EdgeInsets.all(Dimens.margin_narrow),
  //     content: isOn ? widget.enableTitle : widget.unEnableTitle,
  //     color: isOn == isEnable ? theEnableTextColor : theUnEnableTextColor,
  //     fontSize: theFontSize,
  //   );
  //   return Container(
  //     margin: EdgeInsets.all(Dimens.margin_super_narrow),
  //     child: contentView,
  //     decoration: BoxDecoration(
  //       color: isOn == isEnable ? theEnableBackgroundColor : null,
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(Dimens.radius_narrow),
  //       ),
  //     ),
  //   );
  // }
}
