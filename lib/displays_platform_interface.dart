import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'displays_method_channel.dart';

abstract class DisplaysPlatform extends PlatformInterface {
  /// Constructs a DisplaysPlatform.
  DisplaysPlatform() : super(token: _token);

  static final Object _token = Object();

  static DisplaysPlatform _instance = MethodChannelDisplays();

  /// The default instance of [DisplaysPlatform] to use.
  ///
  /// Defaults to [MethodChannelDisplays].
  static DisplaysPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DisplaysPlatform] when
  /// they register themselves.
  static set instance(DisplaysPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
