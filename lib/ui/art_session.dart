import 'dart:async';
import 'dart:io';

import 'package:bluebridge/bluebridge_library.dart';
import 'package:flutter/material.dart';
import 'package:framework/utils/eventbus_manager.dart';

import '../configs/blue_command_config.dart';
import '../configs/event_config.dart';
import '../configs/key_config.dart';
import '../controllers/equalizer_activity_controller.dart';
import '../controllers/extra/bluetooth_controller.dart';
import '../utils/language_util.dart';

enum ArtScreen {
  welcome,
  bluetoothAccess,
  findSpeakers,
  noSpeakers,
  connecting,
  setAdmin,
  adminSaved,
  devices,
  control,
  audioSource,
  equalizer,
  settings,
  rename,
  audioSettings,
  security,
  verifyAdmin,
  changeAdmin,
  changePin,
  pinOffConfirm,
  pinOffSuccess,
  pinUpdated,
  renameSaved,
  productInfo,
  language,
  connectionLost,
  saveFailed,
  broadcast,
}

enum ArtGuard { name, audio, security, pin, admin }

enum ArtPinField { adminNew, adminConfirm, verify, pinNew, changeNew, changeConfirm }

class ArtInput {
  const ArtInput(this.id, this.label);
  final int id;
  final String label;
}

const List<ArtInput> artInputs = [
  ArtInput(4, 'Optical'),
  ArtInput(7, 'HDMI ARC'),
  ArtInput(6, 'USB'),
  ArtInput(1, 'Line in'),
  ArtInput(0, 'Bluetooth'),
  ArtInput(5, 'Wi-Fi'),
];

class ArtLanguage {
  const ArtLanguage(this.code, this.label);

  final String code;
  final String label;
}

const List<ArtLanguage> artLanguages = [
  ArtLanguage('en', 'English'),
  ArtLanguage('es', 'Español'),
  ArtLanguage('fr', 'Français'),
  ArtLanguage('it', 'Italiano'),
  ArtLanguage('de', 'Deutsch'),
  ArtLanguage('nl', 'Nederlands'),
  ArtLanguage('ru', 'Русский'),
  ArtLanguage('pl', 'Polski'),
  ArtLanguage('sv', 'Svenska'),
  ArtLanguage('da', 'Dansk'),
  ArtLanguage('zh', '简体中文'),
];

const List<String> artQuickNames = [
  'Living room',
  'Kitchen',
  'Bedroom',
  'Office',
  'Garden',
  'Other',
];

class ArtSession extends ChangeNotifier {
  ArtSession(this.bt) {
    bt.addListener(_onBluetooth);
    EventBusManager().on(EventConfig.event_connect_response, _onConnectEvent);
    EventBusManager().on(EventConfig.event_update_play_status, _onDeviceStatus);
    EventBusManager().on(EventConfig.event_update_equalizer_status, _onDeviceStatus);
    EventBusManager().on(EventConfig.event_update_auracast_hosts, _onAuracastHosts);
  }

  final BluetoothController bt;

  int tab = 0;
  final List<List<ArtScreen>> stacks = [
    [ArtScreen.welcome],
    [ArtScreen.control],
    [ArtScreen.settings],
    [ArtScreen.broadcast],
  ];

  ArtScreen get screen => stacks[tab].last;

  bool get showTabs => stacks[tab].length == 1 && _isTabRoot(screen);

  bool _isTabRoot(ArtScreen value) {
    return value == ArtScreen.welcome ||
        value == ArtScreen.devices ||
        value == ArtScreen.control ||
        value == ArtScreen.settings ||
        value == ArtScreen.broadcast;
  }

  ArtScreen _tabRoot(int index) {
    if (index == 1) return ArtScreen.control;
    if (index == 2) return ArtScreen.settings;
    if (index == 3) return ArtScreen.broadcast;
    if (sessionConnected || connectedInfo != null) return ArtScreen.devices;
    return ArtScreen.welcome;
  }

  bool searching = false;
  bool connecting = false;
  bool busy = false;
  bool sessionConnected = false;
  bool setupDone = false;
  bool adminVerified = false;
  bool discardDialog = false;
  bool userDisconnect = false;
  bool verifyError = false;
  bool connectFailed = false;
  bool adminSaveError = false;
  bool productLoading = false;
  bool productFailed = false;
  bool audioLoaded = false;
  bool draggingVolume = false;
  bool draggingAudioLimit = false;

  /// Auracast (BP1048) broadcast host scan / select.
  bool auracastScanning = false;
  bool auracastBusy = false;
  String? auracastError;
  String? auracastSelectedKey;

  String adminNew = '';
  String adminConfirm = '';
  String verifyPin = '';
  String connectionPin = '';
  String savedConnectionPin = '';
  bool pinRebootHold = false;
  bool linkDropped = false;
  String changeAdminNew = '';
  String changeAdminConfirm = '';
  String renameDraft = '';
  String savedName = '';
  String? errorLine;
  String? chosenLanguage;
  bool volumeUpdating = false;
  bool volumeFailed = false;
  bool eqUpdating = false;
  bool eqFailed = false;
  bool? _eqRetryOn;
  EqualizerType? _eqRetryPreset;
  List<int>? _eqRetryBands;
  ArtGuard guard = ArtGuard.name;
  ArtPinField? keypad;

  final List<BluetoothInfo> found = [];
  final Map<String, String> names = {};
  BluetoothInfo? target;
  int _searchGen = 0;
  int _connectGen = 0;
  Timer? _volumeTimer;
  Timer? _eqTimer;
  Timer? _connectTimer;
  bool _customSent = false;

