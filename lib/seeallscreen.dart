// import 'package:ballon/categorydetail.dart';
// import 'package:ballon/core/services/services_locator.dart';
// import 'package:ballon/helper.dart';
// import 'package:ballon/models/bussinesstype.dart';
// import 'package:ballon/models/resturants.dart';
// import 'package:ballon/pagination/ui/bloc/pagination_bloc.dart';
// import 'package:ballon/screens.dart';
// import 'package:ballon/search_screen.dart';
// import 'package:ballon/shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'models.dart';
// import 'widgets.dart';

// class SeeAllScreen extends StatefulWidget {
//   const SeeAllScreen({super.key});

//   @override
//   State<SeeAllScreen> createState() => _SeeAllScreenState();
// }

// class _SeeAllScreenState extends State<SeeAllScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final RefreshController _refreshController = RefreshController();
  
//   // Hardcoded categories data
//   final List<Map<String, dynamic>> categories = [
//     {'icon': Icons.rice_bowl, 'name': 'Restaurants', 'color': 0xFFFFEBEE, 'textColor': 0xFFD32F2F},
//     {'icon': Icons.local_bar, 'name': 'Bars', 'color': 0xFFF3E5F5, 'textColor': 0xFF8E24AA},
//     {'icon': Icons.bed, 'name': 'Lounges', 'color': 0xFFE8F5E9, 'textColor': 0xFF388E3C},
//     {'icon': Icons.local_cafe, 'name': 'Cafes', 'color': 0xFFFFF3E0, 'textColor': 0xFFE65100},
//     {'icon': Icons.fastfood, 'name': 'Fast Food', 'color': 0xFFFFEBEE, 'textColor': 0xFFC62828},
//     {'icon': Icons.icecream, 'name': 'Desserts', 'color': 0xFFFCE4EC, 'textColor': 0xFFAD1457},
//     {'icon': Icons.restaurant, 'name': 'Fine Dining', 'color': 0xFFE8EAF6, 'textColor': 0xFF283593},
//     {'icon': Icons.coffee, 'name': 'Coffee Shops', 'color': 0xFFEFEBE9, 'textColor': 0xFF4E342E},
//     {'icon': Icons.liquor, 'name': 'Pubs', 'color': 0xFFE0F2F1, 'textColor': 0xFF00695C},
//     {'icon': Icons.bakery_dining, 'name': 'Bakeries', 'color': 0xFFFFF8E1, 'textColor': 0xFFF57F17},
//     {'icon': Icons.local_pizza_rounded, 'name': 'Pizza', 'color': 0xFFFFF3E0, 'textColor': 0xFFBF360C},
//     {'icon': Icons.ramen_dining, 'name': 'Asian', 'color': 0xFFF1F8E9, 'textColor': 0xFF33691E},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _loadInitialData();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _refreshController.dispose();
//     super.dispose();
//   }

//   // ==================== LOAD INITIAL DATA ====================
  
//   void _loadInitialData() {
//     context.read<PaginationBlocDistance>().add(const LoadPageEvent());
//   }

//   // ==================== REFRESH FUNCTIONS ====================
  
//   Future<void> _onRefresh() async {
//     try {
//       // Reset and reload restaurants
//       context.read<PaginationBlocDistance>().reset();
//       context.read<PaginationBlocDistance>().add(const LoadPageEvent());
//       await Future.delayed(const Duration(seconds: 1));
//     } finally {
//       _refreshController.refreshCompleted();
//     }
//   }

//   // ==================== LOAD MORE FUNCTIONS ====================
  
