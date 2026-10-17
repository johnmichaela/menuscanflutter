import 'dart:async';
import 'dart:convert';
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/screens/sub/business.dart';
import 'package:ballon/screens/sub/loading.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/screens/sub/shimerwidget.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:ballon/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ballon/l10n/app_strings.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? timestamp;
  final int count;
  final String color;
  final String textColor;
  final String? icon;
  final String? cover;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.timestamp,
    this.count = 0,
    this.color = '#000000',
    this.textColor = '#000000',
    this.icon,
    this.cover,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      description: json['description']?.toString(),
      timestamp: json['timestamp']?.toString(),
      count: _parseInt(json['count']) ?? 0,
      color: json['color']?.toString() ?? '#000000',
      textColor: json['text_color']?.toString() ?? '#000000',
      icon: json['icon']?.toString(),
      cover: json['cover']?.toString(),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Converts the stored hex string (e.g. "#FF9800") to a Flutter Color.
  /// Returns null if the string is invalid.
  int? get colorValue => _hexToInt(color);
  int? get textColorValue => _hexToInt(textColor);

  /// A friendly count string like "523+ businesses"
  // String get countLabel => '$count+ ${context.tr.}';

  // ---------------------------------------------------------------------------
  // Private parsing utilities
  // ---------------------------------------------------------------------------

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9-]'), '');
      if (cleaned.isEmpty) return null;
      return int.tryParse(cleaned);
    }
    return null;
  }

  /// Parses "#RRGGBB" or "#AARRGGBB" into a 32-bit int for Color().
  static int? _hexToInt(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var value = hex.replaceAll('#', '').trim();
    if (value.length == 6) value = 'FF$value'; // Add full opacity
    if (value.length != 8) return null;
    return int.tryParse(value, radix: 16);
  }

  IconData get iconData {
    final lower = name.toLowerCase();

    if (lower.contains('restaurant') ||
        lower.contains('café') ||
        lower.contains('cafe')) {
      return Icons.restaurant;
    }
    if (lower.contains('shop') || lower.contains('supermarket')) {
      return Icons.shopping_cart;
    }
    if (lower.contains('book') || lower.contains('stationery')) {
      return Icons.menu_book;
    }
    if (lower.contains('electronic') || lower.contains('gadget')) {
      return Icons.devices;
    }
    if (lower.contains('health') || lower.contains('pharmacy')) {
      return Icons.local_hospital;
    }
    if (lower.contains('beauty') || lower.contains('care')) {
      return Icons.spa;
    }
    if (lower.contains('education') || lower.contains('training')) {
      return Icons.school;
    }
    if (lower.contains('service')) {
      return Icons.build;
    }
    // ----- New 12 -----
    if (lower.contains('hotel') ||
        lower.contains('accommodation') ||
        lower.contains('lodging')) {
      return Icons.hotel;
    }
    if (lower.contains('automotive') ||
        lower.contains('transport') ||
        lower.contains('vehicle')) {
      return Icons.directions_car;
    }
    if (lower.contains('real estate') || lower.contains('property')) {
      return Icons.home_work;
    }
    if (lower.contains('fashion') ||
        lower.contains('clothing') ||
        lower.contains('apparel')) {
      return Icons.checkroom;
    }
    if (lower.contains('sport') ||
        lower.contains('fitness') ||
        lower.contains('gym')) {
      return Icons.fitness_center;
    }
    if (lower.contains('entertainment') ||
        lower.contains('event') ||
        lower.contains('cinema')) {
      return Icons.movie;
    }
    if (lower.contains('travel') ||
        lower.contains('tourism') ||
        lower.contains('flight')) {
      return Icons.flight;
    }
    if (lower.contains('pet') ||
        lower.contains('veterinary') ||
        lower.contains('animal')) {
      return Icons.pets;
    }
    if (lower.contains('garden') || lower.contains('home &')) {
      return Icons.yard;
    }
    if (lower.contains('financial') ||
        lower.contains('bank') ||
        lower.contains('finance')) {
      return Icons.account_balance;
    }
    if (lower.contains('technology') ||
        lower.contains('it ') ||
        lower.contains('software') ||
        lower.contains('computer')) {
      return Icons.computer;
    }
    if (lower.contains('art') ||
        lower.contains('culture') ||
        lower.contains('museum')) {
      return Icons.palette;
    }
// 'Bars, Lounges & Liquor',  'nightlife',
    if (lower.contains('bar')||
         lower.contains('lounges')||
         lower.contains('liquor')){
      return Icons.nightlife;
         }
    return Icons.category;
  }
  //  IconData get iconData => _iconFromString(icon);
  //  static IconData _iconFromString(String? name) {
  //   switch (name) {
  //     case 'restaurant':
  //       return Icons.restaurant;
  //     case 'shopping_cart':
  //       return Icons.shopping_cart;
  //     case 'menu_book':
  //       return Icons.menu_book;
  //     case 'devices':
  //       return Icons.devices;
  //     case 'local_hospital':
  //       return Icons.local_hospital;
  //     case 'spa':
  //       return Icons.spa;
  //     case 'school':
  //       return Icons.school;
  //     case 'build':
  //       return Icons.build;
  //     default:
  //       return Icons.category;
  //   }
  // }
}

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  int _currentIndex = 0;
  // 1. Add the PageController and Timer variables
  final PageController _promoPageController = PageController();
  Timer? _promoTimer;
  int _currentPromoPage = 0;
  List<Result> _allRestaurants = [];
  List<Result> _displayedRestaurants = [];
  bool is_view = false;
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
  // 2. Setup the timer when the widget initializes
  @override
  void initState() {
    super.initState();
    _startPromoTimer();
    fetchCategories();

    _connectionSubscription = InternetConnectionChecker.instance.onStatusChange
        .listen((status) {
          if (_lastConnectionStatus == InternetConnectionStatus.disconnected &&
              status == InternetConnectionStatus.connected) {
            fetchCategories();
          }

          _lastConnectionStatus = status;
        });
  }

  void _startPromoTimer() {
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_promoPageController.hasClients) {
        // If it's the last page, go back to the first page
        if (_currentPromoPage == 2) {
          // Assuming 3 banners (0, 1, 2)
          _promoPageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          // Otherwise, go to the next page
          _promoPageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  // 3. Clean up the timer when the widget is disposed
  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoPageController.dispose();
    super.dispose();
  }

  // ... rest of your build method
  Future<void> fetchCategories() async {
    // For Android emulator, use 10.0.2.2
    // For physical device, use your computer's IP
    const String apiUrl = 'https://qopera.app/prof/api/typemodel/';
    // const String apiUrl = 'http://10.0.2.2:8000/prof/api/typemodel/';

    try {
      setState(() {
        isLoadingCategories = true;
        errorMessageCategories = null;
      });

      print("🔄 Fetching categories from: $apiUrl");

      final response = await http
          .get(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      print("📡 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("✅ Found ${data.length} categories");

        // Add "All" category at the beginning
        final List<CategoryModel> parsedCategories = [
          // CategoryModel(id: 0, name: 'All'), // Special "All" category
          ...data.map(
            (json) => CategoryModel.fromJson(json as Map<String, dynamic>),
          ),
        ];

        print(
          "📋 Categories: ${parsedCategories.map((c) => '${c.name}(${c.id})').join(', ')}",
        );

        setState(() {
          categories = parsedCategories;
          isLoadingCategories = false;
          errorMessageCategories = null;
        });
      } else {
        setState(() {
          errorMessageCategories = "Server error: ${response.statusCode}";
          isLoadingCategories = true;
        });
      }
    } catch (e) {
      print("❌ Error fetching categories: $e");
      setState(() {
        errorMessageCategories = "Error: $e";
        isLoadingCategories = true;
      });
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final _promoData = [
      {
        'title1': context.tr.promoTitle1Line1,
        'title2': context.tr.promoTitle1Line2,
        'desc': context.tr.promoDesc1,
        'img': 'assets/img/everythings.png',
        'color': '#16A34A', // green
      },
      {
        'title1': context.tr.promoTitle2Line1,
        'title2': context.tr.promoTitle2Line2,
        'desc': context.tr.promoDesc2,
        'img': 'assets/img/shop.png',
        'color': '#1D6FE8', // blue
      },
      {
        'title1': context.tr.promoTitle3Line1,
        'title2': context.tr.promoTitle3Line2,
        'desc': context.tr.promoDesc3,
        'img': 'assets/img/more.png',
        'color': '#ec9c11', // amber
      },
    ];
    return Scaffold(
      // backgroundColor: Theme.of(context).,
      // appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              is_view ? SizedBox() : _buildPromoBanner(_promoData),
              is_view ? SizedBox() : const SizedBox(height: 10),
              is_view ? SizedBox() : _buildIndicators(_promoData), //
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildSectionHeader(),
              const SizedBox(height: 16),
              _buildBusinessGrid(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders ---

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          // Custom Logo
          Image.asset(
            "assets/img/menuscan_logo.png",
            fit: BoxFit.cover,
            width: 43,
            height: 43,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qopera',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color!,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Scan • Discover • Access',
                style: TextStyle(
                  color: const Color.fromARGB(255, 151, 150, 150),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).textTheme.bodyMedium!.color!,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  // Data for the banners (You can add your own images/text here)
  // final List<Map<String, String>> _promoData = [
  //   {
  //     'title1': context.tr.promoTitle1Line1,
  //     'title2': context.tr.promoTitle2Line1,
  //     'desc': context.tr.promoDesc1,
  //     'img': 'assets/img/everythings.png',
  //   },
  //   {
  //     'title1': 'Shop Smart.',
  //     'title2': 'Save Time.',
  //     'desc': 'Find your favorite products\nand order them instantly.',
  //     'img': 'assets/img/shop.png',
  //   },
  //   {
  //     'title1': 'Explore More.',
  //     'title2': 'Every Day.',
  //     'desc': 'Discover new places and services\nright at your fingertips.',
  //     'img': 'assets/img/more.png',
  //   },
  // ];

  Widget _buildPromoBanner(List<Map<String, String>> _promoData) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _promoPageController,
        itemCount: _promoData.length,
        onPageChanged: (index) {
          setState(() {
            _currentPromoPage = index;
          });
        },
        itemBuilder: (context, index) {
          final promo = _promoData[index];
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
            ), // Small margin between pages
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
                  // Text(
                  //   promo['title2']!,
                  //   style: const TextStyle(
                  //     color: Color(0xFF4DD0E1),
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     height: 1.1,
                  //   ),
                  // ),
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

                      // Main text color
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
                  SizedBox(height: 10),
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

  // Helper for the pagination dots (rebuilt dynamically based on the selected page)
  Widget _buildIndicators(List<Map<String, String>> _promoData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the dots
      children: List.generate(_promoData.length, (index) {
        return _buildIndicator(index == _currentPromoPage);
      }),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: isActive ? 16 : 6,
      height: 6,
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: context.tr.searchHint,
          // 'Search businesses, products or services...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: Icon(Icons.tune, color: Theme.of(context).primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.tr.ourBusinessTitle,
          style: TextStyle(
            // color: T,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              if (is_view == false) {
                is_view = true;
              } else {
                is_view = false;
              }
            });
          },
          child: Row(
            children: [
              Text(
                is_view ? context.tr.viewLess : context.tr.viewAll,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessGrid() {
    if (isLoadingCategories) {
      return 
      // Center(
      //   child: IconSwapLoader(
      //     size: 96,
      //     icons: const [
      //       Icons.shopping_cart_rounded,
      //       Icons.local_cafe_rounded,
      //       Icons.restaurant_rounded,
      //       Icons.event_rounded,
      //       Icons.chat_bubble_rounded,
      //       Icons.local_hospital_rounded,
      //       Icons.menu_book_sharp,
      //       Icons.qr_code_outlined,
      //     ],
      //     interval: const Duration(milliseconds: 900),
      //   ),
      // );
      // Inline in a screen
      // Center(
      //   child: SnakeHillLoader(
      //     width: 260,
      //     height: 130,
      //     snakeColor: Theme.of(context).primaryColor,
      //   ),
      // );
      //    Center(
      //   child: WaterDropLoader(
      //     size: 160,
      //     dropColor: Theme.of(context).primaryColor,
      //     iconColor: Colors.white,
      //     duration: const Duration(milliseconds: 2600),
      //   ),
      // );
       BusinessCardShimmerGrid(); // your shimmer widget
    }
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: categories.length,
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 12,
  //       mainAxisSpacing: 12,
  //       childAspectRatio: 0.85, // Adjusts height vs width ratio
  //     ),
  //     itemBuilder: (context, index) {
  //       return _buildBusinessCard(categories[index]);
  //     },
  //   );
  // }

  return GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: categories.length,
  padding: const EdgeInsets.symmetric(horizontal: 4),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 10,
    mainAxisSpacing: 11,
    childAspectRatio: 1.05, // was 0.85 — matches the icon-led card
  ),
  itemBuilder: (context, index) {
    return _buildBusinessCard(categories[index]);
  },
);}

Widget _buildBusinessCard(CategoryModel category) {
  // Accent color from the model (or a sensible fallback)
  final accent = category.colorValue != null
      ? Color(category.colorValue!)
      : Theme.of(context).primaryColor;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantsCafesScreen(category: category),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(
        //   color: accent.withOpacity(0.28),
        //   width: 1.2,
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Icon hero ----
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent,
                    Color.lerp(accent, Colors.black, 0.25) ?? accent,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                // boxShadow: [
                //   BoxShadow(
                //     color: accent.withOpacity(0.35),
                //     blurRadius: 10,
                //     offset: const Offset(0, 4),
                //   ),
                // ],
              ),
              child: Icon(
                category.iconData,
                color: Colors.white,
                size: 24,
              ),
            ),
            const Spacer(),

            // ---- Name ----
            Text(
              category.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.15,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // ---- Count row ----
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${category.count} ${context.tr.businessesCount}',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: accent.withOpacity(0.7),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
  Widget _buildBusinessCardx(CategoryModel category) {
    // Convert the hex color from the model into a Flutter Color
    final iconColor = category.colorValue != null
        ? Color(category.colorValue!)
        : Colors.blue;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantsCafesScreen(category: category),
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
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: category.cover != null && category.cover!.isNotEmpty
                    ? Image.network(
                        category.cover!,
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
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category.iconData, // Uses the helper in CategoryModel
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              // color: Color(0xFF001F5B),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${category.count}  ${context.tr.businessesCount}', // "523+ businesses"
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Theme.of(context).textTheme.bodyMedium!.color!,
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
