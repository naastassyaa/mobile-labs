import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final client = MqttServerClient('broker.emqx.io', 'flutter_client_id');
  void Function(String)? onMessageReceived;
  void Function(double)? onTemperatureReceived;

  Future<void> connect() async {
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

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe('sensor/products', MqttQos.atMostOnce);
      client.subscribe('sensor/temperature', MqttQos.atMostOnce);

      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages.first.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.
        payload.message,);

        if (messages.first.topic == 'sensor/products') {
          onMessageReceived?.call(payload);
        } else if (messages.first.topic == 'sensor/temperature') {
          try {
            final temperature = double.parse(payload);
            onTemperatureReceived?.call(temperature);
          } catch (e) {
            _debug('Error parsing temperature: $e, payload: $payload');
          }
        }
      });
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void _debug(String message) {
    assert(() {
      if (kDebugMode) {
        print(message);
      }
      return true;
    }());
  }
}
