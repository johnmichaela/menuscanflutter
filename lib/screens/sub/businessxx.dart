import 'dart:async';
import 'dart:convert';
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/l10n/app_strings.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:ballon/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// ============================================================
// API SERVICE
// ============================================================
class ApiService {
  /// Fetch restaurants sorted by distance (uses device location).
  Future<List<Result>> fetchRestaurantsByDistance(int pageNumber) async {
    try {
      final locationService = LocationService();
      final Position currentPosition =
          await locationService.getCurrentLocation();

      final url =
          "${Urls.baseUrl}/prof/restaurants-high-rated/?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$pageNumber";

      final response = await http.get(Uri.parse(url));
      debugPrint("🔄 Distance fetch: $url");

      if (response.statusCode == 200) {
        final map = jsonDecode(utf8.decode(response.bodyBytes));
        return Resturants.fromJson(map).data!.results!;
      } else {
        throw ServerException(message: "Error: ${response.statusCode}");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Fetch restaurants sorted by reviews.
  Future<List<Result>> fetchRestaurantsByReviews(int pageNumber) async {
    try {
      final url =
          "${Urls.baseUrl}/prof/restaurants-high-rated/?sort_by=reviews&page=$pageNumber";

      final response = await http.get(Uri.parse(url));
      debugPrint("🔄 Reviews fetch: $url");

      if (response.statusCode == 200) {
        final map = jsonDecode(utf8.decode(response.bodyBytes));
        return Resturants.fromJson(map).data!.results!;
      } else {
        throw ServerException(message: "Error: ${response.statusCode}");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Fetch restaurants filtered by category.
  /// [sortBy] must be either 'reviews' or 'distance'.
  Future<List<Result>> fetchRestaurantsByCategory(
    int pageNumber,
    int categoryId, {
    String sortBy = 'reviews',
  }) async {
    try {
      String url;

      if (sortBy == 'distance') {
        final locationService = LocationService();
        final Position currentPosition =
            await locationService.getCurrentLocation();

        url =
            "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$pageNumber";
      } else {
        url =
            "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&sort_by=reviews&page=$pageNumber";
      }

      final response = await http.get(Uri.parse(url));
      debugPrint("🔄 Category fetch: $url");

      if (response.statusCode == 200) {
        final map = jsonDecode(utf8.decode(response.bodyBytes));
        return Resturants.fromJson(map).data!.results!;
      } else {
        throw ServerException(message: "Error: ${response.statusCode}");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<Result>> fetchRestaurants({
  required int pageNumber,
  String? search,
  int? categoryId,
  String sortBy = 'reviews',
}) async {
  try {
    final queryParams = <String, String>{
      'page': pageNumber.toString(),
      'sort_by': sortBy,
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    if (categoryId != null) {
      queryParams['type_business'] = categoryId.toString();
    }

    if (sortBy == 'distance') {
      final locationService = LocationService();
      final Position currentPosition =
          await locationService.getCurrentLocation();
      queryParams['lat'] = currentPosition.latitude.toString();
      queryParams['lon'] = currentPosition.longitude.toString();
    }

    final uri = Uri.parse("${Urls.baseUrl}/prof/restaurants-high-rated/")
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);
    debugPrint("🔄 Fetch: $uri");

    if (response.statusCode == 200) {
      final map = jsonDecode(utf8.decode(response.bodyBytes));
      return Resturants.fromJson(map).data?.results ?? [];
    } else {
      throw ServerException(message: "Error: ${response.statusCode}");
    }
  } on ServerException {
    rethrow;
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}
}

// ============================================================
// SCREEN
// ============================================================
class Business {
  final String name;
  final double rating;
  final int reviewCount;
  final String location;
  final String imageUrl;
  final IconData logoIcon;
  final Color logoBackgroundColor;
  final bool isOpen;

  Business({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.imageUrl,
    required this.logoIcon,
    required this.logoBackgroundColor,
    this.isOpen = true,
  });
}
class RestaurantsCafesScreen extends StatefulWidget {
  const RestaurantsCafesScreen({super.key});

  @override
  State<RestaurantsCafesScreen> createState() => _RestaurantsCafesScreenState();
}

class _RestaurantsCafesScreenState extends State<RestaurantsCafesScreen> {
  // Dummy data based on the image
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Result> _allRestaurants = [];
  List<Result> _displayedRestaurants = [];
  
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  String _currentSort = 'reviews';
  
  // Category related
  int selectedCategoryId = 0; // 0 means "All" or no filter
  int selectedIndex = 0;
  bool isLoadingCategories = true;
  String? errorMessageCategories;
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;
  final ScrollController _scrollController = ScrollController();
 InternetConnectionStatus? _lastConnectionStatus;
   // ===== SLIDER =====
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentSlide = 0;
  Timer? _autoSlideTimer;
 
  @override
  void initState() {
    super.initState();
    _loadRestaurants();
    // _startAutoSlide();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterRestaurants);

    _connectionSubscription =
      InternetConnectionChecker.instance.onStatusChange.listen((status) {
    if (_lastConnectionStatus == InternetConnectionStatus.disconnected &&
        status == InternetConnectionStatus.connected) {
      _loadRestaurants();
      
    }

    _lastConnectionStatus = status;
  });
  }

  
  Future<void> _loadRestaurants() async {
    setState(() { 
      _isLoading = true; 
      _errorMessage = null; 
    });

    try {
      List<Result> fetchedData;
      
      // Check if we're filtering by category
      // if (selectedCategoryId != 0) {
      //   // Fetch by category
      //   fetchedData = await _fetchRestaurantsByCategory();
      // } else {
        // Fetch all restaurants
        if (_currentSort == 'distance') {
          fetchedData = await _apiService.fetchRestaurantsByDistance(_currentPage);
        } else {
          fetchedData = await _apiService.fetchRestaurantsByReviews(_currentPage);
        }
      

      setState(() {
        if (_currentPage == 1) {
          _allRestaurants = fetchedData;
        } else {
          _allRestaurants.addAll(fetchedData);
        }
        _filterRestaurants();
        _isLoading = false;
      });
    } catch (e) {
      setState(() { 
        _errorMessage = e.toString(); 
        _isLoading = false; 
      });
    }
  }

  // NEW: Fetch restaurants by category
  Future<List<Result>> _fetchRestaurantsByCategory() async {
    try {
      String url;
      LocationService locationService = LocationService();
      
      if (_currentSort == 'distance') {
        Position currentPosition = await locationService.getCurrentLocation();
        url = "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$selectedCategoryId&lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$_currentPage";
      } else {
        url = "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$selectedCategoryId&sort_by=reviews&page=$_currentPage";
      }
      
      print("🔄 Fetching category restaurants: $url");
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        var map = jsonDecode(utf8.decode(response.bodyBytes));
        print(map);
        return Resturants.fromJson(map).data!.results!;

      } else {
        print(response.body);
        throw ServerException(message: "Error: ${response.statusCode}");
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  void _filterRestaurants() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayedRestaurants = _allRestaurants;
      } else {
        _displayedRestaurants = _allRestaurants.where((r) {
          return (r.name?.toLowerCase().contains(query) ?? false) ||
                 (r.place?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  // NEW: Handle category selection
  void _selectCategory(int index, int categoryId) {
    setState(() {
      selectedIndex = index;
      selectedCategoryId = categoryId;
      _currentPage = 1;
      _allRestaurants = [];
      _displayedRestaurants = [];
    });
    _loadRestaurants();
  }

  Future<void> _refresh() async {
    _currentPage = 1;
    await _loadRestaurants();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading) {
        _currentPage++;
        _loadRestaurants();
      }
    }
  }

  void _changeSort(String? newSort) {
    if (newSort != null && newSort != _currentSort) {
      setState(() {
        _currentSort = newSort;
        _currentPage = 1;
        _allRestaurants = [];
        _displayedRestaurants = [];
      });
      _loadRestaurants();
    }
  }

  final List<Business> businesses = [
    Business(
      name: 'The Grill House',
      rating: 4.5,
      reviewCount: 124,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.local_fire_department,
      logoBackgroundColor: const Color(0xFF2C2C2C),
    ),
    Business(
      name: 'Urban Café',
      rating: 4.6,
      reviewCount: 98,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.coffee,
      logoBackgroundColor: const Color(0xFF6D4C41),
    ),
    Business(
      name: 'Pizza Corner',
      rating: 4.4,
      reviewCount: 87,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.local_pizza,
      logoBackgroundColor: const Color(0xFFE53935),
    ),
    Business(
      name: 'Burger Zone',
      rating: 4.3,
      reviewCount: 72,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.lunch_dining,
      logoBackgroundColor: const Color(0xFF212121),
    ),
    Business(
      name: 'Fresh Bites',
      rating: 4.7,
      reviewCount: 65,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1622597467836-f3824f1c1f2b?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.eco,
      logoBackgroundColor: const Color(0xFF43A047),
    ),
    Business(
      name: 'Golden Bakery',
      rating: 4.2,
      reviewCount: 53,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.bakery_dining,
      logoBackgroundColor: const Color(0xFF8D6E63),
    ),
    Business(
      name: 'Ocean Delight',
      rating: 4.6,
      reviewCount: 91,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.set_meal,
      logoBackgroundColor: const Color(0xFF1976D2),
    ),
    Business(
      name: 'The Lounge Café',
      rating: 4.4,
      reviewCount: 68,
      location: 'Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop&q=60',
      logoIcon: Icons.local_cafe,
      logoBackgroundColor: const Color(0xFF8E24AA),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: 
      CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // _buildSearchBar(),
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
                            style: const TextStyle(color: Colors.grey),
                            decoration: InputDecoration(
                              hintText: context.tr.searchRestaurants,
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
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
                  ),
                ),
              ],
            ),
          ),
                  // const SizedBox(height: 16),
                  //    SliverToBoxAdapter(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Text(context.tr.restaurants, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                  //             if (selectedCategoryId != 0) ...[
                  //               const SizedBox(width: 8),
                  //               Container(
                  //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  //                 decoration: BoxDecoration(
                  //                   color: const Color(0xFF00a884),
                  //                   borderRadius: BorderRadius.circular(12),
                  //                 ),
                  //                 child: Text(
                  //                   context.tr.filtered,
                  //                   style: const TextStyle(fontSize: 10),
                  //                 ),
                  //               ),
                  //             ],
                  //           ],
                  //         ),
                  //         DropdownButton<String>(
                  //           value: _currentSort,
                  //           dropdownColor: Theme.of(context).cardColor,
                  //           icon: Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
                  //           underline: const SizedBox(),
                  //           style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                  //           items: [
                  //             DropdownMenuItem(value: 'distance', child: Text(context.tr.byDistance)),
                  //             DropdownMenuItem(value: 'reviews', child: Text(context.tr.byReviews)),
                  //           ],
                  //           onChanged: _changeSort,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

//                   const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72, // Adjusts the height of the cards
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildBusinessCard(businesses[index]);
                },
                childCount: businesses.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
//           // --- MAIN LIST ---
// if (_isLoading && _allRestaurants.isEmpty)
//   const SliverFillRemaining(
//     child: Center(child: CircularProgressIndicator()),
//   )
// else if (_errorMessage != null && _allRestaurants.isEmpty)
//   // --- ERROR / SHIMMER PLACEHOLDER ---
//   SliverPadding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//     sliver: SliverToBoxAdapter(
//       child: SizedBox(
//         height: 270,
//         child: Shimmer.fromColors(
//           baseColor: Theme.of(context).cardColor,
//           highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
//           enabled: true,
//           child: GridView.builder(
//             itemCount: 4,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.72,
//             ),
//             itemBuilder: (context, index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     ),
//   )
// else if (_displayedRestaurants.isEmpty)
//   SliverFillRemaining(
//     child: Center(
//       child: Text(
//         context.tr.noRestaurantsFound,
//         style: const TextStyle(color: Colors.grey),
//       ),
//     ),
//   )
// else
//   // --- GRID OF BUSINESS CARDS ---
//   SliverPadding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     sliver: SliverGrid(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.72, // Adjusts the height of the cards
//       ),
//       delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           if (index >= _displayedRestaurants.length) {
//             return _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : const SizedBox.shrink();
//           }

//           final r = _displayedRestaurants[index];
//           return _buildBusinessCardList(r);
//         },
//         childCount: _displayedRestaurants.length + 1,
//         ),
//     ),
//   ),
        ],
      ),
     
    );
  }

  // --- Widget Builders ---

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0D47A1), // Dark blue
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=60',
              fit: BoxFit.cover,
            ),
            // Blue Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D47A1).withOpacity(0.95),
                    const Color(0xFF0D47A1).withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // Header Content
            Positioned(
              left: 20,
              top: 80,
              right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E88E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.restaurant, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Restaurants & Cafés',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Delicious food, great vibes,\njust around you.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.storefront, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text(
                                '523+ businesses',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants, cafés or food places...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.tune, color: Color(0xFF1E88E5)),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final List<String> filters = ['All', 'Restaurants', 'Cafés', 'Fast Food', 'Bars', 'Bakeries'];
    int selectedIndex = 0; // 'All' is selected by default

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          bool isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E88E5) : const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF333333),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBusinessCardList(Result business) {
    return GestureDetector(
       onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: business)),
    ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      business.banner!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                    ),
                  ),
                  if (business.isOpen!)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
                            SizedBox(width: 4),
                            Text(
                              'Open',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Details Section
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo Icon
                        CircleAvatar(
                          radius:30 ,
                          backgroundColor: Colors.grey,
                          foregroundImage: NetworkImage(business.picture!),
                        ),
                        // Container(
                        //   width: 40,
                        //   height: 40,
                        //   decoration: BoxDecoration(
                        //     color: business.logoBackgroundColor,
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: Icon(business.logoIcon, color: Colors.white, size: 15),
                        // ),
                        const SizedBox(width: 10),
                        Text(
                                business.name!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001F5B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),]),
                        // Text Information
                        
                              const SizedBox(height: 4),
      
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFFFB300), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${business.rating} (${business.reviews} reviews)',
                                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Color(0xFF1E88E5), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    business.place!,
                                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                          
                        
                        // Arrow Icon
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.chevron_right, color: Color(0xFF001F5B), size: 20),
                        ),
                    
                  ]   
              ),)),
          ]),
            ),
    );
       
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 1, // "Businesses" selected
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1E88E5),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          activeIcon: Icon(Icons.grid_view_rounded),
          label: 'Businesses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
  Widget _buildBusinessCard(Business business) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    business.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                  ),
                ),
                if (business.isOpen)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
                          SizedBox(width: 4),
                          Text(
                            'Open',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Details Section
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: business.logoBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(business.logoIcon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  // Text Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          business.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001F5B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFB300), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${business.rating} (${business.reviewCount} reviews)',
                              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF1E88E5), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              business.location,
                              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow Icon
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.chevron_right, color: Color(0xFF001F5B), size: 20),
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