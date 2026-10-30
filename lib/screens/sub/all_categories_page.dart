// // lib/screens/main/all_categories_page.dart
// import 'dart:async';
// import 'dart:convert';
// import 'package:ballon/screens/main/homefine.dart';
// import 'package:ballon/screens/sub/business.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:ballon/screens/sub/shimerwidget.dart'
//     show BusinessCardShimmerGrid;
// import 'package:ballon/l10n/app_strings.dart';

// class AllCategoriesPage extends StatefulWidget {
//   /// Optional: pass a pre-loaded list to avoid a refetch.
//   final List<CategoryModel>? initialCategories;

//   const AllCategoriesPage({super.key, this.initialCategories});

//   @override
//   State<AllCategoriesPage> createState() => _AllCategoriesPageState();
// }

// class _AllCategoriesPageState extends State<AllCategoriesPage> {
//   // ---- State ----
//   List<CategoryModel> _allCategories = [];
//   List<CategoryModel> _filteredCategories = [];

//   bool _isLoading = true;
//   String? _errorMessage;

//   final TextEditingController _searchController = TextEditingController();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialCategories != null &&
//         widget.initialCategories!.isNotEmpty) {
//       _allCategories = List.of(widget.initialCategories!);
//       _filteredCategories = List.of(widget.initialCategories!);
//       _isLoading = false;
//     } else {
//       _fetchCategories();
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   // ---- Fetch ----
//   Future<void> _fetchCategories() async {
//     const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final response = await http
//           .get(
//             Uri.parse(apiUrl),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         final parsed = data
//             .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
//             .toList();

//         if (!mounted) return;
//         setState(() {
//           _allCategories = parsed;
//           _filteredCategories = parsed;
//           _isLoading = false;
//           _errorMessage = null;
//         });
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   // ---- Search ----
//   void _onSearchChanged(String query) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () {
//       final q = query.trim().toLowerCase();
//       setState(() {
//         _filteredCategories = q.isEmpty
//             ? List.of(_allCategories)
//             : _allCategories
//                 .where((c) => c.name.toLowerCase().contains(q))
//                 .toList();
//       });
//     });
//   }

//   // ---- Adaptive shadow (light & dark) ----
//   List<BoxShadow> _cardShadow(BuildContext context, {double elevation = 1.0}) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     if (isDark) {
//       return [
//         BoxShadow(
//           color: Colors.white.withOpacity(0.04 * elevation),
//           blurRadius: 8 * elevation,
//           spreadRadius: 0.5,
//           offset: const Offset(0, 2),
//         ),
//         BoxShadow(
//           color: Colors.black.withOpacity(0.35),
//           blurRadius: 6 * elevation,
//           offset: const Offset(0, 3),
//         ),
//       ];
//     }

//     return [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.06 * elevation),
//         blurRadius: 8 * elevation,
//         offset: const Offset(0, 3),
//       ),
//     ];
//   }

//   // ---- Build ----
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
        
//         title:  Text(
//           'All Categories',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _fetchCategories,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             children: [
//               const SizedBox(height: 8),
//               _buildSearchBar(),
//               const SizedBox(height: 16),
//               Expanded(child: _buildBody()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: _cardShadow(context, elevation: 0.5),
//       ),
//       child: TextField(
//         controller: _searchController,
//         onChanged: _onSearchChanged,
//         textInputAction: TextInputAction.search,
//         decoration: InputDecoration(
//           hintText: context.tr.searchHint,
//           hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//           prefixIcon: const Icon(Icons.search, color: Colors.grey),
//           suffixIcon: _searchController.text.isNotEmpty
//               ? IconButton(
//                   icon: const Icon(Icons.clear, color: Colors.grey),
//                   onPressed: () {
//                     _searchController.clear();
//                     _onSearchChanged('');
//                   },
//                 )
//               : null,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 15),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const BusinessCardShimmerGrid();
//     }

//     if (_errorMessage != null) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           const SizedBox(height: 120),
//           Icon(Icons.cloud_off, size: 56, color: Colors.grey.shade400),
//           const SizedBox(height: 12),
//           const Center(child: Text('Could not load categories')),
//           const SizedBox(height: 12),
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: _fetchCategories,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//             ),
//           ),
//         ],
//       );
//     }

//     if (_filteredCategories.isEmpty) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: const [
//           SizedBox(height: 140),
//           Icon(Icons.search_off, size: 48, color: Colors.grey),
//           SizedBox(height: 12),
//           Center(child: Text('Not found')),
//         ],
//       );
//     }