  bool get ready =>
      sessionConnected && bt.bluetoothConnectInfos.isNotEmpty && setupDone;

  bool get renameDirty => renameDraft.trim() != savedName;

  /// BLE limiter type → UI percent (kele-bluetooth-app2 / indicator_light).
  static int limitPercentForType(int type) {
    switch (type) {
      case 0:
        return 100;
      case 1:
        return 25;
      case 2:
        return 50;
      case 3:
        return 75;
      default:
        return 100;
    }
  }

  /// UI percent (25 / 50 / 75 / 100) → BLE limiter type (app2 KeyValue.value).
  static int typeForLimitPercent(int percent) {
    switch (percent) {
      case 25:
        return 1;
      case 50:
        return 2;
      case 75:
        return 3;
      case 100:
        return 0;
      default:
        final idx = ((percent - 25) / 25).round().clamp(0, 3);
        return const [1, 2, 3, 0][idx];
    }
  }

  /// Audio-settings slider tier → type (75% → 3 → payload 0x03), same as app2.
  static int limitTypeForAudioSlider(double sliderValue) =>
      typeForLimitPercent(sliderValue.round());

  int? get limitPercent {
    if (bt.volumeLimit < 0 || bt.volumeLimit > 3) return null;
    return limitPercentForType(bt.volumeLimit);
  }

  bool get inputsLoaded => bt.isInitPlayStatus || bt.playStatusList.isNotEmpty;

  bool get bandsLoaded => bt.equalizerValues.length == 6;

  BluetoothInfo? get connectedInfo => bt.bluetoothConnectInfos.isNotEmpty
      ? bt.bluetoothConnectInfos.first
      : null;

  String nameOf(BluetoothInfo? info) {
    final mac = info?.device?.address ?? '';
    final custom = names[mac];
    if (custom != null && custom.isNotEmpty) return custom;
    final advertised = info?.device?.name ?? '';
    if (advertised.isEmpty) return 'ArtSound';
    return advertised;
  }

  String get speakerName => nameOf(connectedInfo ?? target);

  String languageName() {
    final code = LanguageUtil.getSelectLanguageLocale().languageCode;
    for (final item in artLanguages) {
      if (item.code == code) return item.label;
    }
    return 'English';
  }

  String inputLabel() {
    switch (bt.selectMode) {
      case '0':
        return 'Bluetooth';
      case '1':
        return 'Line in';
      case '4':
        return 'Optical';
      case '5':
        return 'Wi-Fi';
      case '6':
        return 'USB';
      case '7':
        return 'HDMI ARC';
      default:
        return bt.isInitPlayStatus ? 'Other input' : 'Waiting';
    }
  }

  String equalizerLabel() {
    if (!bt.receiveCheckEqualizerStatus && !bt.isEqualizerOn) {
      return 'Waiting';
    }
    if (!bt.isEqualizerOn) return 'Off';
    switch (bt.selectEqualizerMode) {
      case EqualizerType.FLAT:
        return 'Flat · On';
      case EqualizerType.CLASSICAL:
        return 'Classic · On';
      case EqualizerType.POP:
        return 'Pop · On';
      case EqualizerType.ROCK:
        return 'Rock · On';
      case EqualizerType.JAZZ:
        return 'Jazz · On';
      case EqualizerType.VOCAL:
        return 'Vocal boost · On';
      case EqualizerType.CUSTOM:
        return 'Custom · On';
      default:
        return 'On';
    }
  }

  bool inputReported(int id) {
    if (!inputsLoaded) return false;
    if (id < 0 || id >= bt.playStatusList.length) return false;
    return bt.playStatusList[id] == 1;
  }

  bool inputCurrent(int id) => bt.selectMode == '$id';

  int bandValue(int index) {
    if (index < 0 || index >= bt.equalizerValues.length) return 0;
    final value = bt.equalizerValues[index];
    if (value < 0) return 0;
    if (value > 24) return 24;
    return value;
  }

  bool get _showingDropWelcome =>
      linkDropped &&
      tab == 0 &&
      stacks[0].length == 1 &&
      stacks[0].last == ArtScreen.welcome;

  void _onBluetooth() {
    final connected = bt.bluetoothConnectInfos.isNotEmpty;
    if (!connected && !userDisconnect) {
      if (!sessionConnected) return;
      sessionConnected = false;
      setupDone = false;
      adminVerified = false;
      connecting = false;
      if (pinRebootHold ||
          screen == ArtScreen.pinOffSuccess ||
          screen == ArtScreen.pinUpdated ||
          screen == ArtScreen.renameSaved) {
        notifyListeners();
        return;
      }
      _returnHomeAfterDrop();
      return;
    }
    notifyListeners();
  }

  void _onDeviceStatus(dynamic _) {
    if (!draggingVolume && !draggingAudioLimit) notifyListeners();
  }

  void _onAuracastHosts(dynamic _) {
    notifyListeners();
  }

  List<AuracastHost> get auracastHosts => bt.auracastHosts;

  void _onConnectEvent(dynamic arg) {
    if (arg is! Map) return;
    if (!connecting && screen != ArtScreen.connecting) return;
    final ok = arg[KeyConfig.blue_bridge_connect_result_key] == true;
    final info = arg[KeyConfig.blue_bridge_bluetooth_key];
    if (info is BluetoothInfo) target = info;
    _connectTimer?.cancel();
    connecting = false;
    if (ok) {
      sessionConnected = true;
      linkDropped = false;
      final gen = ++_connectGen;
      Future<void>(() => _afterConnected(gen));
    } else {
      sessionConnected = false;
      _returnToSpeakers();
    }
  }

