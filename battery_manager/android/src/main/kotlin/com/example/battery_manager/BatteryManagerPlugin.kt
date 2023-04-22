package com.example.battery_manager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BatteryManagerPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  private lateinit var applicationContext: Context
  private lateinit var channel: MethodChannel
  private lateinit var batteryManager: BatteryManager
  private lateinit var filter: IntentFilter
  private lateinit var streamChannel: EventChannel
  private lateinit var chargingStateChangeReceiver: BroadcastReceiver

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext

    val messenger = flutterPluginBinding.binaryMessenger

    channel = MethodChannel(messenger, "battery_manager/channel")
    channel.setMethodCallHandler(this)

    streamChannel = EventChannel(messenger, "battery_manager/stream")
    streamChannel.setStreamHandler(this)

    filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)

    batteryManager = applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "get_battery_level" -> result.success(getBatteryCall())
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    streamChannel.setStreamHandler(null)
  }

  private fun getBatteryCall(): Double {
    var batteryLevel = -1
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    return batteryLevel.toDouble()
  }

  /** Creates broadcast receiver object that provides battery information upon subscription to the stream */
  private fun createChargingStateChangeReceiver(events: EventSink?): BroadcastReceiver {
    return object : BroadcastReceiver() {
      override fun onReceive(contxt: Context?, intent: Intent?) {
        events?.success(intent?.let { getBatteryCall() })
      }
    }
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    chargingStateChangeReceiver = createChargingStateChangeReceiver(events)
    val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
    applicationContext.registerReceiver(chargingStateChangeReceiver, filter)
  }

  override fun onCancel(arguments: Any?) {
    applicationContext.unregisterReceiver(chargingStateChangeReceiver)
  }
}
