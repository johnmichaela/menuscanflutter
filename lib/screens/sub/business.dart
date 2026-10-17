
// API SERVICE
// ============================================================
import 'dart:convert';
import 'dart:async';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/screens/main/home.dart';
import 'package:ballon/screens/sub/loading.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/screens/sub/shimerwidget.dart';
import 'package:ballon/screens/sub/slivershimer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:ballon/l10n/app_strings.dart';


class ApiService {
  /// Fetch restaurants sorted by distance (uses device location).
  // Future<List<Result>> fetchRestaurantsByDistance(int pageNumber) async {
  //   try {
  //     final locationService = LocationService();
  //     final Position currentPosition =
  //         await locationService.getCurrentLocation();

  //     final url =
  //         "${Urls.baseUrl}/prof/restaurants-high-rated/?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$pageNumber";

  //     final response = await http.get(Uri.parse(url));
  //     debugPrint("🔄 Distance fetch: $url");

  //     if (response.statusCode == 200) {
  //       final map = jsonDecode(utf8.decode(response.bodyBytes));
  //       return Resturants.fromJson(map).data!.results!;
  //     } else {
  //       throw ServerException(message: "Error: ${response.statusCode}");
  //     }
  //   } on ServerException {
  //     rethrow;
  //   } catch (e) {
  //     throw ServerException(message: e.toString());
  //   }
  // }

  // /// Fetch restaurants sorted by reviews.
  // Future<List<Result>> fetchRestaurantsByReviews(int pageNumber) async {
  //   try {
  //     final url =
  //         "${Urls.baseUrl}/prof/restaurants-high-rated/?sort_by=reviews&page=$pageNumber";

  //     final response = await http.get(Uri.parse(url));
  //     debugPrint("🔄 Reviews fetch: $url");

  //     if (response.statusCode == 200) {
  //       final map = jsonDecode(utf8.decode(response.bodyBytes));
  //       return Resturants.fromJson(map).data!.results!;
  //     } else {
  //       throw ServerException(message: "Error: ${response.statusCode}");
  //     }
  //   } on ServerException {
  //     rethrow;
  //   } catch (e) {
  //     throw ServerException(message: e.toString());
  //   }
  // }

  /// Fetch restaurants filtered by category.
  /// [sortBy] must be either 'reviews' or 'distance'.
  // Future<List<Result>> fetchRestaurantsByCategory(
  //   int pageNumber,
  //   int categoryId, {
  //   String sortBy = 'reviews',
  // }) async {
  //   try {
  //     String url;

  //     if (sortBy == 'distance') {
  //       final locationService = LocationService();
  //       final Position currentPosition =
  //           await locationService.getCurrentLocation();

  //       url =
  //           "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$pageNumber";
  //     } else {
  //       url =
  //           "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&sort_by=reviews&page=$pageNumber";
  //     }

  //     final response = await http.get(Uri.parse(url));
  //     debugPrint("🔄 Category fetch: $url");

  //     if (response.statusCode == 200) {
  //       final map = jsonDecode(utf8.decode(response.bodyBytes));
  //       return Resturants.fromJson(map).data!.results!;
  //     } else {
  //       throw ServerException(message: "Error: ${response.statusCode}");
  //     }
  //   } on ServerException {
  //     rethrow;
  //   } catch (e) {
  //     throw ServerException(message: e.toString());
  //   }
  // }

  Future<List<Result>> fetchRestaurants({
  required int pageNumber,
  String? search,
  required int categoryId,
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

    final uri = Uri.parse("${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&")
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



// Import your real model + service
// import 'path/to/resturants_model.dart';
// import 'path/to/api_service.dart';

class RestaurantsCafesScreen extends StatefulWidget {
  CategoryModel category;
   RestaurantsCafesScreen({super.key,required this.category});

  @override
  State<RestaurantsCafesScreen> createState() => _RestaurantsCafesScreenState();
}

class _RestaurantsCafesScreenState extends State<RestaurantsCafesScreen> {
  // --- Controllers & State ---
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  final List<Result> _businesses = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasNextPage = true;
  String? _errorMessage;

  // Filter state
  int _selectedFilterIndex = 0;
  String _sortBy = 'reviews'; // or 'distance'
  final List<String> _filters = [
    'All',
    'Restaurants',
    'Cafés',
    'Fast Food',
    'Bars',
    'Bakeries',
  ];

  @override
  void initState() {
    super.initState();
    _fetchBusinesses(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // --- Pagination ---
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasNextPage &&
        !_isLoading) {
      _fetchBusinesses();
    }
  }

  // --- Data Fetching ---
  Future<void> _fetchBusinesses({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _currentPage = 1;
        _hasNextPage = true;
        _businesses.clear();
      });
    } else {
      if (_isLoadingMore) return;
      setState(() => _isLoadingMore = true);
    }

    try {
      final results = await _apiService.fetchRestaurants(
        categoryId: widget.category.id,
        pageNumber: _currentPage,
        search: _searchController.text,
        sortBy: _sortBy,
      );

      setState(() {
        if (refresh) {
          _businesses.clear();
        }
        _businesses.addAll(results);
        _hasNextPage = results.length >= 10; // adjust based on your page size
        if (_hasNextPage) _currentPage++;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('ServerException: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  // --- Search with Debounce ---
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchBusinesses(refresh: true);
    });
  }

  // --- Filter Selection ---
  void _onFilterSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
      // Map index to category ID if you have one.
      // For now, we just refetch.
    });
    _fetchBusinesses(refresh: true);
  }