//   void _onLoading() {
//     final bloc = context.read<PaginationBlocDistance>();
//     if (!bloc.isLastPage && !bloc.isLoadingMore) {
//       bloc.add(const LoadPageEvent());
//     }
//     _refreshController.loadComplete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 199, 17, 17),
//         toolbarHeight: 80,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Image.asset('assets/img/white.png', height: 190, width: 190),
//           ],
//         ),
//       ),
//       body: SmartRefresher(
//         controller: _refreshController,
//         enablePullDown: true,
//         enablePullUp: true,
//         header: const WaterDropHeader(
//           waterDropColor: Color(0xFFC62828),
//         ),
//         footer: CustomFooter(
//           builder: (context, mode) {
//             Widget body;
//             if (mode == LoadStatus.idle) {
//               body = const Text(
//                 "Pull up to load more",
//                 style: TextStyle(fontSize: 13, color: Colors.grey),
//               );
//             } else if (mode == LoadStatus.loading) {
//               body = const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Color(0xFFC62828),
//                 ),
//               );
//             } else if (mode == LoadStatus.failed) {
//               body = const Text(
//                 "Load Failed! Tap to retry",
//                 style: TextStyle(fontSize: 13, color: Colors.red),
//               );
//             } else if (mode == LoadStatus.canLoading) {
//               body = const Text(
//                 "Release to load more",
//                 style: TextStyle(fontSize: 13, color: Colors.grey),
//               );
//             } else {
//               body = const Text(
//                 "No more restaurants",
//                 style: TextStyle(fontSize: 13, color: Colors.grey),
//               );
//             }
//             return Container(
//               height: 55.0,
//               child: Center(child: body),
//             );
//           },
//         ),
//         onRefresh: _onRefresh,
//         onLoading: _onLoading,
//         child: CustomScrollView(
//           slivers: [
//             // Search Bar
//             SliverPadding(
//               padding: const EdgeInsets.only(top: 16, bottom: 10),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   const SizedBox(height: 16),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const SearchScreen()),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.search, color: Colors.grey, size: 22),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: TextField(
//                               controller: _searchController,
//                               decoration: const InputDecoration(
//                                 hintText: "Search restaurants, bars, lodges...",
//                                 hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                                 border: InputBorder.none,
//                                 isDense: true,
//                                 contentPadding: EdgeInsets.symmetric(vertical: 12),
//                               ),
//                               onSubmitted: (value) {
//                                 // Handle search
//                               },
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFC62828),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: const Icon(
//                               Icons.tune,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//             ),
            
//             // Categories Section
//             SliverPersistentHeader(
//               pinned: false,
//               delegate: _SliverCategoriesDelegate(
//                 child: Container(
//                   color: const Color(0xFFF8F9FA),
//                   height: 120,
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       final category = categories[index];
//                       return _buildCategoryCard(
//                         icon: category['icon'],
//                         label: category['name'],
//                         bgColor: Color(category['color']),
//                         iconColor: Color(category['textColor']),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             // Restaurants Section
//             SliverPadding(
//               padding: const EdgeInsets.only(top: 16, bottom: 100),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   const SizedBox(height: 24),

//                   // Near You Header
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Row(
//                           children: [
//                             Icon(Icons.near_me, color: Color(0xFFC62828), size: 20),
//                             SizedBox(width: 8),
//                             Text(
//                               "Near You",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF333333),
//                               ),
//                             ),
//                           ],
//                         ),
//                         GestureDetector(
//                           onTap: _onRefresh,
//                           child: const Text(
//                             "Refresh",
//                             style: TextStyle(
//                               color: Color(0xFFC62828),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Near You List
//                   _buildNearYouList(),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ==================== BUILD NEAR YOU LIST ====================
  
//   Widget _buildNearYouList() {
//     return BlocBuilder<PaginationBlocDistance, PaginationState>(
//       builder: (context, state) {
//         final bloc = context.read<PaginationBlocDistance>();
        
//         // Show loading shimmer
//         if (bloc.posts.isEmpty && state is PaginationLoadingState) {
//           return _buildListingShimmer();
//         }
        
//         // Show error
//         if (bloc.posts.isEmpty && state is PaginationErrorState) {
//           return _buildErrorWidget();
//         }
        
//         // Show empty
//         if (bloc.posts.isEmpty) {
//           return _buildEmptyWidget();
//         }
        
//         // Show restaurants
//         return ListView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: bloc.posts.length,
//           itemBuilder: (context, index) {
//             final Result data = bloc.posts[index];
//             return _buildListingCard(data: data);
//           },
//         );
//       },
//     );
//   }

//   // ==================== CATEGORY CARD ====================

//   Widget _buildCategoryCard({
//     required IconData icon,
//     required String label,
//     required Color bgColor,
//     required Color iconColor,
//   }) {
//     return Container(
//       width: 85,
//       margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.08),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.09),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: bgColor,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Icon(
//                 icon,
//                 color: iconColor,
//                 size: 26,
//               ),
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF151515),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==================== LISTING CARD ====================

//   Widget _buildListingCard({required Result data}) {
//     Color getColorFromHex(String hexColor) {
//       hexColor = hexColor.replaceAll('#', '');
//       if (hexColor.length == 6) {
//         hexColor = 'FF$hexColor';
//       }
//       return Color(int.parse('0x$hexColor'));
//     }

//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context, 
//         MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: data))
//       ),
//       child: Container(
//         margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: IntrinsicHeight(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   bottomLeft: Radius.circular(12),
//                 ),
//                 child: Image.network(
//                   data.banner ?? '',
//                   width: 120,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: 120,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.image_not_supported),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(12),
//                       bottomRight: Radius.circular(12),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.08),
//                         blurRadius: 15,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                             decoration: BoxDecoration(
//                               color: getColorFromHex(data.typeBusiness?.textColor ?? '#C62828'),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               data.typeBusiness?.name ?? "Category",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         data.name ?? '',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Color(0xFF333333),
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         data.bio ?? '',
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                           height: 1.3,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           const Icon(Icons.star, size: 14, color: Colors.amber),
//                           const SizedBox(width: 4),
//                           Text(
//                             data.rating?.toStringAsFixed(1) ?? '0.0',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             " (${data.reviews ?? 0} reviews)",
//                             style: const TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                           const SizedBox(width: 12),
//                           const Icon(Icons.location_on, size: 14, color: Colors.grey),
//                           const SizedBox(width: 2),
//                           Text(
//                             data.distance ?? '0 km',
//                             style: const TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                           const Spacer(),
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: data.isOpen == true ? Colors.green : Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             data.isOpen == true ? "Open" : "Closed",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: data.isOpen == true ? Colors.green : Colors.red,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==================== SHIMMER & LOADING WIDGETS ====================
  
//   Widget _buildListingShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       enabled: true,
//       child: ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: 4,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             height: 130,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(12),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
//             const SizedBox(height: 16),
//             const Text(
//               'Failed to load restaurants',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Please check your internet connection',
//               style: TextStyle(color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // context.read<PaginationBlocDistance>().reset();
//                 context.read<PaginationBlocDistance>().add(const LoadPageEvent());
//               },
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyWidget() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.store_outlined, size: 60, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'No restaurants found',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ==================== CUSTOM SLIVER DELEGATE ====================

// class _SliverCategoriesDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;

//   _SliverCategoriesDelegate({required this.child});

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return child;
//   }

//   @override
//   double get maxExtent => 120;

//   @override
//   double get minExtent => 120;

//   @override
//   bool shouldRebuild(_SliverCategoriesDelegate oldDelegate) {
//     return oldDelegate.child != child;
//   }
// }

import 'package:ballon/core/services/services_locator.dart';

import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/ui/bloc/pagination_bloc.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/search_screen.dart';
import 'package:ballon/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    context.read<PaginationBlocDistance>().add(const LoadPageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
            lazy: false,
            create: (_) => appServiceLocator<PaginationBlocDistance>()
              ..add(const LoadPageEvent()),
          
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 199, 17, 17),
          toolbarHeight: 80,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/img/white.png', height: 190, width: 190),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            // Search Bar
            SliverPadding(
              padding: const EdgeInsets.only(top: 16, bottom: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: "Search restaurants, bars, lodges...",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              onSubmitted: (value) {
                                // Handle search
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC62828),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
      
            // All Restaurants Section
            SliverPadding(
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),
      
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.storefront, color: Color(0xFFC62828), size: 20),
                            SizedBox(width: 8),
                            Text(
                              "All Restaurants",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Total: ${context.watch<PaginationBlocDistance>().posts.length}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // All Restaurants List
                  _buildRestaurantsList(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== BUILD RESTAURANTS LIST ====================
  
  Widget _buildRestaurantsList() {
    return BlocBuilder<PaginationBlocDistance, PaginationState>(
      builder: (context, state) {
        final bloc = context.read<PaginationBlocDistance>();
        
        // Show loading shimmer
        if (bloc.posts.isEmpty && state is PaginationLoadingState) {
          return _buildListingShimmer();
        }
        
        // Show error
        if (bloc.posts.isEmpty && state is PaginationErrorState) {
          return _buildErrorWidget();
        }
        
        // Show empty
        if (bloc.posts.isEmpty) {
          return _buildEmptyWidget();
        }
        
        // Show restaurants
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bloc.posts.length + (bloc.isLastPage ? 0 : 1),
          itemBuilder: (context, index) {
            // Check if need to load more
            if (index == bloc.posts.length) {
              if (!bloc.isLastPage ) {
                bloc.add(const LoadPageEvent());
              }
              return _buildLoadMoreIndicator();
            }
            
            final Result data = bloc.posts[index];
            return _buildListingCard(data: data);
          },
        );
      },
    );
  }

  // ==================== LISTING CARD ====================

  Widget _buildListingCard({required Result data}) {
    Color getColorFromHex(String hexColor) {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse('0x$hexColor'));
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: data))
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  data.banner ?? '',
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: getColorFromHex(data.typeBusiness?.textColor ?? '#C62828'),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              data.typeBusiness?.name ?? "Category",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.bio ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            data.rating?.toStringAsFixed(1) ?? '0.0',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " (${data.reviews ?? 0} reviews)",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            data.distance?.toString() ?? '0 km',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const Spacer(),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: data.isOpen == true ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.isOpen == true ? "Open" : "Closed",
                            style: TextStyle(
                              fontSize: 12,
                              color: data.isOpen == true ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== LOAD MORE INDICATOR ====================

  Widget _buildLoadMoreIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFC62828),
        ),
      ),
    );
  }

  // ==================== SHIMMER & LOADING WIDGETS ====================
  
  Widget _buildListingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 130,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Failed to load restaurants',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // context.read<PaginationBlocDistance>().reset();
                context.read<PaginationBlocDistance>().add(const LoadPageEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No restaurants found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}