  Future<void> _afterConnected(int gen) async {
    await Future<void>.delayed(Duration.zero);
    if (gen != _connectGen || !sessionConnected) return;
    try {
      await bt.checkAdminStatus();
    } catch (_) {}
    if (gen != _connectGen || !sessionConnected) return;
    final status = bt.adminPasswordStatus;
    tab = 0;
    keypad = null;
    if (status == AdminPasswordStatus.UnSet) {
      setupDone = false;
      adminVerified = false;
      adminNew = '';
      adminConfirm = '';
      adminSaveError = false;
      stacks[0] = [ArtScreen.welcome, ArtScreen.setAdmin];
    } else if (status == AdminPasswordStatus.HaveSet) {
      setupDone = true;
      adminVerified = false;
      stacks[0] = [ArtScreen.devices];
    } else {
      setupDone = false;
      adminVerified = false;
      stacks[0] = [ArtScreen.devices];
    }
    notifyListeners();
    if (setupDone) _later(refreshControl());
  }

  void _returnHomeAfterDrop() {
    if (_showingDropWelcome) return;
    keypad = null;
    discardDialog = false;
    connecting = false;
    tab = 0;
    stacks[0] = [ArtScreen.welcome];
    stacks[1] = [ArtScreen.control];
    stacks[2] = [ArtScreen.settings];
    stacks[3] = [ArtScreen.broadcast];
    _later(stopAuracastScan(silent: true));
    linkDropped = true;
    notifyListeners();
  }

  void push(ArtScreen next) {
    stacks[tab].add(next);
    notifyListeners();
  }

  void goTab(int index) {
    final leavingBroadcast = tab == 3 && index != 3;
    tab = index;
    keypad = null;
    discardDialog = false;
    if (leavingBroadcast) _later(stopAuracastScan(silent: true));
    if (index == 1 && ready) _later(refreshControl());
    if (index == 3 && ready) _later(startAuracastScan());
    notifyListeners();
  }

  void handleBack() {
    if (discardDialog) {
      discardDialog = false;
      notifyListeners();
      return;
    }
    if (screen == ArtScreen.rename && renameDirty) {
      discardDialog = true;
      notifyListeners();
      return;
    }
    keypad = null;
    if (screen == ArtScreen.findSpeakers || screen == ArtScreen.noSpeakers) {
      _searchGen++;
      searching = false;
    }
    if (screen == ArtScreen.pinOffConfirm) {
      cancelPinOff();
      return;
    }
    if (screen == ArtScreen.pinOffSuccess ||
        screen == ArtScreen.pinUpdated ||
        screen == ArtScreen.renameSaved) {
      pinRebootHold = false;
    }
    if (screen == ArtScreen.verifyAdmin) {
      verifyPin = '';
      verifyError = false;
    }
    if (screen == ArtScreen.connecting) {
      _connectTimer?.cancel();
      connecting = false;
      _connectGen++;
      _later(_abortConnect());
    }
    if (stacks[tab].length > 1) {
      stacks[tab].removeLast();
      notifyListeners();
      return;
    }
    if (!_isTabRoot(screen)) {
      stacks[tab] = [_tabRoot(tab)];
      notifyListeners();
    }
  }

  void keepEditing() {
    discardDialog = false;
    notifyListeners();
  }

  void discardRename() {
    discardDialog = false;
    renameDraft = savedName;
    keypad = null;
    if (stacks[tab].length > 1) stacks[tab].removeLast();
    notifyListeners();
  }

  Future<void> findSpeakers() async {
    var allowed = false;
    try {
      allowed = await Bluebridge.requestPermissions();
    } catch (_) {
      allowed = false;
    }
    if (!allowed) {
      push(ArtScreen.bluetoothAccess);
      return;
    }
    await continueBluetooth();
  }

  Future<void> continueBluetooth() async {
    busy = true;
    notifyListeners();
    try {
      await bt.initBluebridge();
    } catch (_) {}
    busy = false;
    tab = 0;
    linkDropped = false;
    stacks[0] = [ArtScreen.welcome, ArtScreen.findSpeakers];
    notifyListeners();
    await startSearch();
  }

  Future<void> startSearch() async {
    final gen = ++_searchGen;
    searching = true;
    connectFailed = false;
    linkDropped = false;
    found.clear();
    if (screen != ArtScreen.findSpeakers) {
      if (stacks[0].isNotEmpty && stacks[0].last == ArtScreen.noSpeakers) {
        stacks[0].removeLast();
      }
      stacks[0].add(ArtScreen.findSpeakers);
      tab = 0;
    }
    notifyListeners();
    List<BluetoothInfo> list = [];
    try {
      list = await Bluebridge.searchDevices();
    } catch (_) {
      list = [];
    }
    if (gen != _searchGen) return;
    found
      ..clear()
      ..addAll(list.where((item) {
        final mac = (item.device?.address ?? '').toLowerCase();
        if (Platform.isIOS) return true;
        return mac.startsWith('b3:aa');
      }));
    if (gen != _searchGen) return;
    searching = false;
    if (found.isEmpty && screen == ArtScreen.findSpeakers) {
      if (stacks[tab].isNotEmpty) stacks[tab].removeLast();
      stacks[tab].add(ArtScreen.noSpeakers);
    }
    notifyListeners();
  }

  void stopSearch() {
    _searchGen++;
    searching = false;
    notifyListeners();
  }

