// // pages/venue_list_screen.dart
// import 'dart:convert';

// import 'package:ballon/pagination/data/data_source/urls.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// // ============================================================
// // THEME
// // ============================================================
// class _C {
//   static const red = Color(0xFFDC2626);
//   static const border = Color(0xFFE5E7EB);
// }

// // ============================================================
// // MODEL — Venue
// // ============================================================
// class Venue {
//   final int? id;
//   final String name;
//   final String address;
//   final int capacity;

//   Venue({
//     this.id,
//     required this.name,
//     required this.address,
//     required this.capacity,
//   });

//   factory Venue.fromJson(Map<String, dynamic> json) => Venue(
//         id: json['id'] is int
//             ? json['id']
//             : int.tryParse('${json['id']}'),
//         name: (json['name'] ?? '').toString(),
//         address: (json['address'] ?? '').toString(),
//         capacity: json['capacity'] is int
//             ? json['capacity']
//             : int.tryParse('${json['capacity']}') ?? 0,
//       );
// }

// // ============================================================
// // SERVICE
// // ============================================================
// class VenueService {
//   static Future<Map<String, String>> _authHeaders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       if (token != null) 'Authorization': 'Token $token',
//     };
//   }

//   /// GET /events-timetable/api/venues/search/?q=<query>
//   static Future<List<Venue>> search(String query) async {
//     final uri = Uri.parse(
//       '${Urls.baseUrl}/events-timetable/api/venues/search/',
//     ).replace(queryParameters: {'q': query});

//     final res = await http.get(uri, headers: await _authHeaders());
//     if (res.statusCode != 200) {
//       throw Exception('Failed to search venues (${res.statusCode})');
//     }

//     final dynamic decoded = jsonDecode(res.body);
//     final List list = decoded is List ? decoded : (decoded['results'] ?? []);
//     return list
//         .whereType<Map>()
//         .map((e) => Venue.fromJson(Map<String, dynamic>.from(e)))
//         .toList();
//   }

//   /// GET /events-timetable/api/venues/  (fallback for listing all)
//   static Future<List<Venue>> list() async {
//     final uri = Uri.parse('${Urls.baseUrl}/events-timetable/api/venues/');
//     final res = await http.get(uri, headers: await _authHeaders());
//     if (res.statusCode != 200) {
//       throw Exception('Failed to load venues (${res.statusCode})');
//     }
//     final dynamic decoded = jsonDecode(res.body);
//     final List list = decoded is List ? decoded : (decoded['results'] ?? []);
//     return list
//         .whereType<Map>()
//         .map((e) => Venue.fromJson(Map<String, dynamic>.from(e)))
//         .toList();
//   }

//   /// POST /events-timetable/api/venues/create/
//   ///
//   /// Returns the created Venue on success.
//   /// Throws [VenueAlreadyExistsException] if the server rejects as duplicate.
//   static Future<Venue> create({
//     required String name,
//     required String address,
//     required int capacity,
//   }) async {
//     final uri =
//         Uri.parse('${Urls.baseUrl}/events-timetable/api/venues/create/');

//     final res = await http.post(
//       uri,
//       headers: await _authHeaders(),
//       body: jsonEncode({
//         'name': name,
//         'address': address,
//         'capacity': capacity,
//       }),
//     );

