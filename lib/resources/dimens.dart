import 'package:flutter/widgets.dart';
import 'package:framework/utils/screen_util.dart';

class Dimens {
  static double s_target_width = 360;

  static double get target_width {
    return ScreenUtil.getSize(s_target_width);
  }

  static double get loading_dialog_width {
    return ScreenUtil.getSize(94);
  }

  static double get loading_dialog_height {
    return ScreenUtil.getSize(94);
  }

  static double get loading_dialog_indicator_width {
    return ScreenUtil.getSize(34);
  }

  static double get loading_dialog_indicator_half_width {
    return ScreenUtil.getSize(17);
  }

  static double get loading_dialog_radius {
    return ScreenUtil.getSize(6);
  }

  static double get margin_super_narrow {
    return ScreenUtil.getSize(4);
  }

  static double get margin_narrow {
    return ScreenUtil.getSize(8);
  }

  static double get margin_less_normal {
    return ScreenUtil.getSize(10);
  }

  static double get margin_normal {
    return ScreenUtil.getSize(12);
  }

  static double get margin_less_broad {
    return ScreenUtil.getSize(14);
  }

  static double get margin_broad {
    return ScreenUtil.getSize(16);
  }

  static double get margin_super_broad {
    return ScreenUtil.getSize(20);
  }

  static double get no_data_image_width {
    return ScreenUtil.getSize(166);
  }

  static double get no_data_image_height {
    return ScreenUtil.getSize(112);
  }

  static double get button_height_narrow {
    return ScreenUtil.getSize(30);
  }

  static double get button_height_normal {
    return ScreenUtil.getSize(35);
  }

  static double get button_height_board {
    return ScreenUtil.getSize(40);
  }

  static double get radius_super_narrow {
    return ScreenUtil.getSize(2);
  }

  static double get radius_narrow {
    return ScreenUtil.getSize(4);
  }

  static double get radius_normal {
    return ScreenUtil.getSize(6);
  }

  static double get radius_broad {
    return ScreenUtil.getSize(8);
  }

  static double get radius_super_broad {
    return ScreenUtil.getSize(10);
  }

  static double get line_narrow {
    return ScreenUtil.getSize(0.5, sizeType: SizeType.UnDo);
  }

  static double get line_normal {
    return ScreenUtil.getSize(1);
  }

  static double get line_broad {
    return ScreenUtil.getSize(2);
  }

  static double get font_min_narrow {
    return ScreenUtil.getSize(6);
  }

  static double get font_super_narrow {
    return ScreenUtil.getSize(8);
  }

  static double get font_more_narrow {
    return ScreenUtil.getSize(10);
  }

  static double get font_narrow {
    return ScreenUtil.getSize(12);
  }

  static double get font_normal {
    return ScreenUtil.getSize(14);
  }

  static double get font_broad {
    return ScreenUtil.getSize(16);
  }

  static double get font_more_broad {
    return ScreenUtil.getSize(18);
  }

  static double get font_super_broad {
    return ScreenUtil.getSize(20);
  }

  static double get font_max_broad {
    return ScreenUtil.getSize(22);
  }

  static double get font_success_dialog_content {
    return ScreenUtil.getSize(36);
  }

  static double get ponit_view_width_narrow {
    return ScreenUtil.getSize(3);
  }

  static double get ponit_view_width_normal {
    return ScreenUtil.getSize(6);
  }

  static double get ponit_view_width_broad {
    return ScreenUtil.getSize(9);
  }

  static double get normal_search_view_height {
    return ScreenUtil.getSize(32);
  }

  static double get normal_tab_view_height {
    return ScreenUtil.getSize(32);
  }

  static double get normal_toolbar_height {
    return ScreenUtil.getSize(32);
  }

  static double get normal_choose_list_view_item_height {
    return ScreenUtil.getSize(45);
  }

  static double get image_placeholder_width {
    return ScreenUtil.getSize(40);
  }

