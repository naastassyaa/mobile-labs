import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:test_project/pages/qr_scan/qr_scan_cubit.dart';

class QRScanPage extends StatelessWidget {
  final String password;
  static const _endpoint = 'http://192.168.1.150/configure';

  const QRScanPage({required this.password, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrScanCubit>(
      create: (_) => QrScanCubit(endpoint: _endpoint),
      child: _QRScanView(password: password),
    );
  }
}

class _QRScanView extends StatelessWidget {
  final String password;
  final GlobalKey qrKey = GlobalKey();

  _QRScanView({required this.password});

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrScanCubit, QrScanState>(
      listener: (context, state) async {
        if (state.status == QrScanStatus.scanning) {
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
        } else if (state.status == QrScanStatus.success) {
          Navigator.of(context).pop();
          await showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('MCU replied'),
              content: Text('Text: ${state.payload}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state.status == QrScanStatus.failure) {
          Navigator.of(context).pop();
          await showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.error ?? 'Unknown error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan QR')),
        body: QRView(
          key: qrKey,
          onQRViewCreated: (ctrl) =>
              context.read<QrScanCubit>().startScan(ctrl, password),
        ),
      ),
    );
  }
}
