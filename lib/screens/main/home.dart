// API SERVICE
// ============================================================
import 'dart:convert';
import 'dart:async';
import 'package:ballon/ads.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/screens/main/home.dart';
import 'package:ballon/screens/main/homefine.dart';
import 'package:ballon/screens/sub/all_categories_page.dart';
import 'package:ballon/screens/sub/loading.dart';
import 'package:ballon/screens/sub/offer.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/screens/sub/shimerwidget.dart';
import 'package:ballon/screens/sub/slivershimer.dart';
import 'package:ballon/widgets/scalloped_badge.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:ballon/l10n/app_strings.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ApiService {
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

      // Only apply the category filter when a real category is selected.
      // categoryId == 0 means "All" → no type_business filter.
      if (categoryId > 0) {
        queryParams['type_business'] = categoryId.toString();
      }

      if (sortBy == 'distance') {
        final locationService = LocationService();
        final Position currentPosition =
            await locationService.getCurrentLocation();
        queryParams['lat'] = currentPosition.latitude.toString();
        queryParams['lon'] = currentPosition.longitude.toString();
      }

      final uri = Uri.parse(
        "${Urls.baseUrl}/prof/restaurants-high-rated/",
      ).replace(queryParameters: queryParams);

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

  Future<List<CategoryModel>> fetchCategories() async {
    const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';

    try {
      debugPrint("🔄 Fetching categories from: $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint("✅ Found ${data.length} categories");

        return data
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(message: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching categories: $e");
      throw ServerException(message: e.toString());
    }
  }


// class ApiService {
//   Future<List<Result>> fetchRestaurants({
//     required int pageNumber,
//     String? search,
//     required int categoryId,
//     String sortBy = 'reviews',
//   }) async {
//     try {
//       final queryParams = <String, String>{
//         'page': pageNumber.toString(),
//         'sort_by': sortBy,
//       };

//       if (search != null && search.trim().isNotEmpty) {
//         queryParams['search'] = search.trim();
//       }

//       if (categoryId != null) {
//         queryParams['type_business'] = categoryId.toString();
//       }

//       if (sortBy == 'distance') {
//         final locationService = LocationService();
//         final Position currentPosition =
//             await locationService.getCurrentLocation();
//         queryParams['lat'] = currentPosition.latitude.toString();
//         queryParams['lon'] = currentPosition.longitude.toString();
//       }

//       final uri = Uri.parse(
//         "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&",
//       ).replace(queryParameters: queryParams);

//       final response = await http.get(uri);
//       debugPrint("🔄 Fetch: $uri");

//       if (response.statusCode == 200) {
//         final map = jsonDecode(utf8.decode(response.bodyBytes));
//         return Resturants.fromJson(map).data?.results ?? [];
//       } else {
//         throw ServerException(message: "Error: ${response.statusCode}");
//       }
//     } on ServerException {
//       rethrow;
//     } catch (e) {
//       throw ServerException(message: e.toString());
//     }
//   }

  /// Fetch the category list from the typemodel endpoint.
  Future<List<CategoryModel>> fetchCategoriess() async {
    const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';

    try {
      debugPrint("🔄 Fetching categories from: $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      debugPrint("📡 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint("✅ Found ${data.length} categories");

        final List<CategoryModel> parsedCategories = data
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return parsedCategories;
      } else {
        throw ServerException(message: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching categories: $e");
      throw ServerException(message: e.toString());
    }
  }
}

IconData tierIcon(String tierLabel) {
  switch (tierLabel.toLowerCase()) {
    case 'vip':
      return Icons.workspace_premium_rounded;
    case 'vvp':
      return Icons.diamond_rounded;
    case 'free':
    default:
      return Icons.person_outline_rounded;
  }
}

Color tierIconColor(String tierLabel) {
  switch (tierLabel.toLowerCase()) {
    case 'vip':
      return const Color(0xFFFFB300); // amber
    case 'vvp':
      return const Color(0xFF8E24AA); // purple
    case 'free':
    default:
      return const Color(0xFF78909C); // blue-grey
  }
}

Color tierContainerColor(String tierLabel, BuildContext context) {
  final base = tierIconColor(tierLabel);
  // Light tinted background; works in both light and dark themes
  return Color.alphaBlend(
    base.withOpacity(0.18),
    Theme.of(context).cardColor.withOpacity(0.95),
  );
}
class HomePages extends StatefulWidget {
  // final CategoryModel category;

  const HomePages({super.key, });

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
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

  // --- Grid / List toggle ---
  bool _isGridView = true;

  // --- Category strip state ---
  List<CategoryModel> _categories = [];
  bool _isLoadingCategories = true;
  String? _errorMessageCategories;
 int _selectedCategoryId =0;

  // Sort state
  String _sortBy = 'reviews';
 bool _adsActive =false;
  @override
  void initState() {
    super.initState();
    // _selectedCategoryId = widget.category.id;
    // // Pre-seed the strip with the current category so it renders immediately
    // _categories = [widget.category];
    getActive();
    _fetchCategories();
    _fetchBusinesses(refresh: true);
    _scrollController.addListener(_onScroll);
  }

 Future<void> getActive() async {
  final prefs = await SharedPreferences.getInstance();
  final bool active = prefs.getBool('ads_active') ?? false;
  if (!mounted) return;
  setState(() {
    _adsActive = active;
  });
}
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // --- Categories ---
  Future<void> _fetchCategories() async {
  setState(() {
    _isLoadingCategories = true;
    _errorMessageCategories = null;
  });

  try {
    final parsed = await _apiService.fetchCategories();
    if (!mounted) return;

    // ✅ Insert a synthetic "All" category at index 0
    final allCategory = CategoryModel(id: 0, name: 'All');

    setState(() {
      _categories = [allCategory, ...parsed];
      _isLoadingCategories = false;
      _errorMessageCategories = null;
    });

    // If current selection is still valid, keep it; otherwise default to All
    final selectionExists =
        _categories.any((c) => c.id == _selectedCategoryId);
    if (!selectionExists) {
      _selectedCategoryId = 0; // All
      _fetchBusinesses(refresh: true);
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      _isLoadingCategories = false;
      _errorMessageCategories =
          e.toString().replaceFirst('ServerException: ', '');
    });
  }
}
  Future<void> _fetchCategoriesx() async {
    setState(() {
      _isLoadingCategories = true;
      _errorMessageCategories = null;
    });

    try {
      final parsed = await _apiService.fetchCategories();
      if (!mounted) return;
      setState(() {
        _categories = parsed;
        _isLoadingCategories = false;
        _errorMessageCategories = null;
      });

      // If the currently selected category isn't in the fetched list,
      // fall back to the first one.
      if (_categories.isNotEmpty &&
          !_categories.any((c) => c.id == _selectedCategoryId)) {
        _selectedCategoryId = _categories.first.id;
        _fetchBusinesses(refresh: true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingCategories = false;
        _errorMessageCategories =
            e.toString().replaceFirst('ServerException: ', '');
      });
    }
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
        categoryId: _selectedCategoryId,
        pageNumber: _currentPage,
        search: _searchController.text,
        sortBy: _sortBy,
      );

      setState(() {
        if (refresh) {
          _businesses.clear();
        }
        _businesses.addAll(results);
        _hasNextPage = results.length >= 10;
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

  // --- Category tap ---
  void _onCategorySelected(CategoryModel category) {
    if (_selectedCategoryId == category.id) return;
    setState(() {
      _selectedCategoryId = category.id;
    });
    _fetchBusinesses(refresh: true);
  }

/// Returns a list of shadows that look good in both light & dark mode.
List<BoxShadow> _cardShadow(BuildContext context, {double elevation = 1.0}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  if (isDark) {
    // In dark mode, a faint white glow separates the card from the background.
    return [
      BoxShadow(
        color: Colors.white.withOpacity(0.04 * elevation),
        blurRadius: 8 * elevation,
        spreadRadius: 0.5,
        offset: const Offset(0, 2),
      ),
      // Slight black shadow underneath for depth
      BoxShadow(
        color: Colors.black.withOpacity(0.35),
        blurRadius: 6 * elevation,
        offset: const Offset(0, 3),
      ),
    ];
  }

  // Light mode: soft neutral black shadow
  return [
    BoxShadow(
      color: Colors.black.withOpacity(0.04 * elevation),
      blurRadius: 8 * elevation,
      offset: const Offset(0, 3),
    ),
  ];
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // _buildSliverAppBar(),

          // ---- Promo Banner ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/img/promo.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              const Color.fromARGB(255, 7, 138, 245)
                                  .withOpacity(0.9),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.85],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 15, 12, 14),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.57,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFC107),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'SPECIAL OFFER',
                                    maxLines: 1,
                                    style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 254, 254, 255),
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                const Text(
                                  'Save More\nwith Qopera',
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    height: 1.05,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Discover exclusive deals near you.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => OfferScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF08B653),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      minimumSize: const Size(0, 34),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 7,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'View All Offers',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(context.tr.category,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                GestureDetector(
                  onTap: () {
                     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AllCategoriesPage(
          // 👇 reuse the already-loaded list → instant open, no refetch
          // initialCategories: categories,
        ),
      ),
    );
                  },
                  child: Text(context.tr.viewAll,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Theme.of(context).primaryColor),))

              ],))),
          // ---- Horizontal Category Strip ----
          SliverToBoxAdapter(
            child: _buildCategoryStrip(),
          ),

          // ---- Search bar (with grid/list toggle) + sort ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                children: [
                  _buildSearchBar(),
                 
                   const SizedBox(height: 3),
                  _adsActive ? SizedBox():BannerAdWidget(),
                  SizedBox(height:3),
                  _buildFilter(),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),

          // ---- Body content ----
          _buildBody(),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  // --- Horizontal Category Strip ---
  Widget _buildCategoryStrip() {
    // Loading state
    if (_isLoadingCategories) {
      return SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   width: 56,
              //   height: 56,
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade200,
              //     shape: BoxShape.circle,
              //   ),
              // ),
              // const SizedBox(height: 6),
              Container(
                width: 50,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Error state
    if (_errorMessageCategories != null && _categories.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: TextButton.icon(
            onPressed: _fetchCategories,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry categories'),
          ),
        ),
      );
    }

    // Empty state
    if (_categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategoryId == cat.id;
          final color = cat.colorValue != null
              ? Color(cat.colorValue!)
              : Theme.of(context).primaryColor;

          return GestureDetector(
            onTap: () => _onCategorySelected(cat),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
              decoration: BoxDecoration(
                color:isSelected? Theme.of(context).primaryColor:Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: const Color.fromARGB(29, 158, 158, 158),width: 2),
                boxShadow:  _cardShadow(context, elevation: 1.0),
              ),
              child: Text(cat.name,style: TextStyle(fontSize: 13,fontWeight: isSelected? FontWeight.bold:FontWeight.w400,color:isSelected?Colors.white:Theme.of(context).textTheme.bodyMedium!.color),),
            )
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     // Container(
            //     //   width: 56,
            //     //   height: 56,
            //     //   decoration: BoxDecoration(
            //     //     color: isSelected ? color : color.withOpacity(0.12),
            //     //     shape: BoxShape.circle,
            //     //     border: isSelected
            //     //         ? Border.all(color: color, width: 2)
            //     //         : null,
            //     //   ),
            //     //   child: Icon(
            //     //     cat.iconData, // or map from cat if available
            //     //     color: isSelected ? Colors.white : color,
            //     //     size: 26,
            //     //   ),
            //     // ),
            //     // const SizedBox(height: 6),
            //     SizedBox(
            //       width: 64,
            //       child: Text(
            //         cat.name,
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 11,
            //           fontWeight: isSelected
            //               ? FontWeight.bold
            //               : FontWeight.w500,
            //           color: isSelected
            //               ? Theme.of(context)
            //                   .textTheme
            //                   .bodyMedium
            //                   ?.color
            //               : Colors.grey,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          );
        },
      ),
    );
  }

  // --- Body ---
  Widget _buildBody() {
    if (_isLoading) {
      return SliverBusinessCardShimmerGrid();
    }

    if (_businesses.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.search_off, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('Not found'),
            ],
          ),
        ),
      );
    }

    // --- GRID VIEW ---
    // --- GRID VIEW with inline native ads ---
