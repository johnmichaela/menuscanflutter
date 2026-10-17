// import 'dart:async';
// import 'package:ballon/models/subscription_models.dart';
// import 'package:ballon/services/subscription_service.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({super.key});

//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   final _service = SubscriptionService();

//   bool _loading = true;
//   bool _processing = false;
//   String? _error;

//   List<SubscriptionPlan> _plans = [];
//   SubscriptionInfo _info = SubscriptionInfo.empty();
//   List<PaymentRecord> _history = [];
//   int _selectedMonths = 1;

//   // Live countdown
//   Timer? _ticker;
//   DateTime? _now;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   @override
//   void dispose() {
//     _ticker?.cancel();
//     super.dispose();
//   }

//   Future<void> _load() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final data = await _service.fetchSubscription();
//       final plans = (data['plans'] as List? ?? [])
//           .map((e) => SubscriptionPlan.fromJson(e))
//           .toList();
//       final info = SubscriptionInfo.fromJson(data);
//       final history = (data['recent_transactions'] as List? ?? [])
//           .map((e) => PaymentRecord.fromJson(e))
//           .toList();

//       final defaultMonths =
//           (data['default_plan_months'] ?? (plans.isNotEmpty ? plans.first.months : 1)) as int;
// print('Default plan months: $defaultMonths');
// print('Available plans: ${plans.map((p) => p.months).toList()}');
// print('Subscription info: hasActive=${info.hasActive}, inGracePeriod=${info.inGracePeriod}, statusLabel=${info.statusLabel}');
//       setState(() {
//         _plans = plans;
//         _info = info;
//         _history = history;
//         _selectedMonths = defaultMonths;
//         _loading = false;
//       });

//       _startTicker();
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }

//   void _startTicker() {
//     _ticker?.cancel();
//     if (_info.currentPeriodEnd == null) return;
//     _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
//       if (!mounted) return;
//       setState(() => _now = DateTime.now());
//     });
//   }

//   ({int d, int h, int m}) _remaining() {
//     final end = _info.currentPeriodEnd;
//     if (end == null) return (d: 0, h: 0, m: 0);
//     final now = _now ?? DateTime.now();
//     final diff = end.difference(now);
//     if (diff.isNegative) return (d: 0, h: 0, m: 0);
//     return (
//       d: diff.inDays,
//       h: diff.inHours % 24,
//       m: diff.inMinutes % 60,
//     );
//   }

//   Future<void> _pay() async {
//     setState(() => _processing = true);
//     try {
//       final link = await _service.createPayment(_selectedMonths);
//       final uri = Uri.parse(link);
//       if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//         throw 'Could not open checkout';
//       }
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Complete the payment in your browser, then come back.'),
//             backgroundColor: Colors.blueGrey,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _processing = false);
//     }
//   }

//   Future<void> _cancel() async {
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Cancel subscription?'),
//         content: const Text(
//             'Your subscription stays active until the current period ends.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Keep it'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Cancel subscription'),
//           ),
//         ],
//       ),
//     );
//     if (ok != true) return;

//     try {
//       await _service.cancelSubscription();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Subscription cancelled'),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         await _load();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('$e'), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).primaryColor;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: primary,
//         elevation: 0,
//         title: const Text(
//           'Subscription',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _loading ? null : _load,
//           ),
//         ],
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//               ? _errorView(primary)
//               : RefreshIndicator(
//                   onRefresh: _load,
//                   child: ListView(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//                     children: [
//                       _statusCard(primary),
//                       const SizedBox(height: 22),
//                       _sectionTitle(_info.hasActive
//                           ? 'Extend your subscription'
//                           : 'Choose a plan'),
//                       const SizedBox(height: 12),
//                       _planGrid(primary),
//                       const SizedBox(height: 20),
//                       _payButton(primary),
//                       const SizedBox(height: 10),
//                       Center(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Icon(Icons.shield_outlined,
//                                 size: 14, color: Colors.black45),
//                             SizedBox(width: 6),
//                             Text(
//                               'Secure payment via Flutterwave',
//                               style: TextStyle(
//                                   fontSize: 12, color: Colors.black45),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       _sectionTitle('Payment history'),
//                       const SizedBox(height: 12),
//                       _historyCard(),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   // =========================================================
//   //  STATUS CARD
//   // =========================================================
//   Widget _statusCard(Color primary) {
//     final rem = _remaining();
//     final color = _statusColor(_info.statusColor);