  Future<void> _abortConnect() async {
    _connectTimer?.cancel();
    connecting = false;
    _connectGen++;
    userDisconnect = true;
    try {
      await bt.disConnectBluetooth(target, clearAll: true);
    } catch (_) {}
    userDisconnect = false;
  }

  Future<void> connect(BluetoothInfo info) async {
    if (sessionConnected && connectedInfo != null) {
      final same = connectedInfo?.device?.address == info.device?.address;
      if (same) {
        tab = 0;
        stacks[0] = [ArtScreen.devices];
        notifyListeners();
        return;
      }
      userDisconnect = true;
      try {
        await bt.disConnectBluetooth(connectedInfo, clearAll: true);
      } catch (_) {}
      userDisconnect = false;
      sessionConnected = false;
      setupDone = false;
      adminVerified = false;
    }
    target = info;
    connecting = true;
    connectFailed = false;
    linkDropped = false;
    final gen = ++_connectGen;
    tab = 0;
    stacks[0] = [ArtScreen.welcome, ArtScreen.connecting];
    notifyListeners();
    _connectTimer?.cancel();
    _connectTimer = Timer(const Duration(seconds: 25), () {
      if (connecting && gen == _connectGen) {
        connecting = false;
        _returnToSpeakers();
      }
    });
    bt.connectDevice(info);
  }

  void _returnToSpeakers() {
    connectFailed = true;
    keypad = null;
    tab = 0;
    stacks[0] = [ArtScreen.welcome, ArtScreen.findSpeakers];
    notifyListeners();
  }

  Future<void> cancelConnect() async {
    _connectTimer?.cancel();
    connecting = false;
    _connectGen++;
    userDisconnect = true;
    try {
      await bt.disConnectBluetooth(target, clearAll: true);
    } catch (_) {}
    userDisconnect = false;
    sessionConnected = false;
    stacks[0] = [ArtScreen.welcome, ArtScreen.findSpeakers];
    notifyListeners();
  }

  Future<void> chooseAnother() async {
    _connectTimer?.cancel();
    connecting = false;
    _connectGen++;
    userDisconnect = true;
    try {
      if (bt.bluetoothConnectInfos.isNotEmpty || bt.connectBluetoothInfo != null) {
        await bt.disConnectBluetooth(connectedInfo ?? target, clearAll: true);
      }
    } catch (_) {}
    userDisconnect = false;
    sessionConnected = false;
    setupDone = false;
    adminVerified = false;
    keypad = null;
    tab = 0;
    stacks[0] = [ArtScreen.welcome, ArtScreen.findSpeakers];
    notifyListeners();
    await startSearch();
  }

  Future<void> disconnectSpeaker() async {
    userDisconnect = true;
    try {
      await bt.disConnectBluetooth(connectedInfo, clearAll: true);
    } catch (_) {}
    userDisconnect = false;
    sessionConnected = false;
    setupDone = false;
    adminVerified = false;
    target = null;
    tab = 0;
    linkDropped = false;
    stacks[0] = [ArtScreen.welcome];
    notifyListeners();
  }

  Future<void> reconnect() async {
    final info = target ?? connectedInfo;
    if (info == null) {
      await chooseAnother();
      return;
    }
    await connect(info);
  }

  void openControls() {
    if (!ready) return;
    tab = 1;
    stacks[1] = [ArtScreen.control];
    keypad = null;
    notifyListeners();
    _later(refreshControl());
  }

  Future<void> saveAdminPassword() async {
    if (adminNew.length != 4 || adminNew != adminConfirm || busy) return;
    busy = true;
    adminSaveError = false;
    notifyListeners();
    var ok = false;
    try {
      ok = await BlueCommandConfig.changeAdminPassword(adminNew);
    } catch (_) {
      ok = false;
    }
    busy = false;
    if (!sessionConnected) return;
    if (ok) {
      setupDone = true;
      adminVerified = true;
      bt.adminPasswordStatus = AdminPasswordStatus.HaveSet;
      stacks[0] = [ArtScreen.welcome, ArtScreen.adminSaved];
    } else {
      adminSaveError = true;
      adminNew = '';
      adminConfirm = '';
    }
    notifyListeners();
  }

  Future<void> verifyAdmin() async {
    if (verifyPin.length != 4 || busy) return;
    busy = true;
    verifyError = false;
    notifyListeners();
    bt.isVerificationAdminPassword = false;
    try {
      await BlueCommandConfig.checkAdminPassword(verifyPin, retryCount: 2);
    } catch (_) {}
    busy = false;
    if (bt.isVerificationAdminPassword) {
      adminVerified = true;
      verifyError = false;
      keypad = null;
      stacks[tab].removeLast();
      _prepareGuard(guard);
      stacks[tab].add(_guardScreen(guard));
    } else {
      verifyError = true;
      verifyPin = '';
    }
    notifyListeners();
  }

  ArtScreen _guardScreen(ArtGuard value) {
    switch (value) {
      case ArtGuard.name:
        return ArtScreen.rename;
      case ArtGuard.audio:
        return ArtScreen.audioSettings;
      case ArtGuard.security:
        return ArtScreen.security;
      case ArtGuard.pin:
        return ArtScreen.changePin;
      case ArtGuard.admin:
        return ArtScreen.changeAdmin;
    }
  }

  void _prepareGuard(ArtGuard value) {
    if (value == ArtGuard.name) {
      savedName = speakerName;
      renameDraft = savedName;
    }
    if (value == ArtGuard.audio) {
      _later(loadAudioSettings());
    }
    if (value == ArtGuard.pin) {
      connectionPin = '';
      errorLine = null;
      keypad = null;
      _later(_loadPin());
    }
    if (value == ArtGuard.admin) {
      changeAdminNew = '';
      changeAdminConfirm = '';
      adminSaveError = false;
      keypad = null;
    }
  }

