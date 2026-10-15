part of bluebridge_library;

class BluetoothDevice {
   String? name;

   String? address;

   BluetoothDeviceType type;

   bool isConnected;

   BluetoothBondState bondState;

   bool get isBonded => bondState.isBonded;

  BluetoothDevice({
    this.name,
    this.address,
    this.type = BluetoothDeviceType.unknown,
    this.isConnected = false,
    this.bondState = BluetoothBondState.unknown,
  });

  factory BluetoothDevice.fromMap(Map map) {
    return BluetoothDevice(
      name: map["name"],
      address: map["address"],
      type: map["type"] != null
          ? BluetoothDeviceType.fromUnderlyingValue(map["type"])
          : BluetoothDeviceType.unknown,
      isConnected: map["isConnected"] ?? false,
      bondState: map["bondState"] != null
          ? BluetoothBondState.fromUnderlyingValue(map["bondState"])
          : BluetoothBondState.unknown,
    );
  }

  Map<String, dynamic> toMap() => {
        "name": this.name,
        "address": this.address,
        "type": this.type.toUnderlyingValue(),
        "isConnected": this.isConnected,
        "bondState": this.bondState.toUnderlyingValue(),
      };

  operator ==(Object other) {
    return other is BluetoothDevice && other.address == this.address;
  }

  @override
  int get hashCode => address.hashCode;
}
