import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:test_project/services/fridge_data.dart';
import 'package:test_project/services/mqtt_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MqttService _mqttService;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  HomeCubit({
    List<String>? initialProducts,
    MqttService? mqttService,
    Connectivity? connectivity,
  })  : _mqttService = mqttService ?? MqttService(),
        _connectivity = connectivity ?? Connectivity(),
        super(HomeState(
        items: initialProducts ?? FridgeData().products,
        filteredItems:
        List.from(initialProducts ?? FridgeData().products),
        temperature: 4,
        hasConnection: true,
      ),);

  void init() {
    _connectivitySub =
        _connectivity.onConnectivityChanged.listen((results) {
          final ConnectivityResult status = results.first;
          _onConnectivityChanged(status);
        });
    _checkInitialConnectivity();
    _mqttService.onMessageReceived = (payload) {
      final items = payload.split(',').map((e) => e.trim()).toList();
      FridgeData().products = items;
      emit(state.copyWith(items: items, filteredItems: items));
    };
    _mqttService.onTemperatureReceived = (temp) {
      final clamped = temp.clamp(-5.0, 5.0);
      emit(state.copyWith(temperature: clamped));
    };

    _mqttService.connect(
      productTopic: 'my_app/12345/products',
      temperatureTopic: 'my_app/12345/temperature',
    );
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _onConnectivityChanged(result as ConnectivityResult);
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    final bool hasConn = result != ConnectivityResult.none;
    if (hasConn != state.hasConnection) {
      emit(state.copyWith(hasConnection: hasConn));
    }
  }

  void filterItems(String query) {
    final low = query.toLowerCase();
    final filtered = state.items
        .where((item) => item.toLowerCase().contains(low))
        .toList();
    emit(state.copyWith(filteredItems: filtered));
  }

  void addProduct(String newItem) {
    if (newItem.isEmpty) return;
    final updated = List<String>.from(state.items)..add(newItem);
    FridgeData().products = updated;
    emit(state.copyWith(items: updated, filteredItems: updated));
  }

  void removeProduct(String item) {
    final updated = List<String>.from(state.items)..remove(item);
    FridgeData().products = updated;
    emit(state.copyWith(items: updated, filteredItems: updated));
  }

  void changeTemperature(double value) {
    emit(state.copyWith(temperature: value));
  }

  @override
  Future<void> close() {
    _mqttService.disconnect();
    _connectivitySub?.cancel();
    return super.close();
  }
}
