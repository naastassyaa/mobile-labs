import 'package:flutter/material.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/specific/circle_button.dart';

class ScanFridgePage extends StatelessWidget {
  const ScanFridgePage({super.key});

  void _startScan() {
    debugPrint('Scanning start');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
