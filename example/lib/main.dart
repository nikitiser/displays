import 'package:displays/displays.pigeon.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<PluginDisplay> _displays = [];
  final Set<String> _tags = {};
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    _getDisplays();
  }

  Future<void> _getDisplays() async {
    setState(() {
      isBusy = true;
    });
    final GetDisplaysRequest request = GetDisplaysRequest();
    final List<PluginDisplay?> displays = await DisplaysPluginApi().getDisplays(request);
    if (displays.isNotEmpty) {
      setState(() {
        _displays.clear();
        _displays.addAll(displays.map((e) => e!).toList());
        isBusy = false;
      });
    }
  }

  Future<void> _startDisplay(int displayId) async {
    setState(() {
      isBusy = true;
    });
    final SetDisplayRequest request = SetDisplayRequest(
      displayId: displayId,
      tag: 'example',
      entryPointFunctionName: 'secondScreen',
    );
    final res = await DisplaysPluginApi().startDisplay(request);
    if (res) {
      _tags.add(request.tag);
    }
    setState(() {
      isBusy = false;
    });
  }

  Future<void> _removeDisplay(String tag) async {
    setState(() {
      isBusy = true;
    });
    final res = await DisplaysPluginApi().removeDisplay(tag);
    if (res) {
      _tags.remove(tag);
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton.filled(onPressed: () => _getDisplays(), icon: const Icon(Icons.refresh)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              isBusy = true;
            });
            final CreateVirtualDisplayRequest request = CreateVirtualDisplayRequest(
              tag: 'example',
              width: 100,
              height: 100,
              dpi: 160,
              entryPointFunctionName: 'secondScreen',
            );
            final res = await DisplaysPluginApi().createVirtualDisplay(request);
            if (res) {
              _tags.add(request.tag);
            }
            setState(() {
              isBusy = false;
            });
          },
          child: const Icon(Icons.add),
        ),
        body: isBusy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: _displays.length,
                      itemBuilder: (BuildContext context, int index) {
                        final PluginDisplay display = _displays[index];
                        return ListTile(
                            title: Text('Display ${display.displayId}'),
                            subtitle: Text('Name: ${display.name}'),
                            trailing: Text('Rotation: ${display.rotation}'),
                            onTap: () => _startDisplay(display.displayId));
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: _tags.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String tag = _tags.elementAt(index);
                        return ListTile(title: Text('Display $tag'), onTap: () => _removeDisplay(tag));
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void secondScreen(List<String> args) {
  print(args);
  runApp(const SecondScreen());
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Second Screen'),
        ),
        body: const Center(
          child: Text('Second Screen'),
        ),
      ),
    );
  }
}
