
// import 'dart:convert';

// import 'package:ballon/core/handle_error/execptions.dart';
// import 'package:ballon/models/bussinesstype.dart';
// import 'package:ballon/models/resturants.dart';
// import 'package:ballon/pagination/data/data_source/urls.dart';
// import 'package:ballon/services/geolocation.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   Future<List<Result>> fetchRestaurantsByDistance(int pageNumber) async {
//     try {
//       LocationService locationService = LocationService();
//       Position currentPosition = await locationService.getCurrentLocation();
//       String url = "${Urls.baseUrl}/prof/restaurants-high-rated/?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&sort_by=distance&page=$pageNumber";
//       final response = await http.get(Uri.parse(url));
//       print(url);
//       if (response.statusCode == 200) {
//         var map = jsonDecode(utf8.decode(response.bodyBytes));
//         return Resturants.fromJson(map).data!.results!;
//       } else {
//         throw ServerException(message: "Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw ServerException(message: e.toString());
//     }
//   }

//   Future<List<Result>> fetchRestaurantsByReviews(int pageNumber) async {
//     try {
//       String url = "${Urls.baseUrl}/prof/restaurants-high-rated/?sort_by=reviews&page=$pageNumber";
//       final response = await http.get(Uri.parse(url));
//       print(url);
//       if (response.statusCode == 200) {
//         var map = jsonDecode(utf8.decode(response.bodyBytes));
//         return Resturants.fromJson(map).data!.results!;
//       } else {
//         throw ServerException(message: "Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw ServerException(message: e.toString());
//     }
//   }
// }

// class RestaurantHomePage extends StatefulWidget {
//   const RestaurantHomePage({super.key});

//   @override
//   State<RestaurantHomePage> createState() => _RestaurantHomePageState();
// }

// class _RestaurantHomePageState extends State<RestaurantHomePage> {
//   final ApiService _apiService = ApiService();
//   final TextEditingController _searchController = TextEditingController();
  
//   List<Result> _allRestaurants = []; // Keeps all API data
//   List<Result> _displayedRestaurants = []; // Shows filtered list
  
//   bool _isLoading = true;
//   String? _errorMessage;
//   int _currentPage = 1;
//   String _currentSort = 'distance';
  
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _loadRestaurants();
//     fetchCategories();
//     _scrollController.addListener(_onScroll);
//     _searchController.addListener(_filterRestaurants);
//   }
// int selectedIndex = 0;
//   List<CategoryModel> categories = [];
//   bool isLoading = true;
//   String? errorMessage;
   
// Future<void> fetchCategories() async {
//     const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';
    
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
// print("Fetching categories from: $apiUrl");
//       if (response.statusCode == 200) {
//         // Your API returns a raw JSON array [], so we decode it directly as a List
//         final List<dynamic> data = jsonDecode(response.body);
//         print("Fetched categories: $data");
//         setState(() {
//           categories = data.map((json) => CategoryModel.fromJson(json)).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = "Error: ${response.statusCode}";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "Failed to connect: $e";
//         isLoading = false;
//       });
//     }
//   }
//   Future<void> _loadRestaurants() async {
//     setState(() { _isLoading = true; _errorMessage = null; });

//     try {
//       List<Result> fetchedData;
//       if (_currentSort == 'distance') {
//         fetchedData = await _apiService.fetchRestaurantsByDistance(_currentPage);
//       } else {
//         fetchedData = await _apiService.fetchRestaurantsByReviews(_currentPage);
//       }

//       setState(() {
//         if (_currentPage == 1) {
//           _allRestaurants = fetchedData;
//         } else {
//           _allRestaurants.addAll(fetchedData);
//         }
//         _filterRestaurants(); // Apply current search filter after loading
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() { _errorMessage = e.toString(); _isLoading = false; });
//     }
//   }

//   // Filter logic based on search bar
//   void _filterRestaurants() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _displayedRestaurants = _allRestaurants;
//       } else {
//         _displayedRestaurants = _allRestaurants.where((r) {
//           return (r.name?.toLowerCase().contains(query) ?? false) ||
//                  (r.place?.toLowerCase().contains(query) ?? false);
//         }).toList();
//       }
//     });
//   }

//   Future<void> _refresh() async {
//     _currentPage = 1;
//     await _loadRestaurants();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
//       if (!_isLoading) {
//         _currentPage++;
//         _loadRestaurants();
//       }
//     }
//   }

