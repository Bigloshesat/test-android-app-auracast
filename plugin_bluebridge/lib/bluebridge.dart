part of bluebridge_library;

class Bluebridge {
  static const String plugin_namespace = 'blue_bridge_plugin';

  static Bluebridge _instance = Bluebridge._();

  static Bluebridge get instance => _instance;

  static const MethodChannel _channel =
      const MethodChannel('$plugin_namespace/bluebridge');

  static const EventChannel _discoveryChannel =
      const EventChannel('$plugin_namespace/discovery');

  static const EventChannel _connectChannel =
      const EventChannel('$plugin_namespace/connect');

  Bluebridge._();

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> get isAvailable async {
    return await _channel.invokeMethod('isAvailable');
  }

  static Future<bool> get isEnabled async {
    return await _channel.invokeMethod('isEnabled');
  }

  static Future<bool> requestPermissions() async {
    return await _channel.invokeMethod('requestPermissions');
  }

  static Future<bool> openSettings() async {
    return await _channel.invokeMethod('openSettings');
  }

  static Future<bool> requestEnable() async {
    return await _channel.invokeMethod('requestEnable');
  }

  static Future<bool> requestDisable() async {
    return await _channel.invokeMethod('requestDisable');
  }

  static Future<int> requestDiscoverable() async {
    return await _channel.invokeMethod('requestDiscoverable');
  }

  static Future<bool> isDiscovering() async {
    return await _channel.invokeMethod('isDiscovering');
  }

  Future<List<BluetoothDevice>> getBondedDevices() async {
    final List list = await _channel.invokeMethod('getBondedDevices');
    return list.map((map) => BluetoothDevice.fromMap(map)).toList();
  }

  static Stream<BluetoothInfo> startDiscovery() async* {
    StreamSubscription? subscription;
    StreamController controller = new StreamController(
      onCancel: () {
        subscription?.cancel();
      },
    );
    await _channel.invokeMethod('startDiscovery');
    subscription = _discoveryChannel.receiveBroadcastStream().listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );
    yield* controller.stream.map((map) => BluetoothInfo.fromMap(map));
  }

  static Future<bool> cancelDiscovery() async {
    return await _channel.invokeMethod('cancelDiscovery');
  }

  static Future<bool> init() async {
    return await _channel.invokeMethod('init');
  }

  static Future<bool> destory() async {
    return await _channel.invokeMethod('destory');
  }

  static Future<List<BluetoothInfo>> searchDevices() async {
    final List list = await _channel.invokeMethod('searchDevices');
    // if(Platform.isIOS){
    //   // IOS 走异步回调
    //   yield* Bluebridge.instance._channel.where((m) => m.method == "RetsearchDevices");
    //   return list;
    // }
    
      return list.map((map) => BluetoothInfo.fromMap(map)).toList();
  }

  static Stream<ConnectResponse> connect(String mac) async* {
    StreamSubscription? subscription;
    StreamController controller = new StreamController(
      onCancel: () {
        subscription?.cancel();
      },
    );
    await _channel.invokeMethod('connect', {"mac": mac});
    subscription = _connectChannel.receiveBroadcastStream().listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );
    yield* controller.stream.map((map) => ConnectResponse.fromMap(map));
  }

  static Future<bool> disConnect() async {
    return await _channel.invokeMethod('disConnect');
  }

  static Future<bool> sendMessage(Uint8List bytes) async {
    return await _channel.invokeMethod('sendMessage', {"bytes": bytes});
  }
}