  void openProtected(ArtGuard value) {
    if (!ready) return;
    guard = value;
    _prepareGuard(value);
    if (adminVerified) {
      push(_guardScreen(value));
      return;
    }
    verifyPin = '';
    verifyError = false;
    keypad = ArtPinField.verify;
    push(ArtScreen.verifyAdmin);
  }

  void openProduct() {
    if (!sessionConnected) return;
    push(ArtScreen.productInfo);
    _later(loadProduct());
  }

  void openLanguage() {
    push(ArtScreen.language);
  }

  void focusPin(ArtPinField field) {
    keypad = field;
    notifyListeners();
  }

  void typeDigit(String digit) {
    final field = keypad;
    if (field == null || digit.length != 1) return;
    void write(String current, void Function(String) set) {
      if (current.length >= 4) return;
      set(current + digit);
    }

    switch (field) {
      case ArtPinField.adminNew:
        write(adminNew, (v) => adminNew = v);
        break;
      case ArtPinField.adminConfirm:
        write(adminConfirm, (v) => adminConfirm = v);
        if (adminConfirm.length == 4 && adminConfirm != adminNew) {
          adminConfirm = '';
        }
        break;
      case ArtPinField.verify:
        write(verifyPin, (v) => verifyPin = v);
        verifyError = false;
        break;
      case ArtPinField.pinNew:
        write(connectionPin, (v) => connectionPin = v);
        break;
      case ArtPinField.changeNew:
        write(changeAdminNew, (v) => changeAdminNew = v);
        break;
      case ArtPinField.changeConfirm:
        write(changeAdminConfirm, (v) => changeAdminConfirm = v);
        if (changeAdminConfirm.length == 4 &&
            changeAdminConfirm != changeAdminNew) {
          changeAdminConfirm = '';
        }
        break;
    }
    notifyListeners();
  }

  void deleteDigit() {
    String trim(String value) =>
        value.isEmpty ? value : value.substring(0, value.length - 1);
    switch (keypad) {
      case ArtPinField.adminNew:
        adminNew = trim(adminNew);
        break;
      case ArtPinField.adminConfirm:
        adminConfirm = trim(adminConfirm);
        break;
      case ArtPinField.verify:
        verifyPin = trim(verifyPin);
        verifyError = false;
        break;
      case ArtPinField.pinNew:
        connectionPin = trim(connectionPin);
        break;
      case ArtPinField.changeNew:
        changeAdminNew = trim(changeAdminNew);
        break;
      case ArtPinField.changeConfirm:
        changeAdminConfirm = trim(changeAdminConfirm);
        break;
      case null:
        break;
    }
    notifyListeners();
  }

  bool get _onAudioSettingsScreen => screen == ArtScreen.audioSettings;

  bool get audioSettingsDirty {
    final monoDirty =
        draftMono != null && draftMono != _audioBaselineMono;
    final limitDirty =
        draftLimit != null && draftLimit != _audioBaselineLimit;
    return monoDirty || limitDirty;
  }

  Future<void> refreshControl() async {
    if (!ready) return;
    final skipLimitQuery = _onAudioSettingsScreen &&
        (draggingAudioLimit || audioSettingsDirty);
    try {
      await BlueCommandConfig.checkPlayStatus(retryCount: 2);
      await BlueCommandConfig.checkEqualizerStatus(retryCount: 2);
      if (!skipLimitQuery) {
        await BlueCommandConfig.checkVolumeLimitStatus(retryCount: 2);
      }
      await BlueCommandConfig.checkIndicatorLightStatus(retryCount: 2);
      await BlueCommandConfig.checkSoundTipsStatus(retryCount: 2);
    } catch (_) {}
    if (!draggingVolume && !draggingAudioLimit) notifyListeners();
  }

  Future<void> setIndicatorLight(bool on) async {
    if (!ready) return;
    try {
      if (on) {
        await BlueCommandConfig.indicatorLightON();
      } else {
        await BlueCommandConfig.indicatorLightOFF();
      }
      bt.isIndicatorLightOn = on;
    } catch (_) {}
    notifyListeners();
  }

  Future<void> setVoicePrompt(bool on) async {
    if (!ready) return;
    try {
      if (on) {
        await BlueCommandConfig.soundTipsON();
      } else {
        await BlueCommandConfig.soundTipsOFF();
      }
      bt.isSoundTipsOn = on;
    } catch (_) {}
    notifyListeners();
  }

  Future<void> setVolume(int value) async {
    if (!ready) return;
    var next = value;
    if (next < 0) next = 0;
    if (next > 100) next = 100;
    draggingVolume = true;
    bt.volume = next;
    notifyListeners();
    _volumeTimer?.cancel();
    volumeFailed = false;
    volumeUpdating = true;
    notifyListeners();
    _volumeTimer = Timer(const Duration(milliseconds: 250), () async {
      var ok = false;
      try {
        // app2: raw 0–100 on 0x20; firmware clamps when 0x2C was applied correctly.
        ok = await BlueCommandConfig.changeVolume(next);
      } catch (_) {
        ok = false;
      }
      draggingVolume = false;
      volumeUpdating = false;
      volumeFailed = !ok;
      notifyListeners();
    });
  }