//     // Try to parse JSON body regardless of status code
//     dynamic body;
//     try {
//       body = jsonDecode(res.body);
//     } catch (_) {
//       body = null;
//     }

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       if (body is Map) {
//         return Venue.fromJson(Map<String, dynamic>.from(body));
//       }
//       throw Exception('Unexpected response from server');
//     }

//     // Detect "already exists" from the backend
//     if (res.statusCode == 400 || res.statusCode == 409) {
//       final msg = _extractError(body) ?? 'Venue already exists';
//       if (msg.toLowerCase().contains('exist') ||
//           msg.toLowerCase().contains('duplicate')) {
//         throw VenueAlreadyExistsException(msg);
//       }
//       throw Exception(msg);
//     }

//     throw Exception('Failed to create venue (${res.statusCode})');
//   }

//   /// Pull a human-readable error out of common DRF error shapes.
//   static String? _extractError(dynamic body) {
//     if (body == null) return null;

//     if (body is String) return body;

//     if (body is Map) {
//       // DRF: {"name": ["Venue with this name already exists."]}
//       for (final key in ['error', 'detail', 'message', 'non_field_errors']) {
//         final v = body[key];
//         if (v is String) return v;
//         if (v is List && v.isNotEmpty) return v.first.toString();
//       }
//       // Fall back to first field error
//       for (final v in body.values) {
//         if (v is String) return v;
//         if (v is List && v.isNotEmpty) return v.first.toString();
//       }
//     }
//     return null;
//   }
// }

// /// Thrown when the backend says the venue already exists.
// class VenueAlreadyExistsException implements Exception {
//   final String message;
//   VenueAlreadyExistsException(this.message);
//   @override
//   String toString() => message;
// }

// // ============================================================
// // SCREEN — Venue List
// // ============================================================
// class VenueListScreen extends StatefulWidget {
//   const VenueListScreen({super.key});

//   @override
//   State<VenueListScreen> createState() => _VenueListScreenState();
// }

// class _VenueListScreenState extends State<VenueListScreen> {
//   List<Venue> _venues = [];
//   bool _loading = true;
//   String? _error;
//   String _search = '';

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final list = _search.trim().isEmpty
//           ? await VenueService.list()
//           : await VenueService.search(_search);
//       if (!mounted) return;
//       setState(() {
//         _venues = list;
//         _loading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _openCreateSheet() async {
//     final created = await showModalBottomSheet<Venue>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Theme.of(context).cardColor,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => const _VenueFormSheet(),
//     );

//     if (created == null || !mounted) return;

//     setState(() => _venues.insert(0, created));
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Venue created')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 0,
//         title: const Text(
//           'Venues',
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//         ),
//         actions: [
//           IconButton(
//             tooltip: 'Add venue',
//             onPressed: _openCreateSheet,
//             icon: const Icon(Icons.add),
//           ),
//           IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _load,
//         child: _buildBody(),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _openCreateSheet,
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Theme.of(context).cardColor,
//         icon: const Icon(Icons.add),
//         label: const Text('Add Venue'),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_loading) {
//       return Center(
//         child: CircularProgressIndicator(
//           color: Theme.of(context).primaryColor,
//         ),
//       );
//     }

//     if (_error != null) {
//       return ListView(
//         children: [
//           const SizedBox(height: 100),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   const Icon(Icons.error_outline,
//                       color: Colors.red, size: 48),
//                   const SizedBox(height: 12),
//                   Text(_error!, textAlign: TextAlign.center),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                     ),
//                     onPressed: _load,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return ListView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
//       children: [
//         Text(
//           'Venues',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).textTheme.titleMedium?.color,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           'Manage the venues available for your events.',
//           style: TextStyle(
//             fontSize: 13,
//             color: Theme.of(context).textTheme.bodyMedium?.color,
//           ),
//         ),
//         const SizedBox(height: 16),

//         TextField(
//           onChanged: (v) {
//             _search = v;
//             _load();
//           },
//           decoration: InputDecoration(
//             hintText: 'Search venues...',
//             prefixIcon: Icon(
//               Icons.search,
//               color: Theme.of(context).textTheme.bodyMedium?.color,
//             ),
//             filled: true,
//             fillColor: Theme.of(context).cardColor,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                   color: Color.fromARGB(132, 224, 224, 224)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                   color: Color.fromARGB(123, 224, 224, 224)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),

//         if (_venues.isEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 60),
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(Icons.place_outlined,
//                       size: 56, color: Colors.grey.shade400),
//                   const SizedBox(height: 12),
//                   Text(
//                     'No venues yet',
//                     style: TextStyle(
//                       color:
//                           Theme.of(context).textTheme.bodyMedium?.color,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton.icon(
//                     onPressed: _openCreateSheet,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                       foregroundColor: Theme.of(context).cardColor,
//                     ),
//                     icon: const Icon(Icons.add, size: 18),
//                     label: const Text('Create your first venue'),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         else
//           ..._venues.map((v) => Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: _VenueCard(venue: v),
//               )),
//       ],
//     );
//   }
// }

// // ============================================================
// // VENUE CARD
// // ============================================================
// class _VenueCard extends StatelessWidget {
//   final Venue venue;
//   const _VenueCard({required this.venue});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: const Color.fromARGB(88, 224, 224, 224),
//           width: 1,
//         ),
//       ),
//       padding: const EdgeInsets.all(14),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: theme.primaryColor.withOpacity(.08),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Icons.place,
//               color: theme.primaryColor,
//               size: 26,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   venue.name,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: theme.textTheme.bodyLarge?.color,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 if (venue.address.isNotEmpty) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     venue.address,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: theme.textTheme.bodyMedium?.color,
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: theme.primaryColor.withOpacity(.08),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'Capacity: ${venue.capacity}',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: theme.primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // VENUE FORM SHEET (create)
// // ============================================================
// class _VenueFormSheet extends StatefulWidget {
//   const _VenueFormSheet();

//   @override
//   State<_VenueFormSheet> createState() => _VenueFormSheetState();
// }

// class _VenueFormSheetState extends State<_VenueFormSheet> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameCtrl = TextEditingController();
//   final _addressCtrl = TextEditingController();
//   final _capacityCtrl = TextEditingController();

//   bool _submitting = false;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _addressCtrl.dispose();
//     _capacityCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _submitting = true);

//     final name = _nameCtrl.text.trim();
//     final address = _addressCtrl.text.trim();
//     final capacity = int.parse(_capacityCtrl.text.trim());

//     // ---- Optional local pre-check against our own list ----
//     // Try to warn early if the same name+address already exists.
//     // (The server is still the source of truth.)
//     try {
//       final existing = await VenueService.search(name);
//       final duplicate = existing.any(
//         (v) =>
//             v.name.toLowerCase().trim() == name.toLowerCase() &&
//             v.address.toLowerCase().trim() == address.toLowerCase(),
//       );
//       if (duplicate) {
//         if (!mounted) return;
//         setState(() => _submitting = false);
//         _showAlreadyExistsDialog(name);
//         return;
//       }
//     } catch (_) {
//       // Ignore pre-check failures; let the server decide
//     }

//     // ---- Create on the server ----
//     try {
//       final created = await VenueService.create(
//         name: name,
//         address: address,
//         capacity: capacity,
//       );
//       if (!mounted) return;
//       Navigator.of(context).pop(created);
//     } on VenueAlreadyExistsException catch (e) {
//       if (!mounted) return;
//       setState(() => _submitting = false);
//       _showAlreadyExistsDialog(e.message);
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _submitting = false);
//       _snack(e.toString(), isError: true);
//     }
//   }

//   void _showAlreadyExistsDialog(String message) {
//     showDialog<void>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Row(
//           children: [
//             Icon(Icons.info_outline, color: Color(0xFFF59E0B)),
//             SizedBox(width: 8),
//             Text('Venue already exists'),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _snack(String m, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(m),
//         backgroundColor: isError ? _C.red : null,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottom = MediaQuery.of(context).viewInsets.bottom;
//     return Padding(
//       padding: EdgeInsets.only(bottom: bottom),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Add New Venue',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _nameCtrl,
//                 textInputAction: TextInputAction.next,
//                 decoration: const InputDecoration(
//                   labelText: 'Name *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.place_outlined),
//                 ),
//                 validator: (v) =>
//                     (v == null || v.trim().isEmpty) ? 'Required' : null,
//               ),
//               const SizedBox(height: 12),

//               TextFormField(
//                 controller: _addressCtrl,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText: 'Address *',
//                   border: OutlineInputBorder(),
//                   alignLabelWithHint: true,
//                 ),
//                 validator: (v) =>
//                     (v == null || v.trim().isEmpty) ? 'Required' : null,
//               ),
//               const SizedBox(height: 12),

//               TextFormField(
//                 controller: _capacityCtrl,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Capacity *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.people_outline),
//                 ),
//                 validator: (v) {
//                   if (v == null || v.trim().isEmpty) return 'Required';
//                   final n = int.tryParse(v.trim());
//                   if (n == null) return 'Invalid number';
//                   if (n <= 0) return 'Must be greater than 0';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),

//               SizedBox(
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _submitting ? null : _submit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).primaryColor,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _submitting
//                       ? const SizedBox(
//                           height: 22,
//                           width: 22,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Text(
//                           'Create Venue',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// pages/venue_list_screen.dart
import 'dart:async';
import 'dart:convert';