  static double get image_placeholder_height {
    return ScreenUtil.getSize(40);
  }

  static double get version_update_view_progress_height {
    return ScreenUtil.getSize(6);
  }

  static double get choose_type_color_tag_item_height {
    return ScreenUtil.getSize(60);
  }

  static double get splash_activity_splash_logo_width {
    return ScreenUtil.getSize(80);
  }

  static double get main_activity_bottom_logo_width {
    return ScreenUtil.getSize(80);
  }

  static double get main_activity_searching_logo_width {
    return ScreenUtil.getSize(76);
  }

  static double get manager_activity_bottom_logo_width {
    return ScreenUtil.getSize(100);
  }

  static double get bluetooth_logo_width {
    return ScreenUtil.getSize(100);
  }

  static double get connected_activity_bluetooth_logo_width {
    return ScreenUtil.getSize(70);
  }

  static double get webview_activity_menu_icon_width {
    return ScreenUtil.getSize(20);
  }

  static double get volume_control_view_height {
    return ScreenUtil.getSize(26);
  }

  static double get password_input_view_line_height {
    return ScreenUtil.getSize(40);
  }

  static double get volume_control_activity_play_width {
    return ScreenUtil.getSize(50);
  }

  static double get volume_control_view_padding {
    return ScreenUtil.getSize(160);
  }

  static double get volume_control_activity_prev_width {
    return ScreenUtil.getSize(50);
  }

  static double get volume_control_activity_next_width {
    return ScreenUtil.getSize(50);
  }

  static double get volume_control_view_width {
    return ScreenUtil.getSize(40);
  }

  static double get volume_control_view_line_height {
    return ScreenUtil.getSize(6);
  }

  static double get volume_control_view_space {
    return ScreenUtil.getSize(0);
  }

  static double get update_success_dialog_split_line_width {
    return ScreenUtil.getSize(100);
  }

  static double get touchable_line_chart_view_canvas_width {
    return ScreenUtil.getSize(280);
  }

  static double get touchable_line_chart_view_canvas_height {
    return ScreenUtil.getSize(160);
  }

  static double get touchable_line_chart_view_canvas_padding {
    return ScreenUtil.getSize(10);
  }

  static double get touchable_line_chart_view_point_radius {
    return ScreenUtil.getSize(7);
  }

  static double get touchable_line_chart_view_point_line_width {
    return ScreenUtil.getSize(8);
  }

  static double get touchable_line_chart_view_check_point_area {
    return ScreenUtil.getSize(20);
  }

  static double get equalizer_activity_volume_control_view_width {
    return ScreenUtil.getSize(50);
  }

  static double get splash_activity_welcome_text_size {
    return ScreenUtil.getSize(42);
  }

  static double get splash_activity_logo_width {
    return ScreenUtil.getSize(250);
  }

  static double get splash_activity_blue_tooth_width {
    return ScreenUtil.getSize(70);
  }

  static double get web_view_activity_menu_icon_width {
    return ScreenUtil.getSize(20);
  }

  static double get equalizer_button_height {
    return ScreenUtil.getSize(30);
  }

  static double get equalizer_button_icon_height {
    return ScreenUtil.getSize(20);
  }

  static double get volume_orientation_control_view_progress_height {
    return ScreenUtil.getSize(6);
  }

  static double get volume_control_slider_theme_shape_color_width {
    return ScreenUtil.getSize(9);
  }

  static double get volume_control_slider_theme_shape_color_height {
    return ScreenUtil.getSize(18);
  }

  static double get volume_control_sound_icon_width {
    return ScreenUtil.getSize(40);
  }


  static double get choose_type_color_tag_item_box_icon_width {
    return ScreenUtil.getSize(44);
  }

  static double get choose_type_color_tag_item_box_icon_small_width {
    return ScreenUtil.getSize(8);
  }
}

