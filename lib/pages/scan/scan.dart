import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/specific/circle_button.dart';
import 'package:test_project/pages/scan/scan_cubit.dart';
import 'package:test_project/services/fridge_data.dart';

class ScanFridgePage extends StatelessWidget {
  const ScanFridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanFridgeCubit>(
      create: (_) => ScanFridgeCubit(),
      child: const _ScanFridgeView(),
    );
  }
}

class _ScanFridgeView extends StatelessWidget {
  const _ScanFridgeView();

  void _startScan(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text('Scanning...'),
        content: SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    final cubit = context.read<ScanFridgeCubit>();
    cubit.stream.first.then((state) {
      if (!context.mounted) return;
      Navigator.of(context).pop();

      final products = state.products;
      FridgeData().products = products;

      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Products Found'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: products.isNotEmpty
                ? products.map((p) => Text('• $p')).toList()
                : [const Text('No products found')],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
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
          onPressed: () => _startScan(context),
          text: 'Start\nScanning\nFridge',
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