//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'CURRENT STATUS',
//                       style: TextStyle(
//                         fontSize: 11,
//                         letterSpacing: 1,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       _info.hasActive
//                           ? 'Active Subscription'
//                           : _info.inGracePeriod
//                               ? 'Grace Period'
//                               : 'No Active Subscription',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _pill(_info.statusLabel, color),
//             ],
//           ),

//           if (_info.hasActive) ...[
//             const SizedBox(height: 18),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(999),
//               child: LinearProgressIndicator(
//                 value: (_info.progress.clamp(0, 100)) / 100,
//                 minHeight: 8,
//                 backgroundColor: const Color(0xFFF1F5F9),
//                 valueColor: const AlwaysStoppedAnimation(Color(0xFF16A34A)),
//               ),
//             ),
//             const SizedBox(height: 18),
//             Row(
//               children: [
//                 _countBox(rem.d, 'DAYS'),
//                 const SizedBox(width: 10),
//                 _countBox(rem.h, 'HOURS'),
//                 const SizedBox(width: 10),
//                 _countBox(rem.m, 'MINUTES'),
//               ],
//             ),
//             const SizedBox(height: 18),
//             _metaGrid(),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: _cancel,
//                 icon: const Icon(Icons.cancel_outlined, size: 18),
//                 label: const Text('Cancel Subscription'),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: Colors.red,
//                   side: const BorderSide(color: Colors.red),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//           ] else if (_info.inGracePeriod) ...[
//             const SizedBox(height: 12),
//             Text(
//               'Your subscription expired but you still have a 3-day grace period. Renew to keep your profile visible.',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.orange.shade800,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ] else ...[
//             const SizedBox(height: 12),
//             const Text(
//               'Choose a plan below to make your business visible to customers.',
//               style: TextStyle(fontSize: 13, ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _metaGrid() {
//     return Row(
//       children: [
//         Expanded(
//           child: _metaItem(
//             'Started',
//             _info.currentPeriodStart != null
//                 ? DateFormat('MMM d, y').format(_info.currentPeriodStart!)
//                 : '—',
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _metaItem(
//             'Expires',
//             _info.currentPeriodEnd != null
//                 ? DateFormat('MMM d, y').format(_info.currentPeriodEnd!)
//                 : '—',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _metaItem(String k, String v) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             k.toUpperCase(),
//             style: const TextStyle(
//               fontSize: 10,
//               letterSpacing: 0.6,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             v,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _countBox(int value, String label) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(
//               '$value',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w800,
//                 height: 1,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 10,
//                 letterSpacing: 0.6,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _pill(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 7,
//             height: 7,
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               color: color,
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _statusColor(String c) {
//     switch (c) {
//       case 'success':
//         return const Color(0xFF16A34A);
//       case 'warning':
//         return const Color(0xFFF59E0B);
//       case 'danger':
//         return const Color(0xFFDC2626);
//       default:
//         return const Color(0xFF64748B);
//     }
//   }

//   // =========================================================
//   //  PLANS
//   // =========================================================
//   Widget _planGrid(Color primary) {
//     if (_plans.isEmpty) {
//       return const Card(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Text('No plans available.'),
//         ),
//       );
//     }
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 12,
//       mainAxisSpacing: 12,
//       childAspectRatio: 1.15,
//       children: _plans.map((p) => _planCard(p, primary)).toList(),
//     );
//   }

//   Widget _planCard(SubscriptionPlan plan, Color primary) {
//     final selected = plan.months == _selectedMonths;
//     return InkWell(
//       onTap: () => setState(() => _selectedMonths = plan.months),
//       borderRadius: BorderRadius.circular(16),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           border: Border.all(
//             color: selected ? primary : const Color.fromARGB(33, 142, 142, 143),
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: selected
//               ? [
//                   BoxShadow(
//                     color: primary.withOpacity(0.15),
//                     blurRadius: 14,
//                     offset: const Offset(0, 6),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${plan.months} MONTH${plan.months > 1 ? 'S' : ''}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: primary,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 0.6,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   plan.label,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     // color: Color(0xFF0F172A),
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   plan.price,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w800,
//                     // color: Color(0xFF0F172A),
//                     height: 1,
//                   ),
//                 ),
//                 Text(
//                   plan.priceDisplay.replaceFirst('${plan.price} ', ''),
//                   style: const TextStyle(
//                     fontSize: 12,
//                     // color: Colors.black45,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             if (selected)
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: Container(
//                   width: 22,
//                   height: 22,
//                   decoration: BoxDecoration(
//                     color: primary,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.check,
//                       color: Colors.white, size: 14),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // =========================================================
//   //  PAY BUTTON
//   // =========================================================
//   Widget _payButton(Color primary) {
//     final plan = _plans.firstWhere(
//       (p) => p.months == _selectedMonths,
//       orElse: () => _plans.isNotEmpty ? _plans.first : SubscriptionPlan(
//         months: 0, price: '0', label: '', priceDisplay: '',
//       ),
//     );

//     return SizedBox(
//       height: 54,
//       child: ElevatedButton(
//         onPressed: _processing || _plans.isEmpty ? null : _pay,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primary,
//           elevation: 4,
//           shadowColor: primary.withOpacity(0.35),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         child: _processing
//             ? const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2.5,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.lock_outline,
//                       color: Colors.white, size: 18),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Pay ${plan.priceDisplay}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   // =========================================================
//   //  HISTORY
//   // =========================================================
//   Widget _historyCard() {
//     if (_history.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(28),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
//         ),
//         child: Column(
//           children: const [
//             Icon(Icons.receipt_long_outlined,
//                 size: 40, color: Color(0xFFCBD5E1)),
//             SizedBox(height: 10),
//             Text(
//               'No payments yet',
//               style: TextStyle(fontSize: 14, ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
//       ),
//       child: Column(
//         children: List.generate(_history.length, (i) {
//           final rec = _history[i];
//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF1F5F9),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(Icons.receipt_outlined,
//                           size: 20, color: Color(0xFF475569)),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${rec.months} Month${rec.months > 1 ? 's' : ''} plan',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF0F172A),
//                             ),
//                           ),
//                           const SizedBox(height: 3),
//                           Text(
//                             DateFormat('MMM d, y • HH:mm')
//                                 .format(rec.createdAt),
//                             style: const TextStyle(
//                                 fontSize: 11, color: Colors.black45),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           '${rec.amount} ${rec.currency}',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF0F172A),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         _statusBadge(rec.status),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               if (i < _history.length - 1)
//                 const Divider(height: 1, indent: 16, endIndent: 16),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Widget _statusBadge(String status) {
//     Color color;
//     switch (status) {
//       case 'succeeded':
//       case 'active':
//         color = const Color(0xFF16A34A);
//         break;
//       case 'pending':
//         color = const Color(0xFFF59E0B);
//         break;
//       case 'failed':
//       case 'canceled':
//         color = const Color(0xFFDC2626);
//         break;
//       default:
//         color = const Color(0xFF64748B);
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Text(
//         status[0].toUpperCase() + status.substring(1),
//         style: TextStyle(
//           color: color,
//           fontSize: 10,
//           fontWeight: FontWeight.w800,
//           letterSpacing: 0.4,
//         ),
//       ),
//     );
//   }

//   // =========================================================
//   //  COMMON
//   // =========================================================
//   Widget _sectionTitle(String t) {
//     return Text(
//       t,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w800,
       
//         letterSpacing: -0.2,
//       ),
//     );
//   }

//   Widget _errorView(Color primary) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 60, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               _error!,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _load,
//               style: ElevatedButton.styleFrom(backgroundColor: primary),
//               child: const Text('Retry',
//                   style: TextStyle()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ballon/models/subscription_models.dart';
import 'package:ballon/services/subscription_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _service = SubscriptionService();

  bool _loading = true;
  bool _processing = false;
  String? _error;

  List<SubscriptionPlan> _plans = [];
  SubscriptionInfo _info = SubscriptionInfo.empty();
  List<PaymentRecord> _history = [];
  int _selectedMonths = 1;

  Timer? _ticker;
  DateTime? _now;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _service.fetchSubscription();
      final plans = (data['plans'] as List? ?? [])
          .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
          .toList();
      final info = SubscriptionInfo.fromJson(data);
      final history = (data['recent_transactions'] as List? ?? [])
          .map((e) => PaymentRecord.fromJson(e as Map<String, dynamic>))
          .toList();

      final defaultMonths = (data['default_plan_months'] ?? 1) as int;
      setState(() {
        _plans = plans;
        _info = info;
        _history = history;
        _selectedMonths = defaultMonths;
        _loading = false;
      });
      _startTicker();
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    if (_info.currentPeriodEnd == null) return;
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  ({int d, int h, int m}) _remaining() {
    final end = _info.currentPeriodEnd;
    if (end == null) return (d: 0, h: 0, m: 0);
    final now = _now ?? DateTime.now();
    final diff = end.difference(now);
    if (diff.isNegative) return (d: 0, h: 0, m: 0);
    return (d: diff.inDays, h: diff.inHours % 24, m: diff.inMinutes % 60);
  }

  // ---------------- PAYMENT FLOW ----------------
  Future<void> _pay() async {
    final method = await _pickPaymentMethod();
    if (method == null) return;

    if (method == 'card') {
      await _payWithCard();
    } else {
      await _payWithMobileMoney();
    }
  }

  Future<String?> _pickPaymentMethod() async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Choose payment method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Card'),
              subtitle: const Text('Visa, Mastercard, Verve'),
              onTap: () => Navigator.pop(context, 'card'),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text('Mobile Money'),
              subtitle: const Text('Airtel, Tigo, Halopesa, Vodacom'),
              onTap: () => Navigator.pop(context, 'mobile_money'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _payWithCard() async {
    final cardData = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _CardInputSheet(),
    );
    if (cardData == null) return;

    setState(() => _processing = true);
    try {
      final response = await _service.createPayment(
        months: _selectedMonths,
        methodType: 'card',
        card: cardData,
      );
      await _handleChargeResponse(response);
    } catch (e) {
      _snack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _payWithMobileMoney() async {
    final mmData = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _MobileMoneyInputSheet(),
    );
    if (mmData == null) return;

    setState(() => _processing = true);
    try {
      final response = await _service.createPayment(
        months: _selectedMonths,
        methodType: 'mobile_money',
        mobileMoney: mmData,
      );
      final nextAction = response['next_action'] as Map<String, dynamic>? ?? {};
      final txRef = response['tx_ref'] as String;

      if (nextAction['type'] == 'payment_instruction' ||
          nextAction['type'] == 'payment_instructions') {
        final instruction = nextAction['payment_instruction']?['message']?.toString() ??
            nextAction['message']?.toString() ??
            'Please check your phone and complete the payment.';
        _showMobileMoneyPending(instruction, txRef);
      } else {
        // Poll verification
        _showMobileMoneyPending('Complete the payment on your phone.', txRef);
      }
    } catch (e) {
      _snack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _handleChargeResponse(Map<String, dynamic> response) async {
    final chargeId = response['charge_id'] as String?;
    final txRef = response['tx_ref'] as String;
    final nextAction = response['next_action'] as Map<String, dynamic>? ?? {};
    final type = nextAction['type']?.toString();

    if (type == 'redirect_url') {
      final url = nextAction['redirect_url']?.toString();
      if (url != null) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        _showRedirectPending(txRef);
      }
      return;
    }

    if (type == 'requires_pin' || type == 'requires_otp') {
      final isPin = type == 'requires_pin';
      final value = await _askForValue(
        title: isPin ? 'Enter Card PIN' : 'Enter OTP',
        subtitle: isPin
            ? 'Enter the PIN for your card.'
            : 'A one-time password was sent to your phone.',
        keyboardType: TextInputType.number,
        obscure: isPin,
        maxLength: isPin ? 4 : 6,
      );
      if (value == null || value.isEmpty) return;

      final result = await _service.authorizeCharge(
        chargeId: chargeId!,
        actionType: isPin ? 'pin' : 'otp',
        value: value,
      );

      final resultStatus = result['status']?.toString();
      final resultNext = result['next_action'] as Map<String, dynamic>? ?? {};
      final resultNextType = resultNext['type']?.toString();

      if (resultStatus == 'successful' || resultStatus == 'completed') {
        _snack('Payment successful!');
        await _load();
      } else if (resultNextType == 'requires_otp') {
        // PIN was accepted, now OTP needed
        await _handleChargeResponse({
          'charge_id': chargeId,
          'tx_ref': txRef,
          'next_action': resultNext,
        });
      } else if (resultNextType == 'redirect_url') {
        final url = resultNext['redirect_url']?.toString();
        if (url != null) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          _showRedirectPending(txRef);
        }
      } else {
        _snack('Payment failed: ${result['error'] ?? resultStatus ?? 'unknown'}',
            isError: true);
      }
      return;
    }

    _snack('Unsupported action: $type', isError: true);
  }

  Future<String?> _askForValue({
    required String title,
    required String subtitle,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    int? maxLength,
  }) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: keyboardType,
              obscureText: obscure,
              maxLength: maxLength,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showRedirectPending(String txRef) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Complete Payment'),
        content: const Text(
            'Finish the payment in your browser, then return and tap Verify.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _verifyAfterRedirect(txRef);
            },
            child: const Text('Verify Now'),
          ),
        ],
      ),
    );
  }

  void _showMobileMoneyPending(String instruction, String txRef) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Complete Payment'),
        content: Text(instruction),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _verifyAfterRedirect(txRef);
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyAfterRedirect(String txRef) async {
    try {
      final result = await _service.verifyCharge(txRef);
      final status = result['status']?.toString();
      if (status == 'successful' || status == 'completed') {
        _snack('Payment successful!');
        await _load();
      } else {
        _snack('Payment status: $status');
        await _load();
      }
    } catch (e) {
      _snack('Verification failed: $e', isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _cancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel subscription?'),
        content: const Text(
            'Your subscription stays active until the current period ends.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel subscription'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _service.cancelSubscription();
      _snack('Subscription cancelled');
      await _load();
    } catch (e) {
      _snack('$e', isError: true);
    }
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: const Text('Subscription',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _errorView(primary)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      _statusCard(primary),
                      const SizedBox(height: 22),
                      _sectionTitle(_info.hasActive
                          ? 'Extend your subscription'
                          : 'Choose a plan'),
                      const SizedBox(height: 12),
                      _planGrid(primary),
                      const SizedBox(height: 20),
                      _payButton(primary),
                      const SizedBox(height: 10),
                      const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield_outlined, size: 14, color: Colors.black45),
                            SizedBox(width: 6),
                            Text('Secure payment via Flutterwave',
                                style: TextStyle(fontSize: 12, color: Colors.black45)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _sectionTitle('Payment history'),
                      const SizedBox(height: 12),
                      _historyCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _statusCard(Color primary) {
    final rem = _remaining();
    final color = _statusColor(_info.statusColor);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CURRENT STATUS',
                        style: TextStyle(fontSize: 11, letterSpacing: 1,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      _info.hasActive
                          ? 'Active Subscription'
                          : _info.inGracePeriod
                              ? 'Grace Period'
                              : 'No Active Subscription',
                      style: const TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w800, letterSpacing: -0.3),
                    ),
                  ],
                ),
              ),
              _pill(_info.statusLabel, color),
            ],
          ),
          if (_info.hasActive) ...[
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (_info.progress.clamp(0, 100)) / 100,
                minHeight: 8,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF16A34A)),
              ),
            ),
            const SizedBox(height: 18),
            Row(children: [
              _countBox(rem.d, 'DAYS'),
              const SizedBox(width: 10),
              _countBox(rem.h, 'HOURS'),
              const SizedBox(width: 10),
              _countBox(rem.m, 'MINUTES'),
            ]),
            const SizedBox(height: 18),
            _metaGrid(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _cancel,
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('Cancel Subscription'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ] else if (_info.inGracePeriod) ...[
            const SizedBox(height: 12),
            Text(
              'Your subscription expired but you still have a 3-day grace period. Renew to keep your profile visible.',
              style: TextStyle(fontSize: 13, color: Colors.orange.shade800,
                  fontWeight: FontWeight.w500),
            ),
          ] else ...[
            const SizedBox(height: 12),
            const Text(
              'Choose a plan below to make your business visible to customers.',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metaGrid() => Row(children: [
    Expanded(child: _metaItem('Started',
        _info.currentPeriodStart != null
            ? DateFormat('MMM d, y').format(_info.currentPeriodStart!) : '—')),
    const SizedBox(width: 10),
    Expanded(child: _metaItem('Expires',
        _info.currentPeriodEnd != null
            ? DateFormat('MMM d, y').format(_info.currentPeriodEnd!) : '—')),
  ]);

  Widget _metaItem(String k, String v) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(k.toUpperCase(), style: const TextStyle(fontSize: 10,
          letterSpacing: 0.6, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(v, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _countBox(int value, String label) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Text('$value', style: const TextStyle(fontSize: 22,
            fontWeight: FontWeight.w800, height: 1)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10,
            letterSpacing: 0.6, fontWeight: FontWeight.w700)),
      ]),
    ),
  );

  Widget _pill(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 7, height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(text, style: TextStyle(color: color, fontSize: 12,
          fontWeight: FontWeight.w700)),
    ]),
  );

  Color _statusColor(String c) {
    switch (c) {
      case 'success': return const Color(0xFF16A34A);
      case 'warning': return const Color(0xFFF59E0B);
      case 'danger': return const Color(0xFFDC2626);
      default: return const Color(0xFF64748B);
    }
  }

  Widget _planGrid(Color primary) {
    if (_plans.isEmpty) {
      return const Card(child: Padding(padding: EdgeInsets.all(24),
          child: Text('No plans available.')));
    }
    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.15,
      children: _plans.map((p) => _planCard(p, primary)).toList(),
    );
  }

  Widget _planCard(SubscriptionPlan plan, Color primary) {
    final selected = plan.months == _selectedMonths;
    return InkWell(
      onTap: () => setState(() => _selectedMonths = plan.months),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: selected ? primary : const Color.fromARGB(33, 142, 142, 143),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected ? [
            BoxShadow(color: primary.withOpacity(0.15),
                blurRadius: 14, offset: const Offset(0, 6)),
          ] : null,
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${plan.months} MONTH${plan.months > 1 ? 'S' : ''}',
                style: TextStyle(fontSize: 12, color: primary,
                    fontWeight: FontWeight.w800, letterSpacing: 0.6)),
            const SizedBox(height: 6),
            Text(plan.label, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(plan.price, style: const TextStyle(fontSize: 22,
                fontWeight: FontWeight.w800, height: 1)),
            Text(plan.priceDisplay.replaceFirst('${plan.price} ', ''),
                style: const TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ]),
          if (selected) Positioned(top: 0, right: 0,
            child: Container(width: 22, height: 22,
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 14))),
        ]),
      ),
    );
  }

  Widget _payButton(Color primary) {
    final plan = _plans.firstWhere(
      (p) => p.months == _selectedMonths,
      orElse: () => _plans.isNotEmpty ? _plans.first :
          SubscriptionPlan(months: 0, price: '0', label: '', priceDisplay: ''),
    );
    return SizedBox(height: 54, child: ElevatedButton(
      onPressed: _processing || _plans.isEmpty ? null : _pay,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary, elevation: 4,
        shadowColor: primary.withOpacity(0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: _processing
          ? const SizedBox(width: 22, height: 22,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.lock_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('Pay ${plan.priceDisplay}', style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            ]),
    ));
  }

  Widget _historyCard() {
    if (_history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
        ),
        child: const Column(children: [
          Icon(Icons.receipt_long_outlined, size: 40, color: Color(0xFFCBD5E1)),
          SizedBox(height: 10),
          Text('No payments yet', style: TextStyle(fontSize: 14)),
        ]),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(17, 194, 195, 196)),
      ),
      child: Column(children: List.generate(_history.length, (i) {
        final rec = _history[i];
        return Column(children: [
          Padding(padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.receipt_outlined, size: 20,
                    color: Color(0xFF475569))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${rec.months} Month${rec.months > 1 ? 's' : ''} plan',
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const SizedBox(height: 3),
                  Text(DateFormat('MMM d, y • HH:mm').format(rec.createdAt),
                      style: const TextStyle(fontSize: 11, color: Colors.black45)),
                ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${rec.amount} ${rec.currency}',
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                _statusBadge(rec.status),
              ]),
            ])),
          if (i < _history.length - 1)
            const Divider(height: 1, indent: 16, endIndent: 16),
        ]);
      })),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'succeeded': case 'active':
        color = const Color(0xFF16A34A); break;
      case 'pending':
        color = const Color(0xFFF59E0B); break;
      case 'failed': case 'canceled':
        color = const Color(0xFFDC2626); break;
      default:
        color = const Color(0xFF64748B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999)),
      child: Text(status[0].toUpperCase() + status.substring(1),
          style: TextStyle(color: color, fontSize: 10,
              fontWeight: FontWeight.w800, letterSpacing: 0.4)),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
          letterSpacing: -0.2));

  Widget _errorView(Color primary) => Center(
    child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, size: 60, color: Colors.red),
        const SizedBox(height: 16),
        Text(_error!, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _load,
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('Retry')),
      ]),
    ),
  );
}

