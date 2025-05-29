import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/pages/history/history_cubit.dart';

class ScanHistoryPage extends StatelessWidget {
  static const _historyEndpoint = 'http://192.168.1.150/history';

  const ScanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanHistoryCubit>(
      create: (_) => ScanHistoryCubit(endpoint: _historyEndpoint),
      child: const _ScanHistoryView(),
    );
  }
}

class _ScanHistoryView extends StatelessWidget {
  const _ScanHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History of QR-code scans')),
      body: BlocBuilder<ScanHistoryCubit, ScanHistoryState>(
        builder: (context, state) {
          switch (state.status) {
            case HistoryStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case HistoryStatus.failure:
              return const Center(child: Text('Error: \${state.errorMessage}'));
            case HistoryStatus.success:
              final history = state.history;
              if (history.isEmpty) {
                return const Center(child: Text('Nothing to show'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: Text('${i + 1}'),
                    title: Text(history[i]),
                  );
                },
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
