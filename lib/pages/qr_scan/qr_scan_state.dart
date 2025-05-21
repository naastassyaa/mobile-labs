part of 'qr_scan_cubit.dart';

enum QrScanStatus { initial, scanning, success, failure }

@immutable
class QrScanState {
  final QrScanStatus status;
  final String? payload;
  final String? error;

  const QrScanState({
    this.status = QrScanStatus.initial,
    this.payload,
    this.error,
  });

  QrScanState copyWith({
    QrScanStatus? status,
    String? payload,
    String? error,
  }) {
    return QrScanState(
      status: status ?? this.status,
      payload: payload ?? this.payload,
      error: error ?? this.error,
    );
  }
}
