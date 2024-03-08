import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'displays_platform_interface.dart';

/// An implementation of [DisplaysPlatform] that uses method channels.
class MethodChannelDisplays extends DisplaysPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('displays');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