// if (_isGridView) {
//   const adsEvery = 1; // every 9 cards ≈ 3 rows of 3
//   final adCount = _businesses.length ~/ adsEvery;
//   final chunks = <Widget>[];

//   int start = 0;
//   for (int i = 0; i < adCount; i++) {
//     final end = start + adsEvery;
//     final chunk = _businesses.sublist(start, end.clamp(0, _businesses.length));

//     chunks.add(
//       SliverPadding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         sliver: SliverGrid(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 4,
//             mainAxisSpacing: 4,
//             childAspectRatio: 0.60,
//           ),
//           delegate: SliverChildBuilderDelegate(
//             (context, index) => _buildBusinessCardSee(chunk[index]),
//             childCount: chunk.length,
//           ),
//         ),
//       ),
//     );

//     // Ad row between chunks
//     chunks.add(
//       const SliverToBoxAdapter(
//         child: NativeAdWidgetGrid(),
//       ),
//     );

//     start = end;
//   }

//   // Remaining businesses (after the last ad slot)
//   final tail = _businesses.sublist(start.clamp(0, _businesses.length));
//   chunks.add(
//     SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 4,
//           mainAxisSpacing: 4,
//           childAspectRatio: 0.60,
//         ),
//         delegate: SliverChildBuilderDelegate(
//           (context, index) {
//             if (index == tail.length) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return _buildBusinessCardSee(tail[index]);
//           },
//           childCount: tail.length + (_isLoadingMore ? 1 : 0),
//         ),
//       ),
//     ),
//   );

