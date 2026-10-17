import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Single API client for the Balloon platform.
/// Change [baseUrl] to point at the deployed Django backend.
class ApiService {
  // Android emulator uses 10.0.2.2 to reach host localhost.
  // For a physical device, replace with your computer's LAN IP, e.g. 192.168.1.116.
  // For web/desktop use: 'https://qopera.app/api'
  static const String baseUrl = 'https://qopera.app/api';

  // Token storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  /// Get stored access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get stored refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Save tokens after login
  static Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, access);
    await prefs.setString(_refreshTokenKey, refresh);
  }

  /// Save user data
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  /// Get stored user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }
    return null;
  }

  /// Clear all stored auth data (logout)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Get headers with authorization token
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ===== AUTHENTICATION ENDPOINTS =====

  /// Register new user
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String password2,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'password2': password2,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Save tokens automatically after registration
      if (data['data']?['tokens'] != null) {
        await saveTokens(
          data['data']['tokens']['access'],
          data['data']['tokens']['refresh'],
        );
        if (data['data']['user'] != null) {
          await saveUser(data['data']['user']);
        }
      }
      return data;
    }
    throw Exception('Registration failed: ${response.statusCode}');
  }

  /// Login user with email and password
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      // Save tokens
      if (data['data']?['tokens'] != null) {
        await saveTokens(
          data['data']['tokens']['access'],
          data['data']['tokens']['refresh'],
        );
        if (data['data']['user'] != null) {
          await saveUser(data['data']['user']);
        }
      }
      return data;
    }
    throw Exception('Invalid credentials: ${response.statusCode}');
  }

  /// Logout user
  static Future<Map<String, dynamic>> logout() async {
    final refreshToken = await getRefreshToken();
    final headers = await getAuthHeaders();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout/'),
        headers: headers,
        body: jsonEncode({
          if (refreshToken != null) 'refresh': refreshToken,
        }),
      );

      // Clear local data regardless of response
      await clearAuthData();
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {'status': 'success', 'message': 'Logged out locally'};
    } catch (e) {
      // Clear local data even if server fails
      await clearAuthData();
      return {'status': 'success', 'message': 'Logged out locally'};
    }
  }

  /// Refresh access token
  static Future<String?> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess = data['data']?['access'];
        if (newAccess != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_accessTokenKey, newAccess);
          return newAccess;
        }
      }
    } catch (e) {
      // If refresh fails, clear auth data
      await clearAuthData();
    }
    return null;
  }

  /// Get current user profile
  static Future<Map<String, dynamic>> getProfile() async {
    final headers = await getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/profile/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['data'] != null) {
        await saveUser(data['data']);
      }
      return data;
    } else if (response.statusCode == 401) {
      // Try to refresh token
      final newToken = await refreshToken();
      if (newToken != null) {
        // Retry with new token
        return await getProfile();
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to load profile: ${response.statusCode}');
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final headers = await getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/profile/'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseData['data'] != null) {
        await saveUser(responseData['data']);
      }
      return responseData;
    } else if (response.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await updateProfile(data);
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to update profile: ${response.statusCode}');
  }

  /// Change password
  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final headers = await getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/change-password/'),
      headers: headers,
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        );
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to change password: ${response.statusCode}');
  }

  /// Request password reset
  static Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Password reset request failed: ${response.statusCode}');
  }

  // ===== RESTAURANT/MENU ENDPOINTS =====

  /// Get restaurant menu by slug
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

  /// Resolve a short QR code to the restaurant menu
  static Future<Map<String, dynamic>> getMenuByCode(String code) async {
    final url = '$baseUrl/menu-by-code/$code/';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load menu by code: ${res.statusCode}');
  }

  /// Get restaurants list with pagination and filters
  static Future<Map<String, dynamic>> getRestaurants({
    int page = 1,
    int pageSize = 10,
    String? search,
    double? minRating,
    int? minReviews,
    bool? isOpen,
    String sortBy = 'rating',
    double? lat,
    double? lon,
    double? maxDistance,
    int? typeId,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
      'sort_by': sortBy,
      if (search != null && search.isNotEmpty) 'search': search,
      if (minRating != null) 'min_rating': minRating.toString(),
      if (minReviews != null) 'min_reviews': minReviews.toString(),
      if (isOpen != null) 'is_open': isOpen.toString(),
      if (lat != null) 'lat': lat.toString(),
      if (lon != null) 'lon': lon.toString(),
      if (maxDistance != null) 'max_distance': maxDistance.toString(),
      if (typeId != null) 'type_id': typeId.toString(),
    };

    final uri = Uri.parse('$baseUrl/restaurants/')
        .replace(queryParameters: queryParams);

    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load restaurants: ${res.statusCode}');
  }

  /// Get restaurants by type
  static Future<Map<String, dynamic>> getRestaurantsByType(
    int typeId, {
    int page = 1,
    int pageSize = 10,
    String? search,
    double? minRating,
    bool? isOpen,
    String sortBy = 'rating',
    double? lat,
    double? lon,
    double? maxDistance,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
      'sort_by': sortBy,
      if (search != null && search.isNotEmpty) 'search': search,
      if (minRating != null) 'min_rating': minRating.toString(),
      if (isOpen != null) 'is_open': isOpen.toString(),
      if (lat != null) 'lat': lat.toString(),
      if (lon != null) 'lon': lon.toString(),
      if (maxDistance != null) 'max_distance': maxDistance.toString(),
    };

    final uri = Uri.parse('$baseUrl/profiles/by-type/$typeId/')
        .replace(queryParameters: queryParams);

    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load restaurants by type: ${res.statusCode}');
  }

  /// Get business types list
  static Future<List<dynamic>> getBusinessTypes() async {
    final res = await http.get(Uri.parse('$baseUrl/business-types/'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['data'] as List<dynamic>;
    }
    throw Exception('Failed to load business types: ${res.statusCode}');
  }

  /// Get dashboard stats
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final headers = await getAuthHeaders();
    final res = await http.get(
      Uri.parse('$baseUrl/dashboard/stats/'),
      headers: headers,
    );
    
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load stats: ${res.statusCode}');
  }

  // ===== ORDER ENDPOINTS =====

  /// Create an order
  static Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> payload,
  ) async {
    final headers = await getAuthHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/orders/'),
      headers: headers,
      body: jsonEncode(payload),
    );
    
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await createOrder(payload);
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Order failed: ${res.statusCode}');
  }

  // ===== EVENT ENDPOINTS =====

  /// Fetches the list of all events
  static Future<List<dynamic>> getEvents() async {
    final res = await http.get(Uri.parse('$baseUrl/events/'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['results'] as List<dynamic>;
    }
    throw Exception('Failed to load events: ${res.statusCode}');
  }

  /// Creates a new event
  static Future<Map<String, dynamic>> createEvent(
    Map<String, dynamic> payload,
  ) async {
    final headers = await getAuthHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/events/create'),
      headers: headers,
      body: jsonEncode(payload),
    );
    
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await createEvent(payload);
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Event create failed: ${res.statusCode}');
  }

  /// Lists events created by the logged-in user
  static Future<List<dynamic>> getMyEvents() async {
    final headers = await getAuthHeaders();
    final res = await http.get(
      Uri.parse('$baseUrl/my-events/'),
      headers: headers,
    );
    
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['results'] as List<dynamic>;
    } else if (res.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await getMyEvents();
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to load my events: ${res.statusCode}');
  }

  /// Fetches comments for an event
  static Future<List<dynamic>> getEventComments(int eventId) async {
    final res = await http.get(Uri.parse('$baseUrl/events/$eventId/comments/'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['results'] as List<dynamic>;
    }
    throw Exception('Failed to load comments: ${res.statusCode}');
  }

  /// Adds a comment to an event
  static Future<Map<String, dynamic>> addEventComment(
    int eventId,
    String text,
  ) async {
    final headers = await getAuthHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/comments/'),
      headers: headers,
      body: jsonEncode({'text': text}),
    );
    
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await addEventComment(eventId, text);
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to add comment: ${res.statusCode}');
  }

  /// Toggles a like on an event
  static Future<Map<String, dynamic>> toggleEventLike(
    int eventId,
  ) async {
    final headers = await getAuthHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/like/'),
      headers: headers,
    );
    
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await toggleEventLike(eventId);
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to toggle like: ${res.statusCode}');
  }

  /// Records that the user shared an event
  static Future<Map<String, dynamic>> shareEvent(
    int eventId, {
    String shareMethod = 'mobile',
  }) async {
    final headers = await getAuthHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/share/'),
      headers: headers,
      body: jsonEncode({'share_method': shareMethod}),
    );
    
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await shareEvent(eventId, shareMethod: shareMethod);
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to record share: ${res.statusCode}');
  }

  /// Toggles attendance for an event
  static Future<Map<String, dynamic>> toggleEventAttend(
    int eventId,
  ) async {
    final headers = await getAuthHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/events/$eventId/attend/'),
      headers: headers,
    );
    
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      final newToken = await refreshToken();
      if (newToken != null) {
        return await toggleEventAttend(eventId);
      }
      throw Exception('Session expired. Please login again.');
    }
    throw Exception('Failed to toggle attendance: ${res.statusCode}');
  }
}