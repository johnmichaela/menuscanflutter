import 'dart:convert';

import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/resturants.dart' show Food, Result, Resturants;
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
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

  List<Food> _allFoods = [];
  List<Food> _displayedFoods = [];
  
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  String _currentSort = 'distance';
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterFoods);
  }

  // Fetch restaurants and extract all food items
  Future<void> _loadFoods() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      List<Result> fetchedRestaurants;
      if (_currentSort == 'distance') {
        fetchedRestaurants = await _apiService.fetchRestaurantsByDistance(_currentPage);
      } else {
        fetchedRestaurants = await _apiService.fetchRestaurantsByReviews(_currentPage);
      }

      // Extract foods from restaurants
      List<Food> newFoods = [];
      for (var r in fetchedRestaurants) {
        if (r.foods != null) {
          newFoods.addAll(r.foods!);
        }
      }

      setState(() {
        if (_currentPage == 1) {
          _allFoods = newFoods;
        } else {
          _allFoods.addAll(newFoods);
        }
        _filterFoods(); // Apply current search filter
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
        _displayedFoods = _allFoods.where((f) {
          return (f.name?.toLowerCase().contains(query) ?? false) ||
                 (f.description?.toLowerCase().contains(query) ?? false);
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
      backgroundColor: Colors.black,
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
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search dishes...',
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
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E5B94),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),

            // --- TITLE AND FILTER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discover Foods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: _currentSort,
                    dropdownColor: const Color(0xFF1C1C1E),
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: const [
                      DropdownMenuItem(value: 'distance', child: Text('Nearby Restaurants')),
                      DropdownMenuItem(value: 'reviews', child: Text('Top Rated Restaurants')),
                    ],
                    onChanged: _changeSort,
                  ),
                ],
              ),
            ),

            // --- GRID LIST OF FOODS ---
            Expanded(
              child: _isLoading && _allFoods.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null && _allFoods.isEmpty
                      ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                      : _displayedFoods.isEmpty
                          ? const Center(child: Text("No dishes found", style: TextStyle(color: Colors.grey)))
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              color: Colors.blue,
                              backgroundColor: Colors.black,
                              child: GridView.builder(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(12.0),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7, // Adjust aspect ratio for card height
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: _displayedFoods.length,
                                itemBuilder: (context, index) {
                                  final food = _displayedFoods[index];
                                  return _FoodCard(food: food);
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

// --- REUSABLE FOOD CARD WIDGET ---
class _FoodCard extends StatelessWidget {
  final Food food;

  const _FoodCard({required this.food});

  @override
  Widget build(BuildContext context) {
    // Calculate price (handle discount if available)
    double displayPrice = food.discountPrice ?? food.price ?? 0.0;
    bool hasDiscount = food.discountPrice != null && food.price != null && food.discountPrice! < food.price!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          Expanded(
            flex: 3,
            child: food.image != null
                ? Image.network(
                    food.image!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Center(child: Icon(Icons.restaurant, color: Colors.white, size: 40)),
                    ),
                  )
                : Container(
                    color: Colors.grey[800],
                    child: const Center(child: Icon(Icons.restaurant, color: Colors.white, size: 40)),
                  ),
          ),
          
          // Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    food.name ?? "Unknown Dish",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  
                  // Description
                  Expanded(
                    child: Text(
                      food.description ?? "No description available.",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${food.currency ?? ''} ${displayPrice.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (hasDiscount)
                            Text(
                              '${food.currency ?? ''} ${food.price!.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12, decoration: TextDecoration.lineThrough),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            (food.rating ?? 0).toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}