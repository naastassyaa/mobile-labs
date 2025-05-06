import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  State<ScanHistoryPage> createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  static const _historyEndpoint = 'http://192.168.1.150/history';

  late Future<List<String>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<List<String>> _fetchHistory() async {
    final resp = await http
        .get(Uri.parse(_historyEndpoint))
        .timeout(const Duration(seconds: 3));
    if (resp.statusCode != 200) {
      throw Exception('Failed to load history (${resp.statusCode})');
    }
    final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History of qr-code scans')),
      body: FutureBuilder<List<String>>(
        future: _historyFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final history = snap.data!;
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
        },
      ),
    );
  }
}
