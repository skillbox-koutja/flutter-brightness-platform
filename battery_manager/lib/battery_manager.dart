
import 'battery_manager_platform_interface.dart';

class BatteryManager {
  Future<double> getBatteryLevel() {
    return BatteryManagerPlatform.instance.getBatteryLevel();
  }

  Stream<double> get batteryLevelStream {
    return BatteryManagerPlatform.instance.batteryLevelStream;
  }
}
