import 'dart:convert';
import 'package:http/http.dart' as http;

/// Single API client for the Balloon platform.
/// Change [baseUrl] to point at the deployed Django backend.
class ApiService {
  // Android emulator uses 10.0.2.2 to reach host localhost.
  // For a physical device, replace with your computer's LAN IP, e.g. 192.168.1.116.
  // For web/desktop use: 'http://localhost:8000/api'
  static const String baseUrl = 'http://192.168.1.115:8000/api';

  static Future<Map<String, dynamic>> getRestaurantMenu(String slug,
      {String? tableSlug}) async {
    final url = tableSlug != null
        ? '$baseUrl/menu/$slug/$tableSlug/'
        : '$baseUrl/menu/$slug/';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load menu: ${res.statusCode}');
  }

  /// Resolve a short QR code (e.g. ``A1B2C3D4``) to the restaurant menu.
  ///
  /// The QR code printed at the restaurant only contains this short code. The
  /// mobile app scans it, then calls this endpoint to look up the matching
  /// restaurant and return its full menu.
  static Future<Map<String, dynamic>> getMenuByCode(String code) async {
    final url = '$baseUrl/menu-by-code/$code/';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load menu by code: ${res.statusCode}');
  }

  static Future<List<dynamic>> getRestaurants() async {
    final res = await http.get(Uri.parse('$baseUrl/restaurants/'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['results'] as List<dynamic>;
    }
    throw Exception('Failed to load restaurants');
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final res = await http.get(Uri.parse('$baseUrl/dashboard/stats/'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load stats');
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Invalid credentials');
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String role = 'customer',
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      }),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Registration failed');
  }

  static Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse('$baseUrl/orders/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Order failed: ${res.statusCode}');
  }

  /// Fetches the list of all events to display in the mobile app.
  static Future<List<dynamic>> getEvents() async {
    final res = await http.get(Uri.parse('$baseUrl/events/'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['results'] as List<dynamic>;
    }
    throw Exception('Failed to load events: ${res.statusCode}');
  }

  /// Creates a new event. Requires a valid JWT access token.
  static Future<Map<String, dynamic>> createEvent(
    Map<String, dynamic> payload, {
    String? accessToken,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.post(
      Uri.parse('$baseUrl/events/create'),
      headers: headers,
      body: jsonEncode(payload),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Event create failed: ${res.statusCode}');
  }

  /// Lists events created by the currently logged-in user.
  static Future<List<dynamic>> getMyEvents({String? accessToken}) async {
    final headers = <String, String>{};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.get(Uri.parse('$baseUrl/my-events/'), headers: headers);
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['results'] as List<dynamic>;
    }
    throw Exception('Failed to load my events: ${res.statusCode}');
  }

  // ===== Event social features (comments, likes) =====

  /// Fetches the list of comments for a given event.
  static Future<List<dynamic>> getEventComments(int eventId) async {
    final res = await http.get(Uri.parse('$baseUrl/events/$eventId/comments/'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['results'] as List<dynamic>;
    }
    throw Exception('Failed to load comments: ${res.statusCode}');
  }

  /// Adds a comment to an event. Requires a valid JWT access token.
  static Future<Map<String, dynamic>> addEventComment(
    int eventId,
    String text, {
    String? accessToken,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/comments/'),
      headers: headers,
      body: jsonEncode({'text': text}),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to add comment: ${res.statusCode}');
  }

  /// Toggles a like on an event for the logged-in user. Returns the new
  /// liked state and like count.
  static Future<Map<String, dynamic>> toggleEventLike(
    int eventId, {
    String? accessToken,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/like/'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to toggle like: ${res.statusCode}');
  }

  /// Records that the logged-in user shared an event. Returns updated
  /// share count.
  static Future<Map<String, dynamic>> shareEvent(
    int eventId, {
    String shareMethod = 'mobile',
    String? accessToken,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/share/'),
      headers: headers,
      body: jsonEncode({'share_method': shareMethod}),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to record share: ${res.statusCode}');
  }

  /// Toggles the logged-in user's attendance for an event. Returns updated
  /// attendance state and attendee count.
  static Future<Map<String, dynamic>> toggleEventAttend(
    int eventId, {
    String? accessToken,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/attend/'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to toggle attendance: ${res.statusCode}');
  }
}
