import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:test_project/services/mqtt_service.dart';

part 'scan_state.dart';

class ScanFridgeCubit extends Cubit<ScanFridgeState> {
  final MqttService _mqttService;

  ScanFridgeCubit({MqttService? mqttService})
      : _mqttService = mqttService ?? MqttService(),
        super(const ScanFridgeState()) {
    // Start MQTT connection
    _mqttService.connect();
    _mqttService.onMessageReceived = (msg) {
      final list = msg.split(',').map((e) => e.trim()).toList();
      emit(state.copyWith(products: list));
    };
  }

  @override
  Future<void> close() {
    _mqttService.disconnect();
    return super.close();
  }
}