// ============================================================
// CARD INPUT SHEET
// ============================================================
class _CardInputSheet extends StatefulWidget {
  const _CardInputSheet();
  @override
  State<_CardInputSheet> createState() => _CardInputSheetState();
}

class _CardInputSheetState extends State<_CardInputSheet> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  final _expMonthCtrl = TextEditingController();
  final _expYearCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expMonthCtrl.dispose();
    _expYearCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'number': _numberCtrl.text.replaceAll(' ', ''),
      'expiry_month': _expMonthCtrl.text.padLeft(2, '0'),
      'expiry_year': _expYearCtrl.text,
      'cvv': _cvvCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Card Details', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (v) => (v == null || v.replaceAll(' ', '').length < 12)
                    ? 'Enter a valid card number' : null,
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextFormField(
                  controller: _expMonthCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'MM',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 2,
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                )),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(
                  controller: _expYearCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'YY',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 2,
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                )),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(
                  controller: _cvvCtrl,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 4,
                  validator: (v) => (v == null || v.length < 3) ? 'Invalid' : null,
                )),
              ]),
              const SizedBox(height: 20),
              SizedBox(height: 50, child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MOBILE MONEY INPUT SHEET
// ============================================================
class _MobileMoneyInputSheet extends StatefulWidget {
  const _MobileMoneyInputSheet();
  @override
  State<_MobileMoneyInputSheet> createState() => _MobileMoneyInputSheetState();
}

class _MobileMoneyInputSheetState extends State<_MobileMoneyInputSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  String _network = 'AIRTEL';

  static const _networks = ['AIRTEL', 'TIGO', 'HALOPESA', 'VODACOM'];

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'network': _network,
      'phone_number': _phoneCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Mobile Money', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _network,
                decoration: const InputDecoration(
                  labelText: 'Network',
                  border: OutlineInputBorder(),
                ),
                items: _networks.map((n) => DropdownMenuItem(
                    value: n, child: Text(n))).toList(),
                onChanged: (v) => setState(() => _network = v ?? 'AIRTEL'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '0782835136',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) => (v == null || v.trim().length < 9)
                    ? 'Enter a valid phone number' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(height: 50, child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}