  Future<void> selectInput(int id) async {
    if (!ready || !inputReported(id) || busy) return;
    busy = true;
    notifyListeners();
    try {
      final ok = await BlueCommandConfig.speakerMode(id);
      if (ok) bt.selectMode = '$id';
    } catch (_) {}
    busy = false;
    notifyListeners();
  }

  Future<void> toggleEqualizer(bool on) async {
    if (!ready || busy) return;
    busy = true;
    eqUpdating = true;
    eqFailed = false;
    _eqRetryOn = on;
    _eqRetryPreset = null;
    _eqRetryBands = null;
    notifyListeners();
    var ok = false;
    try {
      ok = on
          ? await BlueCommandConfig.equalizerOn()
          : await BlueCommandConfig.equalizerOFF();
      if (ok) bt.isEqualizerOn = on;
    } catch (_) {
      ok = false;
    }
    busy = false;
    eqUpdating = false;
    eqFailed = !ok;
    notifyListeners();
  }

  Future<void> applyPreset(EqualizerType type) async {
    if (!ready || !bt.isEqualizerOn || busy) return;
    busy = true;
    eqUpdating = true;
    eqFailed = false;
    _eqRetryOn = null;
    _eqRetryPreset = type;
    _eqRetryBands = null;
    notifyListeners();
    var ok = false;
    try {
      ok = await _sendPreset(type);
      if (ok) {
        bt.selectEqualizerMode = type;
        _customSent = type == EqualizerType.CUSTOM;
      }
    } catch (_) {
      ok = false;
    }
    busy = false;
    eqUpdating = false;
    eqFailed = !ok;
    notifyListeners();
  }

  Future<void> retryEqualizer() {
    final bands = _eqRetryBands;
    if (bands != null) return _sendBands(bands);
    final preset = _eqRetryPreset;
    if (preset != null) return applyPreset(preset);
    final on = _eqRetryOn;
    if (on != null) return toggleEqualizer(on);
    return Future<void>.value();
  }

  Future<void> _sendBands(List<int> values) async {
    if (!ready || busy) return;
    busy = true;
    eqUpdating = true;
    eqFailed = false;
    notifyListeners();
    var ok = false;
    try {
      if (!_customSent) {
        final switched = await BlueCommandConfig.customEqualizer();
        if (switched) {
          bt.selectEqualizerMode = EqualizerType.CUSTOM;
          _customSent = true;
        }
      }
      if (_customSent) {
        ok = await BlueCommandConfig.updateCustomEqualizerValue(values);
      }
    } catch (_) {
      ok = false;
    }
    busy = false;
    eqUpdating = false;
    eqFailed = !ok;
    if (!ok) _eqRetryBands = List<int>.from(values);
    notifyListeners();
  }

  Future<bool> _sendPreset(EqualizerType type) {
    switch (type) {
      case EqualizerType.CUSTOM:
        return BlueCommandConfig.customEqualizer();
      case EqualizerType.POP:
        return BlueCommandConfig.popEqualizer();
      case EqualizerType.CLASSICAL:
        return BlueCommandConfig.classicalEqualizer();
      case EqualizerType.JAZZ:
        return BlueCommandConfig.jazzEqualizer();
      case EqualizerType.ROCK:
        return BlueCommandConfig.rockEqualizer();
      case EqualizerType.VOCAL:
        return BlueCommandConfig.vocalEqualizer();
      case EqualizerType.FLAT:
        return BlueCommandConfig.flatEqualizer();
      case EqualizerType.LOUNGE:
        return BlueCommandConfig.loungeEqualizer();
      case EqualizerType.DANCE:
        return BlueCommandConfig.danceEqualizer();
      case EqualizerType.HIP_HOP:
        return BlueCommandConfig.hipHopEqualizer();
      case EqualizerType.ACOUSTIC:
        return BlueCommandConfig.acousticEqualizer();
    }
  }

  Future<void> setBand(int index, int value) async {
    if (!ready || !bt.isEqualizerOn || !bandsLoaded) return;
    if (bt.selectEqualizerMode != EqualizerType.CUSTOM) return;
    var next = value;
    if (next < 0) next = 0;
    if (next > 24) next = 24;
    final values = List<int>.from(bt.equalizerValues);
    if (values.length != 6) return;
    values[index] = next;
    bt.equalizerValues
      ..clear()
      ..addAll(values);
    eqFailed = false;
    _eqRetryOn = null;
    _eqRetryPreset = null;
    _eqRetryBands = List<int>.from(values);
    notifyListeners();
    _eqTimer?.cancel();
    _eqTimer = Timer(const Duration(milliseconds: 250), () {
      _later(_sendBands(values));
    });
  }

  void editName(String value) {
    renameDraft = value;
    notifyListeners();
  }

  Future<void> saveName() async {
    final next = renameDraft.trim();
    if (next.isEmpty || !ready || busy) return;
    busy = true;
    notifyListeners();
    var ok = false;
    try {
      ok = await BlueCommandConfig.rename(next);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      busy = false;
      errorLine = 'The speaker did not confirm the name.';
      if (screen != ArtScreen.saveFailed) push(ArtScreen.saveFailed);
      notifyListeners();
      return;
    }
    final mac = (connectedInfo ?? target)?.device?.address ?? '';
    if (mac.isNotEmpty) names[mac] = next;
    (connectedInfo ?? target)?.device?.name = next;
    savedName = next;
    errorLine = null;
    await _rebootForPinChange();
    busy = false;
    keypad = null;
    while ((screen == ArtScreen.saveFailed || screen == ArtScreen.rename) &&
        stacks[tab].length > 1) {
      stacks[tab].removeLast();
    }
    if (screen != ArtScreen.renameSaved) {
      stacks[tab].add(ArtScreen.renameSaved);
    }
    notifyListeners();
  }

