import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

part 'qr_scan_state.dart';

class QrScanCubit extends Cubit<QrScanState> {
  final String endpoint;
  StreamSubscription<Barcode>? _scanSub;

  QrScanCubit({required this.endpoint}) : super(const QrScanState());

  void startScan(QRViewController controller, String password) {
    emit(state.copyWith(status: QrScanStatus.scanning));
    _scanSub = controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      _scanSub?.cancel();

      final qrString = scanData.code;
      if (qrString == null) {
        emit(state.copyWith(
          status: QrScanStatus.failure,
          error: 'Scanned data is null',
        ),);
        return;
      }

      try {
        final resp = await http
            .post(
          Uri.parse(endpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'password': password,
            'payload': qrString,
          }),
        )
            .timeout(const Duration(seconds: 3));

        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        if (resp.statusCode == 200 && data['status'] == 'ok') {
          emit(state.copyWith(
            status: QrScanStatus.success,
            payload: data['payload']?.toString(),
          ),);
        } else {
          final err = data['error']?.toString() ?? 'Unknown error';
          emit(state.copyWith(
            status: QrScanStatus.failure,
            error: 'MCU error: $err',
          ),);
        }
      } catch (e) {
        emit(state.copyWith(
          status: QrScanStatus.failure,
          error: e.toString(),
        ),);
      }
    });
  }

  @override
  Future<void> close() {
    _scanSub?.cancel();
    return super.close();
  }
}
