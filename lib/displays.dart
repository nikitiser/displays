import 'package:displays/display.dart';
import 'package:displays/displays.pigeon.dart';

base class DisplaysManager {
  static Future<List<PresentationDisplay>> getDisplays() async {
    final GetDisplaysRequest request = GetDisplaysRequest();
    final List<PluginDisplay?> physicalDisplays = await DisplaysPluginApi().getDisplays(request);
    final List<PresentationDisplay> displays = physicalDisplays.map((e) => PresentationDisplay(e!.displayId)).toList();
    return displays;
  }
}
