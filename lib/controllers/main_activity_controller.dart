import 'dart:async';

import 'package:base_flutter/configs/app_config.dart';
import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/eventbus_manager.dart';
import 'package:framework/utils/toast_util.dart';

import '../configs/event_config.dart';
import '../configs/key_config.dart';
import '../configs/router_config.dart';
import '../resources/dimens.dart';
import '../resources/s_colors.dart';
import '../utils/navigator_util.dart';
import '../utils/view_util.dart';
import '../widgets/normal/normal_text_view.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

enum SearchStatus { INIT, SEARCHING, SUCCESS, EMPTY, CONNECTED }

class MainActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  Timer? countDownTimer;
  int timeDownCount = 0;
  SearchStatus searchStatus = SearchStatus.INIT;
  List<BluetoothInfo> bluetoothInfos = [];
  int? selectedIndex;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    postFrameCallback((callback) async {
      await startSearch();
    });
    EventBusManager().on(EventConfig.event_connect_response, (arg) {
      bool result = arg[KeyConfig.blue_bridge_connect_result_key];
      BluetoothInfo bluetoothInfo = arg[KeyConfig.blue_bridge_bluetooth_key];
      baseActivityState.baseDialogController?.hide();
      if (!result) {
        ToastUtil.showShortToast(AppConfig.appS.connect_failed);
        searchStatus = SearchStatus.EMPTY;
      } else {
        searchStatus = SearchStatus.CONNECTED;
        enterConnectedActivity(bluetoothInfo);
      }
      notifyListeners();
    });
  }

  Future<void> startSearch() async {
    searchStatus = SearchStatus.SEARCHING;
    countDownTimer?.cancel();
    timeDownCount = 0;
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeDownCount++;
      if (timeDownCount > 2) {
        timeDownCount = 0;
      }
      notifyListeners();
    });
    await bluetoothController.startDiscovery();
    notifyListeners();
  }

  String getSearchStatusTips() {
    String tips;
    switch (timeDownCount) {
      case 0:
        tips = ".";
        break;
      case 1:
        tips = "..";
        break;
      case 2:
      default:
        tips = "...";
        break;
    }
    return tips;
  }

  String getConnectStatusTips() {
    String tips;
    switch (searchStatus) {
      case SearchStatus.SEARCHING:
        tips = AppConfig.appS.searching + getSearchStatusTips();
        break;
      case SearchStatus.EMPTY:
        tips = "";
        break;
      case SearchStatus.SUCCESS:
        tips = "";
        break;
      case SearchStatus.CONNECTED:
        tips = AppConfig.appS.main_activity_connected_text;
        break;
      case SearchStatus.INIT:
      default:
        tips = "";
        break;
    }
    return tips;
  }


  void showBluetoothInfoList() {
    countDownTimer?.cancel();
    bluetoothInfos = bluetoothController.bluetoothInfos;
    if (bluetoothInfos.length == 0) {
      searchStatus = SearchStatus.EMPTY;
    } else {
      searchStatus = SearchStatus.SUCCESS;
    }
    notifyListeners();
  }

  Future<void> connectDevice(BluetoothInfo bluetoothInfo) async {
    baseActivityState.baseDialogController?.show(AppConfig.appS.waiting);
    await bluetoothController.disConnectBluetooth(null, clearAll: true);
    await Future.delayed(Duration(milliseconds: AppConfig.connectDialogDelay));
    bluetoothController.connectDevice(bluetoothInfo);
  }

  Future<void> enterConnectedActivity(BluetoothInfo bluetoothInfo) async {
    Bundle bundle = Bundle();
    bundle.putObject(KeyConfig.bluetooth_key, bluetoothInfo);
    NavigatorUtil.jumpTo(context, ActivityName.ConnectedActivity,
        bundle: bundle, dataCallback: (data) {});
  }

  @override
  void dispose() {
    super.dispose();
    countDownTimer?.cancel();
    EventBusManager().off(EventConfig.event_connect_response);
  }
}
