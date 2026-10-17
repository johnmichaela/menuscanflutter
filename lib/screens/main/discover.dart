import 'dart:async';
import 'dart:convert';

import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/resturants.dart' show Food, Result, Resturants;
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:ballon/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ballon/l10n/app_strings.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// --- API SERVICE ---
class ApiService {
  Future<List<Result>> fetchRestaurantsByDistance(int pageNumber) async {
    try {
      LocationService locationService = LocationService();
      Position currentPosition = await locationService.getCurrentLocation();
      String url = "${Urls.baseUrl}/prof/restaurants-high-rated/?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$pageNumber";
      final response = await http.get(Uri.parse(url));
      print(url);
      if (response.statusCode == 200) {
        var map = jsonDecode(utf8.decode(response.bodyBytes));
        return Resturants.fromJson(map).data!.results!;
      } else {
        throw ServerException(message: "Error: ${response.statusCode}");
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<Result>> fetchRestaurantsByReviews(int pageNumber) async {
    try {
      String url = "${Urls.baseUrl}/prof/restaurants-high-rated/?sort_by=reviews&page=$pageNumber";
      final response = await http.get(Uri.parse(url));
      print(url);
      if (response.statusCode == 200) {
        var map = jsonDecode(utf8.decode(response.bodyBytes));
        return Resturants.fromJson(map).data!.results!;
      } else {
        throw ServerException(message: "Error: ${response.statusCode}");
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<FoodWithRestaurant> _allFoods = [];
  List<FoodWithRestaurant> _displayedFoods = [];
  
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  String _currentSort = 'reviews';
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;

 InternetConnectionStatus? _lastConnectionStatus;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterFoods);
     _connectionSubscription =
      InternetConnectionChecker.instance.onStatusChange.listen((status) {
    if (_lastConnectionStatus == InternetConnectionStatus.disconnected &&
        status == InternetConnectionStatus.connected) {
      
       _loadFoods();
    }

    _lastConnectionStatus = status;
  });
  }

  // Fetch restaurants and extract all food items with restaurant info
  Future<void> _loadFoods() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      List<Result> fetchedRestaurants;
      if (_currentSort == 'reviews') {
         fetchedRestaurants = await _apiService.fetchRestaurantsByReviews(_currentPage);
      } else {
        fetchedRestaurants = await _apiService.fetchRestaurantsByDistance(_currentPage);
      }

      // Extract foods from restaurants with restaurant info
      List<FoodWithRestaurant> newFoods = [];
      for (var restaurant in fetchedRestaurants) {
        if (restaurant.foods != null) {
          for (var food in restaurant.foods!) {
            newFoods.add(FoodWithRestaurant(
              food: food,
              restaurantName: restaurant.name ?? 'Unknown Restaurant',
              restaurantId: restaurant.id ?? 0,
              restaurantImage: restaurant.banner ?? restaurant.picture,
            ));
          }
        }
      }

      setState(() {
        if (_currentPage == 1) {
          _allFoods = newFoods;
        } else {
          _allFoods.addAll(newFoods);
        }
        _filterFoods();
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
    }
  }

  // Filter logic based on search bar
  void _filterFoods() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayedFoods = _allFoods;
      } else {
        _displayedFoods = _allFoods.where((fw) {
          final food = fw.food;
          return (food.name?.toLowerCase().contains(query) ?? false) ||
                 (food.description?.toLowerCase().contains(query) ?? false) ||
                 (fw.restaurantName.toLowerCase().contains(query));
        }).toList();
      }
    });
  }

