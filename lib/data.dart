import 'models.dart';

/// Central demo data source used by Home, Search, Favorites and Profile.
/// When the backend is available, AppState.loadRestaurants() replaces this list.
///
/// Seed/demo content has been removed. All restaurants and offers are now
/// loaded from the backend API.
class DemoData {
  static final List<Restaurant> restaurants = [];

  static final List<Offer> offers = [];
}

