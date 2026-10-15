part of bluebridge_library;

class ConnectResponse {
  static const int onWriteInitDescriptorStatus = 1;
  static const int onNotifyInitStatus = 2;
  static const int onNotify = 3;
  static const int onConnectStatusChanged = 4;
  static const int onConnected = 5;
  static const int onDisconnected = 6;
  static const int onConnectedError = 7;

  final int? operate;

  final String? mac;

  final int? statusCode;

  final Uint8List? bytes;

  final String? serviceUuid;

  final String? characterUuid;

  final String? error;

  final bool? isIndicate;

  const ConnectResponse(
      {this.operate,
      this.mac,
      this.statusCode,
      this.bytes,
      this.serviceUuid,
      this.characterUuid,
      this.error,
      this.isIndicate = false,
      });

  factory ConnectResponse.fromMap(Map map) {
    return ConnectResponse(
      operate: map["operate"],
      mac: map["mac"],
      statusCode: map["statusCode"],
      bytes: map["bytes"],
      isIndicate: map["isIndicate"],
      serviceUuid: map["serviceUuid"],
      characterUuid: map["characterUuid"],
      error: map["error"],
    );
  }

  Map<String, dynamic> toMap() => {
        "operate": this.operate,
        "mac": this.mac,
        "statusCode": this.statusCode,
        "bytes": this.bytes,
        "isIndicate": this.isIndicate,
        "serviceUuid": this.serviceUuid,
        "characterUuid": this.characterUuid,
        "error": this.error,
      };

  operator ==(Object other) {
    return other is ConnectResponse && other.mac == this.mac;
  }

  @override
  int get hashCode => mac.hashCode;
}
