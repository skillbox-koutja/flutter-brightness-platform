import 'package:flutter/material.dart';
import 'dart:async';

import 'package:battery_manager/battery_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _batteryLevel = 0.0;
  bool _loading = true;
  final _plugin = BatteryManager();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onChangeBatteryLevel(double batteryLevel) {
    _batteryLevel = batteryLevel;

    if (!mounted) return;

    setState(() {
      _loading = false;
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> initPlatformState() async {
    _plugin.getBatteryLevel().then((batteryLevel) {
      debugPrint('batteryLevel(future): $batteryLevel');
      onChangeBatteryLevel(batteryLevel);
    });

    _plugin.batteryLevelStream.listen((batteryLevel) {
      debugPrint('batteryLevel(stream): $batteryLevel');
      onChangeBatteryLevel(batteryLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final widget = _loading
        ? const CircularProgressIndicator()
        : Text(
            '${_batteryLevel.toStringAsFixed(1)}%',
          );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery level example'),
        ),
        body: Column(
          children: [
            Center(
              child: widget,
            ),
          ],
        ),
      ),
    );
  }
}