//   return  SliverMainAxisGroup(slivers: chunks);
// }
    if (_isGridView) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 0.60,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
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
    // --- LIST VIEW ---
    // else {
    //   return SliverPadding(
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     sliver: SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //         (context, index) {
    //           if (index == _businesses.length) {
    //             return const Padding(
    //               padding: EdgeInsets.all(16.0),
    //               child: Center(child: CircularProgressIndicator()),
    //             );
    //           }
    //           return Padding(
    //             padding: const EdgeInsets.only(bottom: 6.0),
    //             child: _buildBusinessListCard(_businesses[index]),
    //           );
    //         },
    //         childCount: _businesses.length + (_isLoadingMore ? 1 : 0),
    //       ),
    //     ),
    //   );
    // }
    else {
  const int adsEvery = 1;

  // Total child count:
  //   businesses + (1 ad per group of 5) + (optional loading indicator)
  final int adSlots = _businesses.length ~/ adsEvery;
  final int extraTail =
      (_businesses.length % adsEvery == 0 && _businesses.length > 0) ? 1 : 0;
  // ↑ ensures an ad also appears after the very last item when length
  //   is an exact multiple of 5 (optional — remove if not wanted)

  final int childCount =
      _businesses.length + adSlots + extraTail + (_isLoadingMore ? 1 : 0);

  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // 1) Bottom loading indicator
          if (index == childCount - 1 && _isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // 2) Ad slot: after every 5 items (index 5, 11, 17, ...)
          //    We also catch the tail ad via `extraTail`.
          final bool isAdSlot =
              ((index + 1) % (adsEvery + 1) == 0) ||
              (extraTail == 1 && index == childCount - 1 - (_isLoadingMore ? 1 : 0));

          if (isAdSlot) {
            return _adsActive ? SizedBox(): Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: NativeAdWidget(),
            );
          }

          // 3) Map list index → business index (skip ad slots)
          final int businessIndex =
              index - (index ~/ (adsEvery + 1)) - _tailAdOffset(index, extraTail);

          // Safety guard
          if (businessIndex < 0 || businessIndex >= _businesses.length) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: _buildBusinessListCard(_businesses[businessIndex]),
          );
        },
        childCount: childCount,
      ),
    ),
  );
}
  }
