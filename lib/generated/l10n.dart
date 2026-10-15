// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `bt5`
  String get app_name {
    return Intl.message(
      'bt5',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `DONE`
  String get ok {
    return Intl.message(
      'DONE',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get cancel {
    return Intl.message(
      'CANCEL',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `SET`
  String get set {
    return Intl.message(
      'SET',
      name: 'set',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `CONFIRM`
  String get confirm {
    return Intl.message(
      'CONFIRM',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `ON`
  String get on {
    return Intl.message(
      'ON',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `OFF`
  String get off {
    return Intl.message(
      'OFF',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `Please waiting...`
  String get waiting {
    return Intl.message(
      'Please waiting...',
      name: 'waiting',
      desc: '',
      args: [],
    );
  }

  /// `TIP:`
  String get tip {
    return Intl.message(
      'TIP:',
      name: 'tip',
      desc: '',
      args: [],
    );
  }

  /// `Connect failed`
  String get connect_failed {
    return Intl.message(
      'Connect failed',
      name: 'connect_failed',
      desc: '',
      args: [],
    );
  }

  /// `KITCHEN`
  String get device_name_kitchen {
    return Intl.message(
      'KITCHEN',
      name: 'device_name_kitchen',
      desc: '',
      args: [],
    );
  }

  /// `BEDROOM`
  String get device_name_bedroom {
    return Intl.message(
      'BEDROOM',
      name: 'device_name_bedroom',
      desc: '',
      args: [],
    );
  }

  /// `BATHROOM`
  String get device_name_bathroom {
    return Intl.message(
      'BATHROOM',
      name: 'device_name_bathroom',
      desc: '',
      args: [],
    );
  }

  /// `ENSUITE`
  String get device_name_ensuite {
    return Intl.message(
      'ENSUITE',
      name: 'device_name_ensuite',
      desc: '',
      args: [],
    );
  }

  /// `LOUNGE`
  String get device_name_lounge {
    return Intl.message(
      'LOUNGE',
      name: 'device_name_lounge',
      desc: '',
      args: [],
    );
  }

  /// `DINING ROOM`
  String get device_name_dining_room {
    return Intl.message(
      'DINING ROOM',
      name: 'device_name_dining_room',
      desc: '',
      args: [],
    );
  }

  /// `GAMES ROOM`
  String get device_name_games_room {
    return Intl.message(
      'GAMES ROOM',
      name: 'device_name_games_room',
      desc: '',
      args: [],
    );
  }

  /// `OFFICE`
  String get device_name_office {
    return Intl.message(
      'OFFICE',
      name: 'device_name_office',
      desc: '',
      args: [],
    );
  }

  /// `FAMILY ROOM`
  String get device_name_family_room {
    return Intl.message(
      'FAMILY ROOM',
      name: 'device_name_family_room',
      desc: '',
      args: [],
    );
  }

  /// `LIBRARY`
  String get device_name_library {
    return Intl.message(
      'LIBRARY',
      name: 'device_name_library',
      desc: '',
      args: [],
    );
  }

  /// `GARDEN`
  String get device_name_garden {
    return Intl.message(
      'GARDEN',
      name: 'device_name_garden',
      desc: '',
      args: [],
    );
  }

  /// `HALLWAY`
  String get device_name_hallway {
    return Intl.message(
      'HALLWAY',
      name: 'device_name_hallway',
      desc: '',
      args: [],
    );
  }

  /// `GYM`
  String get device_name_GYM {
    return Intl.message(
      'GYM',
      name: 'device_name_GYM',
      desc: '',
      args: [],
    );
  }

  /// `MASTER BEDROOM`
  String get device_name_master_bedroom {
    return Intl.message(
      'MASTER BEDROOM',
      name: 'device_name_master_bedroom',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message(
      'OR',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `ENGLISH`
  String get language_name_english {
    return Intl.message(
      'ENGLISH',
      name: 'language_name_english',
      desc: '',
      args: [],
    );
  }

  /// `SPANISH`
  String get language_name_spanish {
    return Intl.message(
      'SPANISH',
      name: 'language_name_spanish',
      desc: '',
      args: [],
    );
  }

  /// `FRENCH`
  String get language_name_french {
    return Intl.message(
      'FRENCH',
      name: 'language_name_french',
      desc: '',
      args: [],
    );
  }

  /// `ITALIAN`
  String get language_name_italian {
    return Intl.message(
      'ITALIAN',
      name: 'language_name_italian',
      desc: '',
      args: [],
    );
  }

  /// `GERMAN`
  String get language_name_german {
    return Intl.message(
      'GERMAN',
      name: 'language_name_german',
      desc: '',
      args: [],
    );
  }

  /// `DUTCH`
  String get language_name_dutch {
    return Intl.message(
      'DUTCH',
      name: 'language_name_dutch',
      desc: '',
      args: [],
    );
  }

  /// `RUSSIAN`
  String get language_name_russian {
    return Intl.message(
      'RUSSIAN',
      name: 'language_name_russian',
      desc: '',
      args: [],
    );
  }

  /// `POLISH`
  String get language_name_polish {
    return Intl.message(
      'POLISH',
      name: 'language_name_polish',
      desc: '',
      args: [],
    );
  }

  /// `SWEDISH`
  String get language_name_swedish {
    return Intl.message(
      'SWEDISH',
      name: 'language_name_swedish',
      desc: '',
      args: [],
    );
  }

  /// `DANISH`
  String get language_name_danish {
    return Intl.message(
      'DANISH',
      name: 'language_name_danish',
      desc: '',
      args: [],
    );
  }

  /// `CHINESE`
  String get language_name_chinese {
    return Intl.message(
      'CHINESE',
      name: 'language_name_chinese',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get save {
    return Intl.message(
      'SAVE',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth`
  String get bluetooth_mode {
    return Intl.message(
      'Bluetooth',
      name: 'bluetooth_mode',
      desc: '',
      args: [],
    );
  }

  /// `RCA`
  String get bluetooth_mode_rca {
    return Intl.message(
      'RCA',
      name: 'bluetooth_mode_rca',
      desc: '',
      args: [],
    );
  }

  /// `AUX`
  String get bluetooth_mode_aux {
    return Intl.message(
      'AUX',
      name: 'bluetooth_mode_aux',
      desc: '',
      args: [],
    );
  }

  /// `Automatic`
  String get bluetooth_mode_automatic {
    return Intl.message(
      'Automatic',
      name: 'bluetooth_mode_automatic',
      desc: '',
      args: [],
    );
  }

  /// `CREATE YOUR OWN NAME`
  String get device_name_custom {
    return Intl.message(
      'CREATE YOUR OWN NAME',
      name: 'device_name_custom',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get search_result_list {
    return Intl.message(
      'Devices',
      name: 'search_result_list',
      desc: '',
      args: [],
    );
  }

  /// `Set admin password success`
  String get first_set_admin_password_success {
    return Intl.message(
      'Set admin password success',
      name: 'first_set_admin_password_success',
      desc: '',
      args: [],
    );
  }

  /// `Password length error`
  String get password_length_error {
    return Intl.message(
      'Password length error',
      name: 'password_length_error',
      desc: '',
      args: [],
    );
  }

  /// `Admin password error`
  String get admin_password_error {
    return Intl.message(
      'Admin password error',
      name: 'admin_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Launch failed`
  String get version_update_view_launch_error_text {
    return Intl.message(
      'Launch failed',
      name: 'version_update_view_launch_error_text',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get version_update_view_un_init_text {
    return Intl.message(
      'Update',
      name: 'version_update_view_un_init_text',
      desc: '',
      args: [],
    );
  }

  /// `Permission not granted`
  String get version_update_view_permission_not_granted_text {
    return Intl.message(
      'Permission not granted',
      name: 'version_update_view_permission_not_granted_text',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get version_update_view_downloading_text {
    return Intl.message(
      'Downloading...',
      name: 'version_update_view_downloading_text',
      desc: '',
      args: [],
    );
  }

  /// `Download error`
  String get version_update_view_download_error_text {
    return Intl.message(
      'Download error',
      name: 'version_update_view_download_error_text',
      desc: '',
      args: [],
    );
  }

  /// `Download success`
  String get version_update_view_download_success_text {
    return Intl.message(
      'Download success',
      name: 'version_update_view_download_success_text',
      desc: '',
      args: [],
    );
  }

  /// `Find new version`
  String get version_update_view_find_new_version_title {
    return Intl.message(
      'Find new version',
      name: 'version_update_view_find_new_version_title',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version_update_view_find_new_version_tips {
    return Intl.message(
      'Version',
      name: 'version_update_view_find_new_version_tips',
      desc: '',
      args: [],
    );
  }

  /// `ENTER ADMINISTRATION\n PASSWORD`
  String get dialog_administrator_password_title {
    return Intl.message(
      'ENTER ADMINISTRATION\n PASSWORD',
      name: 'dialog_administrator_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Please reboot device to make changes effective`
  String get dialog_reboot_tips {
    return Intl.message(
      'Please reboot device to make changes effective',
      name: 'dialog_reboot_tips',
      desc: '',
      args: [],
    );
  }

  /// `Prompt`
  String get dialog_reconnect_tips {
    return Intl.message(
      'Prompt',
      name: 'dialog_reconnect_tips',
      desc: '',
      args: [],
    );
  }

  /// `You need to restart the device`
  String get dialog_reconnect_hint {
    return Intl.message(
      'You need to restart the device',
      name: 'dialog_reconnect_hint',
      desc: '',
      args: [],
    );
  }

  /// `NEW NAME CONFIRMED:`
  String get dialog_update_device_name_title {
    return Intl.message(
      'NEW NAME CONFIRMED:',
      name: 'dialog_update_device_name_title',
      desc: '',
      args: [],
    );
  }

  /// `PIN CONFIRMED:`
  String get dialog_update_pin_code_title {
    return Intl.message(
      'PIN CONFIRMED:',
      name: 'dialog_update_pin_code_title',
      desc: '',
      args: [],
    );
  }

  /// `TAKE A SCREENSHOT OR\nSAVE YOUR NEW PIN IN YOUR\nPHONE’S NOTES`
  String get dialog_update_pin_code_tips {
    return Intl.message(
      'TAKE A SCREENSHOT OR\nSAVE YOUR NEW PIN IN YOUR\nPHONE’S NOTES',
      name: 'dialog_update_pin_code_tips',
      desc: '',
      args: [],
    );
  }

  /// `CHANGE NAME`
  String get dialog_update_speaker_button_text {
    return Intl.message(
      'CHANGE NAME',
      name: 'dialog_update_speaker_button_text',
      desc: '',
      args: [],
    );
  }

  /// `CHANGE PIN`
  String get dialog_update_pin_code_button_text {
    return Intl.message(
      'CHANGE PIN',
      name: 'dialog_update_pin_code_button_text',
      desc: '',
      args: [],
    );
  }

  /// `PIN UPDATE TO:`
  String get dialog_update_pin_success_title {
    return Intl.message(
      'PIN UPDATE TO:',
      name: 'dialog_update_pin_success_title',
      desc: '',
      args: [],
    );
  }

  /// `PASSWORD SET TO:`
  String get dialog_update_admin_success_title {
    return Intl.message(
      'PASSWORD SET TO:',
      name: 'dialog_update_admin_success_title',
      desc: '',
      args: [],
    );
  }

  /// `TAKE A SCREENSHOT OR\nSAVE YOUR PASSWORD IN YOUR\nPHONE‘S NOTES`
  String get dialog_update_admin_success_tips {
    return Intl.message(
      'TAKE A SCREENSHOT OR\nSAVE YOUR PASSWORD IN YOUR\nPHONE‘S NOTES',
      name: 'dialog_update_admin_success_tips',
      desc: '',
      args: [],
    );
  }

  /// `BLUETOOTH SETTINGS`
  String get dialog_bluetooth_settings_text {
    return Intl.message(
      'BLUETOOTH SETTINGS',
      name: 'dialog_bluetooth_settings_text',
      desc: '',
      args: [],
    );
  }

  /// `THE PIN WILL BE TURNED OFF`
  String get dialog_will_pin_off_title {
    return Intl.message(
      'THE PIN WILL BE TURNED OFF',
      name: 'dialog_will_pin_off_title',
      desc: '',
      args: [],
    );
  }

  /// `THE PIN HAS BEEN TURNED OFF`
  String get dialog_pin_off_title {
    return Intl.message(
      'THE PIN HAS BEEN TURNED OFF',
      name: 'dialog_pin_off_title',
      desc: '',
      args: [],
    );
  }

  /// `SEARCHING`
  String get main_activity_searching_text {
    return Intl.message(
      'SEARCHING',
      name: 'main_activity_searching_text',
      desc: '',
      args: [],
    );
  }

  /// `CONNECTED`
  String get main_activity_connected_text {
    return Intl.message(
      'CONNECTED',
      name: 'main_activity_connected_text',
      desc: '',
      args: [],
    );
  }

  /// `RENAME OR CHANGE PIN`
  String get manager_activity_menu_rename_or_change_pin {
    return Intl.message(
      'RENAME OR CHANGE PIN',
      name: 'manager_activity_menu_rename_or_change_pin',
      desc: '',
      args: [],
    );
  }

  /// `VOLUME CONTROL`
  String get manager_activity_menu_volume_control {
    return Intl.message(
      'VOLUME CONTROL',
      name: 'manager_activity_menu_volume_control',
      desc: '',
      args: [],
    );
  }

  /// `EQUALIZER`
  String get manager_activity_menu_equalizer {
    return Intl.message(
      'EQUALIZER',
      name: 'manager_activity_menu_equalizer',
      desc: '',
      args: [],
    );
  }

  /// `SET LANGUAGE`
  String get manager_activity_menu_set_language {
    return Intl.message(
      'SET LANGUAGE',
      name: 'manager_activity_menu_set_language',
      desc: '',
      args: [],
    );
  }

  /// `VISIT SUPPORT PORTAL`
  String get manager_activity_menu_visit_support_portal {
    return Intl.message(
      'VISIT SUPPORT PORTAL',
      name: 'manager_activity_menu_visit_support_portal',
      desc: '',
      args: [],
    );
  }

  /// `LITHE AUDIO WEBSITE`
  String get manager_activity_menu_lithe_audio_website {
    return Intl.message(
      'LITHE AUDIO WEBSITE',
      name: 'manager_activity_menu_lithe_audio_website',
      desc: '',
      args: [],
    );
  }

  /// `RATE SHARE APP`
  String get manager_activity_menu_rate_share_app {
    return Intl.message(
      'RATE SHARE APP',
      name: 'manager_activity_menu_rate_share_app',
      desc: '',
      args: [],
    );
  }

  /// `REGISTER YOUR PRODUCT`
  String get manager_activity_menu_register_your_product {
    return Intl.message(
      'REGISTER YOUR PRODUCT',
      name: 'manager_activity_menu_register_your_product',
      desc: '',
      args: [],
    );
  }

  /// `CONNECTED`
  String get connected_activity_connected_tips {
    return Intl.message(
      'CONNECTED',
      name: 'connected_activity_connected_tips',
      desc: '',
      args: [],
    );
  }

  /// `SELECT YOUR LANGUAGE`
  String get set_language_activity_tips {
    return Intl.message(
      'SELECT YOUR LANGUAGE',
      name: 'set_language_activity_tips',
      desc: '',
      args: [],
    );
  }

  /// `CHANGE OR REMOVE PIN`
  String get rename_or_change_pin_activity_menu_update_pin {
    return Intl.message(
      'CHANGE OR REMOVE PIN',
      name: 'rename_or_change_pin_activity_menu_update_pin',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE ADMIN PASSWORD`
  String get rename_or_change_pin_activity_menu_update_admin_password {
    return Intl.message(
      'UPDATE ADMIN PASSWORD',
      name: 'rename_or_change_pin_activity_menu_update_admin_password',
      desc: '',
      args: [],
    );
  }

  /// `PIN CODE`
  String get update_pin_activity_pin_status_text {
    return Intl.message(
      'PIN CODE',
      name: 'update_pin_activity_pin_status_text',
      desc: '',
      args: [],
    );
  }

  /// `SET YOUR PIN`
  String get update_pin_activity_pin_status_set_text {
    return Intl.message(
      'SET YOUR PIN',
      name: 'update_pin_activity_pin_status_set_text',
      desc: '',
      args: [],
    );
  }

  /// `SET PIN`
  String get update_pin_activity_pin_status_set_button_text {
    return Intl.message(
      'SET PIN',
      name: 'update_pin_activity_pin_status_set_button_text',
      desc: '',
      args: [],
    );
  }

  /// `SET ADMINISTRATION\nPASSWORD`
  String get update_admin_password_activity_title {
    return Intl.message(
      'SET ADMINISTRATION\nPASSWORD',
      name: 'update_admin_password_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `SET`
  String get update_admin_password_activity_set_text {
    return Intl.message(
      'SET',
      name: 'update_admin_password_activity_set_text',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get update_admin_password_activity_cancel_text {
    return Intl.message(
      'CANCEL',
      name: 'update_admin_password_activity_cancel_text',
      desc: '',
      args: [],
    );
  }

  /// `Prompt`
  String get update_pin_activity_confirm_title {
    return Intl.message(
      'Prompt',
      name: 'update_pin_activity_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to update PIN Code?`
  String get update_pin_activity_confirm_tips {
    return Intl.message(
      'Confirm to update PIN Code?',
      name: 'update_pin_activity_confirm_tips',
      desc: '',
      args: [],
    );
  }

  /// `TO CONNECT TO A\n AMAZON ALEXA OR GOOGLE HOME\nKEEP THE PIN CODE TURNED OFF`
  String get update_pin_activity_off_tips {
    return Intl.message(
      'TO CONNECT TO A\n AMAZON ALEXA OR GOOGLE HOME\nKEEP THE PIN CODE TURNED OFF',
      name: 'update_pin_activity_off_tips',
      desc: '',
      args: [],
    );
  }

  /// `Prompt`
  String get update_admin_password_activity_confirm_title {
    return Intl.message(
      'Prompt',
      name: 'update_admin_password_activity_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to update admin password?`
  String get update_admin_password_activity_confirm_tips {
    return Intl.message(
      'Confirm to update admin password?',
      name: 'update_admin_password_activity_confirm_tips',
      desc: '',
      args: [],
    );
  }

  /// `Change language success`
  String get set_language_activity_success_tips {
    return Intl.message(
      'Change language success',
      name: 'set_language_activity_success_tips',
      desc: '',
      args: [],
    );
  }

  /// `TRY AGAIN`
  String get wrong_password_tips_activity_button_text {
    return Intl.message(
      'TRY AGAIN',
      name: 'wrong_password_tips_activity_button_text',
      desc: '',
      args: [],
    );
  }

  /// `WRONG PASSWORD`
  String get wrong_password_tips_activity_tips {
    return Intl.message(
      'WRONG PASSWORD',
      name: 'wrong_password_tips_activity_tips',
      desc: '',
      args: [],
    );
  }

  /// `EQUALIZER`
  String get equalizer_activity_title {
    return Intl.message(
      'EQUALIZER',
      name: 'equalizer_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `CUSTOM EQ`
  String get equalizer_activity_custom_eq_mode_custom {
    return Intl.message(
      'CUSTOM EQ',
      name: 'equalizer_activity_custom_eq_mode_custom',
      desc: '',
      args: [],
    );
  }

  /// `CLASSICAL`
  String get equalizer_activity_custom_eq_mode_classical {
    return Intl.message(
      'CLASSICAL',
      name: 'equalizer_activity_custom_eq_mode_classical',
      desc: '',
      args: [],
    );
  }

  /// `LOUNGE`
  String get equalizer_activity_custom_eq_mode_lounge {
    return Intl.message(
      'LOUNGE',
      name: 'equalizer_activity_custom_eq_mode_lounge',
      desc: '',
      args: [],
    );
  }

  /// `DANCE`
  String get equalizer_activity_custom_eq_mode_dance {
    return Intl.message(
      'DANCE',
      name: 'equalizer_activity_custom_eq_mode_dance',
      desc: '',
      args: [],
    );
  }

  /// `JAZZ`
  String get equalizer_activity_custom_eq_mode_jazz {
    return Intl.message(
      'JAZZ',
      name: 'equalizer_activity_custom_eq_mode_jazz',
      desc: '',
      args: [],
    );
  }

  /// `HIP-HOP`
  String get equalizer_activity_custom_eq_mode_hip_hop {
    return Intl.message(
      'HIP-HOP',
      name: 'equalizer_activity_custom_eq_mode_hip_hop',
      desc: '',
      args: [],
    );
  }

  /// `ACOUSTIC`
  String get equalizer_activity_custom_eq_mode_acoustic {
    return Intl.message(
      'ACOUSTIC',
      name: 'equalizer_activity_custom_eq_mode_acoustic',
      desc: '',
      args: [],
    );
  }

  /// `ROCK`
  String get equalizer_activity_custom_eq_mode_rock {
    return Intl.message(
      'ROCK',
      name: 'equalizer_activity_custom_eq_mode_rock',
      desc: '',
      args: [],
    );
  }

  /// `LITHE-LINK`
  String get manager_activity_menu_lithe_link {
    return Intl.message(
      'LITHE-LINK',
      name: 'manager_activity_menu_lithe_link',
      desc: '',
      args: [],
    );
  }

  /// `QR CONNECT`
  String get manager_activity_menu_qr_connect {
    return Intl.message(
      'QR CONNECT',
      name: 'manager_activity_menu_qr_connect',
      desc: '',
      args: [],
    );
  }

  /// `AUTOMATIC MODE`
  String get speaker_mode_activity_bluetooth_mode_automatic {
    return Intl.message(
      'AUTOMATIC MODE',
      name: 'speaker_mode_activity_bluetooth_mode_automatic',
      desc: '',
      args: [],
    );
  }

  /// `BLUETOOTH ONLY`
  String get speaker_mode_activity_bluetooth_mode_bluetooth {
    return Intl.message(
      'BLUETOOTH ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_bluetooth',
      desc: '',
      args: [],
    );
  }

  /// `AUX ONLY`
  String get speaker_mode_activity_bluetooth_mode_aux {
    return Intl.message(
      'AUX ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_aux',
      desc: '',
      args: [],
    );
  }

  /// `OPTICAL ONLY`
  String get speaker_mode_activity_bluetooth_mode_optical {
    return Intl.message(
      'OPTICAL ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_optical',
      desc: '',
      args: [],
    );
  }

  /// `VOICE PROMPT`
  String get speaker_mode_activity_voice_prompt_text {
    return Intl.message(
      'VOICE PROMPT',
      name: 'speaker_mode_activity_voice_prompt_text',
      desc: '',
      args: [],
    );
  }

  /// `Enable or Disable\naudible notifications`
  String get speaker_mode_activity_voice_prompt_tips {
    return Intl.message(
      'Enable or Disable\naudible notifications',
      name: 'speaker_mode_activity_voice_prompt_tips',
      desc: '',
      args: [],
    );
  }

  /// `NOTE:`
  String get lithe_link_activity_note {
    return Intl.message(
      'NOTE:',
      name: 'lithe_link_activity_note',
      desc: '',
      args: [],
    );
  }

  /// `THE LITHE LINK WILL BE TURNED OFF`
  String get lithe_link_activity_will_lithe_link_off_title {
    return Intl.message(
      'THE LITHE LINK WILL BE TURNED OFF',
      name: 'lithe_link_activity_will_lithe_link_off_title',
      desc: '',
      args: [],
    );
  }

  /// `THE LITHE LINK HAS BEEN TURNED OFF`
  String get lithe_link_activity_lithe_link_off_title {
    return Intl.message(
      'THE LITHE LINK HAS BEEN TURNED OFF',
      name: 'lithe_link_activity_lithe_link_off_title',
      desc: '',
      args: [],
    );
  }

  /// `OPTICAL:CONNECTED`
  String get lithe_link_activity_lithe_connect_text {
    return Intl.message(
      'OPTICAL:CONNECTED',
      name: 'lithe_link_activity_lithe_connect_text',
      desc: '',
      args: [],
    );
  }

  /// `OPTICAL:DISCONNECTED`
  String get lithe_link_activity_lithe_disconnect_text {
    return Intl.message(
      'OPTICAL:DISCONNECTED',
      name: 'lithe_link_activity_lithe_disconnect_text',
      desc: '',
      args: [],
    );
  }

  /// `TO CONNECT TO\nGOOGLE HOME OR  AMAZON ALEXA\nKEEP THE EQ TURNED OFF`
  String get equalizer_activity_off_tips {
    return Intl.message(
      'TO CONNECT TO\nGOOGLE HOME OR  AMAZON ALEXA\nKEEP THE EQ TURNED OFF',
      name: 'equalizer_activity_off_tips',
      desc: '',
      args: [],
    );
  }

  /// `LECOVITA`
  String get splash_activity_lecovita_text {
    return Intl.message(
      'LECOVITA',
      name: 'splash_activity_lecovita_text',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get splash_activity_welcome_text {
    return Intl.message(
      'Welcome',
      name: 'splash_activity_welcome_text',
      desc: '',
      args: [],
    );
  }

  /// `SINCE 2018`
  String get splash_activity_since_text {
    return Intl.message(
      'SINCE 2018',
      name: 'splash_activity_since_text',
      desc: '',
      args: [],
    );
  }

  /// `INSTALL AUDO PIONEER`
  String get splash_activity_install_text {
    return Intl.message(
      'INSTALL AUDO PIONEER',
      name: 'splash_activity_install_text',
      desc: '',
      args: [],
    );
  }

  /// `ORIGIN DESIGNER`
  String get splash_activity_designer_text {
    return Intl.message(
      'ORIGIN DESIGNER',
      name: 'splash_activity_designer_text',
      desc: '',
      args: [],
    );
  }

  /// `PRO+ MANUFACTURER`
  String get splash_activity_pro_text {
    return Intl.message(
      'PRO+ MANUFACTURER',
      name: 'splash_activity_pro_text',
      desc: '',
      args: [],
    );
  }

  /// `BLUETOOTH`
  String get blue_tooth_text {
    return Intl.message(
      'BLUETOOTH',
      name: 'blue_tooth_text',
      desc: '',
      args: [],
    );
  }

  /// `SEARCHING`
  String get searching {
    return Intl.message(
      'SEARCHING',
      name: 'searching',
      desc: '',
      args: [],
    );
  }

  /// `Abnormal link address:`
  String get web_view_activity_uri_error_tips {
    return Intl.message(
      'Abnormal link address:',
      name: 'web_view_activity_uri_error_tips',
      desc: '',
      args: [],
    );
  }

  /// `SURE`
  String get sure {
    return Intl.message(
      'SURE',
      name: 'sure',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to switch the app language to %x`
  String get confirm_selected_language_dialog_content {
    return Intl.message(
      'Are you sure to switch the app language to %x',
      name: 'confirm_selected_language_dialog_content',
      desc: '',
      args: [],
    );
  }

  /// `PRODUCT INFORMATION`
  String get manager_activity_menu_product_information {
    return Intl.message(
      'PRODUCT INFORMATION',
      name: 'manager_activity_menu_product_information',
      desc: '',
      args: [],
    );
  }

  /// `STEREO`
  String get indicator_light_activity_sereo {
    return Intl.message(
      'STEREO',
      name: 'indicator_light_activity_sereo',
      desc: '',
      args: [],
    );
  }

  /// `MONO`
  String get indicator_light_activity_mono {
    return Intl.message(
      'MONO',
      name: 'indicator_light_activity_mono',
      desc: '',
      args: [],
    );
  }

  /// `WARM LIGHT`
  String get lighting_lamp_activity_style_warm_light_text {
    return Intl.message(
      'WARM LIGHT',
      name: 'lighting_lamp_activity_style_warm_light_text',
      desc: '',
      args: [],
    );
  }

  /// `COLD LIGHT`
  String get lighting_lamp_activity_style_cold_light_text {
    return Intl.message(
      'COLD LIGHT',
      name: 'lighting_lamp_activity_style_cold_light_text',
      desc: '',
      args: [],
    );
  }

  /// `DAY LIGHT`
  String get lighting_lamp_activity_style_day_light_text {
    return Intl.message(
      'DAY LIGHT',
      name: 'lighting_lamp_activity_style_day_light_text',
      desc: '',
      args: [],
    );
  }

  /// `CUSTOM COLOR`
  String get lighting_lamp_activity_custom_color_text {
    return Intl.message(
      'CUSTOM COLOR',
      name: 'lighting_lamp_activity_custom_color_text',
      desc: '',
      args: [],
    );
  }

  /// `PRODUCT MODEL`
  String get product_information_activity_product_model_text {
    return Intl.message(
      'PRODUCT MODEL',
      name: 'product_information_activity_product_model_text',
      desc: '',
      args: [],
    );
  }

  /// `BLUETOOTH NAME`
  String get product_information_activity_bluetooth_name_text {
    return Intl.message(
      'BLUETOOTH NAME',
      name: 'product_information_activity_bluetooth_name_text',
      desc: '',
      args: [],
    );
  }

  /// `FIRMWARE VERSION`
  String get product_information_activity_firmware_version_text {
    return Intl.message(
      'FIRMWARE VERSION',
      name: 'product_information_activity_firmware_version_text',
      desc: '',
      args: [],
    );
  }

  /// `HARDWARE VERSION`
  String get product_information_activity_hardware_version_text {
    return Intl.message(
      'HARDWARE VERSION',
      name: 'product_information_activity_hardware_version_text',
      desc: '',
      args: [],
    );
  }

  /// `APP VERSION NUMBER`
  String get product_information_activity_app_version_text {
    return Intl.message(
      'APP VERSION NUMBER',
      name: 'product_information_activity_app_version_text',
      desc: '',
      args: [],
    );
  }

  /// `VOCAL ENHANCE`
  String get equalizer_activity_custom_eq_mode_vocal {
    return Intl.message(
      'VOCAL ENHANCE',
      name: 'equalizer_activity_custom_eq_mode_vocal',
      desc: '',
      args: [],
    );
  }

  /// `WIFI ONLY`
  String get speaker_mode_activity_bluetooth_mode_wifi {
    return Intl.message(
      'WIFI ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_wifi',
      desc: '',
      args: [],
    );
  }

  /// `UDisk ONLY`
  String get speaker_mode_activity_bluetooth_mode_udisk {
    return Intl.message(
      'UDisk ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_udisk',
      desc: '',
      args: [],
    );
  }

  /// `HDMI ONLY`
  String get speaker_mode_activity_bluetooth_mode_hdmi {
    return Intl.message(
      'HDMI ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_hdmi',
      desc: '',
      args: [],
    );
  }

  /// `FM Radio ONLY`
  String get speaker_mode_activity_bluetooth_mode_fm {
    return Intl.message(
      'FM Radio ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_fm',
      desc: '',
      args: [],
    );
  }

  /// `SAME TRACK ONLY`
  String get speaker_mode_activity_bluetooth_mode_same_track {
    return Intl.message(
      'SAME TRACK ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_same_track',
      desc: '',
      args: [],
    );
  }

  /// `SETUP YOUR DEVICE`
  String get connected_activity_connected_setup_device_button_text {
    return Intl.message(
      'SETUP YOUR DEVICE',
      name: 'connected_activity_connected_setup_device_button_text',
      desc: '',
      args: [],
    );
  }

  /// `POPULAR`
  String get equalizer_activity_custom_eq_mode_pop {
    return Intl.message(
      'POPULAR',
      name: 'equalizer_activity_custom_eq_mode_pop',
      desc: '',
      args: [],
    );
  }

  /// `FLAT`
  String get equalizer_activity_custom_eq_mode_flat {
    return Intl.message(
      'FLAT',
      name: 'equalizer_activity_custom_eq_mode_flat',
      desc: '',
      args: [],
    );
  }

  /// `MUSIC SOURCE`
  String get manager_activity_menu_speaker_mode {
    return Intl.message(
      'MUSIC SOURCE',
      name: 'manager_activity_menu_speaker_mode',
      desc: '',
      args: [],
    );
  }

  /// `LINE IN ONLY`
  String get speaker_mode_activity_bluetooth_mode_rca {
    return Intl.message(
      'LINE IN ONLY',
      name: 'speaker_mode_activity_bluetooth_mode_rca',
      desc: '',
      args: [],
    );
  }

  /// `OTHER FUNCTION`
  String get manager_activity_menu_indicator_light {
    return Intl.message(
      'OTHER FUNCTION',
      name: 'manager_activity_menu_indicator_light',
      desc: '',
      args: [],
    );
  }

  /// `INDICATOR LIGHT`
  String get indicator_light_activity_indicator_light {
    return Intl.message(
      'INDICATOR LIGHT',
      name: 'indicator_light_activity_indicator_light',
      desc: '',
      args: [],
    );
  }

  /// `VOLUME LIMITER`
  String get indicator_light_activity_milit {
    return Intl.message(
      'VOLUME LIMITER',
      name: 'indicator_light_activity_milit',
      desc: '',
      args: [],
    );
  }

  /// `VOICE PROMPT`
  String get indicator_light_activity_voice_prompt {
    return Intl.message(
      'VOICE PROMPT',
      name: 'indicator_light_activity_voice_prompt',
      desc: '',
      args: [],
    );
  }

  /// `LIGHTING CONTROLLER`
  String get manager_activity_menu_lighting_lamp {
    return Intl.message(
      'LIGHTING CONTROLLER',
      name: 'manager_activity_menu_lighting_lamp',
      desc: '',
      args: [],
    );
  }

  /// `COLOUR TEMPERATURE`
  String get lighting_lamp_activity_title {
    return Intl.message(
      'COLOUR TEMPERATURE',
      name: 'lighting_lamp_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `DIMMER`
  String get lighting_lamp_activity_lamp_brightness_text {
    return Intl.message(
      'DIMMER',
      name: 'lighting_lamp_activity_lamp_brightness_text',
      desc: '',
      args: [],
    );
  }

  /// `PORTUGUESE`
  String get language_name_portuguese {
    return Intl.message(
      'PORTUGUESE',
      name: 'language_name_portuguese',
      desc: '',
      args: [],
    );
  }

  /// `JAPANESE`
  String get language_name_japanese {
    return Intl.message(
      'JAPANESE',
      name: 'language_name_japanese',
      desc: '',
      args: [],
    );
  }

  /// `Device Disconnected`
  String get disconnect_tips {
    return Intl.message(
      'Device Disconnected',
      name: 'disconnect_tips',
      desc: '',
      args: [],
    );
  }

  /// `DEVICE SETUP`
  String get manager_activity_title {
    return Intl.message(
      'DEVICE SETUP',
      name: 'manager_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `DEVICE NAME UPDATE TO:`
  String get dialog_update_rename_success_title {
    return Intl.message(
      'DEVICE NAME UPDATE TO:',
      name: 'dialog_update_rename_success_title',
      desc: '',
      args: [],
    );
  }

  /// `GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE\nTO USE THE NEW NAME`
  String get dialog_update_rename_success_tips {
    return Intl.message(
      'GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE\nTO USE THE NEW NAME',
      name: 'dialog_update_rename_success_tips',
      desc: '',
      args: [],
    );
  }

  /// `GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE\nTO USE THE NEW PIN`
  String get dialog_update_pin_success_tips {
    return Intl.message(
      'GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE\nTO USE THE NEW PIN',
      name: 'dialog_update_pin_success_tips',
      desc: '',
      args: [],
    );
  }

  /// `GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE`
  String get dialog_pin_off_tips {
    return Intl.message(
      'GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE',
      name: 'dialog_pin_off_tips',
      desc: '',
      args: [],
    );
  }

  /// `NO DEVICE\nFOUND`
  String get main_activity_search_not_found_text {
    return Intl.message(
      'NO DEVICE\nFOUND',
      name: 'main_activity_search_not_found_text',
      desc: '',
      args: [],
    );
  }

  /// `CONNECT TO\nDEVICE VIA\nBLUETOOTH\nTHEN RETURN\nTO APP TO\nSEARCH AGAIN`
  String get main_activity_search_not_found_tips_content {
    return Intl.message(
      'CONNECT TO\nDEVICE VIA\nBLUETOOTH\nTHEN RETURN\nTO APP TO\nSEARCH AGAIN',
      name: 'main_activity_search_not_found_tips_content',
      desc: '',
      args: [],
    );
  }

  /// `SETUP YOUR DEVICE`
  String get connected_activity_connected_setup_button_text {
    return Intl.message(
      'SETUP YOUR DEVICE',
      name: 'connected_activity_connected_setup_button_text',
      desc: '',
      args: [],
    );
  }

  /// `DEVICE CONNECTED`
  String get connected_activity_title {
    return Intl.message(
      'DEVICE CONNECTED',
      name: 'connected_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `RENAME YOUR DEVICE`
  String get rename_or_change_pin_activity_menu_rename {
    return Intl.message(
      'RENAME YOUR DEVICE',
      name: 'rename_or_change_pin_activity_menu_rename',
      desc: '',
      args: [],
    );
  }

  /// `SELECT A DEVICE NAME`
  String get rename_speaker_activity_tips {
    return Intl.message(
      'SELECT A DEVICE NAME',
      name: 'rename_speaker_activity_tips',
      desc: '',
      args: [],
    );
  }

  /// `DEVICE name length error`
  String get rename_speaker_activity_length_error {
    return Intl.message(
      'DEVICE name length error',
      name: 'rename_speaker_activity_length_error',
      desc: '',
      args: [],
    );
  }

  /// `DEVICE SETUP`
  String get rename_custom_speaker_activity_title {
    return Intl.message(
      'DEVICE SETUP',
      name: 'rename_custom_speaker_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `ENTER NEW NAME FOR YOUR DEVICE`
  String get rename_custom_speaker_activity_input_title {
    return Intl.message(
      'ENTER NEW NAME FOR YOUR DEVICE',
      name: 'rename_custom_speaker_activity_input_title',
      desc: '',
      args: [],
    );
  }

  /// `ENTER NEW DEVICE PIN`
  String get update_pin_activity_pin_set_pin_input_title {
    return Intl.message(
      'ENTER NEW DEVICE PIN',
      name: 'update_pin_activity_pin_set_pin_input_title',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE DEVICE NOW`
  String get dialog_update_pin_code_now_button_text {
    return Intl.message(
      'UPDATE DEVICE NOW',
      name: 'dialog_update_pin_code_now_button_text',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE DEVICE NOW`
  String get dialog_update_speaker_now_button_text {
    return Intl.message(
      'UPDATE DEVICE NOW',
      name: 'dialog_update_speaker_now_button_text',
      desc: '',
      args: [],
    );
  }

  /// `SELECT DEVICE MODE`
  String get speaker_mode_activity_bluetooth_select_tips {
    return Intl.message(
      'SELECT DEVICE MODE',
      name: 'speaker_mode_activity_bluetooth_select_tips',
      desc: '',
      args: [],
    );
  }

  /// `GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE`
  String get lithe_link_activity_lithe_link_off_tips {
    return Intl.message(
      'GO TO BLUETOOTH SETTING\n&RE-CONNECT THE DEVICE',
      name: 'lithe_link_activity_lithe_link_off_tips',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE DEVICE NOW`
  String get lithe_link_activity_lithe_link_now_button_text {
    return Intl.message(
      'UPDATE DEVICE NOW',
      name: 'lithe_link_activity_lithe_link_now_button_text',
      desc: '',
      args: [],
    );
  }

  /// `THIS FEATURE IS USED IF YOU HAVE 2 OR 3\nPAIRS LINKED VIA OPTICAL CABLE.\n\nTURN ON TO PLAY ALL\nDEVICES TOGETHER\n\nTURN OFF,AND EACH PAIR WILL\nPLAY INDEPENDENTLY`
  String get lithe_link_activity_tips {
    return Intl.message(
      'THIS FEATURE IS USED IF YOU HAVE 2 OR 3\nPAIRS LINKED VIA OPTICAL CABLE.\n\nTURN ON TO PLAY ALL\nDEVICES TOGETHER\n\nTURN OFF,AND EACH PAIR WILL\nPLAY INDEPENDENTLY',
      name: 'lithe_link_activity_tips',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get language_name_arabic {
    return Intl.message(
      'Arabic',
      name: 'language_name_arabic',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sv'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