//     return GridView.builder(
//       physics: const AlwaysScrollableScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 24),
//       itemCount: _filteredCategories.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 11,
//         childAspectRatio: 0.85,
//       ),
//       itemBuilder: (context, index) {
//         return _buildCategoryCard(_filteredCategories[index]);
//       },
//     );
//   }

//   // ---- Reuse the same visual card from your home grid ----
//   Widget _buildCategoryCard(CategoryModel category) {
//     final accent = category.colorValue != null
//         ? Color(category.colorValue!)
//         : Theme.of(context).primaryColor;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => RestaurantsCafesScreen(category: category),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: _cardShadow(context),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 54,
//                     height: 54,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           accent,
//                           Color.lerp(accent, Colors.black, 0.25) ?? accent,
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Icon(
//                       category.iconData,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_outward_outlined,
//                     color: accent,
//                     size: 18,
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Text(
//                 category.name,
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700,
//                   height: 1.15,
//                   color: Theme.of(context).textTheme.bodyLarge?.color,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 children: [
//                   Container(
//                     width: 6,
//                     height: 6,
//                     decoration: BoxDecoration(
//                       color: accent,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       '${category.count} ${context.tr.businessesCount}',
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontWeight: FontWeight.w500,
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyMedium
//                             ?.color
//                             ?.withOpacity(0.75),
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios,
//                     size: 10,
//                     color: accent.withOpacity(0.7),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 6),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/screens/main/all_categories_page.dart
import 'dart:async';
import 'dart:convert';
import 'package:ballon/screens/main/homefine.dart';
import 'package:ballon/screens/sub/business.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ballon/models/bussinesstype.dart' show CategoryModel;
import 'package:ballon/screens/sub/screens.dart'
    show RestaurantsCafesScreen; // adjust if needed
import 'package:ballon/screens/sub/shimerwidget.dart'
    show BusinessCardShimmerGrid;
import 'package:ballon/l10n/app_strings.dart';

class AllCategoriesPage extends StatefulWidget {
  final List<CategoryModel>? initialCategories;

  const AllCategoriesPage({super.key, this.initialCategories});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  // ---- State ----
  List<CategoryModel> _allCategories = [];
  List<CategoryModel> _filteredCategories = [];
  List<CategoryModel> _promoCategories = [];

  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // Promo carousel
  final PageController _promoController = PageController(viewportFraction: 0.92);
  Timer? _promoTimer;
  int _currentPromoIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategories != null &&
        widget.initialCategories!.isNotEmpty) {
      _applyCategories(widget.initialCategories!);
      _isLoading = false;
    } else {
      _fetchCategories();
    }
    _startPromoTimer();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  void _applyCategories(List<CategoryModel> list) {
    _allCategories = List.of(list);
    _filteredCategories = List.of(list);
    // Only categories that actually have a cover image go in the promo carousel
    _promoCategories = list
        .where((c) => c.cover != null && c.cover!.isNotEmpty)
        .toList();
    _currentPromoIndex = 0;
  }

  void _startPromoTimer() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_promoController.hasClients || _promoCategories.length < 2) return;
      final next = (_currentPromoIndex + 1) % _promoCategories.length;
      _promoController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // ---- Fetch ----
  Future<void> _fetchCategories() async {
    const String apiUrl = 'http://192.168.1.115:8000 /prof/api/typemodel/';

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http
          .get(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        final parsed = data
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();

        if (!mounted) return;
        setState(() {
          _applyCategories(parsed);
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // ---- Search ----
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final q = query.trim().toLowerCase();
      setState(() {
        _filteredCategories = q.isEmpty
            ? List.of(_allCategories)
            : _allCategories
                .where((c) => c.name.toLowerCase().contains(q))
                .toList();
      });
    });
  }

  // ---- Adaptive shadow ----
  List<BoxShadow> _cardShadow(BuildContext context, {double elevation = 1.0}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.white.withOpacity(0.04 * elevation),
          blurRadius: 8 * elevation,
          spreadRadius: 0.5,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 6 * elevation,
          offset: const Offset(0, 3),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.06 * elevation),
        blurRadius: 8 * elevation,
        offset: const Offset(0, 3),
      ),
    ];
  }

  // ---- Build ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Categories',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCategories,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildSearchBar(),
              const SizedBox(height: 16),
              if (_promoCategories.isNotEmpty) ...[
                _buildPromoCarousel(),
                const SizedBox(height: 10),
                _buildPromoIndicators(),
                const SizedBox(height: 16),
              ],
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Search ----
  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: _cardShadow(context, elevation: 0.5),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: context.tr.searchHint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // ---- Promo carousel (cover + name + description) ----
  Widget _buildPromoCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _promoController,
        itemCount: _promoCategories.length,
        onPageChanged: (i) => setState(() => _currentPromoIndex = i),
        itemBuilder: (context, index) {
          return _buildPromoCard(_promoCategories[index]);
        },
      ),
    );
  }

  Widget _buildPromoCard(CategoryModel cat) {
    final accent = cat.colorValue != null
        ? Color(cat.colorValue!)
        : Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantsCafesScreen(category: cat),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
          boxShadow: _cardShadow(context, elevation: 1.2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ---- Cover image ----
            CachedNetworkImage(
        imageUrl: cat.cover!,
        fit: BoxFit.cover,
        // Shown while the image is downloading
        placeholder: (context, url) => Container(
          color: accent.withOpacity(0.10),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        // Shown if the image fails to load
        errorWidget: (context, url, error) => Container(
          color: accent.withOpacity(0.15),
          child: Icon(cat.iconData, size: 48, color: accent),
        ),
        // Optional: fade in for a smooth feel
        fadeInDuration: const Duration(milliseconds: 250),
        fadeOutDuration: const Duration(milliseconds: 100),
        // Optional: give it some memory-cache sizing hint
        memCacheWidth: 1080,
      ),
            // Image.network(
            //   cat.cover!,
            //   fit: BoxFit.cover,
            //   errorBuilder: (_, __, ___) => Container(
            //     color: accent.withOpacity(0.15),
            //     child: Icon(cat.iconData, size: 48, color: accent),
            //   ),
            //   loadingBuilder: (ctx, child, progress) {
            //     if (progress == null) return child;
            //     return Container(
            //       color: accent.withOpacity(0.10),
            //       child: const Center(child: CircularProgressIndicator()),
            //     );
            //   },
            // ),

            // ---- Gradient overlay (left → transparent) ----
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(0.92),
                    accent.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),

            // ---- Text content ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.68,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Small label with count
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
                      const SizedBox(height: 8),

                      // Name
                      Text(
                        cat.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 5),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Description
                      if (cat.description != null &&
                          cat.description!.trim().isNotEmpty)
                        Text(
                          cat.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),

                      const SizedBox(height: 10),

                      // CTA
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.tr.viewAll,
                              style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: accent,
                            ),
                          ],
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
    );
  }

  Widget _buildPromoIndicators() {
    if (_promoCategories.length < 2) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promoCategories.length, (i) {
        final isActive = i == _currentPromoIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 16 : 6,
          height: 6,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  // ---- Grid body ----
  Widget _buildBody() {
    if (_isLoading) {
      return const BusinessCardShimmerGrid();
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Icon(Icons.cloud_off, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Center(child: Text('Could not load categories')),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: _fetchCategories,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (_filteredCategories.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 140),
          Icon(Icons.search_off, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Center(child: Text('Not found')),
        ],
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _filteredCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 11,
        childAspectRatio: 0.80,
      ),
      itemBuilder: (context, index) {
        return _buildCategoryCard(_filteredCategories[index]);
      },
    );
  }

  // ---- Category card (same style as home grid) ----
  Widget _buildCategoryCard(CategoryModel category) {
    final accent = category.colorValue != null
        ? Color(category.colorValue!)
        : Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantsCafesScreen(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _cardShadow(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Container(
              //       width: 54,
              //       height: 54,
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //           colors: [
              //             accent,
              //             Color.lerp(accent, Colors.black, 0.25) ?? accent,
              //           ],
              //         ),
              //         borderRadius: BorderRadius.circular(14),
              //       ),
              //       child: Icon(
              //         category.iconData,
              //         color: Colors.white,
              //         size: 24,
              //       ),
              //     ),
              //     Icon(
              //       Icons.arrow_outward_outlined,
              //       color: accent,
              //       size: 18,
              //     ),
              //   ],
              // ),
              // const Spacer(),
             
              category.image !=null && category.image!.isNotEmpty?
              CachedNetworkImage(
                imageUrl: category.image!,
                height: 65,
                width: 65,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  height: 65,
                  width: 65,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                 color:Colors.grey,
                  height: 65,
                  width: 65,
                ),
              ):Container(
                decoration: BoxDecoration(
                  color:Colors.grey,
                  borderRadius: BorderRadius.circular(60)
                ),
                 
                  height: 65,
                  width: 65,
                ),
                Spacer(),
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
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}