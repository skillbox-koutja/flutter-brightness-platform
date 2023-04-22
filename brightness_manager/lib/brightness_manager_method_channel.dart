import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:brightness_manager/brightness_manager_platform_interface.dart';

const getBrightnessMethod = 'get_brightness';
const setBrightnessMethod = 'set_brightness';
const logMethod = 'log';

class MethodChannelBrightnessManager extends BrightnessManagerPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('brightness_manager');

  MethodChannelBrightnessManager() {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case getBrightnessMethod:
          for (final listener in listeners) {
            listener(call.arguments);
          }
          break;
        case logMethod:
          debugPrint(call.arguments);
          break;
      }
    });
  }

  @override
  Future<void> setBrightness(double brightness) {
    return methodChannel.invokeListMethod(setBrightnessMethod, brightness);
  }
}
