import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_storage_example/example.dart';

void main() {
  const MethodChannel channel = MethodChannel('example');

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
    expect(await Example.platformVersion, '42');
  });
}
