import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluebridge/bluebridge_library.dart';

void main() {
  const MethodChannel channel = MethodChannel('bluebridge');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Bluebridge.platformVersion, '42');
  });
}
