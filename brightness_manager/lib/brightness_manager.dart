import 'package:brightness_manager/brightness_manager_platform_interface.dart';

class BrightnessManager {
  void init(void Function(double brightness) listener) {
    return BrightnessManagerPlatform.instance.addListener(listener);
  }

  Future<void> setBrightness(double brightness) {
    return BrightnessManagerPlatform.instance.setBrightness(brightness);
  }
}
