// // API SERVICE
// // ============================================================
// import 'dart:convert';
// import 'dart:async';
// import 'package:ballon/qr_scanner_screen.dart';
// import 'package:ballon/screens/main/homefine.dart';
// import 'package:ballon/screens/sub/loading.dart';
// import 'package:ballon/screens/sub/offer.dart';
// import 'package:ballon/screens/sub/screens.dart';
// import 'package:ballon/screens/sub/shimerwidget.dart';
// import 'package:ballon/screens/sub/slivershimer.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:ballon/core/handle_error/execptions.dart';
// import 'package:ballon/models/resturants.dart';
// import 'package:ballon/pagination/data/data_source/urls.dart';
// import 'package:ballon/services/geolocation.dart';
// import 'package:ballon/l10n/app_strings.dart';

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
//         final Position currentPosition = await locationService
//             .getCurrentLocation();
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
// }

// class RestaurantsCafesScreen extends StatefulWidget {
//   CategoryModel category;
//   RestaurantsCafesScreen({super.key, required this.category});

//   @override
//   State<RestaurantsCafesScreen> createState() => _RestaurantsCafesScreenState();
// }

// class _RestaurantsCafesScreenState extends State<RestaurantsCafesScreen> {
//   // --- Controllers & State ---
//   final ApiService _apiService = ApiService();
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   Timer? _debounce;

//   final List<Result> _businesses = [];
//   int _currentPage = 1;
//   bool _isLoading = false;
//   bool _isLoadingMore = false;
//   bool _hasNextPage = true;
//   String? _errorMessage;

//   // --- NEW: Toggle State ---
//   bool _isGridView = true;

//   // Filter state
//   int _selectedFilterIndex = 0;
//   String _sortBy = 'reviews';
//   final List<String> _filters = [
//     'All',
//     'Restaurants',
//     'Cafés',
//     'Fast Food',
//     'Bars',
//     'Bakeries',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchBusinesses(refresh: true);
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   // --- Pagination ---
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 200 &&
//         !_isLoadingMore &&
//         _hasNextPage &&
//         !_isLoading) {
//       _fetchBusinesses();
//     }
//   }

//   // --- Data Fetching ---
//   Future<void> _fetchBusinesses({bool refresh = false}) async {
//     if (refresh) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//         _currentPage = 1;
//         _hasNextPage = true;
//         _businesses.clear();
//       });
//     } else {
//       if (_isLoadingMore) return;
//       setState(() => _isLoadingMore = true);
//     }

//     try {
//       final results = await _apiService.fetchRestaurants(
//         categoryId: widget.category.id,
//         pageNumber: _currentPage,
//         search: _searchController.text,
//         sortBy: _sortBy,
//       );

//       setState(() {
//         if (refresh) {
//           _businesses.clear();
//         }
//         _businesses.addAll(results);
//         _hasNextPage = results.length >= 10;
//         if (_hasNextPage) _currentPage++;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString().replaceFirst('ServerException: ', '');
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//         _isLoadingMore = false;
//       });
//     }
//   }

//   // --- Search with Debounce ---
//   void _onSearchChanged(String query) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       _fetchBusinesses(refresh: true);
//     });
//   }

//   // --- Filter Selection ---
//   void _onFilterSelected(int index) {
//     setState(() {
//       _selectedFilterIndex = index;
//     });
//     _fetchBusinesses(refresh: true);
//   }

//   // --- Sort Toggle ---
//   void _toggleSort() {
//     setState(() {
//       _sortBy = _sortBy == 'reviews' ? 'distance' : 'reviews';
//     });
//     _fetchBusinesses(refresh: true);
//   }

//   Color _hexToColor(String hex) {
//     hex = hex.replaceFirst('#', '');
//     if (hex.length == 6) hex = 'FF$hex';
//     return Color(int.parse(hex, radix: 16));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final category = widget.category;
//     final iconColor = widget.category.colorValue != null
//         ? Color(widget.category.colorValue!)
//         : Colors.blue;