int _tailAdOffset(int index, int extraTail) {
  if (extraTail == 1) {
    final tailAdIndex = _businesses.length + (_businesses.length ~/ 5);
    if (index > tailAdIndex) return 1;
  }
  return 0;
}
  // --- List View Card ---
  Widget _buildBusinessListCard(Result category) {
    final banner = category.banner ?? '';
    final picture = category.picture ?? '';
    final name = category.name ?? 'Business';
    final place = category.place ?? 'Location unavailable';
    final rating = category.rating ?? 0;
    final distance = category.distance ?? '--';
    final reviews = category.reviews ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantScreen(restaurant: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: banner.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: banner,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade300,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade300,
                    ),
                  )
                : Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade300,
                  ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: category.isOpen == true
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Open',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Closed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (picture.isNotEmpty)
                          // CircleAvatar(
                          //   radius: 12,
                          //   backgroundImage: NetworkImage(picture),
                          //   backgroundColor: Colors.grey,
                          // ),
                          Stack(
  clipBehavior: Clip.none, // Allows the badge to overflow outside the avatar boundaries
  children: [
    CircleAvatar(
      radius: 12,
      backgroundImage: NetworkImage(picture),
      backgroundColor: Colors.grey,
    ),
    Positioned(
      bottom: -4, // Shifts the badge down slightly
      right: -4,  // Shifts the badge right slightly
      child: ScallopedTierBadge(
        tierLabel: category.tier, // or 'vip', 'vvp', 'free'
        size: 14, // Small size for the badge to match the 24px avatar
      ),
    ),
  ],
),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                       
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($reviews reviews)',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$distance',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$place',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
//                           Container(
//   padding: const EdgeInsets.all(5),
//   decoration: BoxDecoration(
//     color: tierContainerColor(category.tier, context),
//     shape: BoxShape.circle,
//     border: Border.all(
//       color: tierIconColor(category.tier).withOpacity(0.45),
//       width: 1,
//     ),
//   ),
//   child: Icon(
//     tierIcon(category.tier),
//     color: tierIconColor(category.tier),
//     size: 13,
//   ),
// ), 
// Row(
//   children: [
//     ScallopedTierBadge(tierLabel: category.tier, size: 20),

