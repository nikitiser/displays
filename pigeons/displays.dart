import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/displays.pigeon.dart',
    dartTestOut: 'test/displays.test.pigeon.dart',
    dartOptions: DartOptions(
      sourceOutPath: 'pigeions/displays.dart',
    ),
    kotlinOut: 'android/src/main/kotlin/com/kicknext/displays/gen/DisplaysAPI.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.kicknext.displays.gen',
    ),
  ),
)
class PluginDisplay {
  /// Gets the display id.
  /// <p>
  /// Each logical display has a unique id.
  /// The default display has id [DEFAULT_DISPLAY]
  /// </p>
  int displayId;

  /// Returns a combination of flags that describe the capabilities of the display.
  /// @return The display flags.
  ///
  /// See [FLAG_SUPPORTS_PROTECTED_BUFFERS], [FLAG_SECURE], [FLAG_PRIVATE]
  int? flag;

  /// Returns the rotation of the screen from its "natural" orientation.
  /// The returned value may be [ROTATION_0]
  /// (no rotation), [ROTATION_90], [ROTATION_180], or [ROTATION_270].  For
  /// example, if a device has a naturally tall screen, and the user has
  /// turned it on its side to go into a landscape orientation, the value
  /// returned here may be either [ROTATION_90] or [ROTATION_270] depending on
  /// the direction it was turned.  The angle is the rotation of the drawn
  /// graphics on the screen, which is the opposite direction of the physical
  /// rotation of the device.  For example, if the device is rotated 90
  /// degrees counter-clockwise, to compensate rendering will be rotated by
  /// 90 degrees clockwise and thus the returned value here will be
  /// [ROTATION_90].
  int? rotation;

  /// Gets the name of the display.
  /// <p>
  /// Note that some displays may be renamed by the user.
  /// </p>
  ///
  /// @return The display's name.
  String name;

  PluginDisplay({required this.displayId, this.flag, required this.name, this.rotation});
}

class GetDisplaysRequest {
  final String? category;
  GetDisplaysRequest({required this.category});
}

class SetDisplayRequest {
  final int displayId;
  final int? flag;
  final int? rotation;
  final String tag;
  final String entryPointFunctionName;
  SetDisplayRequest({
    required this.displayId,
    this.flag,
    required this.tag,
    this.rotation,
    required this.entryPointFunctionName,
  });
}

class CreateVirtualDisplayRequest {
  final String tag;
  final int width;
  final int height;
  final int dpi;
  final String entryPointFunctionName;
  CreateVirtualDisplayRequest({
    required this.tag,
    required this.width,
    required this.height,
    required this.dpi,
    required this.entryPointFunctionName,
  });
}

@HostApi()
abstract class DisplaysPluginApi {
  @async
  @TaskQueue(type: TaskQueueType.serial)
  List<PluginDisplay> getDisplays(GetDisplaysRequest request);

  @async
  @TaskQueue(type: TaskQueueType.serial)
  bool startDisplay(SetDisplayRequest request);

  @async
  @TaskQueue(type: TaskQueueType.serial)
  bool removeDisplay(String tag);

  @async
  @TaskQueue(type: TaskQueueType.serial)
  bool createVirtualDisplay(CreateVirtualDisplayRequest request);
}

@FlutterApi()
abstract class DisplaysPluginReceiverApi {
  void newInfo(String message);
}
