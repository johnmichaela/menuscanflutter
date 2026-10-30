import 'dart:async';
import 'dart:convert';
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/models/resturants.dart';
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
import 'package:cached_network_image/cached_network_image.dart';

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

  // NEW: Fetch restaurants by category
  Future<List<Result>> fetchRestaurantsByCategory(int pageNumber, int categoryId) async {
    try {
      // Check if we need location for distance sorting
      String url;
      if (_currentSort == 'distance') {
        LocationService locationService = LocationService();
        Position currentPosition = await locationService.getCurrentLocation();
        url = "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$pageNumber";
      } else {
        url = "${Urls.baseUrl}/prof/restaurants-high-rated/?type_business=$categoryId&sort_by=reviews&page=$pageNumber";
      }
      
      final response = await http.get(Uri.parse(url));
      print("🔄 Fetching category restaurants: $url");
      
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

  // Add this to track current sort
  String _currentSort = 'reviews';
}

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({super.key});

  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
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
  List<CategoryModel> categories = [];
  bool isLoadingCategories = true;
  String? errorMessageCategories;
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;
  final ScrollController _scrollController = ScrollController();
 InternetConnectionStatus? _lastConnectionStatus;
   // ===== SLIDER =====
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentSlide = 0;
  Timer? _autoSlideTimer;
  final List<String> _slideImages = [
    'assets/img/slide1.png',
    'assets/img/slide2.png',
    'assets/img/slide3.png',
    'assets/img/slide4.png',
  ];
  @override
  void initState() {
    super.initState();
    _loadRestaurants();
    fetchCategories();
    _startAutoSlide();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterRestaurants);

    _connectionSubscription =
      InternetConnectionChecker.instance.onStatusChange.listen((status) {
    if (_lastConnectionStatus == InternetConnectionStatus.disconnected &&
        status == InternetConnectionStatus.connected) {
      _loadRestaurants();
      fetchCategories();
    }

    _lastConnectionStatus = status;
  });
  }

  Future<void> fetchCategories() async {
    // For Android emulator, use 10.0.2.2
    // For physical device, use your computer's IP
    const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';
    // const String apiUrl = 'http://10.0.2.2:8000/prof/api/typemodel/';
    
    try {
      setState(() {
        isLoadingCategories = true;
        errorMessageCategories = null;
      });
      
      print("🔄 Fetching categories from: $apiUrl");
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      print("📡 Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("✅ Found ${data.length} categories");
        
        // Add "All" category at the beginning
        final List<CategoryModel> parsedCategories = [
          CategoryModel(id: 0, name: 'All'), // Special "All" category
          ...data.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)),
        ];
        
        print("📋 Categories: ${parsedCategories.map((c) => '${c.name}(${c.id})').join(', ')}");
        
        setState(() {
          categories = parsedCategories;
          isLoadingCategories = false;
          errorMessageCategories = null;
        });
      } else {
        setState(() {
          errorMessageCategories = "Server error: ${response.statusCode}";
          isLoadingCategories = false;
        });
      }
    } catch (e) {
      print("❌ Error fetching categories: $e");
      setState(() {
        errorMessageCategories = "Error: $e";
        isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadRestaurants() async {
    setState(() { 
      _isLoading = true; 
      _errorMessage = null; 
    });

    try {
      List<Result> fetchedData;
      
      // Check if we're filtering by category
      if (selectedCategoryId != 0) {
        // Fetch by category
        fetchedData = await _fetchRestaurantsByCategory();
      } else {
        // Fetch all restaurants
        if (_currentSort == 'distance') {
          fetchedData = await _apiService.fetchRestaurantsByDistance(_currentPage);
        } else {
          fetchedData = await _apiService.fetchRestaurantsByReviews(_currentPage);
        }
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

  void _openQrScanner() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      //  const Color(0xFF1C1C1E),
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
             Text(context.tr.scanQrCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color)),
            const SizedBox(height: 10),
             Text("Integrate your mobile_scanner package here", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      ),
    );
  }
  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 9), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        int nextPage = _currentSlide + 1;
        if (nextPage >= _slideImages.length) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _pauseAutoSlide() => _autoSlideTimer?.cancel();
  void _resumeAutoSlide() => _startAutoSlide();
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           // --- SEARCH BAR AND QR ICON ---
  //           Padding(
  //             padding: const EdgeInsets.all(12.0),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Container(
  //                     height: 50,
  //                     padding: const EdgeInsets.symmetric(horizontal: 12),
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).cardColor,
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         const Icon(Icons.search, color: Colors.grey),
  //                         const SizedBox(width: 10),
  //                         Expanded(
  //                           child: TextField(
  //                             controller: _searchController,
  //                             style: const TextStyle(color: Colors.grey),
  //                             decoration: InputDecoration(
  //                               hintText: context.tr.searchRestaurants,
  //                               hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
  //                               border: InputBorder.none,
  //                             ),
  //                           ),
  //                         ),
  //                         if (_searchController.text.isNotEmpty)
  //                           GestureDetector(
  //                             onTap: () => _searchController.clear(),
  //                             child: const Icon(Icons.close, color: Colors.grey, size: 20),
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 GestureDetector(
  //                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerScreen())),
  //                   child: Container(
  //                     height: 50,
  //                     width: 50,
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).primaryColor,
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //                     // ===== 4-IMAGE AUTO SLIDER =====
  //           const SizedBox(height: 8),
  //           Container(
  //             padding: EdgeInsets.symmetric(vertical: 5),
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               // boxShadow: [

  //               // ]
  //             ),
  //             height: 200,
  //             child: GestureDetector(
  //               onPanDown: (_) => _pauseAutoSlide(),
  //               onPanCancel: _resumeAutoSlide,
  //               onPanEnd: (_) => _resumeAutoSlide(),
  //               child: PageView.builder(
  //                 controller: _pageController,
  //                 itemCount: _slideImages.length,
  //                 onPageChanged: (index) {
  //                   setState(() => _currentSlide = index);
  //                 },
  //                 itemBuilder: (context, index) {
  //                   final bool isActive = _currentSlide == index;
  //                   return AnimatedScale(
  //                     scale: isActive ? 1.0 : 0.95,
  //                     duration: const Duration(milliseconds: 600),
  //                     child: AnimatedOpacity(
  //                       opacity: isActive ? 1.0 : 0.7,
  //                       duration: const Duration(milliseconds: 600),
  //                       child: Container(
  //                         margin: const EdgeInsets.symmetric(horizontal: 0),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(16),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.black.withOpacity(0.15),
  //                               blurRadius: 10,
  //                               offset: const Offset(0, 5),
  //                             ),
  //                           ],
  //                         ),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(10),
  //                           child: Image.asset(
  //                             _slideImages[index],
  //                             fit: BoxFit.cover,
  //                             width: double.infinity,
  //                             errorBuilder: (c, e, s) => Container(
  //                               color: Theme.of(context).cardColor,
  //                               child: const Center(
  //                                 child: Icon(Icons.image_not_supported,
  //                                     color: Colors.grey, size: 40),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),

  //           // ===== DOTS INDICATOR =====
  //           const SizedBox(height: 10),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: List.generate(
  //               _slideImages.length,
  //               (index) => AnimatedContainer(
  //                 duration: const Duration(milliseconds: 300),
  //                 margin: const EdgeInsets.symmetric(horizontal: 4),
  //                 height: 8,
  //                 width: _currentSlide == index ? 24 : 8,
  //                 decoration: BoxDecoration(
  //                   color: _currentSlide == index
  //                       ? Theme.of(context).primaryColor
  //                       : Colors.grey.shade400,
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           // --- CATEGORY LIST ---
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 10.0),
  //             child: isLoadingCategories?
  //                 // ? const Center(
  //                 //     child: SizedBox(
  //                 //       height: 40,
  //                 //       child: Center(child: CircularProgressIndicator()),
  //                 //     ),
  //                 //   )
  //                 Container(
  //                       height: 70,
  //                         child:  Shimmer.fromColors(
  //                                     baseColor: Theme.of(context).cardColor,
  //                                     highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
  //                                     enabled: true,
  //                                     child: ListView.builder(
  //                                         itemCount: 4,
  //                                          physics: const NeverScrollableScrollPhysics(),
  //                                         scrollDirection: Axis.horizontal,
  //                                         itemBuilder: ((context, index) {
  //                                           return Container(
  //                                             margin: EdgeInsets.symmetric(
  //                                                 horizontal: 5, vertical: 10),
  //                                             height: 60,
  //                                             width: 120,
  //                                             decoration: BoxDecoration(
  //                                                 color: Theme.of(context).cardColor,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(10)),
  //                                           );
  //                                         }))),
  //                       )
  //                 : errorMessageCategories != null
  //                     ? Container(
  //                       height: 70,
  //                         child:  Shimmer.fromColors(
  //                                     baseColor: Theme.of(context).cardColor,
  //                                     highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
  //                                     enabled: true,
  //                                     child: ListView.builder(
  //                                         itemCount: 4,
  //                                          physics: const NeverScrollableScrollPhysics(),
  //                                         scrollDirection: Axis.horizontal,
  //                                         itemBuilder: ((context, index) {
  //                                           return Container(
  //                                             margin: EdgeInsets.symmetric(
  //                                                 horizontal: 5, vertical: 10),
  //                                             height: 60,
  //                                             width: 120,
  //                                             decoration: BoxDecoration(
  //                                                 color: Theme.of(context).cardColor,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(10)),
  //                                           );
  //                                         }))),
  //                       )
  //                     : categories.isEmpty
  //                         ?  Center(
  //                             child: Text(
  //                               'No categories available',
  //                               style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12),
  //                             ),
  //                           )
  //                         : SizedBox(
  //                             height: 40,
  //                             child: ListView.separated(
  //                               scrollDirection: Axis.horizontal,
  //                               padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //                               itemCount: categories.length,
  //                               separatorBuilder: (context, index) => const SizedBox(width: 8.0),
  //                               itemBuilder: (context, index) {
  //                                 final isSelected = selectedIndex == index;
  //                                 final category = categories[index];
  //                                 return CategoryChip(
  //                                   label: category.name,
  //                                   isSelected: isSelected,
  //                                   onTap: () => _selectCategory(index, category.id),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //           ),

  //           // --- FILTER DROPDOWN ---
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                      Text(context.tr.restaurants, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
  //                     if (selectedCategoryId != 0) ...[
  //                       const SizedBox(width: 8),
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //                         decoration: BoxDecoration(
  //                           color: const Color(0xFF00a884),
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                         child: Text(
  //                           context.tr.filtered,
  //                           style: const TextStyle( fontSize: 10),
  //                         ),
  //                       ),
  //                     ],
  //                   ],
  //                 ),
  //                 DropdownButton<String>(
  //                   value: _currentSort,
  //                   dropdownColor: Theme.of(context).cardColor,
  //                   icon:  Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
  //                   underline: const SizedBox(),
  //                   style:  TextStyle( fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
  //                   items: [
  //                     DropdownMenuItem(value: 'distance', child: Text(context.tr.byDistance)),
  //                     DropdownMenuItem(value: 'reviews', child: Text(context.tr.byReviews)),
  //                   ],
  //                   onChanged: _changeSort,
  //                 ),
  //               ],
  //             ),
  //           ),

  //           // --- MAIN LIST ---
  //           Expanded(
  //             child: _isLoading && _allRestaurants.isEmpty
  //                 ? const Center(child: CircularProgressIndicator())
  //                 : _errorMessage != null && _allRestaurants.isEmpty
  //                     ?Container(
  //                       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //                       height: 270,
  //                         child:  Shimmer.fromColors(
  //                                     baseColor: Theme.of(context).cardColor,
  //                                     highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
  //                                     enabled: true,
  //                                     child: ListView.builder(
  //                                         itemCount: 4,
  //                                          physics: const NeverScrollableScrollPhysics(),
  //                                         scrollDirection: Axis.vertical,
  //                                         itemBuilder: ((context, index) {
  //                                           return Row(
  //                                             children:[
  //                                               Container(
  //                                             margin: EdgeInsets.symmetric(
  //                                                 horizontal: 5, vertical: 10),
  //                                             height: 120,
  //                                             width: 120,
  //                                             decoration: BoxDecoration(
  //                                                 color: Theme.of(context).cardColor,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(10)),
  //                                           ),
  //                                           Column(
  //                                             children: [
  //                                               Container(
  //                                             margin: EdgeInsets.symmetric(
  //                                                 horizontal: 5, vertical: 10),
  //                                             height: 30,
  //                                             width: 180,
  //                                             decoration: BoxDecoration(
  //                                                 color: Theme.of(context).cardColor,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(10)),
  //                                           ),
  //                                            Container(
  //                                             margin: EdgeInsets.symmetric(
  //                                                 horizontal: 5, vertical: 10),
  //                                             height: 30,
  //                                             width: 180,
  //                                             decoration: BoxDecoration(
  //                                                 color: Theme.of(context).cardColor,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(10)),
  //                                           ),]),
  //                                           ]);
  //                                         }))),
  //                       )
  //                     : _displayedRestaurants.isEmpty
  //                         ?  Center(child: Text(context.tr.noRestaurantsFound, style: TextStyle(color: Colors.grey)))
  //                         : RefreshIndicator(
  //                             onRefresh: _refresh,
  //                             color: Theme.of(context).primaryColor,
  //                             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //                             child: ListView.separated(
  //                               controller: _scrollController,
  //                               physics: const AlwaysScrollableScrollPhysics(),
  //                               itemCount: _displayedRestaurants.length + 1,
  //                               separatorBuilder: (ctx, i) => const Divider(color: Colors.grey, height: 1, thickness: 0.5),
  //                               itemBuilder: (context, index) {
  //                                 if (index >= _displayedRestaurants.length) {
  //                                   return _isLoading 
  //                                       ? const Padding(
  //                                           padding: EdgeInsets.all(16.0),
  //                                           child: Center(child: CircularProgressIndicator()),
  //                                         )
  //                                       : const SizedBox(height: 50);
  //                                 }

  //                                 final r = _displayedRestaurants[index];
  //                                 return GestureDetector(
  //                                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r))),
      
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //                                     child: Row(
  //                                       children: [
  //                                         Stack(
  //                                           children: [
  //                                             ClipRRect(
  //                                               borderRadius: BorderRadius.circular(10),
  //                                               child: SizedBox(
  //                                                 width: 70,
  //                                                 height: 70,
  //                                                 child: r.banner != null
  //                                                     ? CachedNetworkImage(r.banner!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey))
  //                                                     : Container(color: Colors.grey, child: const Icon(Icons.restaurant)),
  //                                               ),
  //                                             ),
  //                                             Positioned(
  //                                               bottom: 0,
  //                                               right: 0,
  //                                               child: CircleAvatar(
  //                                                 radius: 14,
  //                                                 backgroundColor: Colors.black.withOpacity(0.6),
  //                                                 child: CircleAvatar(
  //                                                   radius: 12,
  //                                                   backgroundImage: r.picture != null ? NetworkImage(r.picture!) : null,
  //                                                   backgroundColor: r.picture == null ? Colors.grey : null,
  //                                                 ),
  //                                               )
  //                                             )
  //                                           ],
  //                                         ),
  //                                         const SizedBox(width: 16),
  //                                         Expanded(
  //                                           child: Column(
  //                                             crossAxisAlignment: CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 r.name ?? "Unknown",maxLines: 1, overflow: TextOverflow.ellipsis,
  //                                                 style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.titleMedium?.color),
  //                                               ),
  //                                               const SizedBox(height: 4),
  //                                               Row(
  //                                                 children: [
  //                                                   const Icon(Icons.place_outlined, size: 14, color: Colors.grey),
  //                                                   const SizedBox(width: 2),
  //                                                   Expanded(child: Text(r.place ?? "Unknown",maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12))),
  //                                                   if (r.distance != null) ...[
  //                                                     const SizedBox(width: 8),
  //                                                     Text('${r.distance} ', style: const TextStyle(color: Colors.grey, fontSize: 12)),
  //                                                   ]
  //                                                 ],
  //                                               ),
  //                                               const SizedBox(height: 4),
  //                                               Row(
  //                                                 children: [
  //                                                   const Icon(Icons.star, size: 14, color: Colors.amber),
  //                                                   const SizedBox(width: 2),
  //                                                   Text((r.rating ?? r.averageRating ?? 0).toStringAsFixed(1), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
  //                                                   const SizedBox(width: 4),
  //                                                   Text('(${r.reviews ?? r.totalReviews ?? 0} ${context.tr.reviews})', style: const TextStyle(color: Colors.grey, fontSize: 12)),
  //                                                 ],
  //                                               ),
  //                                               if (r.isOpen == false)
  //                                                  Padding(
  //                                                   padding: EdgeInsets.only(top: 4),
  //                                                   child: Text(context.tr.closed, style: TextStyle(color: Colors.red, fontSize: 12)),
  //                                                 ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         // const Icon(Icons.favorite_border, color: Colors.grey),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: SafeArea(
      child: Column(
        children: [
          // --- SEARCH BAR AND QR ICON (STATIC) ---
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

          // --- SCROLLABLE CONTENT (slider, categories, filter, list) ---
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ===== 4-IMAGE AUTO SLIDER =====
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                          ),
                          height: 220,
                          child: GestureDetector(
                            onPanDown: (_) => _pauseAutoSlide(),
                            onPanCancel: _resumeAutoSlide,
                            onPanEnd: (_) => _resumeAutoSlide(),
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _slideImages.length,
                              onPageChanged: (index) {
                                setState(() => _currentSlide = index);
                              },
                              itemBuilder: (context, index) {
                                final bool isActive = _currentSlide == index;
                                return AnimatedScale(
                                  scale: isActive ? 1.0 : 0.95,
                                  duration: const Duration(milliseconds: 600),
                                  child: AnimatedOpacity(
                                    opacity: isActive ? 1.0 : 0.7,
                                    duration: const Duration(milliseconds: 600),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.15),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.asset(
                                          _slideImages[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (c, e, s) => Container(
                                            color: Theme.of(context).cardColor,
                                            child: const Center(
                                              child: Icon(Icons.image_not_supported,
                                                  color: Colors.grey, size: 40),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // ===== DOTS INDICATOR =====
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _slideImages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentSlide == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentSlide == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // --- CATEGORY LIST ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: isLoadingCategories
                          ? Container(
                              height: 70,
                              child: Shimmer.fromColors(
                                  baseColor: Theme.of(context).cardColor,
                                  highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
                                  enabled: true,
                                  child: ListView.builder(
                                      itemCount: 4,
                                      physics: const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: ((context, index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          height: 60,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        );
                                      }))),
                            )
                          : errorMessageCategories != null
                              ? Container(
                                  height: 70,
                                  child: Shimmer.fromColors(
                                      baseColor: Theme.of(context).cardColor,
                                      highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 60,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                )
                              : categories.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No categories available',
                                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 40,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        itemCount: categories.length,
                                        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                                        itemBuilder: (context, index) {
                                          final isSelected = selectedIndex == index;
                                          final category = categories[index];
                                          return CategoryChip(
                                            label: category.name,
                                            isSelected: isSelected,
                                            onTap: () => _selectCategory(index, category.id),
                                          );
                                        },
                                      ),
                                    ),
                    ),
                  ),

                  // --- FILTER DROPDOWN ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(context.tr.restaurants, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                              if (selectedCategoryId != 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00a884),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    context.tr.filtered,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          DropdownButton<String>(
                            value: _currentSort,
                            dropdownColor: Theme.of(context).cardColor,
                            icon: Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
                            underline: const SizedBox(),
                            style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                            items: [
                              DropdownMenuItem(value: 'distance', child: Text(context.tr.byDistance)),
                              DropdownMenuItem(value: 'reviews', child: Text(context.tr.byReviews)),
                            ],
                            onChanged: _changeSort,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- MAIN LIST ---
                  if (_isLoading && _allRestaurants.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_errorMessage != null && _allRestaurants.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        height: 270,
                        child: Shimmer.fromColors(
                            baseColor: Theme.of(context).cardColor,
                            highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
                            enabled: true,
                            child: ListView.builder(
                                itemCount: 4,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: ((context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            height: 30,
                                            width: 180,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            height: 30,
                                            width: 180,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }))),
                      ),
                    )
                  else if (_displayedRestaurants.isEmpty)
                    SliverFillRemaining(
                      child: Center(child: Text(context.tr.noRestaurantsFound, style: TextStyle(color: Colors.grey))),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= _displayedRestaurants.length) {
                            return _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  )
                                : const SizedBox(height: 50);
                          }

                          final r = _displayedRestaurants[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: 
                                            CachedNetworkImage(
                                                imageUrl: r.banner!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Container(
                                                  color: Colors.grey.shade300,
                                                  child: const Center(
                                                    child: CircularProgressIndicator(strokeWidth: 2),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  color: Colors.grey,
                                                  child: const Icon(Icons.restaurant, color: Colors.white),
                                                ),
                                              )
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.black.withOpacity(0.6),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundImage: r.picture != null ? NetworkImage(r.picture!) : null,
                                            backgroundColor: r.picture == null ? Colors.grey : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.name ?? "Unknown",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.titleMedium?.color),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.place_outlined, size: 14, color: Colors.grey),
                                            const SizedBox(width: 2),
                                            Expanded(child: Text(r.place ?? "Unknown", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12))),
                                            if (r.distance != null) ...[
                                              const SizedBox(width: 8),
                                              Text('${r.distance} ', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, size: 14, color: Colors.amber),
                                            const SizedBox(width: 2),
                                            Text((r.rating ?? r.averageRating ?? 0).toStringAsFixed(1), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                            const SizedBox(width: 4),
                                            Text('(${r.reviews ?? r.totalReviews ?? 0} ${context.tr.reviews})', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                        if (r.isOpen == false)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(context.tr.closed, style: const TextStyle(color: Colors.red, fontSize: 12)),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: _displayedRestaurants.length + 1,
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
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}

// CategoryModel class
class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? timestamp;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.timestamp,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      description: json['description']?.toString(),
      timestamp: json['timestamp']?.toString(),
    );
  }
}

// Category Chip Widget
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).textTheme.titleMedium?.color,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}