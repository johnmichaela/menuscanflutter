// class SubscriptionPlan {
//   final int months;
//   final String price;
//   final String label;
//   final String priceDisplay;

//   SubscriptionPlan({
//     required this.months,
//     required this.price,
//     required this.label,
//     required this.priceDisplay,
//   });

//   factory SubscriptionPlan.fromJson(Map<String, dynamic> j) => SubscriptionPlan(
//         months: j['months'] as int,
//         price: j['price'].toString(),
//         label: j['label']?.toString() ?? '',
//         priceDisplay: j['price_display']?.toString() ?? '',
//       );
// }

// class SubscriptionInfo {
//   final bool hasActive;
//   final bool inGracePeriod;
//   final String statusLabel;
//   final String statusColor; // success | warning | danger
//   final int daysRemaining;
//   final int hoursRemaining;
//   final int minutesRemaining;
//   final double progress; // 0..100
//   final DateTime? currentPeriodStart;
//   final DateTime? currentPeriodEnd;
//   final int totalMonths;
//   final bool isVisible;

//   SubscriptionInfo({
//     required this.hasActive,
//     required this.inGracePeriod,
//     required this.statusLabel,
//     required this.statusColor,
//     required this.daysRemaining,
//     required this.hoursRemaining,
//     required this.minutesRemaining,
//     required this.progress,
//     required this.currentPeriodStart,
//     required this.currentPeriodEnd,
//     required this.totalMonths,
//     required this.isVisible,
//   });

//   factory SubscriptionInfo.empty() => SubscriptionInfo(
//         hasActive: false,
//         inGracePeriod: false,
//         statusLabel: 'No Active Subscription',
//         statusColor: 'danger',
//         daysRemaining: 0,
//         hoursRemaining: 0,
//         minutesRemaining: 0,
//         progress: 0,
//         currentPeriodStart: null,
//         currentPeriodEnd: null,
//         totalMonths: 0,
//         isVisible: false,
//       );

//   factory SubscriptionInfo.fromJson(Map<String, dynamic> j) => SubscriptionInfo(
//         hasActive: j['has_active'] == true,
//         inGracePeriod: j['in_grace_period'] == true,
//         statusLabel: j['status_label']?.toString() ?? 'Unknown',
//         statusColor: j['status_color']?.toString() ?? 'neutral',
//         daysRemaining: (j['days_remaining'] ?? 0) as int,
//         hoursRemaining: (j['hours_remaining'] ?? 0) as int,
//         minutesRemaining: (j['minutes_remaining'] ?? 0) as int,
//         progress: ((j['progress'] ?? 0) as num).toDouble(),
//         currentPeriodStart: j['current_period_start'] != null
//             ? DateTime.tryParse(j['current_period_start'])
//             : null,
//         currentPeriodEnd: j['current_period_end'] != null
//             ? DateTime.tryParse(j['current_period_end'])
//             : null,
//         totalMonths: (j['total_months'] ?? 0) as int,
//         isVisible: j['is_visible'] == true,
//       );
// }

// class PaymentRecord {
//   final String txRef;
//   final String provider;
//   final String amount;
//   final String currency;
//   final int months;
//   final String status;
//   final DateTime createdAt;

//   PaymentRecord({
//     required this.txRef,
//     required this.provider,
//     required this.amount,
//     required this.currency,
//     required this.months,
//     required this.status,
//     required this.createdAt,
//   });

//   factory PaymentRecord.fromJson(Map<String, dynamic> j) => PaymentRecord(
//         txRef: j['tx_ref']?.toString() ?? '',
//         provider: j['provider']?.toString() ?? '',
//         amount: j['amount']?.toString() ?? '0',
//         currency: j['currency']?.toString() ?? '',
//         months: (j['months'] ?? 0) as int,
//         status: j['status']?.toString() ?? 'pending',
//         createdAt: DateTime.tryParse(j['created_at']?.toString() ?? '') ??
//             DateTime.now(),
//       );
// }

class SubscriptionPlan {
  final int months;
  final String price;
  final String label;
  final String priceDisplay;

  SubscriptionPlan({
    required this.months,
    required this.price,
    required this.label,
    required this.priceDisplay,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> j) => SubscriptionPlan(
    months: j['months'] as int,
    price: j['price'].toString(),
    label: j['label'].toString(),
    priceDisplay: j['price_display'].toString(),
  );
}

class SubscriptionInfo {
  final bool hasActive;
  final bool inGracePeriod;
  final String statusLabel;
  final String statusColor;
  final double progress;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;

  SubscriptionInfo({
    required this.hasActive,
    required this.inGracePeriod,
    required this.statusLabel,
    required this.statusColor,
    required this.progress,
    this.currentPeriodStart,
    this.currentPeriodEnd,
  });

  factory SubscriptionInfo.empty() => SubscriptionInfo(
    hasActive: false, inGracePeriod: false, statusLabel: 'Expired',
    statusColor: 'danger', progress: 0,
  );

  factory SubscriptionInfo.fromJson(Map<String, dynamic> j) => SubscriptionInfo(
    hasActive: j['has_active'] == true,
    inGracePeriod: j['in_grace_period'] == true,
    statusLabel: (j['status_label'] ?? 'Expired').toString(),
    statusColor: (j['status_color'] ?? 'danger').toString(),
    progress: (j['progress'] as num?)?.toDouble() ?? 0,
    currentPeriodStart: j['current_period_start'] != null
        ? DateTime.tryParse(j['current_period_start'].toString()) : null,
    currentPeriodEnd: j['current_period_end'] != null
        ? DateTime.tryParse(j['current_period_end'].toString()) : null,
  );
}

class PaymentRecord {
  final String txRef;
  final String amount;
  final String currency;
  final int months;
  final String status;
  final DateTime createdAt;

  PaymentRecord({
    required this.txRef, required this.amount, required this.currency,
    required this.months, required this.status, required this.createdAt,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> j) => PaymentRecord(
    txRef: j['tx_ref'].toString(),
    amount: j['amount'].toString(),
    currency: j['currency'].toString(),
    months: j['months'] as int,
    status: j['status'].toString(),
    createdAt: DateTime.tryParse(j['created_at'].toString()) ?? DateTime.now(),
  );
}