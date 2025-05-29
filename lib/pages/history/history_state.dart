part of 'history_cubit.dart';

enum HistoryStatus { initial, loading, success, failure }

@immutable
class ScanHistoryState {
  final HistoryStatus status;
  final List<String> history;
  final String? errorMessage;

  const ScanHistoryState({
    this.status = HistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  ScanHistoryState copyWith({
    HistoryStatus? status,
    List<String>? history,
    String? errorMessage,
  }) {
    return ScanHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }
}