//   void _changeSort(String? newSort) {
//     if (newSort != null && newSort != _currentSort) {
//       setState(() {
//         _currentSort = newSort;
//         _currentPage = 1;
//         _allRestaurants = [];
//         _displayedRestaurants = [];
//       });
//       _loadRestaurants();
//     }
//   }

//   // Mock QR Scanner placeholder
//   void _openQrScanner() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1C1C1E),
//       builder: (context) => Container(
//         height: 300,
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
//             const SizedBox(height: 20),
//             const Text("Scan QR Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             const Text("Integrate your mobile_scanner package here", style: TextStyle(color: Colors.grey)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Close"),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // --- SEARCH BAR AND QR ICON ---
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 children: [
//                   // Search Input
//                   Expanded(
//                     child: Container(
//                       height: 50,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF252525),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.search, color: Colors.grey),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               controller: _searchController,
//                               style: const TextStyle(color: Colors.white),
//                               decoration: const InputDecoration(
//                                 hintText: 'Search restaurants or places...',
//                                 hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           if (_searchController.text.isNotEmpty)
//                             GestureDetector(
//                               onTap: () => _searchController.clear(),
//                               child: const Icon(Icons.close, color: Colors.grey, size: 20),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // QR Scanner Button
//                   GestureDetector(
//                     onTap: _openQrScanner,
//                     child: Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1E5B94),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//   Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.0),
//             child:  SizedBox(
//       height: 40, // Fixed height for the list
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         itemCount: categories.length,
//         separatorBuilder: (context, index) => const SizedBox(width: 8.0),
//         itemBuilder: (context, index) {
//           final isSelected = selectedIndex == index;
//           return CategoryChip(
//             label: categories[index].name ?? "Unknown",
//             isSelected: isSelected,
//             onTap: () {
//               setState(() {
//                 selectedIndex = index;
//               });
//             },
//           );
//         },
//       ),
//     ),
//           ),
//             // --- FILTER DROPDOWN ---
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   DropdownButton<String>(
//                     value: _currentSort,
//                     dropdownColor: const Color(0xFF1C1C1E),
//                     icon: const Icon(Icons.filter_list, color: Colors.white),
//                     underline: const SizedBox(),
//                     style: const TextStyle(color: Colors.white, fontSize: 14),
//                     items: const [
//                       DropdownMenuItem(value: 'distance', child: Text('By Distance')),
//                       DropdownMenuItem(value: 'reviews', child: Text('By Reviews')),
//                     ],
//                     onChanged: _changeSort,
//                   ),
//                 ],
//               ),
//             ),

//             // --- MAIN LIST ---
//             Expanded(
//               child: _isLoading && _allRestaurants.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : _errorMessage != null && _allRestaurants.isEmpty
//                       ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
//                       : _displayedRestaurants.isEmpty
//                           ? const Center(child: Text("No restaurants found", style: TextStyle(color: Colors.grey)))
//                           : RefreshIndicator(
//                               onRefresh: _refresh,
//                               color: Colors.blue,
//                               backgroundColor: Colors.black,
//                               child: ListView.separated(
//                                 controller: _scrollController,
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 itemCount: _displayedRestaurants.length + 1,
//                                 separatorBuilder: (ctx, i) => const Divider(color: Colors.grey, height: 1, thickness: 0.5),
//                                 itemBuilder: (context, index) {
//                                   if (index >= _displayedRestaurants.length) {
//                                     return _isLoading 
//                                         ? const Padding(
//                                             padding: EdgeInsets.all(16.0),
//                                             child: Center(child: CircularProgressIndicator()),
//                                           )
//                                         : const SizedBox(height: 50);
//                                   }

//                                   final r = _displayedRestaurants[index];
//                                   return Padding(
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
//                                                     ? Image.network(r.banner!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey))
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
//                                                       radius: 12,
//                                                       backgroundImage:r.picture != null ? NetworkImage(r.picture!) : null,
//                                                       backgroundColor: r.picture == null ? Colors.grey : null,),
//                                               ))
//                                           ],
//                                         ),
//                                         const SizedBox(width: 16),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 r.name ?? "Unknown",
//                                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Row(
//                                                 children: [
//                                                   const Icon(Icons.place_outlined, size: 14, color: Colors.grey),
//                                                   const SizedBox(width: 2),
//                                                   Text(r.place ?? "Unknown", style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
//                                                   Text('(${r.reviews ?? r.totalReviews ?? 0} reviews)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                                                   //  const SizedBox(width: 4),
                                                   
//                                                 ],
//                                               ),
//                                               if (r.isOpen == false)
//                                                 const Padding(
//                                                   padding: EdgeInsets.only(top: 4),
//                                                   child: Text('Closed', style: TextStyle(color: Colors.red, fontSize: 12)),
//                                                 ),
//                                             ],
//                                           ),
//                                         ),
//                                         const Icon(Icons.favorite_border, color: Colors.grey),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

// class CategoryList extends StatefulWidget {
//   const CategoryList({super.key});

//   @override
//   State<CategoryList> createState() => _CategoryListState();
// }

// class _CategoryListState extends State<CategoryList> {
//   // The list of categories based on your image
//   // final List<String> categories = [
//   //   "All",
//   //   "Unread",
//   //   "Favourites",
//   //   "Groups",
//   //   "New customers", // Added from the edge of your image
//   // ];

//   int selectedIndex = 0; // 'All' is selected by default
//   List<CategoryModel> categories = [];
//   bool isLoading = true;
//   String? errorMessage;
//     @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   } 


//   // Future<void> fetchCategoriesx() async {
//   //   const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';
//   //   print("Fetching categories from: $apiUrl");
//   //   try {
//   //     final response = await http.get(Uri.parse(apiUrl));

//   //     if (response.statusCode == 200) {
//   //       // Decode the JSON array
//   //       final List<Datum> data = jsonDecode(response.body);
        
//   //       setState(() {
//   //         categories = data.map((json) => Datum.fromJson(json as Map<String, dynamic>)).toList();
//   //         isLoading = false;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         errorMessage = "Error: ${response.statusCode}";
//   //         isLoading = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       errorMessage = "Failed to load: $e";
//   //       isLoading = false;
//   //     });
//   //   }
//   // }

// Future<void> fetchCategories() async {
//     const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';
    
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         // Your API returns a raw JSON array [], so we decode it directly as a List
//         final List<dynamic> data = jsonDecode(response.body);
        
//         setState(() {
//           categories = data.map((json) => CategoryModel.fromJson(json)).toList();
//           print("Fetched categories: $categories");
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = "Error: ${response.statusCode}";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "Failed to connect: $e";
//         isLoading = false;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 40, // Fixed height for the list
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         itemCount: categories.length,
//         separatorBuilder: (context, index) => const SizedBox(width: 8.0),
//         itemBuilder: (context, index) {
//           final isSelected = selectedIndex == index;
//           return CategoryChip(
//             label: categories[index].name ?? "Unknown",
//             isSelected: isSelected,
//             onTap: () {
//               setState(() {
//                 selectedIndex = index;
//               });
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// class CategoryModel {
//   final int ?id;
//   final String? name;
//   final String? description;
//   final String? timestamp;

//   CategoryModel({
//     this.id,
//     this.name,
//     this.description,
//     this.timestamp,
//   });

//   factory CategoryModel.fromJson(Map<String, dynamic> json) {
//     return CategoryModel(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? 'Unknown',
//       description: json['description'] ?? '',
//       timestamp: json['timestamp'] ?? '',
//     );
//   }
// }
// // ---------------------------------------------------------
// // 2. The Reusable Card / Chip Widget
// // ---------------------------------------------------------
// class CategoryChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const CategoryChip({
//     super.key,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF00a884) : const Color(0xFF202c33),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey.shade400,
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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
  String _currentSort = 'reviews'; // CHANGED: Default to 'reviews'
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _loadRestaurants();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterRestaurants);
  }

  int selectedIndex = 0;
  List<CategoryModel> categories = [];
  bool isLoadingCategories = true;
  String? errorMessageCategories;
   
  // Future<void> fetchCategories() async {
  //   const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';
    
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));
  //     print("Fetching categories from: $apiUrl");
      
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       print("Fetched categories count: ${data.length}");
        
  //       setState(() {
  //         categories = data.map((json) => CategoryModel.fromJson(json)).toList();
  //         isLoadingCategories = false;
  //       });
  //     } else {
  //       setState(() {
  //         errorMessageCategories = "Error: ${response.statusCode}";
  //         isLoadingCategories = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessageCategories = "Failed to connect: $e";
  //       isLoadingCategories = false;
  //     });
  //   }
  // }
