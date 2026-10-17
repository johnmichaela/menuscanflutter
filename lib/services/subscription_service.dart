// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class SubscriptionService {
//   static const String _base = 'https://qopera.app';

//   Future<String?> _token() async {
//     final p = await SharedPreferences.getInstance();
//     return p.getString('token');
//   }

//   Future<Map<String, dynamic>> fetchSubscription() async {
//     final token = await _token();
//     print('fetchSubscription: token=$token');
//     final res = await http.get(
//       Uri.parse('$_base/prof/subscription/api/'),
//       headers: {
//         'Authorization': 'Token $token',
//         'Accept': 'application/json',
//       },
//     );

//     print('fetchSubscription: ${res.statusCode} ${res.body}');
//     if (res.statusCode == 200) return jsonDecode(res.body);
//     throw Exception('Failed to load subscription (${res.statusCode})');
//   }

//   Future<String> createPayment(int months) async {
//     final token = await _token();
//     final res = await http.post(
//       Uri.parse('$_base/prof/flutterwave/create-payment/'),
//       headers: {
//         'Authorization': 'Token $token',
//         'Accept': 'application/json',
//       },
//       body: {'months': months.toString()},
//     );
//     final body = jsonDecode(res.body);
//     print('createPayment: ${res.statusCode} ${res.body}');
//     if (res.statusCode == 200 && body['link'] != null) {
//       return body['link'] as String;
//     }
//     throw Exception(body['error'] ?? 'Failed to create payment');
//   }

//   Future<void> cancelSubscription() async {
//     final token = await _token();
//     final res = await http.post(
//       Uri.parse('$_base/prof/subscription/cancel/'),
//       headers: {
//         'Authorization': 'Token $token',
//         'Accept': 'application/json',
//       },
//     );
//     if (res.statusCode >= 400) {
//       throw Exception('Failed to cancel subscription');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _base = 'https://qopera.app';

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Token $token',
    };
  }

  Future<Map<String, dynamic>> fetchSubscription() async {
    final res = await http.get(
      Uri.parse('$_base/prof/api/subscription/'),
      headers: await _headers(),
    ).timeout(const Duration(seconds: 20));

    if (res.statusCode != 200) {
      throw Exception('Failed to load subscription (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Returns the full response including charge_id and next_action.
  Future<Map<String, dynamic>> createPayment({
    required int months,
    required String methodType, // 'card' or 'mobile_money'
    Map<String, dynamic>? card,
    Map<String, dynamic>? mobileMoney,
  }) async {
    final body = <String, dynamic>{
      'months': months,
      'method_type': methodType,
    };
    if (card != null) body['card'] = card;
    if (mobileMoney != null) body['mobile_money'] = mobileMoney;

    final res = await http.post(
      Uri.parse('$_base/prof/api/subscription/flutterwave/create/'),
      headers: await _headers(),
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 30));

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      throw Exception(data['error'] ?? 'Payment init failed (${res.statusCode})');
    }
    return data;
  }

  Future<Map<String, dynamic>> authorizeCharge({
    required String chargeId,
    required String actionType,
    required String value,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/prof/api/subscription/flutterwave/authorize/'),
      headers: await _headers(),
      body: jsonEncode({
        'charge_id': chargeId,
        'action_type': actionType,
        'value': value,
      }),
    ).timeout(const Duration(seconds: 30));

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      throw Exception(data['error'] ?? 'Authorization failed');
    }
    return data;
  }

  Future<Map<String, dynamic>> verifyCharge(String txRef) async {
    final res = await http.get(
      Uri.parse('$_base/prof/api/subscription/flutterwave/verify/$txRef/'),
      headers: await _headers(),
    ).timeout(const Duration(seconds: 20));

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      throw Exception(data['error'] ?? 'Verification failed');
    }
    return data;
  }

  Future<void> cancelSubscription() async {
    final res = await http.post(
      Uri.parse('$_base/prof/api/subscription/cancel/'),
      headers: await _headers(),
    ).timeout(const Duration(seconds: 20));

    if (res.statusCode != 200) {
      throw Exception('Cancel failed (${res.statusCode})');
    }
  }
}