  bool? draftMono;
  int? draftLimit;
  bool? _audioBaselineMono;
  int? _audioBaselineLimit;

  int _audioSettingsLoadGen = 0;

  Future<void> loadAudioSettings() async {
    final gen = ++_audioSettingsLoadGen;
    if (!audioLoaded) {
      notifyListeners();
    }
    try {
      await BlueCommandConfig.checkIndicatorLightIsMonoStatus(retryCount: 2);
      await BlueCommandConfig.checkVolumeLimitStatus(retryCount: 2);
    } catch (_) {}
    if (gen != _audioSettingsLoadGen) return;
    final preserveDraft = draggingAudioLimit || audioSettingsDirty;
    if (!preserveDraft) {
      if (bt.receiveCheckIndicatorLightIsMonoStatus) draftMono = bt.isMono;
      if (bt.volumeLimit >= 0 && bt.volumeLimit <= 3) {
        draftLimit = bt.volumeLimit;
      }
      _audioBaselineMono = draftMono;
      _audioBaselineLimit = draftLimit;
    }
    audioLoaded = true;
    if (!draggingAudioLimit) notifyListeners();
  }

  void setDraftMono(bool mono) {
    draftMono = mono;
    notifyListeners();
  }

  void setDraftLimit(int step) {
    if (step < 0 || step > 3) return;
    draftLimit = step;
    notifyListeners();
  }

  void beginDragAudioLimit() {
    draggingAudioLimit = true;
  }

  void endDragAudioLimit() {
    draggingAudioLimit = false;
    notifyListeners();
  }

  /// Discrete tiers (app2 indicator_light KeyValue values).
  static const List<int> audioLimitUiPercents = [25, 50, 75, 100];

  static int limitTypeForUiPercent(int percent) =>
      typeForLimitPercent(percent);