import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';

// ============================================================
// THEME
// ============================================================
class _C {
  static const red = Color(0xFFDC2626);
  static const border = Color(0xFFE5E7EB);
}

// ============================================================
// MODEL — Venue
// ============================================================
class Venue {
  final int? id;
  final String name;
  final String address;
  final int capacity;

  Venue({
    this.id,
    required this.name,
    required this.address,
    required this.capacity,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json['id'] is int
            ? json['id']
            : int.tryParse('${json['id']}'),
        name: (json['name'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
        capacity: json['capacity'] is int
            ? json['capacity']
            : int.tryParse('${json['capacity']}') ?? 0,
      );
}

// ============================================================
// SERVICE
// ============================================================
class VenueService {
  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// GET /events-timetable/api/venues/search/?q=<query>
  static Future<List<Venue>> search(String query) async {
    final uri = Uri.parse(
      '${Urls.baseUrl}/events-timetable/api/venues/search/',
    ).replace(queryParameters: {'q': query});

    final res = await http.get(uri, headers: await _authHeaders());
    if (res.statusCode != 200) {
      throw Exception('Failed to search venues (${res.statusCode})');
    }

    final dynamic decoded = jsonDecode(res.body);
    final List list = decoded is List ? decoded : (decoded['results'] ?? []);
    return list
        .whereType<Map>()
        .map((e) => Venue.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// GET /events-timetable/api/venues/  (fallback for listing all)
  static Future<List<Venue>> list() async {
    final uri = Uri.parse('${Urls.baseUrl}/events-timetable/api/venues/');
    final res = await http.get(uri, headers: await _authHeaders());
    if (res.statusCode != 200) {
      throw Exception('Failed to load venues (${res.statusCode})');
    }
    final dynamic decoded = jsonDecode(res.body);
    final List list = decoded is List ? decoded : (decoded['results'] ?? []);
    return list
        .whereType<Map>()
        .map((e) => Venue.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// POST /events-timetable/api/venues/create/
  ///
  /// Returns the created Venue on success.
  /// Throws [VenueAlreadyExistsException] if the server rejects as duplicate.
  static Future<Venue> create({
    required String name,
    required String address,
    required int capacity,
  }) async {
    final uri =
        Uri.parse('${Urls.baseUrl}/events-timetable/api/venues/create/');

    final res = await http.post(
      uri,
      headers: await _authHeaders(),
      body: jsonEncode({
        'name': name,
        'address': address,
        'capacity': capacity,
      }),
    );

    // Try to parse JSON body regardless of status code
    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (_) {
      body = null;
    }

    if (res.statusCode == 200 || res.statusCode == 201) {
      if (body is Map) {
        return Venue.fromJson(Map<String, dynamic>.from(body));
      }
      throw Exception('Unexpected response from server');
    }

    // Detect "already exists" from the backend
    if (res.statusCode == 400 || res.statusCode == 409) {
      final msg = _extractError(body) ?? 'Venue already exists';
      if (msg.toLowerCase().contains('exist') ||
          msg.toLowerCase().contains('duplicate')) {
        throw VenueAlreadyExistsException(msg);
      }
      throw Exception(msg);
    }

    throw Exception('Failed to create venue (${res.statusCode})');
  }

  /// Pull a human-readable error out of common DRF error shapes.
  static String? _extractError(dynamic body) {
    if (body == null) return null;

    if (body is String) return body;

    if (body is Map) {
      // DRF: {"name": ["Venue with this name already exists."]}
      for (final key in ['error', 'detail', 'message', 'non_field_errors']) {
        final v = body[key];
        if (v is String) return v;
        if (v is List && v.isNotEmpty) return v.first.toString();
      }
      // Fall back to first field error
      for (final v in body.values) {
        if (v is String) return v;
        if (v is List && v.isNotEmpty) return v.first.toString();
      }
    }
    return null;
  }
}

/// Thrown when the backend says the venue already exists.
class VenueAlreadyExistsException implements Exception {
  final String message;
  VenueAlreadyExistsException(this.message);
  @override
  String toString() => message;
}

// ============================================================
// SCREEN — Venue List
// ============================================================
class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  final _searchCtrl = TextEditingController();

  List<Venue> _venues = [];
  bool _initialLoading = true;
  bool _searchLoading = false;
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  /// First load — can show a full-screen spinner because nothing is on screen yet.
  Future<void> _loadInitial() async {
    setState(() {
      _initialLoading = true;
      _error = null;
    });
    try {
      final list = await VenueService.list();
      if (!mounted) return;
      setState(() {
        _venues = list;
        _initialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _initialLoading = false;
      });
    }
  }

  /// Refresh (pull-to-refresh + refresh button) — keeps the current query.
  Future<void> _refresh() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return _loadInitial();

    try {
      final list = await VenueService.search(q);
      if (!mounted) return;
      setState(() {
        _venues = list;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  /// Called on every keystroke. Debounces then runs the search.
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(value);
    });
  }

  Future<void> _runSearch(String value) async {
    final q = value.trim();
    if (!mounted) return;

    if (q.isEmpty) {
      setState(() => _searchLoading = false);
      return _loadInitial();
    }

    setState(() {
      _searchLoading = true;
      _error = null;
    });

    try {
      final list = await VenueService.search(q);
      if (!mounted) return;
      setState(() {
        _venues = list;
        _searchLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _searchLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _openCreateSheet() async {
    final created = await showModalBottomSheet<Venue>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _VenueFormSheet(),
    );

    if (created == null || !mounted) return;

    // If the user is searching, refetch so the new venue appears (if it matches).
    // If not, just insert it at the top of the current list.
    if (_searchCtrl.text.trim().isEmpty) {
      setState(() => _venues.insert(0, created));
    } else {
      await _runSearch(_searchCtrl.text);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Venue created' )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          'Venues' ,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Add venue',
            onPressed: _openCreateSheet,
            icon: const Icon(Icons.add),
          ),
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).cardColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Venue'),
      ),
    );
  }

  Widget _buildBody() {
    // Only the FIRST load shows the full-screen spinner.
    if (_initialLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    // Build header + search + list as a single ListView so the TextField
    // is never unmounted while the user types.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        Text(
          'Venues',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage the venues available for your events.',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 16),

        // ---- Search field (never unmounted) ----
        TextField(
          controller: _searchCtrl,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search venues...',
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            suffixIcon: _searchLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color.fromARGB(132, 224, 224, 224)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color.fromARGB(123, 224, 224, 224)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ---- Inline error (kept inside the same ListView) ----
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _C.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: _C.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: _C.red, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),

        // ---- List / empty state ----
        if (_venues.isEmpty && !_searchLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.place_outlined,
                      size: 56, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    _searchCtrl.text.trim().isEmpty
                        ? 'No venues yet'
                        : 'No venues match "${_searchCtrl.text.trim()}"',
                    style: TextStyle(
                      color:
                          Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (_searchCtrl.text.trim().isEmpty)
                    ElevatedButton.icon(
                      onPressed: _openCreateSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).cardColor,
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create your first venue'),
                    ),
                ],
              ),
            ),
          )
        else
          ..._venues.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VenueCard(venue: v),
              )),
      ],
    );
  }
}

