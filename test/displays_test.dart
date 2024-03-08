import 'package:flutter_test/flutter_test.dart';
import 'package:displays/displays.dart';
import 'package:displays/displays_platform_interface.dart';
import 'package:displays/displays_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDisplaysPlatform
    with MockPlatformInterfaceMixin
    implements DisplaysPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DisplaysPlatform initialPlatform = DisplaysPlatform.instance;

  test('$MethodChannelDisplays is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDisplays>());
  });

  test('getPlatformVersion', () async {
    Displays displaysPlugin = Displays();
    MockDisplaysPlatform fakePlatform = MockDisplaysPlatform();
    DisplaysPlatform.instance = fakePlatform;

    expect(await displaysPlugin.getPlatformVersion(), '42');
  });
}