  Future<void> saveAudio() async {
    if (!ready || busy) return;
    final monoChanged =
        draftMono != null && draftMono != _audioBaselineMono;
    final limitChanged =
        draftLimit != null && draftLimit != _audioBaselineLimit;
    if (!monoChanged && !limitChanged) {
      if (stacks[tab].length > 1) stacks[tab].removeLast();
      notifyListeners();
      return;
    }
    busy = true;
    errorLine = null;
    notifyListeners();
    var ok = true;
    try {
      // Limit-only (Art 音频设置): same BLE as app2 selectedLimiterMenu — 0x2C only.
      if (limitChanged && draftLimit != null) {
        ok = await BlueCommandConfig.indicatorLightMinLimit(draftLimit!);
        if (ok && monoChanged) {
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      }
      if (monoChanged && ok && draftMono != null) {
        ok = draftMono!
            ? await BlueCommandConfig.indicatorLightMonoModel()
            : await BlueCommandConfig.indicatorLightSereoModel();
      }
    } catch (_) {
      ok = false;
    }
    busy = false;
    if (ok) {
      var limitReadbackOk = true;
      if (limitChanged && draftLimit != null) {
        bt.volumeLimit = draftLimit!;
        _audioBaselineLimit = draftLimit;
        try {
          await BlueCommandConfig.checkVolumeLimitStatus(retryCount: 2);
          limitReadbackOk = bt.volumeLimit == draftLimit;
        } catch (_) {
          limitReadbackOk = false;
        }
        if (!limitReadbackOk) {
          errorLine =
              'Volume limit did not read back from the speaker (expected type ${draftLimit}, got ${bt.volumeLimit}).';
        }
      }
      if (monoChanged && draftMono != null) {
        bt.isMono = draftMono!;
        _audioBaselineMono = draftMono;
      }
      if (limitReadbackOk) {
        if (stacks[tab].length > 1) stacks[tab].removeLast();
      }
    } else {
      errorLine = 'The speaker did not confirm the change.';
    }
    notifyListeners();
  }

  Future<void> setPinProtection(bool on) async {
    if (!ready || busy) return;
    busy = true;
    notifyListeners();
    try {
      if (on) {
        await BlueCommandConfig.pingOn();
      } else {
        await BlueCommandConfig.pingOff();
      }
    } catch (_) {
      busy = false;
      notifyListeners();
      return;
    }
    bt.isPinOn = on;
    busy = false;
    if (!on) {
      keypad = null;
      push(ArtScreen.pinOffConfirm);
      return;
    }
    notifyListeners();
  }

  void cancelPinOff() {
    if (screen == ArtScreen.pinOffConfirm && stacks[tab].length > 1) {
      stacks[tab].removeLast();
    }
    notifyListeners();
  }

  Future<void> confirmPinOffReboot() async {
    if (busy || screen != ArtScreen.pinOffConfirm) return;
    busy = true;
    notifyListeners();
    await _rebootForPinChange();
    busy = false;
    keypad = null;
    if (screen == ArtScreen.pinOffConfirm && stacks[tab].length > 1) {
      stacks[tab].removeLast();
    }
    if (screen != ArtScreen.pinOffSuccess) {
      stacks[tab].add(ArtScreen.pinOffSuccess);
    }
    notifyListeners();
  }

  Future<void> saveConnectionPin() async {
    if (!ready || connectionPin.length != 4 || busy) return;
    final code = connectionPin;
    busy = true;
    errorLine = null;
    notifyListeners();
    try {
      await BlueCommandConfig.changePinPassword(code);
    } catch (_) {
      busy = false;
      errorLine = 'The speaker did not confirm the PIN.';
      connectionPin = '';
      notifyListeners();
      return;
    }
    savedConnectionPin = code;
    await _rebootForPinChange();
    busy = false;
    keypad = null;
    if (screen == ArtScreen.changePin && stacks[tab].length > 1) {
      stacks[tab].removeLast();
    }
    if (screen != ArtScreen.pinUpdated) {
      stacks[tab].add(ArtScreen.pinUpdated);
    }
    notifyListeners();
  }

  Future<void> openBluetoothSettings() async {
    try {
      await Bluebridge.openSettings();
    } catch (_) {}
  }

  Future<void> _rebootForPinChange() async {
    pinRebootHold = true;
    userDisconnect = true;
    try {
      await bt.reboot();
    } catch (_) {}
    sessionConnected = false;
    setupDone = false;
    adminVerified = false;
    connecting = false;
    userDisconnect = false;
  }

  void openChangePin() {
    if (!adminVerified) return;
    connectionPin = '';
    errorLine = null;
    keypad = null;
    push(ArtScreen.changePin);
    _later(_loadPin());
  }

  Future<void> _loadPin() async {
    try {
      await BlueCommandConfig.checkPingStatus(retryCount: 2);
    } catch (_) {}
    notifyListeners();
  }

  void openChangeAdmin() {
    if (!adminVerified) return;
    changeAdminNew = '';
    changeAdminConfirm = '';
    adminSaveError = false;
    keypad = null;
    push(ArtScreen.changeAdmin);
  }

  Future<void> saveChangedAdmin() async {
    if (changeAdminNew.length != 4 ||
        changeAdminNew != changeAdminConfirm ||
        busy) {
      return;
    }
    busy = true;
    adminSaveError = false;
    notifyListeners();
    var ok = false;
    try {
      ok = await BlueCommandConfig.changeAdminPassword(changeAdminNew);
    } catch (_) {
      ok = false;
    }
    busy = false;
    if (ok) {
      keypad = null;
      if (stacks[tab].length > 1) stacks[tab].removeLast();
    } else {
      adminSaveError = true;
      changeAdminNew = '';
      changeAdminConfirm = '';
    }
    notifyListeners();
  }

  Future<void> loadProduct() async {
    productLoading = true;
    productFailed = false;
    notifyListeners();
    try {
      await BlueCommandConfig.checkProductStatus(retryCount: 2);
      if ((bt.firmware == null || bt.firmware!.isEmpty) &&
          bt.productModel.isEmpty) {
        await bt.checkAdminStatus();
      }
    } catch (_) {}
    productLoading = false;
    final missing = !bt.receiveCheckProductStatus &&
        (bt.firmware == null || bt.firmware!.isEmpty) &&
        bt.productModel.isEmpty;
    productFailed = missing;
    notifyListeners();
  }

  void chooseLanguage(String code) {
    chosenLanguage = code;
    notifyListeners();
  }

  Future<void> applyLanguage() async {
    final code = chosenLanguage;
    if (code == null || code.isEmpty) return;
    final locale = Locale(code);
    await LanguageUtil.updateSelectLanguageLocale(locale);
    EventBusManager().send(EventConfig.event_update_locale, locale);
    chosenLanguage = null;
    if (screen == ArtScreen.language && stacks[tab].length > 1) {
      stacks[tab].removeLast();
    }
    notifyListeners();
  }

  Future<void> startAuracastScan() async {
    if (!ready) {
      auracastError = 'Connect a speaker and finish setup first';
      notifyListeners();
      return;
    }
    if (auracastBusy) return;
    auracastError = null;
    auracastSelectedKey = null;
    bt.clearAuracastHosts();
    auracastScanning = true;
    notifyListeners();
    try {
      final ok = await BlueCommandConfig.auracastStartScan();
      if (!ok) {
        auracastScanning = false;
        auracastError = 'Could not start broadcast scan';
        notifyListeners();
      }
    } catch (_) {
      auracastScanning = false;
      auracastError = 'Could not start broadcast scan';
      notifyListeners();
    }
  }

  Future<void> stopAuracastScan({bool silent = false}) async {
    if (!auracastScanning && silent) return;
    try {
      await BlueCommandConfig.auracastStopScan();
    } catch (_) {}
    auracastScanning = false;
    if (!silent) notifyListeners();
  }

  Future<void> selectAuracastHost(AuracastHost host) async {
    if (!ready || auracastBusy) return;
    auracastBusy = true;
    auracastError = null;
    auracastSelectedKey = host.addressKey;
    notifyListeners();
    try {
      // Spec §5.2.3: stop scan (0x32 00) then send address (0x2E).
      await BlueCommandConfig.auracastStopScan();
      auracastScanning = false;
      final ok = await BlueCommandConfig.auracastSelectHost(host.address);
      if (!ok) {
        auracastError = 'Could not send selected broadcast host';
      }
    } catch (_) {
      auracastError = 'Could not send selected broadcast host';
    }
    auracastBusy = false;
    notifyListeners();
  }

  void _later(Future<void> future) {}

  @override
  void dispose() {
    _volumeTimer?.cancel();
    _eqTimer?.cancel();
    _connectTimer?.cancel();
    bt.removeListener(_onBluetooth);
    EventBusManager().off(EventConfig.event_connect_response, _onConnectEvent);
    EventBusManager().off(EventConfig.event_update_play_status, _onDeviceStatus);
    EventBusManager().off(EventConfig.event_update_equalizer_status, _onDeviceStatus);
    EventBusManager().off(EventConfig.event_update_auracast_hosts, _onAuracastHosts);
    super.dispose();
  }
}