  Future<void> _refresh() async {
    _currentPage = 1;
    await _loadFoods();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading) {
        _currentPage++;
        _loadFoods();
      }
    }
  }

  void _changeSort(String? newSort) {
    if (newSort != null && newSort != _currentSort) {
      setState(() {
        _currentSort = newSort;
        _currentPage = 1;
        _allFoods = [];
        _displayedFoods = [];
      });
      _loadFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- SEARCH BAR AND QR ICON ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style:  TextStyle(color: Colors.grey),
                              decoration:  InputDecoration(
                                hintText: context.tr.searchDishesOrRestaurants,
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () => _searchController.clear(),
                              child: const Icon(Icons.close, color: Colors.grey, size: 20),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerScreen())),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                  ),)
                ],
              ),
            ),

            // --- TITLE AND FILTER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(context.tr.discover, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                  DropdownButton<String>(
                    value: _currentSort,
                    dropdownColor: Theme.of(context).cardColor,
                    icon:  Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
                    underline: const SizedBox(),
                    style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: 14),
                    items:  [
                      DropdownMenuItem(value: 'reviews', child: Text(context.tr.topRated)),
                       DropdownMenuItem(value: 'distance', child: Text(context.tr.nearbyRestaurants)),
                    ],
                    onChanged: _changeSort,
                  ),
                ],
              ),
            ),

            // --- GRID LIST OF FOODS (3 COLUMNS) ---
            Expanded(
              child: _isLoading && _allFoods.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null && _allFoods.isEmpty
                      ?  Container(
                        margin: const EdgeInsets.all(20),
                            height: 300,
                            child: Shimmer.fromColors(
                              baseColor: Theme.of(context).cardColor,
                              highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
                              enabled: true,
                              child: GridView.builder(
                                itemCount: 15, // 2 rows × 3 columns
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // 3 columns
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.0,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                      : _displayedFoods.isEmpty
                          ?  Center(child: Text(context.tr.noDishesFound, style: TextStyle(color: Colors.grey)))
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              color: Theme.of(context).primaryColor,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: GridView.builder(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(12.0),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // CHANGED: 3 columns
                                  childAspectRatio: 0.65, // Adjusted for 3 columns
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: _displayedFoods.length,
                                itemBuilder: (context, index) {
                                  final foodWithRestaurant = _displayedFoods[index];
                                  return _FoodCard(foodWithRestaurant: foodWithRestaurant);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// --- HELPER CLASS TO COMBINE FOOD WITH RESTAURANT INFO ---
class FoodWithRestaurant {
  final Food food;
  final String restaurantName;
  final int restaurantId;
  final String? restaurantImage;

  FoodWithRestaurant({
    required this.food,
    required this.restaurantName,
    required this.restaurantId,
    this.restaurantImage,
  });
}

// --- REUSABLE FOOD CARD WIDGET (3-column design) ---
class _FoodCard extends StatelessWidget {
  final FoodWithRestaurant foodWithRestaurant;

  const _FoodCard({required this.foodWithRestaurant});

  @override
  Widget build(BuildContext context) {
    final food = foodWithRestaurant.food;
    
    // Calculate price (handle discount if available)
    double displayPrice = food.discountPrice ?? food.price ?? 0.0;
    bool hasDiscount = food.discountPrice != null && food.price != null && food.discountPrice! < food.price!;

    return GestureDetector(
      onTap: () {
        // Navigate to food details page (to be implemented)
        Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(food: foodWithRestaurant.food)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(9),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image (smaller for 3 columns)
            AspectRatio(
              aspectRatio: 1.2,
              child: food.image != null
                  ? Image.network(
                      food.image!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Center(child: Icon(Icons.fastfood, color: Colors.white, size: 30)),
                      ),
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Center(child: Icon(Icons.fastfood, color: Colors.white, size: 30)),
                    ),
            ),
            
            // Details (compact for 3 columns)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name (NEW)
                  Row(
                    children: [
                      // const Icon(Icons.restaurant, color: Colors.orange, size: 10),
                      // const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          foodWithRestaurant.restaurantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  
                  // Food Title
                  Text(
                    food.name ?? "Unknown Dish",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  
                  // Description (optional, show only if space allows)
                  Text(
                    food.description ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  
                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${food.currency ?? '\$'} ${displayPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                            if (hasDiscount)
                              Text(
                                '${food.currency ?? '\$'} ${food.price!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 7,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.star, color: Colors.amber, size: 12),
                      //     const SizedBox(width: 2),
                      //     Text(
                      //       (food.rating ?? 0).toStringAsFixed(1),
                      //       style: const TextStyle(color: Colors.white, fontSize: 10),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
