import 'dart:convert';
import 'dart:math' as math;
import 'package:ballon/models/resturants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'services/api_servicex.dart';

/// Central app state for the customer app.
class AppState extends ChangeNotifier {
  int currentIndex = 0;
  bool isDark = false;
  String? selectedLanguage = 'English';

  // User auth
  bool isLoggedIn = false;
  String username = 'Guest User';
  String email = '';
  String role = 'customer';
  String? accessToken;

// Favorites
  final List<Food> favoriteFoods = [];
  final List<Result> favoriteRestaurants = [];

  // Recently scanned restaurants (from QR codes)
  final List<Result> recentScans = [];

  // Cart
  final List<CartItem> cartItems = [];
  Result? currentRestaurant;
  TableModel? currentTable;
  String orderType = 'dine_in';

// Restaurants & offers
  List<Result> allRestaurants = [];
  List<Offer> offers = [];
  bool restaurantsLoaded = false;

  // Events
  List<EventModel> events = [];
  bool eventsLoaded = false;

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.total);

  double get tax => subtotal * 0.18; // 18% tax
  double get serviceCharge => subtotal * 0.05; // 5%
  double get total => subtotal + tax + serviceCharge;

  void changeTab(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void toggleDark() {
    isDark = !isDark;
    notifyListeners();
  }

  void setRestaurant(Result restaurant, {TableModel? table}) {
    currentRestaurant = restaurant;
    if (table != null) currentTable = table;
    notifyListeners();
  }

  void setOrderType(String type) {
    orderType = type;
    notifyListeners();
  }

  // ---- Auth ----
  void login({String? username, String? email, String? token, String role = 'customer'}) {
    isLoggedIn = true;
    this.username = (username != null && username.isNotEmpty) ? username : 'Customer';
    this.email = email ?? '';
    this.role = role;
    accessToken = token;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    username = 'Guest User';
    email = '';
    role = 'customer';
    accessToken = null;
    notifyListeners();
  }

  // ---- Restaurants ----
    bool isLoading = false;
  String? errorMessage;

  // ... your other existing code ...

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      allRestaurants = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Replace BASE_URL with your actual domain (e.g., http://192.168.1.115:8000)
    final uri = Uri.parse('http://192.168.1.115:8000/prof/restaurants-high-rated/?search=$query');

    // try {
    //   final response = await http.get(uri);

    //   if (response.statusCode == 200) {
    //     final decoded = json.decode(response.body);
        
    //     // Check API structure: if it returns {"results": [...]}, map manually
    //     // Assuming the API returns a raw list:
    //     List<dynamic> list = decoded is List ? decoded : decoded['results'];
        
    //     // Example if using your Result model:
    //     allRestaurants = list.map((e) => Result.fromJson(e)).toList();
        
    //     // OR if the endpoint uses the standard 'Restaurant' model:
    //     // allRestaurants = list.map((e) => Restaurant.fromJson(e)).toList();

    //     // Placeholder for now - adjust based on actual API response
    //     allRestaurants = (decoded['results'] as List)
    //         .map((e) => Result.fromJson(e)) 
    //         .toList();
            
    //   } else {
    //     errorMessage = 'Failed to fetch restaurants';
    //   }
    // } catch (e) {
    //   errorMessage = 'Error: $e';
    // } finally {
    //   isLoading = false;
    //   notifyListeners();
    // }
     try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // IMPORTANT: Safely parse the nested data object
      final dynamic data = decoded['data'];
      final dynamic results = data != null ? data['results'] : null;

      if (results is List) {
        allRestaurants = results
            .map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        // If results is null or not a list, set to empty
        allRestaurants = [];
      }
      
    } else {
      errorMessage = 'Failed to fetch restaurants (Status: ${response.statusCode})';
    }
  } catch (e) {
    errorMessage = 'Error: $e';
    allRestaurants = []; // Prevent old data from showing on error
  } finally {
    isLoading = false;
    notifyListeners();
  }
  }
  /// Loads restaurants from the backend. Falls back to demo data on failure
  /// or when the backend is unreachable.
  Future<void> loadRestaurants() async {
    if (restaurantsLoaded) return;
    try {
      final results = await ApiService.getRestaurants();
      if (results.isNotEmpty) {
        allRestaurants = results
            .map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Backend unreachable — keep demo data.
    }
    restaurantsLoaded = true;
    notifyListeners();
  }

  // ---- Events ----
  /// Loads events from the backend to display in the mobile app.
  Future<void> loadEvents() async {
    try {
      final results = await ApiService.getEvents();
      events = results
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Backend unreachable — keep existing (possibly empty) events list.
    }
    eventsLoaded = true;
    notifyListeners();
  }

  /// Creates a new event via the API using the logged-in user's token and
  /// refreshes the public events list. Returns the created event.
  Future<EventModel?> createEvent(EventModel draft) async {
    try {
      final created = await ApiService.createEvent(
        draft.toCreateJson(),
        accessToken: accessToken,
      );
      final newEvent = EventModel.fromJson(created);
      events.insert(0, newEvent);
      notifyListeners();
      return newEvent;
    } catch (_) {
      rethrow;
    }
  }

  /// Updates a single event in the list in place (used after like/comment).
  void _updateEvent(EventModel updated) {
    final idx = events.indexWhere((e) => e.id == updated.id);
    if (idx != -1) {
      events[idx] = updated;
      notifyListeners();
    }
  }

  /// Toggles the "like" state of an event for the logged-in user.
  Future<bool> toggleEventLike(EventModel event) async {
    if (!isLoggedIn) return false;
    try {
      final result = await ApiService.toggleEventLike(
        event.id,
        accessToken: accessToken,
      );
      final liked = result['liked'] ?? !event.isLiked;
      final likeCount = result['like_count'] ?? event.likeCount;
      _updateEvent(event.copyWith(isLiked: liked, likeCount: likeCount));
      return liked;
    } catch (_) {
      return false;
    }
  }

  /// Adds a comment to an event and refreshes its comment list/count.
  Future<EventCommentModel?> addEventComment(
    EventModel event,
    String text,
  ) async {
    if (!isLoggedIn) return null;
    try {
      final created = await ApiService.addEventComment(
        event.id,
        text,
        accessToken: accessToken,
      );
      final comment = EventCommentModel.fromJson(created);
      final updatedComments = [...event.comments, comment];
      _updateEvent(event.copyWith(
        comments: updatedComments,
        commentCount: updatedComments.length,
      ));
      return comment;
    } catch (_) {
      return null;
    }
  }

/// Loads comments for an event from the backend and updates the event.
  Future<void> loadEventComments(EventModel event) async {
    try {
      final results = await ApiService.getEventComments(event.id);
      final comments = results
          .map((e) => EventCommentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _updateEvent(event.copyWith(
        comments: comments,
        commentCount: comments.length,
      ));
    } catch (_) {
      // Ignore — keep existing comments.
    }
  }

  /// Records that the logged-in user shared an event and updates its share
  /// count from the backend response.
  Future<int?> shareEvent(EventModel event, {String shareMethod = 'mobile'}) async {
    if (!isLoggedIn) return null;
    try {
      final result = await ApiService.shareEvent(
        event.id,
        shareMethod: shareMethod,
        accessToken: accessToken,
      );
      final shareCount = (result['share_count'] ?? event.shareCount);
      _updateEvent(event.copyWith(shareCount: shareCount));
      return shareCount;
    } catch (_) {
      return null;
    }
  }

  /// Toggles the logged-in user's attendance for an event and updates the
  /// attendee count from the backend response.
  Future<bool> toggleEventAttend(EventModel event) async {
    if (!isLoggedIn) return false;
    try {
      final result = await ApiService.toggleEventAttend(
        event.id,
        accessToken: accessToken,
      );
      final attending = result['attending'] ?? !event.isAttending;
      final attendeeCount = result['attendee_count'] ?? event.attendeeCount;
      _updateEvent(event.copyWith(
        isAttending: attending,
        attendeeCount: attendeeCount,
      ));
      return attending;
    } catch (_) {
      return false;
    }
  }

  // ---- Cart ----
  void addToCart(CartItem item) {
    final existing = cartItems.indexWhere((e) =>
        e.food.id == item.food.id && e.variant == item.variant && e.extras.join() == item.extras.join());
    if (existing != -1) {
      cartItems[existing].quantity += item.quantity;
    } else {
      cartItems.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int delta) {
    final idx = cartItems.indexOf(item);
    if (idx != -1) {
      cartItems[idx].quantity += delta;
      if (cartItems[idx].quantity <= 0) {
        cartItems.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  // ---- Favorites ----
  bool isFoodFavorite(Food food) =>
      favoriteFoods.any((f) => f.id == food.id);

  void toggleFoodFavorite(Food food) {
    if (isFoodFavorite(food)) {
      favoriteFoods.removeWhere((f) => f.id == food.id);
    } else {
      favoriteFoods.add(food);
    }
    notifyListeners();
  }

  bool isRestaurantFavorite(Result r) =>
      favoriteRestaurants.any((x) => x.id == r.id);

void toggleRestaurantFavorite(Result r) {
    if (isRestaurantFavorite(r)) {
      favoriteRestaurants.removeWhere((x) => x.id == r.id);
    } else {
      favoriteRestaurants.add(r);
    }
    notifyListeners();
  }

  // ---- Recently Scanned (from QR codes) ----
  /// Adds a restaurant to the top of the recent scans list and keeps it
  /// capped at [maxRecentScans] entries. Most recent first.
  void addRecentScan(Result r) {
    recentScans.removeWhere((x) => x.id == r.id);
    recentScans.insert(0, r);
    const maxRecentScans = 10;
    if (recentScans.length > maxRecentScans) {
      recentScans.removeRange(maxRecentScans, recentScans.length);
    }
    notifyListeners();
  }

  // ---- Offers ----
  /// Returns offers whose restaurant is within [radiusKm] of the user's
  /// current location. If [lat] or [lng] is null, returns all offers.
  List<Offer> offersNearby(double? lat, double? lng) {
    if (lat == null || lng == null) return offers;
    final result = <Offer>[];
    for (final offer in offers) {
      final r = allRestaurants
          .cast<Restaurant?>().firstWhere((x) => x != null && x.id == offer.restaurantId, orElse: () => null);
      if (r == null) continue;
      if (r.latitude == null || r.longitude == null) continue;
      final distance = _distanceKm(lat, lng, r.latitude!, r.longitude!);
      if (distance <= offer.radiusKm) result.add(offer);
    }
    return result;
  }

  double _distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0; // Earth radius in km
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.asin(math.sqrt(a));
    return r * c;
  }

  double _toRad(double deg) => deg * math.pi / 180;
}
