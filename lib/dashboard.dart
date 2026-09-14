import 'package:flutter/material.dart';
import 'services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? stats;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await ApiService.getDashboardStats();
      setState(() => stats = res);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: loading
              ? const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()))
              : error != null
                  ? Column(
                      children: [
                        Text('Error: $error'),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _loadStats, child: const Text('Retry')),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _statCard('Events', stats?['events_count']?.toString() ?? '0'),
                            _statCard('Comments', stats?['comments_count']?.toString() ?? '0'),
                            _statCard('Shares', stats?['shares_count']?.toString() ?? '0'),
                            _statCard('Attendees', stats?['attendees_count']?.toString() ?? '0'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Raw data', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(stats.toString()),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
      ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