//   ],
// ),
SizedBox(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RestaurantScreen(restaurant: category),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  'View Detail',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 7),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Sliver App Bar ---
  // Widget _buildSliverAppBar() {
  //   return SliverAppBar(
  //     pinned: true,
  //     floating: false,
  //     backgroundColor: Theme.of(context).primaryColor,
  //     elevation: 0,
  //     toolbarHeight: 60,
  //     leading: IconButton(
  //       icon: const Icon(
  //         Icons.arrow_back_rounded,
  //         color: Color.fromARGB(255, 252, 253, 253),
  //         size: 25,
  //       ),
  //       onPressed: () => Navigator.of(context).pop(),
  //       tooltip: 'Back',
  //     ),
  //     title: Text(
  //       // widget.category.name,
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //       style: const TextStyle(
  //         color: Color.fromARGB(255, 254, 255, 255),
  //         fontSize: 20,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  // --- Search Bar with Grid/List toggle (replaces QR) ---
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow:  _cardShadow(context, elevation: 1.0),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _fetchBusinesses(refresh: true),
              decoration: InputDecoration(
                hintText: context.tr.searchHint,
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
        // Grid/List toggle icon (replaces QR button)
        GestureDetector(
          onTap: () => setState(() => _isGridView = !_isGridView),
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isGridView ? LucideIcons.list : LucideIcons.layoutGridCircles,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.tr.ourBusinesses,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Theme.of(context).cardColor,
              style: TextStyle(
                fontSize: 13,
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
                    children: [Text(context.tr.topRatedSort,style:TextStyle(fontSize: 13))],
                  ),
                ),
                DropdownMenuItem(
                  value: 'distance',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(context.tr.nearestSort,style:TextStyle(fontSize: 13))],
                  ),
                ),
                DropdownMenuItem(
                  value: 'rating',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(context.tr.highestRatingSort,style:TextStyle(fontSize: 13))],
                  ),
                ),
                DropdownMenuItem(
                  value: 'newest',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(context.tr.newestSort,style:TextStyle(fontSize: 13))],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Business Card (Grid View) ---
  Widget _buildBusinessCardSee(Result category) {
    final banner = category.banner ?? '';
    final picture = category.picture ?? '';
    final name = category.name ?? 'Business';
    final place = category.place ?? 'Location unavailable';
    final rating = category.rating ?? 0;
    final distance = category.distance ?? '--';
    final reviews = category.reviews ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantScreen(restaurant: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color.fromARGB(29, 238, 238, 238)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  if (banner.isNotEmpty)
                CachedNetworkImage(
                    imageUrl: banner,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: Colors.blue.shade50,
                      child: Icon(
                        Icons.storefront_rounded,
                        size: 34,
                        color: Theme.of(context).primaryColor.withOpacity(0.65),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.blue.shade50,
                      child: Icon(
                        Icons.storefront_rounded,
                        size: 34,
                        color: Theme.of(context).primaryColor.withOpacity(0.65),
                      ),
                    ),
                  )
    
                  else
                    Container(
                      color: Colors.blue.shade50,
                      child: Icon(
                        Icons.storefront_rounded,
                        size: 34,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.65),
                      ),
                    ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child:
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.95),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 13,
                      ),
                    ),
                    
                  ),
                  Positioned(
                    left: 9,
                    bottom: -19,
                    child: Stack(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            // shape: BoxShape.circle,
                            // border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipOval(
                            child: picture.isNotEmpty
                                ?CachedNetworkImage(
                                  height: 40,
                                  width: 40,
                                  imageUrl: picture,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => _businessPlaceholder(
                                    Theme.of(context).primaryColor,
                                  ),
                                  errorWidget: (_, __, ___) => _businessPlaceholder(
                                    Theme.of(context).primaryColor,
                                  ),
                                )
                                
                                : _businessPlaceholder(
                                    Theme.of(context).primaryColor,
                                  ),
                          ),
                        ),
                     
    Positioned(
      bottom: -1, // Shifts the badge down slightly
      right: 0,  // Shifts the badge right slightly
      child: ScallopedTierBadge(
        tierLabel: category.tier, // or 'vip', 'vvp', 'free'
        size: 18, // Small size for the badge to match the 24px avatar
      ),
    ),
                    ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 23, 8, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            place,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB300),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating is num
                              ? rating.toStringAsFixed(1)
                              : '$rating',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '($reviews)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontSize: 8, color: Colors.grey),
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Text(
                            distance,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "View Detail",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
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

  Widget _businessPlaceholder(Color color) {
    return Container(
      color: color.withOpacity(0.09),
      alignment: Alignment.center,
      child: Icon(Icons.store_rounded, size: 23, color: color),
    );
  }
}