// ============================================================
// VENUE CARD
// ============================================================
class _VenueCard extends StatelessWidget {
  final Venue venue;
  const _VenueCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromARGB(88, 224, 224, 224),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.place,
              color: theme.primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (venue.address.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    venue.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodyMedium?.color,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Capacity: ${venue.capacity}',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VENUE FORM SHEET (create)
// ============================================================
class _VenueFormSheet extends StatefulWidget {
  const _VenueFormSheet();

  @override
  State<_VenueFormSheet> createState() => _VenueFormSheetState();
}

class _VenueFormSheetState extends State<_VenueFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _capacityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final name = _nameCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final capacity = int.parse(_capacityCtrl.text.trim());

    // ---- Optional local pre-check against the server ----
    // Warn early if the same name+address already exists.
    // (The server is still the source of truth.)
    try {
      final existing = await VenueService.search(name);
      final duplicate = existing.any(
        (v) =>
            v.name.toLowerCase().trim() == name.toLowerCase() &&
            v.address.toLowerCase().trim() == address.toLowerCase(),
      );
      if (duplicate) {
        if (!mounted) return;
        setState(() => _submitting = false);
        _showAlreadyExistsDialog(
          'A venue with this name and address already exists.',
        );
        return;
      }
    } catch (_) {
      // Ignore pre-check failures; let the server decide
    }

    // ---- Create on the server ----
    try {
      final created = await VenueService.create(
        name: name,
        address: address,
        capacity: capacity,
      );
      if (!mounted) return;
      Navigator.of(context).pop(created);
    } on VenueAlreadyExistsException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showAlreadyExistsDialog(e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _snack(e.toString(), isError: true);
    }
  }

  void _showAlreadyExistsDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('Venue already exists'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _snack(String m, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(m),
        backgroundColor: isError ? _C.red : null,
      ),
    );
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
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add New Venue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _addressCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address *',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _capacityCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capacity *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people_outline),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final n = int.tryParse(v.trim());
                  if (n == null) return 'Invalid number';
                  if (n <= 0) return 'Must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Create Venue',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}