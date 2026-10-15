import 'package:base_flutter/activitys/connected_activity.dart';
import 'package:base_flutter/activitys/lithe_link_activity.dart';
import 'package:base_flutter/activitys/main_activity.dart';
import 'package:base_flutter/activitys/manager_activity.dart';
import 'package:base_flutter/activitys/speaker_mode_activity.dart';
import 'package:base_flutter/activitys/splash_activity.dart';
import 'package:base_flutter/activitys/wrong_password_tips_activity.dart';
import 'package:framework/utils/router_manager.dart';

import '../activitys/equalizer_activity.dart';
import '../activitys/indicator_light_activity.dart';
import '../activitys/lighting_lamp_activity.dart';
import '../activitys/product_information_activity.dart';
import '../activitys/rename_custom_speaker_activity.dart';
import '../activitys/rename_or_change_pin_activity.dart';
import '../activitys/rename_speaker_activity.dart';
import '../activitys/set_language_activity.dart';
import '../activitys/update_admin_password_activity.dart';
import '../activitys/update_pin_activity.dart';
import '../activitys/volume_control_activity.dart';
import '../activitys/webview_activity.dart';

enum ActivityName {
  SplashActivity,
  MainActivity,
  ManagerActivity,
  SetLanguageActivity,
  ConnectedActivity,
  WrongPasswordTipsActivity,
  RenameOrChangePinActivity,
  EqualizerActivity,
  LitheLinkActivity,
  SpeakerModeActivity,
  VolumeControlActivity,
  RenameSpeakerActivity,
  RenameCustomSpeakerActivity,
  UpdatePinActivity,
  UpdateAdminPasswordActivity,
  WebViewActivity,
  IndicatorLightActivity,
  LightingLampActivity,
  ProductInformationActivity
}

class FlutterRouterConfig {
  static Map<ActivityName, ActivityBuilder> activityRoutes = {
    ActivityName.SplashActivity:
        ActivityBuilder(builderFunction: (bundle) => SplashActivity()),
    ActivityName.MainActivity:
        ActivityBuilder(builderFunction: (bundle) => MainActivity(bundle)),
    ActivityName.ManagerActivity:
        ActivityBuilder(builderFunction: (bundle) => ManagerActivity(bundle)),
    ActivityName.SetLanguageActivity: ActivityBuilder(
        builderFunction: (bundle) => SetLanguageActivity(bundle)),
    ActivityName.ConnectedActivity:
        ActivityBuilder(builderFunction: (bundle) => ConnectedActivity(bundle)),
    ActivityName.WrongPasswordTipsActivity: ActivityBuilder(
        builderFunction: (bundle) => WrongPasswordTipsActivity(bundle)),
    ActivityName.RenameOrChangePinActivity: ActivityBuilder(
        builderFunction: (bundle) => RenameOrChangePinActivity(bundle)),
    ActivityName.LitheLinkActivity:
    ActivityBuilder(builderFunction: (bundle) => LitheLinkActivity(bundle)),
    ActivityName.SpeakerModeActivity:
    ActivityBuilder(builderFunction: (bundle) => SpeakerModeActivity(bundle)),
    ActivityName.EqualizerActivity:
        ActivityBuilder(builderFunction: (bundle) => EqualizerActivity(bundle)),
    ActivityName.VolumeControlActivity: ActivityBuilder(
        builderFunction: (bundle) => VolumeControlActivity(bundle)),
    ActivityName.RenameSpeakerActivity: ActivityBuilder(
        builderFunction: (bundle) => RenameSpeakerActivity(bundle)),
    ActivityName.RenameCustomSpeakerActivity: ActivityBuilder(
        builderFunction: (bundle) => RenameCustomSpeakerActivity(bundle)),
    ActivityName.UpdatePinActivity:
        ActivityBuilder(builderFunction: (bundle) => UpdatePinActivity(bundle)),
    ActivityName.UpdateAdminPasswordActivity: ActivityBuilder(
        builderFunction: (bundle) => UpdateAdminPasswordActivity(bundle)),
    ActivityName.WebViewActivity:
        ActivityBuilder(builderFunction: (bundle) => WebViewActivity(bundle)),
    ActivityName.IndicatorLightActivity:
      ActivityBuilder(builderFunction: (bundle) => IndicatorLightActivity(bundle)),
    ActivityName.LightingLampActivity:
      ActivityBuilder(builderFunction: (bundle) => LightingLampActivity(bundle)),
    ActivityName.ProductInformationActivity:
      ActivityBuilder(builderFunction: (bundle) => ProductInformationActivity(bundle)),
  };
}