  // --- Sort Toggle ---
  void _toggleSort() {
    setState(() {
      _sortBy = _sortBy == 'reviews' ? 'distance' : 'reviews';
    });
    _fetchBusinesses(refresh: true);
  }
Color _hexToColor(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
  @override
  Widget build(BuildContext context) {
    final category=widget.category;
     
    return Scaffold(
      // backgroundColor: Theme.of(context).,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildFilter(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildBody(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  // --- Body: handles loading / error / empty / grid ---
  Widget _buildBody() {
    if (_isLoading) {
      return  SliverBusinessCardShimmerGrid();
      // const SliverFillRemaining(
      //   hasScrollBody: false,
      //   child: Center(child: CircularProgressIndicator()),
      // );
    }

    if (_errorMessage != null && _businesses.isEmpty) {
      return SliverBusinessCardShimmerGrid();
      // SliverFillRemaining(
      //   hasScrollBody: false,
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         const Icon(Icons.error_outline, size: 48, color: Colors.grey),
      //         const SizedBox(height: 12),
      //         Text(_errorMessage!, textAlign: TextAlign.center),
      //         const SizedBox(height: 16),
      //         ElevatedButton(
      //           onPressed: () => _fetchBusinesses(refresh: true),
      //           child:  Text( context.tr.retry ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    }

    if (_businesses.isEmpty) {
      return  SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('Not  found'  ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Show loading indicator at the end
            if (index == _businesses.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildBusinessCardSee(_businesses[index]);
          },
          childCount: _businesses.length + (_isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }

  // --- Sliver App Bar ---
  Widget _buildSliverAppBar() {
     final iconColor = widget.category.colorValue != null
      ? Color(widget.category.colorValue!)
      : Colors.blue;
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0D47A1),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child:   IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
        ),
      )),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.category.cover!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFF0D47A1)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _hexToColor(widget.category.color).withOpacity(0.95),
                    _hexToColor(widget.category.color).withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 80,
              right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration:  BoxDecoration(
                      color: iconColor ,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)
                    ),
                    child: Icon(widget.category.iconData,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          widget.category.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                         Text(
                          widget.category.description!,
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            // color: const Color(0xFF1E88E5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.storefront,
                                  color: Colors.white, size: 22),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.category.count}${context.tr.businessesCount}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
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

  // --- Search Bar with working controller ---
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _fetchBusinesses(refresh: true),
              decoration: InputDecoration(
                hintText: context.tr.searchHint ,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _fetchBusinesses(refresh: true);
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
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
    );
  }

 Widget _buildFilter(){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
   Text(context.tr.ourBusinesses,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
   Container(
  height: 50,
  padding: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    // color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(7),
    // border: Border.all(color: Colors.grey.shade300),
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: _sortBy,
      icon: Icon(Icons.keyboard_arrow_down,
          color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Theme.of(context).cardColor,
      style:  TextStyle(
        fontSize: 17,
        color: Theme.of(context).textTheme.bodyMedium!.color,
        fontWeight: FontWeight.w600,
      ),
      onChanged: (value) {
        if (value != null && value != _sortBy) {
          setState(() => _sortBy = value);
          _fetchBusinesses(refresh: true);
        }
      },
      items: [
        DropdownMenuItem(
          value: 'reviews',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(Icons.star, size: 16, color: Color(0xFF1E88E5)),
              // SizedBox(width: 6),
              Text( context.tr.topRatedSort),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'distance',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(Icons.near_me, size: 16, color: Color(0xFF1E88E5)),
              // SizedBox(width: 6),
              Text( context.tr.nearestSort),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'rating',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(Icons.trending_up, size: 16, color: Color(0xFF1E88E5)),
              // SizedBox(width: 6),
              Text( context.tr.highestRatingSort),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'newest',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(Icons.fiber_new, size: 16, color: Color(0xFF1E88E5)),
              // SizedBox(width: 6),
              Text(context.tr.newestSort),
            ],
          ),
        ),
      ],
    ),
  ),
),
  ],);
 }
  // --- Filter Chips (working selection) ---
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = index == _selectedFilterIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => _onFilterSelected(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1E88E5)
                      : const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF333333),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- Business Card using REAL Result data ---
  Widget _buildBusinessCard(Result business) {
    final imageUrl = business.banner ??
        business.picture ??
        'https://via.placeholder.com/400x300?text=No+Image';

    final rating = business.averageRating ?? business.rating ?? 0.0;
    final reviews = business.totalReviews ?? business.reviews ?? 0;
    final location = business.place ?? 'Unknown location';
    final name = business.name ?? 'Unnamed';
    final isOpen = business.isOpen ?? true;

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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey[300]),
                  ),
                ),
                if (isOpen)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,
                              color: Color(0xFF4CAF50), size: 8),
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
                  // Logo (use type_business color/icon if available)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    foregroundImage: NetworkImage(business.picture!),
                  ),
                  // Container(
                  //   width: 40,
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //     color: _parseColor(
                  //         business.typeBusiness?.color) ??
                  //         const Color(0xFF1E88E5),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: Icon(
                  //     _iconForType(business.typeBusiness?.name),
                  //     color: Colors.white,
                  //     size: 20,
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                   Expanded(
                     child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                   ),]))),

                     Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   name,
                        //   style: const TextStyle(
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        // const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFFFB300), size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${rating.toStringAsFixed(1)} ($reviews reviews)',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[700]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xFF1E88E5), size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[700]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.chevron_right,
                        color: Color(0xFF001F5B), size: 20),
                  ),
                ],
              // ),
            // ),
          ),
        ],
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
          color: Theme.of(context).cardColor,
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
                          radius:14 ,
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
                        Expanded(
                          child: Text(
                                  business.name!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                                  Expanded(
                                    child: Text(
                                      business.place!,
                                       maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                          
                        
                        // Arrow Icon
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                            Text(business.distance??'Unknown Km',style: TextStyle(fontSize: 10, color: Colors.grey[700]),),
                             Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.chevron_right, color: Theme.of(context).textTheme.bodyMedium!.color, size: 20),
                                                     ),
                           ],
                         ),
                    
                  ]   
              ),)),
          ]),
            ),
    );
       
  }
 
 
 Widget _buildBusinessCardSee(Result category) {
  // Convert the hex color from the model into a Flutter Color
 

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantScreen(restaurant: category),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
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
            flex: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: category.banner != null && category.banner!.isNotEmpty
                  ? Image.network(
                      category.banner!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey),
                    )
                  : Container(color: Colors.grey),
            ),
          ),
          // Details Section
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 13,
                    foregroundImage: NetworkImage(category.picture!),
                  ),
                
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.name!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            // color: Color(0xFF001F5B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Expanded(
                        //   child:
                           Text(
                            category.place!, // "523+ businesses"
                            maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                        // ),
                      ],
                    ),
                  ),
                   Icon(Icons.chevron_right,
                      size: 16, color: Theme.of(context).textTheme.bodyMedium!.color!),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 13,right: 13,bottom: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(category.distance??'',style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),),
              Row(
                                  children: [
                                    const Icon(Icons.star, color: Color(0xFFFFB300), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${category.rating} (${category.reviews} reviews)',
                                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
            ],),
          )
        ],
      ),
    ),
  );
}
  // --- Helpers ---
  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final cleaned = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return null;
    }
  }

  IconData _iconForType(String? typeName) {
    if (typeName == null) return Icons.storefront;
    final name = typeName.toLowerCase();
    if (name.contains('caf')) return Icons.coffee;
    if (name.contains('pizza')) return Icons.local_pizza;
    if (name.contains('burger')) return Icons.lunch_dining;
    if (name.contains('bak')) return Icons.bakery_dining;
    if (name.contains('bar')) return Icons.local_bar;
    if (name.contains('sea') || name.contains('fish')) return Icons.set_meal;
    return Icons.restaurant;
  }
}