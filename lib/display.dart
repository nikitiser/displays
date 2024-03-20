import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:displays/displays.pigeon.dart';

final class PresentationDisplay {
  final int displayId;

  bool get isActive => _isActive;

  bool _isActive = false;
  String? _tag;
  String? get tag => _tag;
  String? _entryPointFunctionName;
  String? get entryPointFunctionName => _entryPointFunctionName;

  PresentationDisplay(this.displayId);

  final _receivePort = ReceivePort();

  SendPort? _sendPort;

  Stream get events => _receivePort.asBroadcastStream();

  Future<void> run({required String entryPointFunctionName, required String tag}) async {
    if (_isActive) {
      return;
    }
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, tag);
    final SetDisplayRequest request = SetDisplayRequest(
      displayId: displayId,
      tag: tag,
      entryPointFunctionName: entryPointFunctionName,
    );
    final res = await DisplaysPluginApi().startDisplay(request);
    if (res) {
      _tag = tag;
      _entryPointFunctionName = entryPointFunctionName;
      _isActive = true;
    } else {
      _entryPointFunctionName = null;
      _tag = null;
      _isActive = false;
    }
    _sendPort = await events
        .firstWhere((element) => element is SendPort)
        .timeout(const Duration(seconds: 5), onTimeout: () => null);
  }

  Future<void> send(dynamic message) async {
    _sendPort?.send(message);
  }

  Future<void> stop() async {
    if (!_isActive) {
      return;
    }
    final res = await DisplaysPluginApi().removeDisplay(_tag!);
    if (res) {
      _tag = null;
      _entryPointFunctionName = null;
      _isActive = false;
      _sendPort = null;
      IsolateNameServer.removePortNameMapping(_tag!);
    }
  }
}
