import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final client = MqttServerClient('broker.emqx.io', 'flutter_client_id');
  void Function(String)? onMessageReceived;
  void Function(double)? onTemperatureReceived;
  String? _productTopic = 'sensor/products';
  String? _temperatureTopic = 'sensor/temperature';

  Future<void> connect({
    required String productTopic,
    required String temperatureTopic,
  }) async {
    _productTopic = productTopic;
    _temperatureTopic = temperatureTopic;

    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);

    client.onConnected = () => _debug('MQTT Connected');
    client.onDisconnected = () => _debug('MQTT Disconnected');

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_id')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    connMessage.payload.username = 'your_username';
    connMessage.payload.password = 'your_password';

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      _debug('MQTT Connection failed: $e');
      client.disconnect();
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(_productTopic!, MqttQos.atMostOnce);
      client.subscribe(_temperatureTopic!, MqttQos.atMostOnce);

      client.updates?.listen((messages) {
        for (var message in messages) {
          final recMess = message.payload as MqttPublishMessage;
          final payload = MqttPublishPayload
              .bytesToStringAsString(recMess.payload.message);
          if (message.topic == _productTopic) {
            onMessageReceived?.call(payload);
          } else if (message.topic == _temperatureTopic) {
            try {
              final temperature = double.parse(payload);
              onTemperatureReceived?.call(temperature);
            } catch (e) {
              _debug('Error parsing temperature: $e, payload: $payload');
            }
          }
        }
      });
    } else {
      _debug('MQTT Connection State: \${client.connectionStatus?.state}');
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void _debug(String message) {
    assert(() {
      if (kDebugMode) print(message);
      return true;
    }());
  }
}
