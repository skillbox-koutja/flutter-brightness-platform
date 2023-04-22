import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'battery_manager_method_channel.dart';

abstract class BatteryManagerPlatform extends PlatformInterface {
  BatteryManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BatteryManagerPlatform _instance = MethodChannelBatteryManager();

  /// The default instance of [BatteryManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBatteryManager].
  static BatteryManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BatteryManagerPlatform] when
  /// they register themselves.
  static set instance(BatteryManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<double> getBatteryLevel() async {
    throw UnimplementedError('getBatteryLevel() has not been implemented.');
  }

  Stream<double> get batteryLevelStream {
    throw UnimplementedError('batteryLevelStream() has not been implemented.');
  }
}
