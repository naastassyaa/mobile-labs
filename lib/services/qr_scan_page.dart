import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScanPage extends StatefulWidget {
  final String password;
  const QRScanPage({required this.password, super.key});

  @override
  QRScanPageState createState() => QRScanPageState();
}

class QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  bool _handled = false;
  static const _mcuConfigEndpoint = 'http://192.168.1.150/configure';

  @override
  void reassemble() {
    super.reassemble();
    controller
      ?..pauseCamera()
      ..resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) async {
      if (_handled) return;
      _handled = true;
      await ctrl.pauseCamera();

      final qrString = scanData.code;
      if (qrString == null) return;

      try {
        final uri = Uri.parse(_mcuConfigEndpoint);
        final resp = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'password': widget.password,
            'payload': qrString,
          }),
        ).timeout(const Duration(seconds: 3));

        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        if (resp.statusCode == 200 && data['status'] == 'ok') {
          if (!mounted) return;
          await showDialog<void>(
            context: context,
            builder: (_) =>
                AlertDialog(
                  title: const Text('MCU replied'),
                  content: Text('Text: ${data['payload']}'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('ОК'),
                    ),
                  ],
                ),
          );
        } else {
          final err = data['error'] ?? 'unknown error';
          if (!mounted) return;
          await showDialog<void>(
            context: context,
            builder: (_) =>
                AlertDialog(
                  title: const Text('Error'),
                  content: Text('MCU error: $err'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('ОК'),
                    ),
                  ],
                ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: const Text('Communication error'),
                content: Text('$e'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('ОК'),
                  ),
                ],
              ),
        );
      }
    });
  }
}
