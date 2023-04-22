import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:brightness_manager/brightness_manager_method_channel.dart';

abstract class BrightnessManagerPlatform extends PlatformInterface {
  final List<void Function(double brightness)> _listeners = [];

  List<void Function(double brightness)> get listeners => _listeners;

  /// Constructs a BrightnessManagerPlatform.
  BrightnessManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BrightnessManagerPlatform _instance = MethodChannelBrightnessManager();

  /// The default instance of [BrightnessManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBrightnessManager].
  static BrightnessManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BrightnessManagerPlatform] when
  /// they register themselves.
  static set instance(BrightnessManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setBrightness(double brightness) {
    throw UnimplementedError('setBrightness() has not been implemented.');
  }

  void addListener(void Function(double brightness) handler) {
    _listeners.add(handler);
  }

  void removeListener(void Function(double brightness) handler) {
    _listeners.remove(handler);
  }
}