class DimenBoxs {
  static Widget get hBox2 {
    return Container(width: ScreenUtil.getSize(2));
  }

  static Widget get hBox4 {
    return Container(width: ScreenUtil.getSize(4));
  }

  static Widget get hBox6 {
    return Container(width: ScreenUtil.getSize(6));
  }

  static Widget get hBox8 {
    return Container(width: ScreenUtil.getSize(8));
  }

  static Widget get hBox10 {
    return Container(width: ScreenUtil.getSize(10));
  }

  static Widget get hBox12 {
    return Container(width: ScreenUtil.getSize(12));
  }

  static Widget get hBox14 {
    return Container(width: ScreenUtil.getSize(14));
  }

  static Widget get hBox16 {
    return Container(width: ScreenUtil.getSize(16));
  }

  static Widget get hBox18 {
    return Container(width: ScreenUtil.getSize(18));
  }

  static Widget get hBox20 {
    return Container(width: ScreenUtil.getSize(20));
  }

  static Widget get hBox22 {
    return Container(width: ScreenUtil.getSize(22));
  }

  static Widget get hBox24 {
    return Container(width: ScreenUtil.getSize(24));
  }

  static Widget get hBox26 {
    return Container(width: ScreenUtil.getSize(26));
  }

  static Widget get hBox28 {
    return Container(width: ScreenUtil.getSize(28));
  }

  static Widget get hBox30 {
    return Container(width: ScreenUtil.getSize(30));
  }

  static Widget get vBox2 {
    return Container(height: ScreenUtil.getSize(2));
  }

  static Widget get vBox4 {
    return Container(height: ScreenUtil.getSize(4));
  }

  static Widget get vBox6 {
    return Container(height: ScreenUtil.getSize(6));
  }

  static Widget get vBox8 {
    return Container(height: ScreenUtil.getSize(8));
  }

  static Widget get vBox10 {
    return Container(height: ScreenUtil.getSize(10));
  }

  static Widget get vBox12 {
    return Container(height: ScreenUtil.getSize(12));
  }

  static Widget get vBox14 {
    return Container(height: ScreenUtil.getSize(14));
  }

  static Widget get vBox16 {
    return Container(height: ScreenUtil.getSize(16));
  }

  static Widget get vBox18 {
    return Container(height: ScreenUtil.getSize(18));
  }

  static Widget get vBox20 {
    return Container(height: ScreenUtil.getSize(20));
  }

  static Widget get vBox22 {
    return Container(height: ScreenUtil.getSize(22));
  }

  static Widget get vBox24 {
    return Container(height: ScreenUtil.getSize(24));
  }

  static Widget get vBox26 {
    return Container(height: ScreenUtil.getSize(26));
  }

  static Widget get vBox28 {
    return Container(height: ScreenUtil.getSize(28));
  }

  static Widget get vBox30 {
    return Container(height: ScreenUtil.getSize(30));
  }

  static Widget get hBoxSuperNarrow {
    return Container(width: ScreenUtil.getSize(4));
  }

  static Widget get hBoxNarrow {
    return Container(width: ScreenUtil.getSize(8));
  }

  static Widget get hBoxNormal {
    return Container(width: ScreenUtil.getSize(12));
  }

  static Widget get hBoxBroad {
    return Container(width: ScreenUtil.getSize(16));
  }

  static Widget get hBoxSuperBroad {
    return Container(width: ScreenUtil.getSize(20));
  }

  static Widget get vBoxSuperNarrow {
    return Container(height: ScreenUtil.getSize(4));
  }

  static Widget get vBoxNarrow {
    return Container(height: ScreenUtil.getSize(8));
  }

  static Widget get vBoxNormal {
    return Container(height: ScreenUtil.getSize(12));
  }

  static Widget get vBoxBroad {
    return Container(height: ScreenUtil.getSize(16));
  }

  static Widget get vBoxSuperBroad {
    return Container(height: ScreenUtil.getSize(20));
  }
}
