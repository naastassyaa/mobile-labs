import 'package:flutter/material.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/specific/circle_button.dart';
import 'package:test_project/services/fridge_data.dart';
import 'package:test_project/services/mqtt_service.dart';

class ScanFridgePage extends StatefulWidget {
  const ScanFridgePage({super.key});

  @override
  State<ScanFridgePage> createState() => _ScanFridgePageState();
}

class _ScanFridgePageState extends State<ScanFridgePage> {
  final MqttService _mqttService = MqttService();
  List<String> _productList = [];

  @override
  void initState() {
    super.initState();
    _mqttService.onMessageReceived = (msg) {
      _productList = msg.split(',').map((e) => e.trim()).toList();
    };
    _mqttService.connect();
  }

  void _startScan() {
    debugPrint('Scanning start');
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text('Scanning...'),
        content: SizedBox(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pop();
      FridgeData().products = _productList;

      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Products Found'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _productList.isNotEmpty
                ? _productList.map((p) => Text('• $p')).toList()
                : [const Text('No products found')],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });

  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Fridge'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: CircularButton(
          onPressed: _startScan,
          text: 'Start\nScanning\nFridge',
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