//     return Scaffold(
//       body: CustomScrollView(
//         controller: _scrollController,
//         slivers: [
//           _buildSliverAppBar(),

//           // Promo Banner
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: SizedBox(
//                   height: 190,
//                   width: double.infinity,
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.asset(
//                         'assets/img/promo.png',
//                         fit: BoxFit.cover,
//                         alignment: Alignment.center,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                             colors: [
//                               const Color.fromARGB(255, 7, 138, 245).withOpacity(0.9),
//                               Colors.transparent,
//                             ],
//                             stops: const [0.0, 0.85],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(16, 15, 12, 14),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: FractionallySizedBox(
//                             widthFactor: 0.57,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 9,
//                                     vertical: 5,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFFFC107),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: const Text(
//                                     'SPECIAL OFFER',
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                       color: Color.fromARGB(255, 254, 254, 255),
//                                       fontSize: 9,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 9),
//                                 const Text(
//                                   'Save More\nwith Qopera',
//                                   maxLines: 2,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 23,
//                                     height: 1.05,
//                                     fontWeight: FontWeight.bold,
//                                     shadows: [
//                                       Shadow(
//                                         color: Colors.black26,
//                                         blurRadius: 5,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 const Text(
//                                   'Discover exclusive deals near you.',
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     height: 1.2,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Flexible(
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => OfferScreen(),
//                                         ),
//                                       );
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color(0xFF08B653),
//                                       foregroundColor: Colors.white,
//                                       elevation: 0,
//                                       minimumSize: const Size(0, 34),
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                         vertical: 7,
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     child: const FittedBox(
//                                       fit: BoxFit.scaleDown,
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             'View All Offers',
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(width: 5),
//                                           Icon(
//                                             Icons.arrow_forward_rounded,
//                                             size: 14,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Search & Filters
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildSearchBar(),
//                   const SizedBox(height: 12),
//                   _buildToggleSwitch(), // <--- NEW TOGGLE SWITCH
//                   const SizedBox(height: 12),
//                   _buildFilter(),
//                   const SizedBox(height: 6),
//                 ],
//               ),
//             ),
//           ),

//           // Body content (Switches between Grid and List)
//           _buildBody(),

//           const SliverToBoxAdapter(child: SizedBox(height: 20)),
//         ],
//       ),
//     );
//   }

//   // --- NEW: Grid / List Toggle Widget ---
//   Widget _buildToggleSwitch() {
//     return Container(
//       height: 45,
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: const Color.fromARGB(31, 224, 224, 224)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _isGridView = true),
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: _isGridView
//                       ? accent
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.grid_view,
//                       size: 18,
//                       color: _isGridView ? Colors.white : Colors.grey,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Grid View',
//                       style: TextStyle(
//                         color: _isGridView ? Colors.white : Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _isGridView = false),
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: !_isGridView
//                       ? accent
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.list,
//                       size: 18,
//                       color: !_isGridView ? Colors.white : Colors.grey,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'List View',
//                       style: TextStyle(
//                         color: !_isGridView ? Colors.white : Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Body: handles loading / error / empty / grid / list ---
//   Widget _buildBody() {
//     if (_isLoading) {
//       return SliverBusinessCardShimmerGrid();
//     }

//     // if (_errorMessage != null && _businesses.isEmpty) {
//     //   return SliverBusinessCardShimmerGrid();
//     // }

//     if (_businesses.isEmpty) {
//       return SliverFillRemaining(
//         hasScrollBody: false,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.search_off, size: 48, color: Colors.grey),
//               SizedBox(height: 12),
//               Text('Not found'),
//             ],
//           ),
//         ),
//       );
//     }

//     // --- GRID VIEW ---
//     if (_isGridView) {
//       return SliverPadding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         sliver: SliverGrid(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 4,
//             mainAxisSpacing: 4,
//             childAspectRatio: 0.60,
//           ),
//           delegate: SliverChildBuilderDelegate((context, index) {
//             if (index == _businesses.length) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return _buildBusinessCardSee(_businesses[index]);
//           }, childCount: _businesses.length + (_isLoadingMore ? 1 : 0)),
//         ),
//       );
//     }
//     // --- NEW: LIST VIEW ---
//     else {
//       return SliverPadding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         sliver: SliverList(
//           delegate: SliverChildBuilderDelegate((context, index) {
//             if (index == _businesses.length) {
//               return const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             }
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 6.0),
//               child: _buildBusinessListCard(_businesses[index]),
//             );
//           }, childCount: _businesses.length + (_isLoadingMore ? 1 : 0)),
//         ),
//       );
//     }
//   }

//   // --- NEW: List View Card Widget ---
//   Widget _buildBusinessListCard(Result category) {
//     final banner = category.banner ?? '';
//     final picture = category.picture ?? '';
//     final name = category.name ?? 'Business';
//     final place = category.place ?? 'Location unavailable';
//     final rating = category.rating ?? 0;
//     final distance = category.distance ?? '--';
//     final reviews = category.reviews ?? 0;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => RestaurantScreen(restaurant: category),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Left Image
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: banner.isNotEmpty
//                         ? Image.network(
//                             banner,
//                             width: 90,
//                             height: 90,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => Container(
//                               width: 90,
//                               height: 90,
//                               color: Colors.grey.shade300,
//                             ),
//                           )
//                         : Container(
//                             width: 90,
//                             height: 90,
//                             color: Colors.grey.shade300,
//                           ),
//                   ),
//                   Positioned(
//                     top: 4,
//                     right: 4,
//                     child: category.isOpen!
//                         ? Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               'Open',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               'Closed',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 12),
//               // Right Content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (picture.isNotEmpty)
//                                 CircleAvatar(
//                                   radius: 12,
//                                   backgroundImage: NetworkImage(picture),
//                                   backgroundColor: Colors.grey,
//                                 ),
//                               const SizedBox(width: 6),
//                               Expanded(
//                                 child: Text(
//                                   name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 12),
//                         const SizedBox(width: 4),
//                         Text(
//                           '$rating ($reviews reviews)',
//                           style: const TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           '$distance',
//                           style: const TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         //  OutlinedButton(
//                         //   onPressed: () {
//                         //     Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //         builder: (_) => RestaurantScreen(restaurant: category),
//                         //       ),
//                         //     );
//                         //   },
//                         //   style: OutlinedButton.styleFrom(
//                         //     side: const BorderSide(color: Color(0xFF0052CC)),
//                         //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//                         //     minimumSize: const Size(0, 26),
//                         //   ),
//                         //   child: Row(
//                         //     children: const [
//                         //       Text('View', style: TextStyle(fontSize: 11, color: Color(0xFF0052CC))),
//                         //       Icon(Icons.chevron_right, size: 14, color: Color(0xFF0052CC)),
//                         //     ],
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on,
//                           color: Colors.grey,
//                           size: 12,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             '$place',
//                             style: const TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     RestaurantScreen(restaurant: category),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               vertical: 4,
//                               horizontal: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               color: accent,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'View Detail',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(width: 7),
//                                 Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 14,
//                                   color: Colors.white,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- Sliver App Bar ---
//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       pinned: true,
//       floating: false,
//       backgroundColor: accent,
//       // surfaceTintColor: Colors.white,
//       elevation: 0,
//       toolbarHeight: 60,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_rounded,
//           color: Color.fromARGB(255, 252, 253, 253),
//           size: 25,
//         ),
//         onPressed: () => Navigator.of(context).pop(),
//         tooltip: 'Back',
//       ),
//       title: Text(
//         widget.category.name,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: const TextStyle(
//           color: Color.fromARGB(255, 254, 255, 255),
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   // --- Search Bar with working controller ---
//   Widget _buildSearchBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 50,
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: TextField(
//               controller: _searchController,
//               onChanged: _onSearchChanged,
//               textInputAction: TextInputAction.search,
//               onSubmitted: (_) => _fetchBusinesses(refresh: true),
//               decoration: InputDecoration(
//                 hintText: context.tr.searchHint,
//                 hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 suffixIcon: _searchController.text.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, color: Colors.grey),
//                         onPressed: () {
//                           _searchController.clear();
//                           _fetchBusinesses(refresh: true);
//                           setState(() {});
//                         },
//                       )
//                     : null,
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 15),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const QrScannerScreen()),
//           ),
//           child: Container(
//             height: 50,
//             width: 50,
//             decoration: BoxDecoration(
//               color: accent,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.qr_code_scanner,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilter() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           context.tr.ourBusinesses,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Container(
//           height: 50,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _sortBy,
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: accent,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               dropdownColor: Theme.of(context).cardColor,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Theme.of(context).textTheme.bodyMedium!.color,
//                 fontWeight: FontWeight.w600,
//               ),
//               onChanged: (value) {
//                 if (value != null && value != _sortBy) {
//                   setState(() => _sortBy = value);
//                   _fetchBusinesses(refresh: true);
//                 }
//               },
//               items: [
//                 DropdownMenuItem(
//                   value: 'reviews',
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [Text(context.tr.topRatedSort)],
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'distance',
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [Text(context.tr.nearestSort)],
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'rating',
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [Text(context.tr.highestRatingSort)],
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'newest',
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [Text(context.tr.newestSort)],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // --- Business Card (Grid View) ---
//   Widget _buildBusinessCardSee(Result category) {
//     final banner = category.banner ?? '';
//     final picture = category.picture ?? '';
//     final name = category.name ?? 'Business';
//     final place = category.place ?? 'Location unavailable';
//     final rating = category.rating ?? 0;
//     final distance = category.distance ?? '--';
//     final reviews = category.reviews ?? 0;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => RestaurantScreen(restaurant: category),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: const Color.fromARGB(29, 238, 238, 238)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 4,
//               child: Stack(
//                 fit: StackFit.expand,
//                 clipBehavior: Clip.none,
//                 children: [
//                   if (banner.isNotEmpty)
//                     Image.network(
//                       banner,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         color: Colors.blue.shade50,
//                         child: Icon(
//                           Icons.storefront_rounded,
//                           size: 34,
//                           color: Theme.of(
//                             context,
//                           ).primaryColor.withOpacity(0.65),
//                         ),
//                       ),
//                     )
//                   else
//                     Container(
//                       color: Colors.blue.shade50,
//                       child: Icon(
//                         Icons.storefront_rounded,
//                         size: 34,
//                         color: accent.withOpacity(0.65),
//                       ),
//                     ),
//                   Positioned(
//                     top: 7,
//                     right: 7,
//                     child: Container(
//                       padding: const EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardColor.withOpacity(0.95),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.arrow_outward_rounded,
//                         color: accent,
//                         size: 13,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 9,
//                     bottom: -19,
//                     child: Container(
//                       width: 40,
//                       height: 40,
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: ClipOval(
//                         child: picture.isNotEmpty
//                             ? Image.network(
//                                 picture,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (_, __, ___) =>
//                                     _businessPlaceholder(
//                                       accent,
//                                     ),
//                               )
//                             : _businessPlaceholder(
//                                 accent,
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 6,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 23, 8, 7),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         // color: Color(0xFF172B4D),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         height: 1.15,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_rounded,
//                           size: 12,
//                           color: accent,
//                         ),
//                         const SizedBox(width: 3),
//                         Expanded(
//                           child: Text(
//                             place,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 9,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.star_rounded,
//                           color: Color(0xFFFFB300),
//                           size: 15,
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           rating is num ? rating.toStringAsFixed(1) : '$rating',
//                           style: const TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                         Expanded(
//                           child: Text(
//                             '($reviews)',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(fontSize: 9, color: Colors.grey),
//                           ),
//                         ),
//                         Spacer(),
//                         Flexible(
//                           child: Text(
//                             distance,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         color: accent,
//                         border: Border.all(
//                           color: accent,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "View Detail",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _businessPlaceholder(Color color) {
//     return Container(
//       color: color.withOpacity(0.09),
//       alignment: Alignment.center,
//       child: Icon(Icons.store_rounded, size: 23, color: color),
//     );
//   }
// }

// API SERVICE
// ============================================================
import 'dart:convert';
import 'dart:async';
import 'package:ballon/screens/main/homefine.dart';
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

      final uri = Uri.parse(
        "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&",
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
}

class RestaurantsCafesScreen extends StatefulWidget {
  CategoryModel category;
  RestaurantsCafesScreen({super.key, required this.category});

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

  // --- Grid / List toggle ---
  bool _isGridView = true;

  // --- Promo carousel ---
  final PageController _promoPageController =
      PageController(viewportFraction: 0.92);
  Timer? _promoTimer;
  int _currentPromoPage = 0;

  // Filter state
  int _selectedFilterIndex = 0;
  String _sortBy = 'reviews';
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
    _startPromoTimer();
    _fetchBusinesses(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoPageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // --- Promo carousel timer ---
  void _startPromoTimer() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_promoPageController.hasClients) return;
      final promoLen = _promoData.length;
      if (promoLen < 2) return;

      if (_currentPromoPage >= promoLen - 1) {
        _promoPageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _promoPageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
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

  // --- Filter Selection ---
  void _onFilterSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
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

  // --- Promo data (same look & feel as HomePages) ---
  List<Map<String, String>> get _promoData => [
        {
          'title1': context.tr.promoTitle1Line1,
          'title2': context.tr.promoTitle1Line2,
          'desc': context.tr.promoDesc1,
          'img': 'assets/img/everythings.png',
          'color': '#1D6FE8',
        },
        {
          'title1': context.tr.promoTitle2Line1,
          'title2': context.tr.promoTitle2Line2,
          'desc': context.tr.promoDesc2,
          'img': 'assets/img/shop.png',
          'color': '#1D6FE8',
        },
        {
          'title1': context.tr.promoTitle3Line1,
          'title2': context.tr.promoTitle3Line2,
          'desc': context.tr.promoDesc3,
          'img': 'assets/img/more.png',
          'color': '#1D6FE8',
        },
      ];

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),

          // ---- Promo Carousel (like HomePages) ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              child: _buildPromoBanner(_promoData),
            ),
          ),

          // ---- Indicators ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _buildIndicators(_promoData),
            ),
          ),

          // ---- Search & Filters ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  _buildSearchBar(), // includes grid/list toggle
                  const SizedBox(height: 12),
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

  // --- Promo Banner (PageView) ---
  Widget _buildPromoBannerx(List<Map<String, String>> promoData) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _promoPageController,
        itemCount: promoData.length,
        onPageChanged: (index) {
          setState(() => _currentPromoPage = index);
        },
        itemBuilder: (context, index) {
          final promo = promoData[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(promo['img']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    _hexToColor(promo['color']!).withOpacity(0.9),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    promo['title1']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  Stack(
                    children: [
                      // White outline
                      Text(
                        promo['title2']!,
                        style: TextStyle(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      // Main color text
                      Text(
                        promo['title2']!,
                        style: TextStyle(
                          color: _hexToColor(promo['color']!),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    promo['desc']!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  // --- Promo Banner (PageView) — category-based ---
Widget _buildPromoBanner(List<Map<String, String>> promoData) {
  final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;

  // Cover image — use network cover if available,
  // otherwise fall back to the current asset-based promos.
  final hasCover = cat.cover != null && cat.cover!.trim().isNotEmpty;

  return SizedBox(
    height: 180,
    child: hasCover
        // ================= Single category card with cover =================
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: CachedNetworkImageProvider(cat.cover!),
                fit: BoxFit.cover,
                onError: (_, __) {}, // ignore load errors
              ),
              color: accent.withOpacity(0.15), // behind the image
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(0.92),
                    accent.withOpacity(0.55),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Small count chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${cat.count} ${context.tr.businessesCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Category name
                  Text(
                    cat.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 6),
                      ],
                    ),
                  ),

                  // Description (if any)
                  if (cat.description != null &&
                      cat.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      cat.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )

        // ================= Fallback: keep old PageView promos =================
        : PageView.builder(
            controller: _promoPageController,
            itemCount: promoData.length,
            onPageChanged: (index) {
              setState(() => _currentPromoPage = index);
            },
            itemBuilder: (context, index) {
              final promo = promoData[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(promo['img']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        _hexToColor(promo['color']!).withOpacity(0.9),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo['title1']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      Stack(
                        children: [
                          Text(
                            promo['title2']!,
                            style: TextStyle(
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            promo['title2']!,
                            style: TextStyle(
                              color: _hexToColor(promo['color']!),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        promo['desc']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}

  Widget _buildIndicators(List<Map<String, String>> promoData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(promoData.length, (index) {
        return _buildIndicator(index == _currentPromoPage);
      }),
    );
  }

  Widget _buildIndicator(bool isActive) {
     final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isActive ? 16 : 6,
      height: 6,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isActive
            ? accent
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // --- Body: handles loading / error / empty / grid / list ---
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
    else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == _businesses.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: _buildBusinessListCard(_businesses[index]),
              );
            },
            childCount: _businesses.length + (_isLoadingMore ? 1 : 0),
          ),
        ),
      );
    }
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
  final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;

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
                        ? Image.network(
                            banner,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
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
                          // Stack(
                          //   children: [
                          //     CircleAvatar(
                          //       radius: 13,
                          //       backgroundImage: NetworkImage(picture),
                          //       backgroundColor: Colors.grey,
                          //     ),
                          //     Positioned(
                          //     bottom: -4, // Shifts the badge down slightly
                          //     right: -4,  // Shifts the badge right slightly
                          //     child: ScallopedTierBadge(
                          //       tierLabel: category.tier, // or 'vip', 'vvp', 'free'
                          //       size: 18, // Small size for the badge to match the 24px avatar
                          //     ),
                          //   ),
                          //   ],
                          // ),
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
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$distance',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$place',
                            style: const TextStyle(
                              fontSize: 9,
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
                        const SizedBox(),
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
                              color: accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'View Detail',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 7),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13,
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
  Widget _buildSliverAppBar() {
    final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;
    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor:accent,
      elevation: 0,
      toolbarHeight: 60,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Color.fromARGB(255, 252, 253, 253),
          size: 25,
        ),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      ),
      title: Text(
        widget.category.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color.fromARGB(255, 254, 255, 255),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Search Bar with Grid/List Toggle (replaces QR) ---
  Widget _buildSearchBar() {
     final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _fetchBusinesses(refresh: true),
              decoration: InputDecoration(
                hintText: context.tr.searchHint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
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
              color: accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilter() {
     final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.tr.ourBusinesses,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: accent,
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
                    children: [Text(context.tr.topRatedSort)],
                  ),
                ),
                DropdownMenuItem(
                  value: 'distance',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(context.tr.nearestSort)],
                  ),
                ),
                DropdownMenuItem(
                  value: 'rating',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(context.tr.highestRatingSort)],
                  ),
                ),
                DropdownMenuItem(
                  value: 'newest',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(context.tr.newestSort)],
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
 final cat = widget.category;

  // Accent color from the category (fallback to theme primary)
  final accent = cat.colorValue != null
      ? Color(cat.colorValue!)
      : Theme.of(context).primaryColor;

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
                    Image.network(
                      banner,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.blue.shade50,
                        child: Icon(
                          Icons.storefront_rounded,
                          size: 34,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.65),
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
                            accent.withOpacity(0.65),
                      ),
                    ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.95),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        color: accent,
                        size: 13,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 9,
                    bottom: -19,
                    child:  Stack(
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
                          color: accent,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            place,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
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
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Text(
                            distance,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9,
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
                        color: accent,
                        border: Border.all(
                          color: accent,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "View Detail",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 13,
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