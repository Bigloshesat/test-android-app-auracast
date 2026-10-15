import 'dart:async';
import 'dart:math';

import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/bundle.dart';
import 'package:framework/base/controllers/base_controller.dart';
import 'package:framework/utils/eventbus_manager.dart';

import '../configs/blue_command_config.dart';
import '../configs/event_config.dart';
import '../configs/key_config.dart';
import 'extra/application_controller.dart';
import 'extra/bluetooth_controller.dart';

class VolumeControlActivityController extends BaseController {
  late ApplicationController applicationController;
  late BluetoothController bluetoothController;
  BluetoothInfo? bluetoothInfo;

  bool isPlaying = false;
  int volume = 0;
  int lastVolume = -1;

  //控制图片旋转
  final ValueNotifier<double> volumeCounter = ValueNotifier<double>(0);
  Timer? volumeTimer;

  //控制音量
  Timer? soundTimer;
  bool isSoundUp = true;

  @override
  void initController(State state, Bundle? bundle) {
    applicationController = ApplicationController.getInstance();
    bluetoothController = BluetoothController.getInstance();
    bluetoothInfo = bundle?.getObject(KeyConfig.bluetooth_key);
    getBluetoothStatusInfo();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      if (volume == 0) {
        //防止延时返回导致的重置,只在第一次进入(默认0)或者0时候执行checkPlayStatus
        await checkPlayStatus();
      }
    });

    EventBusManager().on(EventConfig.event_update_play_status, (arg) {
      getBluetoothStatusInfo();
      notifyListeners();
    });
  }

  void getBluetoothStatusInfo() {
    isPlaying = bluetoothController.isPlaying ?? false;
    volume = bluetoothController.volume ?? 0;
    if(isPlaying) playVolumeTimer();
    else cancelVolumeTimer();
  }

  void cancelVolumeTimer() {
    if((volumeTimer?.isActive ?? false)) {
      volumeCounter.value = 0;
      volumeTimer?.cancel();
    }
  }

  void playVolumeTimer() {
    if(!(volumeTimer?.isActive ?? false)) {
      volumeTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        volumeCounter.value += 0.01 * pi;
        if(volumeCounter.value == pi) volumeCounter.value = 0;
      });
    }
  }

  void playSoundTimer() {
    if(!(soundTimer?.isActive ?? false)) {
      soundTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
        if(lastVolume != volume) {
          lastVolume = volume;
          if(isSoundUp) {
            if(volume < 100) volume ++;
          } else {
            if(volume > 0) volume --;
          }
          bluetoothController.volume = this.volume;
          notifyListeners();
          BlueCommandConfig.changeVolume(this.volume);
        }
      });
    }
  }

  void cancelSoundTimer() {
    if((soundTimer?.isActive ?? false)) {
      soundTimer?.cancel();
      lastVolume = -1;
    }
  }

  String getDeviceName() {
    return bluetoothInfo?.device?.name ?? "";
  }

  Future<void> changeVolume(int volume) async {
    this.volume = volume;
    bluetoothController.volume = this.volume;
    await BlueCommandConfig.changeVolume(this.volume);
  }

  Future<void> checkPlayStatus() async {
    Map<String, dynamic> data = await bluetoothController.checkPlayStatus();
    isPlaying = data[KeyConfig.blue_bridge_is_playing_key];
    volume = data[KeyConfig.blue_bridge_volume_key];
    if(isPlaying) playVolumeTimer();
    else cancelVolumeTimer();
    notifyListeners();
  }

  Future<void> playMusic() async {
    this.isPlaying = !isPlaying;
    bluetoothController.isPlaying = this.isPlaying;
    if(isPlaying) playVolumeTimer();
    else cancelVolumeTimer();
    await BlueCommandConfig.playMusic();
    notifyListeners();
  }

  Future<void> prevMusic() async {
    await BlueCommandConfig.prevMusic();
  }

  Future<void> nextMusic() async {
    await BlueCommandConfig.nextMusic();
  }

  @override
  void dispose() {
    volumeCounter.dispose();
    cancelVolumeTimer();
    cancelSoundTimer();
    EventBusManager().off(EventConfig.event_update_play_status);
    super.dispose();
  }
}
