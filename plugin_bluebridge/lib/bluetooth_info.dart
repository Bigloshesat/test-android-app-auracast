part of bluebridge_library;

class BluetoothInfo {
  final BluetoothDevice? device;
  final int? rssi;

  BluetoothInfo({
    this.device,
    this.rssi = 0,
  });

  factory BluetoothInfo.fromMap(Map map) {
    return BluetoothInfo(
      device: BluetoothDevice.fromMap(map),
      rssi: map['rssi'] ?? 0,
    );
  }
}
