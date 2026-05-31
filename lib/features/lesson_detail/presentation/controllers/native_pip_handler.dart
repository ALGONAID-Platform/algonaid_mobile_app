import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NativePipHandler {
  static final NativePipHandler _instance = NativePipHandler._internal();
  factory NativePipHandler() => _instance;

  static const MethodChannel _channel = MethodChannel('com.algonaid.pip');
  final ValueNotifier<bool> isInPipMode = ValueNotifier<bool>(false);

  NativePipHandler._internal() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPipModeChanged') {
        isInPipMode.value = call.arguments as bool;
      }
    });
  }

  Future<void> setPipAllowed(bool allowed) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _channel.invokeMethod('setPipAllowed', {'allowed': allowed});
      } on PlatformException catch (e) {
        debugPrint('Failed to set PiP allowed: ${e.message}');
      } on MissingPluginException catch (e) {
        debugPrint('PiP plugin missing: ${e.message}');
      }
    }
  }

  Future<void> setPipRect(int left, int top, int right, int bottom) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _channel.invokeMethod('setPipRect', {
          'left': left,
          'top': top,
          'right': right,
          'bottom': bottom,
        });
      } on PlatformException catch (e) {
        debugPrint('Failed to set PiP rect: ${e.message}');
      } on MissingPluginException catch (e) {
        debugPrint('PiP plugin missing: ${e.message}');
      }
    }
  }
}
