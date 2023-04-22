import 'package:flutter/services.dart';

import 'battery_manager_platform_interface.dart';

const getBatteryLevelMethod = 'get_battery_level';

class MethodChannelBatteryManager extends BatteryManagerPlatform {
  final methodChannel = const MethodChannel('battery_manager/channel');
  final streamChannel = const EventChannel("battery_manager/stream");

  @override
  Future<double> getBatteryLevel() async {
    final batteryLevel = await methodChannel.invokeMethod<double>(getBatteryLevelMethod);

    return batteryLevel ?? 0.0;
  }

  @override
  Stream<double> get batteryLevelStream {
    return streamChannel.receiveBroadcastStream().map((batteryLevel) {
      return batteryLevel ?? 0.0;
    });
  }
}
