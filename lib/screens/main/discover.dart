import 'dart:async';
import 'dart:convert';

import 'package:ballon/ads.dart';
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/resturants.dart' show Food, Result, Resturants;
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:ballon/shimmer.dart';
import 'package:ballon/widgets/scalloped_badge.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ballon/l10n/app_strings.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _adsActive=false;
 InternetConnectionStatus? _lastConnectionStatus;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getActive();
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

Future<void> getActive() async {
  final prefs = await SharedPreferences.getInstance();
  final bool active = prefs.getBool('ads_active') ?? false;
  if (!mounted) return;
  setState(() {
    _adsActive = active;
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

bool _isGridView = true; // true = grid, false = list

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // --- SEARCH BAR AND QR ICON ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
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
                                style: const TextStyle(color: Colors.grey),
                                decoration: InputDecoration(
                                  hintText: context.tr.searchDishesOrRestaurants,
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () => _searchController.clear(),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(width: 12),
                    // GestureDetector(
                    //   onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                    //   ),
                    //   child: Container(
                    //     height: 40,
                    //     width: 40,
                    //     decoration: BoxDecoration(
                    //       color: Theme.of(context).primaryColor,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: const Icon(
                    //       Icons.qr_code_scanner,
                    //       color: Colors.white,
                    //       size: 28,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(width: 8),
                    // 👇 Toggle grid/list
                    GestureDetector(
                      onTap: () => setState(() => _isGridView = !_isGridView),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _isGridView ? LucideIcons.list : LucideIcons.layoutGridCircles,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
              child: _adsActive?SizedBox():Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: BannerAdWidget())),
            // --- TITLE AND FILTER ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr.discover,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: _currentSort,
                      dropdownColor: Theme.of(context).cardColor,
                      icon: Icon(
                        Icons.filter_list,
                        color: Theme.of(context).primaryColor,
                      ),
                      underline: const SizedBox(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 14,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'reviews',
                          child: Text(context.tr.topRated),
                        ),
                        DropdownMenuItem(
                          value: 'distance',
                          child: Text(context.tr.nearbyRestaurants),
                        ),
                      ],
                      onChanged: _changeSort,
                    ),
                  ],
                ),
              ),
            ),

            // --- GRID LIST OF FOODS (3 COLUMNS) ---
            if (_isLoading && _allFoods.isEmpty)
              // Loading state
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null && _allFoods.isEmpty)
              // Error state
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: 300,
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).cardColor,
                    highlightColor:
                        Theme.of(context).cardColor.withOpacity(0.5),
                    enabled: true,
                    child: GridView.builder(
                      itemCount: 15,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
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
                ),
              )
            else if (_displayedFoods.isEmpty)
              // Empty state
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    context.tr.noDishesFound,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
              else if (_isGridView)
  // ---------- GRID ----------
  SliverPadding(
    padding: const EdgeInsets.all(12.0),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.63,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final foodWithRestaurant = _displayedFoods[index];
          return _FoodCard(foodWithRestaurant: foodWithRestaurant);
        },
        childCount: _displayedFoods.length,
      ),
    ),
  )
  
  else 
  // ---------- LIST ----------
   
  SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    sliver: Builder(
      builder: (context) {
         const int adsEvery = 2;
    const int groupSize = adsEvery + 1; // 5 items + 1 ad = 6 slots
    final int adSlots = _displayedFoods.length ~/ adsEvery;
    final int itemCount = _displayedFoods.length + adSlots;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // Is this index an ad slot?
            final int positionInGroup = index % groupSize;   // index % 3 → 0,1,2,0,1,2,...
            final int adsBefore = index ~/ groupSize;        // index ~/ 3
            final bool isAdSlot =
                positionInGroup == adsEvery && adsBefore < adSlots;
              
              if (isAdSlot) {
                return _adsActive?SizedBox(): Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: NativeAdWidget(), // your native widget
                );
              }

              // Map list index → food index (skip ad slots)
              final int foodIndex = index - adsBefore;

              if (foodIndex < 0 || foodIndex >= _displayedFoods.length) {
                return const SizedBox.shrink();
              }

              final foodWithRestaurant = _displayedFoods[foodIndex];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: foodIndex == _displayedFoods.length - 1 ? 0 : 2,
                ),
                child: _FoodListCard(foodWithRestaurant: foodWithRestaurant),
              );
            },
            childCount: itemCount,
          ),
        );
      },
    ),
  ),
// else
//   // ---------- LIST ----------
//   SliverPadding(
//     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//     sliver: SliverList.separated(
//       itemCount: _displayedFoods.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 5),
//       itemBuilder: (context, index) {
//         final foodWithRestaurant = _displayedFoods[index];
//         return _FoodListCard(foodWithRestaurant: foodWithRestaurant);
//       },
//     ),
//   ),
            // else
            //   // Main grid
            //   SliverPadding(
            //     padding: const EdgeInsets.all(12.0),
            //     sliver: SliverGrid(
            //       gridDelegate:
            //           const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 3,
            //         childAspectRatio: 0.65,
            //         crossAxisSpacing: 8,
            //         mainAxisSpacing: 8,
            //       ),
            //       delegate: SliverChildBuilderDelegate(
            //         (context, index) {
            //           final foodWithRestaurant = _displayedFoods[index];
            //           return _FoodCard(
            //             foodWithRestaurant: foodWithRestaurant,
            //           );
            //         },
            //         childCount: _displayedFoods.length,
            //       ),
            //     ),
            //   ),
          ],
        ),
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
class _FoodListCard extends StatelessWidget {
  final FoodWithRestaurant foodWithRestaurant;
  const _FoodListCard({required this.foodWithRestaurant});

  @override
  Widget build(BuildContext context) {
    final food = foodWithRestaurant.food;

    final double displayPrice = food.discountPrice ?? food.price ?? 0.0;
    final bool hasDiscount = food.discountPrice != null &&
        food.price != null &&
        food.discountPrice! < food.price!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailScreen(food: food),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // ---- Image ----
            SizedBox(
              width: 90,
              height: 90,
              child: food.image != null
                  ? Image.network(
                      food.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.fastfood,
                            color: Colors.white, size: 32),
                      ),
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.fastfood,
                          color: Colors.white, size: 32),
                    ),
            ),

            // ---- Details ----
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Restaurant name
                    Row(
                      children: [
                        Text(
                          foodWithRestaurant.restaurantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
        //                 ScallopedTierBadge(
        // tierLabel: foodWithRestaurant.tier, // or 'vip', 'vvp', 'free'
        // size: 18,)
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Food title
                    Text(
                      food.name ?? 'Unknown Dish',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Description
                    if (food.description != null &&
                        food.description!.isNotEmpty)
                      Text(
                        food.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey),
                      ),
                    const SizedBox(height: 6),

                    // Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${food.currency ?? '\$'} ${NumberFormat.decimalPattern().format(displayPrice)}',
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${food.currency ?? '\$'} ${NumberFormat.decimalPattern().format(food.price!)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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
                            fontSize: 9,
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
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
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
                              '${food.currency ?? '\$'} ${NumberFormat.decimalPattern().format(displayPrice)}',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                            if (hasDiscount)
                              Text(
                                '${food.currency ?? '\$'} ${NumberFormat.decimalPattern().format(food.price!)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
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