Future<void> fetchCategories() async {
  const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';
  
  try {
    print("🔄 Starting to fetch categories...");
    final response = await http.get(Uri.parse(apiUrl));
    print("📡 Response status code: ${response.statusCode}");
    print("📦 Response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...");
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("✅ Success! Found ${data.length} categories");
      print("📋 First category: ${data.isNotEmpty ? data[0] : 'No data'}");
      
      setState(() {
        categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        isLoadingCategories = false;
        print("🏷️ Categories loaded: ${categories.map((c) => c.name).join(', ')}");
      });
    } else {
      print("❌ Error: Status code ${response.statusCode}");
      setState(() {
        errorMessageCategories = "Error: ${response.statusCode}";
        isLoadingCategories = false;
      });
    }
  } catch (e) {
    print("🔥 Exception: $e");
    setState(() {
      errorMessageCategories = "Failed to connect: $e";
      isLoadingCategories = false;
    });
  }
}
  Future<void> _loadRestaurants() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      List<Result> fetchedData;
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
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
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
      backgroundColor: const Color(0xFF1C1C1E),
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text("Scan QR Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Integrate your mobile_scanner package here", style: TextStyle(color: Colors.grey)),
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
                                hintText: 'Search restaurants or places...',
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
                    onTap: _openQrScanner,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E5B94),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                    ),
                  ),
                ],
              ),
            ),
            
            // --- CATEGORY LIST (FIXED) ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: isLoadingCategories
                  ? const Center(
                      child: SizedBox(
                        height: 40,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : errorMessageCategories != null
                      ? Center(
                          child: Text(
                            errorMessageCategories!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                      : categories.isEmpty
                          ? const Center(
                              child: Text(
                                'No categories available',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
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
                                  return CategoryChip(
                                    label: categories[index].name ?? "Unknown",
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
            ),

            // --- FILTER DROPDOWN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  DropdownButton<String>(
                    value: _currentSort,
                    dropdownColor: const Color(0xFF1C1C1E),
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: const [
                      DropdownMenuItem(value: 'distance', child: Text('By Distance')),
                      DropdownMenuItem(value: 'reviews', child: Text('By Reviews')),
                    ],
                    onChanged: _changeSort,
                  ),
                ],
              ),
            ),

            // --- MAIN LIST ---
            Expanded(
              child: _isLoading && _allRestaurants.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null && _allRestaurants.isEmpty
                      ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                      : _displayedRestaurants.isEmpty
                          ? const Center(child: Text("No restaurants found", style: TextStyle(color: Colors.grey)))
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              color: Colors.blue,
                              backgroundColor: Colors.black,
                              child: ListView.separated(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: _displayedRestaurants.length + 1,
                                separatorBuilder: (ctx, i) => const Divider(color: Colors.grey, height: 1, thickness: 0.5),
                                itemBuilder: (context, index) {
                                  if (index >= _displayedRestaurants.length) {
                                    return _isLoading 
                                        ? const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Center(child: CircularProgressIndicator()),
                                          )
                                        : const SizedBox(height: 50);
                                  }

                                  final r = _displayedRestaurants[index];
                                  return Padding(
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
                                                child: r.banner != null
                                                    ? Image.network(r.banner!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey))
                                                    : Container(color: Colors.grey, child: const Icon(Icons.restaurant)),
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
                                              )
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                r.name ?? "Unknown",
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.place_outlined, size: 14, color: Colors.grey),
                                                  const SizedBox(width: 2),
                                                  Text(r.place ?? "Unknown", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                                  if (r.distance != null) ...[
                                                    const SizedBox(width: 8),
                                                    Text('${r.distance} ', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                                  ]
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                                  const SizedBox(width: 2),
                                                  Text((r.rating ?? r.averageRating ?? 0).toStringAsFixed(1), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                                  const SizedBox(width: 4),
                                                  Text('(${r.reviews ?? r.totalReviews ?? 0} reviews)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                                ],
                                              ),
                                              if (r.isOpen == false)
                                                const Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: Text('Closed', style: TextStyle(color: Colors.red, fontSize: 12)),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.favorite_border, color: Colors.grey),
                                      ],
                                    ),
                                  );
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

// CategoryModel class (moved outside for better organization)
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
      name: json['name'] ?? 'Unknown',
      description: json['description'],
      timestamp: json['timestamp'],
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
          color: isSelected ? const Color(0xFF00a884) : const Color(0xFF202c33),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade400,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}