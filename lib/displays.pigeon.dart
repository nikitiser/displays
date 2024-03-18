// Autogenerated from Pigeon (v12.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
List<Object?> wrapResponse({Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

class PluginDisplay {
  PluginDisplay({
    required this.displayId,
    this.flag,
    this.rotation,
    required this.name,
  });

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

  Object encode() {
    return <Object?>[
      displayId,
      flag,
      rotation,
      name,
    ];
  }

  static PluginDisplay decode(Object result) {
    result as List<Object?>;
    return PluginDisplay(
      displayId: result[0]! as int,
      flag: result[1] as int?,
      rotation: result[2] as int?,
      name: result[3]! as String,
    );
  }
}

class GetDisplaysRequest {
  GetDisplaysRequest({
    this.category,
  });

  String? category;

  Object encode() {
    return <Object?>[
      category,
    ];
  }

  static GetDisplaysRequest decode(Object result) {
    result as List<Object?>;
    return GetDisplaysRequest(
      category: result[0] as String?,
    );
  }
}

class SetDisplayRequest {
  SetDisplayRequest({
    required this.displayId,
    this.flag,
    this.rotation,
    required this.tag,
    required this.entryPointFunctionName,
  });

  int displayId;

  int? flag;

  int? rotation;

  String tag;

  String entryPointFunctionName;

  Object encode() {
    return <Object?>[
      displayId,
      flag,
      rotation,
      tag,
      entryPointFunctionName,
    ];
  }

  static SetDisplayRequest decode(Object result) {
    result as List<Object?>;
    return SetDisplayRequest(
      displayId: result[0]! as int,
      flag: result[1] as int?,
      rotation: result[2] as int?,
      tag: result[3]! as String,
      entryPointFunctionName: result[4]! as String,
    );
  }
}

class CreateVirtualDisplayRequest {
  CreateVirtualDisplayRequest({
    required this.tag,
    required this.width,
    required this.height,
    required this.dpi,
    required this.entryPointFunctionName,
  });

  String tag;

  int width;

  int height;

  int dpi;

  String entryPointFunctionName;

  Object encode() {
    return <Object?>[
      tag,
      width,
      height,
      dpi,
      entryPointFunctionName,
    ];
  }

  static CreateVirtualDisplayRequest decode(Object result) {
    result as List<Object?>;
    return CreateVirtualDisplayRequest(
      tag: result[0]! as String,
      width: result[1]! as int,
      height: result[2]! as int,
      dpi: result[3]! as int,
      entryPointFunctionName: result[4]! as String,
    );
  }
}

class _DisplaysPluginApiCodec extends StandardMessageCodec {
  const _DisplaysPluginApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CreateVirtualDisplayRequest) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is GetDisplaysRequest) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is PluginDisplay) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is SetDisplayRequest) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return CreateVirtualDisplayRequest.decode(readValue(buffer)!);
      case 129: 
        return GetDisplaysRequest.decode(readValue(buffer)!);
      case 130: 
        return PluginDisplay.decode(readValue(buffer)!);
      case 131: 
        return SetDisplayRequest.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class DisplaysPluginApi {
  /// Constructor for [DisplaysPluginApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  DisplaysPluginApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _DisplaysPluginApiCodec();

  Future<List<PluginDisplay?>> getDisplays(GetDisplaysRequest arg_request) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.displays.DisplaysPluginApi.getDisplays', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_request]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<PluginDisplay?>();
    }
  }

  Future<bool> startDisplay(SetDisplayRequest arg_request) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.displays.DisplaysPluginApi.startDisplay', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_request]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> removeDisplay(String arg_tag) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.displays.DisplaysPluginApi.removeDisplay', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_tag]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> createVirtualDisplay(CreateVirtualDisplayRequest arg_request) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.displays.DisplaysPluginApi.createVirtualDisplay', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_request]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }
}

abstract class DisplaysPluginReceiverApi {
  static const MessageCodec<Object?> codec = StandardMessageCodec();

  void newInfo(String message);

  static void setup(DisplaysPluginReceiverApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.displays.DisplaysPluginReceiverApi.newInfo', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.displays.DisplaysPluginReceiverApi.newInfo was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_message = (args[0] as String?);
          assert(arg_message != null,
              'Argument for dev.flutter.pigeon.displays.DisplaysPluginReceiverApi.newInfo was null, expected non-null String.');
          try {
            api.newInfo(arg_message!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}