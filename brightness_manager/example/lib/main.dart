import 'package:flutter/material.dart';
import 'dart:async';

import 'package:brightness_manager/brightness_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _brightness = 0.5;
  final _brightnessManagerPlugin = BrightnessManager();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onChangeBrightness(double brightness) {
    _brightness = brightness;
    debugPrint('brightness $brightness');
    if (!mounted) return;

    setState(() {
      _brightness = brightness;
    });
  }

  Future<void> initPlatformState() async {
    _brightnessManagerPlugin.init(onChangeBrightness);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Opacity(
                opacity: _brightness,
                child: const Icon(
                  Icons.brightness_high,
                  size: 64,
                  color: Colors.red,
                ),
              ),
            ),
            Center(
              child: Slider(
                value: _brightness,
                min: 0.1,
                max: 1.0,
                divisions: 10,
                onChanged: (double value) {
                  onChangeBrightness(value);
                  _brightnessManagerPlugin.setBrightness(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
