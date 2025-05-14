import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

part 'history_state.dart';

class ScanHistoryCubit extends Cubit<ScanHistoryState> {
  final String endpoint;

  ScanHistoryCubit({required this.endpoint})
      : super(const ScanHistoryState()) {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      final response = await http
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode != 200) {
        throw Exception('Failed to load history (${response.statusCode})');
      }
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      final items = data.map((e) => e.toString()).toList();
      emit(state.copyWith(
        status: HistoryStatus.success,
        history: items,
      ),);
    } catch (e) {
      emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: e.toString(),
      ),);
    }
  }
}
