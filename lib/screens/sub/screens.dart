// import 'dart:async';
// import 'dart:convert';
// import 'package:ballon/home.dart';
// import 'package:ballon/models/profile.dart';
// import 'package:ballon/models/resturants.dart';
// import 'package:ballon/reviewwidget.dart';
// import 'package:ballon/screens/main/discover.dart';
// import 'package:ballon/screens/main/event.dart';
// import 'package:ballon/screens/main/home.dart';
// import 'package:ballon/screens/main/main_settings.dart';
// import 'package:ballon/screens/sub/profile/createprofile.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../app_state.dart';
// import '../../models.dart';
// import '../../widgets.dart';
// import '../../qr_scanner_screen.dart';
// import '../../search_screen.dart';
// import '../../l10n/app_strings.dart';

// /// ==================== SPLASH SCREEN ====================
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scale;
//   late Animation<double> _opacity;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 1800));
//     _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
//         CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
//     _opacity = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _controller, curve: Curves.easeIn));
//     _controller.forward();

//     Timer(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (_) => const MainScaffold()));
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Stack(
//         children: [
//           Positioned(
//               top: -80,
//               right: -60,
//               child: _blob(220,
//                   Theme.of(context).cardColor.withOpacity(0.08))),
//           Positioned(
//               bottom: -100,
//               left: -80,
//               child: _blob(280,
//                   Theme.of(context).cardColor.withOpacity(0.06))),
//           Positioned(
//               top: 200,
//               left: -50,
//               child: _blob(120,
//                   Theme.of(context).cardColor.withOpacity(0.1))),
//           Center(
//             child: FadeTransition(
//               opacity: _opacity,
//               child: ScaleTransition(
//                 scale: _scale,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 280,
//                       height: 280,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Image.asset('assets/img/menuscan_logo.png',
//                             fit: BoxFit.contain, height: 500),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Image.asset('assets/img/splash.png',
//                         fit: BoxFit.contain, height: 50),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Scan · Posts · Enjoy',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white.withOpacity(0.85),
//                         fontSize: 16,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: CircularProgressIndicator(
//                   color: Colors.white.withOpacity(0.7), strokeWidth: 2),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _blob(double size, Color color) {
//     return Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(color: color, shape: BoxShape.circle));
//   }
// }

// /// ==================== MAIN SCAFFOLD ====================
// class MainScaffold extends StatefulWidget {
//   const MainScaffold({super.key});
//   @override
//   State<MainScaffold> createState() => _MainScaffoldState();
// }

// class _MainScaffoldState extends State<MainScaffold> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final app = Provider.of<AppState>(context, listen: false);
//       app.loadRestaurants();
//     });
//     fetchProfile();
//   }

//   static Future<void> _saveProfileData(
//       Map<String, dynamic> profileData) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       print('📝 Saving Profile Data:');
//       print('   - PK: ${profileData['pk']}');

//       await prefs.setInt('profid', profileData['pk'] ?? 0);
//       await prefs.setString(
//           'profile_name', profileData['name']?.toString() ?? '');
//       await prefs.setString(
//           'profile_email', profileData['email']?.toString() ?? '');
//       await prefs.setString(
//           'profile_phone', profileData['phone_number']?.toString() ?? '');
//       await prefs.setString(
//           'profile_place', profileData['place']?.toString() ?? '');
//       await prefs.setString(
//           'profile_bio', profileData['bio']?.toString() ?? '');
//       await prefs.setString(
//           'profile_picture', profileData['picture']?.toString() ?? '');

//       if (profileData['user'] != null) {
//         final user = profileData['user'] as Map<String, dynamic>;
//         await prefs.setString(
//             'profile_username', user['username']?.toString() ?? '');
//         await prefs.setString('user_data', jsonEncode(user));
//       }

//       await prefs.setString('profile_data', jsonEncode(profileData));
//       print('✅ Profile data saved successfully!');
//     } catch (e) {
//       print('❌ Error saving profile data: $e');
//     }
//   }

//   Future<Profile> fetchProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');

//     final url = Uri.parse('https://qopera.app/prof/api-prof/');

//     try {
//       final response = await http.get(url, headers: {
//         'Authorization': 'Token $token',
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);

//         if (jsonData is List) {
//           if (jsonData.isEmpty) {
//             print('No profile found. Redirecting to CreateProfileScreen.');
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const CreateProfileScreen()),
//             );
//             throw Exception('No profile found for this user');
//           }

//           print("Raw JSON data: $jsonData");
//           print("First item: ${jsonData[0]}");
//           _saveProfileData(jsonData[0]);

//           return Profile.fromJson(jsonData[0] as Map<String, dynamic>);
//         } else if (jsonData is Map<String, dynamic>) {
//           return Profile.fromJson(jsonData);
//         } else {
//           throw Exception('Unexpected data format');
//         }
//       } else {
//         throw Exception(
//             'Failed to load profile. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final app = Provider.of<AppState>(context);
//     final screens = [
//       RestaurantHomePage(),
//       DiscoverPage(),
//       EventScreen(),
//       SettingsPage(),
//     ];

//     return Scaffold(
//       body: IndexedStack(index: app.currentIndex, children: screens),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(top: 10),
//         height: 65,
//         width: 65,
//         child: FloatingActionButton(
//           onPressed: () => Navigator.push(context,
//               MaterialPageRoute(builder: (_) => const QrScannerScreen())),
//           backgroundColor: Theme.of(context).primaryColor,
//           elevation: 4,
//           shape: const CircleBorder(),
//           child: const Icon(Icons.qr_code_scanner,
//               size: 32, color: Colors.white),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         color: Theme.of(context).cardColor,
//         elevation: 10,
//         shadowColor:
//             Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             GestureDetector(
//               onTap: () => app.changeTab(0),
//               child: _buildNavItem(Icons.home_outlined, context.tr.home,
//                   app.currentIndex == 0, context),
//             ),
//             GestureDetector(
//               onTap: () => app.changeTab(1),
//               child: _buildNavItem(Icons.explore, context.tr.discover,
//                   app.currentIndex == 1, context),
//             ),
//             const SizedBox(width: 40),
//             GestureDetector(
//               onTap: () => app.changeTab(2),
//               child: _buildNavItem(Icons.timeline, context.tr.events,
//                   app.currentIndex == 2, context),
//             ),
//             GestureDetector(
//               onTap: () => app.changeTab(3),
//               child: _buildNavItem(Icons.settings, context.tr.settings,
//                   app.currentIndex == 3, context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(
//       IconData icon, String label, bool isActive, BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon,
//             color: isActive ? Theme.of(context).primaryColor : Colors.grey,
//             size: 26),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             color: isActive ? Theme.of(context).primaryColor : Colors.grey,
//             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//           ),
//         )
//       ],
//     );
//   }
// }

// /// ==================== HOME SCREEN ====================
// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final app = Provider.of<AppState>(context);
//     final nearby = app.allRestaurants.take(5).toList();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _header(context),
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   _searchBar(context),
//                   const SizedBox(height: 20),
//                   _sectionTitle('Nearby Restaurants', context),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     height: 150,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: nearby.length,
//                       itemBuilder: (context, i) =>
//                           _nearbyCard(context, nearby[i]),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   _sectionTitle('Popular Categories', context),
//                   const SizedBox(height: 12),
//                   _categoriesRow(context),
//                   const SizedBox(height: 24),
//                   _sectionTitle('Offers', context),
//                   const SizedBox(height: 12),
//                   _offersCard(),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _header(BuildContext context) {
//     return Container(
//       height: 200,
//       child: Stack(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 30, 20, 54),
//             decoration: const BoxDecoration(color: Color(0xFFE71D36)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(children: [
//                   Image.asset('assets/img/white-logo.png',
//                       width: 60, height: 60),
//                   const SizedBox(width: 8),
//                   const Text('Balloon',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 40,
//                           fontWeight: FontWeight.w900)),
//                 ]),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       shape: BoxShape.circle),
//                   child: const Icon(Icons.notifications,
//                       color: Colors.white, size: 22),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 18),
//           Positioned(
//             bottom: 0,
//             top: 90,
//             left: 0,
//             right: 0,
//             child: GestureDetector(
//               onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => const QrScannerScreen())),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8)),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                           color: const Color(0xFFE71D36),
//                           borderRadius: BorderRadius.circular(12)),
//                       child: const Icon(Icons.qr_code_scanner,
//                           color: Color.fromARGB(255, 253, 252, 252),
//                           size: 30),
//                     ),
//                     const SizedBox(width: 14),
//                     const Expanded(
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Scan QR Code',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFFE71D36))),
//                             Text('Scan to view menu & order instantly',
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.grey)),
//                           ]),
//                     ),
//                     const Icon(Icons.arrow_forward_ios,
//                         size: 14, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _searchBar(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         final app = Provider.of<AppState>(context, listen: false);
//         app.changeTab(1);
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4)),
//           ],
//         ),
//         child: Row(children: [
//           Icon(Icons.search, color: Colors.grey.shade400),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text('Search restaurants by name...',
//                 style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _sectionTitle(String title, BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Text(title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
//       Text('See all',
//           style: TextStyle(
//               color: Theme.of(context).colorScheme.error,
//               fontWeight: FontWeight.w600,
//               fontSize: 13)),
//     ]);
//   }

//   Widget _nearbyCard(BuildContext context, Result r, {bool featured = false}) {
//     return GestureDetector(
//       child: Container(
//         width: 150,
//         margin: const EdgeInsets.only(right: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 12,
//                 offset: const Offset(0, 5)),
//           ],
//         ),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Stack(children: [
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(20)),
//               child: Image.network(
//                 'https://qopera.app/${r.banner}',
//                 height: 90,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                     height: 90,
//                     color: Colors.grey.shade200,
//                     child:
//                         const Icon(Icons.restaurant, color: Colors.grey)),
//               ),
//             ),
//             Positioned(
//                 top: 8,
//                 right: 8,
//                 child: _ratingChipSimple((r.rating ?? 0).toDouble())),
//           ]),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(r.name ?? '',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 13),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis),
//               const SizedBox(height: 2),
//               Text(r.place ?? '',
//                   style:
//                       TextStyle(color: Colors.grey.shade500, fontSize: 11),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _ratingChipSimple(double rating) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//           color: const Color(0xFFE71D36),
//           borderRadius: BorderRadius.circular(12)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         const Icon(Icons.star, color: Colors.white, size: 12),
//         const SizedBox(width: 2),
//         Text('${rating.toStringAsFixed(1)}',
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 11,
//                 fontWeight: FontWeight.bold)),
//       ]),
//     );
//   }

//   Widget _categoriesRow(BuildContext context) {
//     final cats = [
//       ('Pizza', Icons.local_pizza, const Color(0xFFFF6B6B)),
//       ('Burger', Icons.lunch_dining, const Color(0xFFFFA94D)),
//       ('Rice', Icons.rice_bowl, const Color(0xFF51CF66)),
//       ('Chicken', Icons.local_dining, const Color(0xFFFCC419)),
//       ('Dessert', Icons.cake, const Color(0xFFE71D36)),
//       ('Drinks', Icons.local_cafe, const Color(0xFF339AF0)),
//     ];
//     return SizedBox(
//       height: 90,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: cats.length,
//         itemBuilder: (context, i) => Column(children: [
//           Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                   color: cats[i].$3.withOpacity(0.15), shape: BoxShape.circle),
//               child: Icon(cats[i].$2, color: cats[i].$3, size: 26)),
//           const SizedBox(height: 6),
//           Text(cats[i].$1,
//               style:
//                   const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
//         ]).padding(r: 16),
//       ),
//     );
//   }

//   Widget _offersCard() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//             colors: [Color(0xFFE71D36), Color(0xFFa3152a)]),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(children: [
//         const Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('50% OFF',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w900)),
//           SizedBox(height: 4),
//           Text('On your first order!',
//               style: TextStyle(color: Colors.white70, fontSize: 13)),
//           SizedBox(height: 10),
//           Text('Use code: BALLOON50',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold)),
//         ])),
//         Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(16)),
//             child: const Icon(Icons.local_offer,
//                 color: Colors.white, size: 34)),
//       ]),
//     );
//   }
// }

// /// ==================== RESTAURANT SCREEN ====================
// class RestaurantScreen extends StatefulWidget {
//   final Result restaurant;

//   const RestaurantScreen({
//     super.key,
//     required this.restaurant,
//   });

//   @override
//   State<RestaurantScreen> createState() => _RestaurantScreenState();
// }

// class _RestaurantScreenState extends State<RestaurantScreen> {
//   String _selectedCategory = 'All';
//   String _selectedTab = 'menu'; // 'menu' or 'events'

//   /// ✅ Holds the currently selected event in the timetable.
//   /// Null = nothing selected → detail panel hidden.
//   EventOrganizer? _selectedEvent;

//   Future<void> _openDirections(BuildContext context) async {
//     final r = widget.restaurant;

//     String destination;

//     if (r.latitude != null && r.longitude != null) {
//       destination = '${r.latitude},${r.longitude}';
//     } else if (r.place != null && r.place!.isNotEmpty) {
//       destination = r.place!;
//     } else {
//       destination = r.name ?? '';
//     }

//     final mapsAppUri = Uri.parse(
//       'google.navigation:q=${Uri.encodeComponent(destination)}',
//     );

//     final webUri = Uri.parse(
//       'https://www.google.com/maps/dir/?api=1'
//       '&destination=${Uri.encodeComponent(destination)}',
//     );

//     try {
//       if (await canLaunchUrl(mapsAppUri)) {
//         await launchUrl(mapsAppUri, mode: LaunchMode.externalApplication);
//         return;
//       }
//       if (await canLaunchUrl(webUri)) {
//         await launchUrl(webUri, mode: LaunchMode.externalApplication);
//         return;
//       }
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open Google Maps')),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open Google Maps')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final restaurant = widget.restaurant;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: CustomScrollView(slivers: [
//         SliverAppBar(
//           expandedHeight: 220,
//           pinned: true,
//           backgroundColor: Theme.of(context).primaryColor,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back,
//                 color: Theme.of(context).textTheme.titleMedium?.color),
//             onPressed: () => Navigator.pop(context),
//           ),
//           flexibleSpace: FlexibleSpaceBar(
//             background: Stack(fit: StackFit.expand, children: [
//               Image.network(
//                 restaurant.banner!.isNotEmpty ? '${restaurant.banner}' : 'no ',
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) =>
//                     Container(color: const Color(0xFFE71D36)),
//               ),
//               Container(color: Colors.black.withOpacity(0.3)),
//             ]),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 10,
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         backgroundImage: (restaurant.picture != null &&
//                                 restaurant.picture!.isNotEmpty)
//                             ? NetworkImage(restaurant.picture!)
//                             : null,
//                         child: (restaurant.picture == null ||
//                                 restaurant.picture!.isEmpty)
//                             ? Icon(
//                                 Icons.restaurant,
//                                 size: 30,
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium
//                                     ?.color,
//                               )
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             restaurant.name ?? context.tr.noName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                           Text(
//                             (restaurant.place != null &&
//                                     restaurant.place!.isNotEmpty)
//                                 ? ' · ${restaurant.place!}'
//                                 : context.tr.noLocation,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _ratingChip(restaurant.rating ?? 0.0, context),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     _statusChip(
//                       restaurant.isOpen == true
//                           ? context.tr.open
//                           : context.tr.closed,
//                       restaurant.isOpen == true
//                           ? const Color(0xFF2ecc71)
//                           : const Color(0xFFe74c3c),
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   restaurant.bio ?? context.tr.noDescription,
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: () => _openDirections(context),
//                     icon: Icon(
//                       Icons.directions,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     label: Text(
//                       context.tr.getDirections,
//                       style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       side: BorderSide(
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                   ),
//                 ),
//                 ReviewWidget(profileId: restaurant.id!),
//               ],
//             ),
//           ),
//         ),

//         // ✅ MENU / EVENTS SWITCHER
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           sliver: SliverToBoxAdapter(child: _contentSwitcher(context)),
//         ),
//       ]),
//     );
//   }

//   // ================================================================
//   //  CONTENT SWITCHER — Menu / Events
//   // ================================================================
//   Widget _contentSwitcher(BuildContext context) {
//     final restaurant = widget.restaurant;

//     final bool hasFoods =
//         restaurant.foods != null && restaurant.foods!.isNotEmpty;
//     final bool hasEvents =
//         restaurant.organizer != null && restaurant.organizer!.isNotEmpty;

//     // Neither → placeholder
//     if (!hasFoods && !hasEvents) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 30),
//         child: Center(
//           child: Text(
//             context.tr.noMenuAvailable,
//             style: const TextStyle(fontSize: 15, color: Colors.grey),
//           ),
//         ),
//       );
//     }

//     // Only foods
//     if (hasFoods && !hasEvents) {
//       return _menuSection(context);
//     }

//     // Only events
//     if (!hasFoods && hasEvents) {
//       return _eventsSection(context);
//     }

//     // Both → show switcher
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: Row(
//             children: [
//               _switchButton(
//                 context,
//                 label: context.tr.menu,
//                 icon: Icons.restaurant_menu,
//                 value: 'menu',
//               ),
//               _switchButton(
//                 context,
//                 label: 'Events',
//                 icon: Icons.event,
//                 value: 'events',
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         if (_selectedTab == 'menu')
//           _menuSection(context)
//         else
//           _eventsSection(context),
//       ],
//     );
//   }

//   Widget _switchButton(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     required String value,
//   }) {
//     final bool isActive = _selectedTab == value;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _selectedTab = value),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color:
//                 isActive ? Theme.of(context).primaryColor : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 18,
//                 color: isActive ? Colors.white : Colors.grey.shade700,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: isActive ? Colors.white : Colors.grey.shade700,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   //  EVENTS SECTION — Opera-style timetable + detail panel
//   // ================================================================
//   Widget _eventsSection(BuildContext context) {
//     final events = widget.restaurant.organizer ?? [];

//     if (events.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 30),
//         child: Center(
//           child: Text(
//             'No events available',
//             style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
//           ),
//         ),
//       );
//     }

//     // Sort by start time (earliest first)
//     final sortedEvents = [...events]
//       ..sort((a, b) {
//         if (a.startTime == null) return 1;
//         if (b.startTime == null) return -1;
//         return a.startTime!.compareTo(b.startTime!);
//       });

//     // Auto-select first event if nothing is selected
//     if (_selectedEvent == null && sortedEvents.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted && _selectedEvent == null) {
//           setState(() => _selectedEvent = sortedEvents.first);
//         }
//       });
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ---------- Timetable Header ----------
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           child: Row(
//             children: [
//               Icon(Icons.calendar_month,
//                   color: Color(0xFF1E68D6), size: 22),
//               SizedBox(width: 8),
//               Text(
//                 'Event Timetable',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         // ---------- Timetable List ----------
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               for (int i = 0; i < sortedEvents.length; i++) ...[
//                 _eventCard(context, sortedEvents[i]),
//                 if (i != sortedEvents.length - 1)
//                   Divider(
//                     height: 1,
//                     thickness: 1,
//                     indent: 66,
//                     color: Colors.grey.shade100,
//                   ),
//               ],
//             ],
//           ),
//         ),

//         const SizedBox(height: 20),

//         // ---------- Detail Panel Below ----------
//         if (_selectedEvent != null) _eventDetailPanel(context, _selectedEvent!),

//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   // ================================================================
//   //  TIMETABLE ROW
//   // ================================================================
//   Widget _eventCard(BuildContext context, EventOrganizer event) {
//     final primaryColor = Theme.of(context).primaryColor;
//     final bool isSelected = _selectedEvent?.id == event.id;

//     IconData getEventIcon(String? title) {
//       final t = (title ?? '').toLowerCase();
//       if (t.contains('open') || t.contains('ceremony')) {
//         return Icons.event_note;
//       }
//       if (t.contains('keynote') || t.contains('talk')) {
//         return Icons.people_alt;
//       }
//       if (t.contains('lunch') ||
//           t.contains('dinner') ||
//           t.contains('food')) {
//         return Icons.restaurant;
//       }
//       if (t.contains('workshop') || t.contains('training')) {
//         return Icons.lightbulb_outline;
//       }
//       if (t.contains('panel') || t.contains('discussion')) {
//         return Icons.attach_money;
//       }
//       if (t.contains('gala') ||
//           t.contains('party') ||
//           t.contains('evening')) {
//         return Icons.calendar_today;
//       }
//       return Icons.event;
//     }

//     final String timeRange = event.startTime != null
//         ? _formatTimeRange(event.startTime!, event.endTime)
//         : 'Time TBA';

//     return InkWell(
//       onTap: () {
//         setState(() => _selectedEvent = event);
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? const Color(0xFFE3F2FD).withOpacity(0.55)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Circle icon
//             Container(
//               height: 52,
//               width: 52,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFE3F2FD),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 getEventIcon(event.title),
//                 color: const Color(0xFF1E68D6),
//                 size: 26,
//               ),
//             ),
//             const SizedBox(width: 14),

//             // Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     timeRange,
//                     style: const TextStyle(
//                       color: Color(0xFF1E68D6),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     event.title ?? 'Untitled Event',
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 15.5,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 14,
//                         color: Color(0xFF1E68D6),
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           event.venueDetails?.name ??
//                               (event.venueDetails?.address ?? 'Main Hall'),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 12.5,
//                             color: Color(0xFF1E68D6),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Chevron rotates when selected
//             Padding(
//               padding: const EdgeInsets.only(top: 14),
//               child: AnimatedRotation(
//                 duration: const Duration(milliseconds: 200),
//                 turns: isSelected ? 0.25 : 0,
//                 child: Icon(
//                   Icons.chevron_right,
//                   color: primaryColor,
//                   size: 24,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   //  EVENT DETAIL PANEL (Below Timetable)
//   // ================================================================
//   Widget _eventDetailPanel(BuildContext context, EventOrganizer event) {
//     final bool isFull = event.isFull == true;
//     final bool canAttend = event.canAttend == true;

//     return AnimatedSize(
//       duration: const Duration(milliseconds: 250),
//       curve: Curves.easeOut,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color(0xFFE3F2FD), width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ---------- Header strip ----------
//             Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFE3F2FD),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(14),
//                   topRight: Radius.circular(14),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.info_outline,
//                       color: Color(0xFF1E68D6), size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'Event Details',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1E68D6),
//                       ),
//                     ),
//                   ),
//                   _statusBadge(event.status),
//                 ],
//               ),
//             ),

//             // ---------- Body ----------
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     event.title ?? 'Untitled Event',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w800,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Description
//                   if ((event.description ?? '').isNotEmpty) ...[
//                     Text(
//                       event.description!,
//                       style: TextStyle(
//                         fontSize: 13.5,
//                         height: 1.45,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                   ],

//                   // Meta info grid
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: [
//                       if (event.startTime != null)
//                         _metaChip(
//                           icon: Icons.schedule,
//                           label:
//                               _formatTimeRange(event.startTime!, event.endTime),
//                         ),
//                       if (event.categoryDetails?.name != null)
//                         _metaChip(
//                           icon: Icons.category_outlined,
//                           label: event.categoryDetails!.name!,
//                         ),
//                       if (event.venueDetails?.name != null)
//                         _metaChip(
//                           icon: Icons.place_outlined,
//                           label: event.venueDetails!.name!,
//                         ),
//                       if (event.venueDetails?.capacity != null)
//                         _metaChip(
//                           icon: Icons.groups_outlined,
//                           label: 'Capacity ${event.venueDetails!.capacity}',
//                         ),
//                       if (event.maxAttendees != null)
//                         _metaChip(
//                           icon: Icons.people_outline,
//                           label: 'Max ${event.maxAttendees}',
//                         ),
//                       _metaChip(
//                         icon: Icons.lock_open_outlined,
//                         label: _attendanceLabel(event.attendanceType),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 14),

//                   // Full venue address
//                   if ((event.venueDetails?.address ?? '').isNotEmpty) ...[
//                     const Divider(height: 1),
//                     const SizedBox(height: 12),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Icon(Icons.location_on_outlined,
//                             size: 16, color: Color(0xFF1E68D6)),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             event.venueDetails!.address!,
//                             style: TextStyle(
//                               fontSize: 12.5,
//                               color: Colors.grey.shade700,
//                               height: 1.4,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],

//                   // Sessions
//                   if ((event.sessions ?? []).isNotEmpty) ...[
//                     const SizedBox(height: 16),
//                     const Divider(height: 1),
//                     const SizedBox(height: 12),
//                     const Text(
//                       'Sessions',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...event.sessions!.map((s) => _sessionTile(context, s)),
//                   ],

//                   const SizedBox(height: 16),

//                   // Attendance availability
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isFull
//                           ? Colors.red.withOpacity(0.08)
//                           : (canAttend
//                               ? Colors.green.withOpacity(0.08)
//                               : Colors.orange.withOpacity(0.08)),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: isFull
//                             ? Colors.red.withOpacity(0.25)
//                             : (canAttend
//                                 ? Colors.green.withOpacity(0.25)
//                                 : Colors.orange.withOpacity(0.25)),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           isFull
//                               ? Icons.block
//                               : (canAttend
//                                   ? Icons.check_circle_outline
//                                   : Icons.info_outline),
//                           size: 20,
//                           color: isFull
//                               ? Colors.red
//                               : (canAttend
//                                   ? Colors.green.shade700
//                                   : Colors.orange.shade800),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             isFull
//                                 ? 'This event is full'
//                                 : (canAttend
//                                     ? 'You can attend this event'
//                                     : 'You are not eligible to attend'),
//                             style: TextStyle(
//                               fontSize: 12.5,
//                               fontWeight: FontWeight.w600,
//                               color: isFull
//                                   ? Colors.red
//                                   : (canAttend
//                                       ? Colors.green.shade800
//                                       : Colors.orange.shade900),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // CTA
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: (!canAttend || isFull)
//                           ? null
//                           : () {
//                               // TODO: wire up RSVP
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content:
//                                       Text('RSVP for "${event.title}" — TODO'),
//                                 ),
//                               );
//                             },
//                       icon: const Icon(Icons.event_available, size: 18),
//                       label: Text(
//                         isFull
//                             ? 'Event Full'
//                             : (canAttend ? 'RSVP Now' : 'Not Available'),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         foregroundColor: Colors.white,
//                         disabledBackgroundColor: Colors.grey.shade300,
//                         disabledForegroundColor: Colors.grey.shade600,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _metaChip({required IconData icon, required String label}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F7FA),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: const Color(0xFF1E68D6)),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statusBadge(String? status) {
//     final s = (status ?? 'draft').toLowerCase();
//     Color bg;
//     Color fg;
//     String label;

//     switch (s) {
//       case 'published':
//         bg = Colors.green.withOpacity(0.15);
//         fg = Colors.green.shade800;
//         label = 'Published';
//         break;
//       case 'cancelled':
//         bg = Colors.red.withOpacity(0.15);
//         fg = Colors.red.shade800;
//         label = 'Cancelled';
//         break;
//       case 'completed':
//         bg = Colors.blueGrey.withOpacity(0.15);
//         fg = Colors.blueGrey.shade700;
//         label = 'Completed';
//         break;
//       default:
//         bg = Colors.orange.withOpacity(0.15);
//         fg = Colors.orange.shade800;
//         label = 'Draft';
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 10.5,
//           fontWeight: FontWeight.w700,
//           color: fg,
//         ),
//       ),
//     );
//   }

//   Widget _sessionTile(BuildContext context, EventSession s) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFAFBFC),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   s.title ?? 'Session',
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//               ),
//               if (s.startTime != null)
//                 Text(
//                   _formatTimeRange(s.startTime!, s.endTime),
//                   style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1E68D6),
//                   ),
//                 ),
//             ],
//           ),
//           if ((s.description ?? '').isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Text(
//               s.description!,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade700,
//                 height: 1.35,
//               ),
//             ),
//           ],
//           const SizedBox(height: 6),
//           Wrap(
//             spacing: 12,
//             runSpacing: 4,
//             children: [
//               if ((s.speaker ?? '').isNotEmpty)
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.person_outline,
//                         size: 12, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       s.speaker!,
//                       style: TextStyle(
//                           fontSize: 11, color: Colors.grey.shade700),
//                     ),
//                   ],
//                 ),
//               if ((s.location ?? '').isNotEmpty)
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.place_outlined,
//                         size: 12, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       s.location!,
//                       style: TextStyle(
//                           fontSize: 11, color: Colors.grey.shade700),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String _attendanceLabel(String? type) {
//     switch ((type ?? '').toLowerCase()) {
//       case 'public':
//         return 'Public';
//       case 'registered':
//         return 'Registered Users';
//       case 'staff':
//         return 'Staff Only';
//       case 'invite':
//         return 'Invitation Only';
//       case 'members':
//         return 'Members Only';
//       default:
//         return 'Public';
//     }
//   }

//   String _formatTimeRange(DateTime start, DateTime? end) {
//     String fmt(DateTime d) {
//       final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
//       final minute = d.minute.toString().padLeft(2, '0');
//       final period = d.hour >= 12 ? 'PM' : 'AM';
//       return '${hour.toString().padLeft(2, '0')}:$minute $period';
//     }

//     if (end == null) return fmt(start);
//     return '${fmt(start)} - ${fmt(end)}';
//   }

//   // ================================================================
//   //  MENU SECTION
//   // ================================================================
//   Widget _menuSection(BuildContext context) {
//     final restaurant = widget.restaurant;
//     final List<Food>? foods = restaurant.foods;

//     if (foods == null || foods.isEmpty) {
//       return Center(
//         child: Text(
//           context.tr.noMenuAvailable,
//           style: const TextStyle(fontSize: 16),
//         ),
//       );
//     }

//     final List<String> categories = [
//       'All',
//       ...foods
//           .map((f) => f.category?.name)
//           .where((name) => name != null && name.isNotEmpty)
//           .cast<String>()
//           .toSet()
//           .toList(),
//     ];

//     final selectedCategory = _selectedCategory;

//     final List<Food> filteredFoods = selectedCategory == 'All'
//         ? foods
//         : foods.where((f) => f.category?.name == selectedCategory).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           context.tr.menu,
//           style: const TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 40,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: categories.length,
//             itemBuilder: (context, i) {
//               final category = categories[i];
//               final isSelected = category == selectedCategory;

//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedCategory = category;
//                   });
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(right: 10),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 18, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? Theme.of(context).primaryColor
//                         : Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: isSelected ? Colors.transparent : Colors.grey,
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       category,
//                       style: TextStyle(
//                         color: isSelected
//                             ? Theme.of(context).colorScheme.onPrimary
//                             : Colors.grey.shade700,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 9),
//         Column(
//           children: filteredFoods
//               .map(
//                 (f) => FoodCard(
//                   food: f,
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => FoodDetailScreen(food: f),
//                     ),
//                   ),
//                   onAdd: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => FoodDetailScreen(food: f),
//                     ),
//                   ),
//                 ).padding(b: 12),
//               )
//               .toList(),
//         ),
//       ],
//     );
//   }

//   List<FoodItemModel> _fallbackFoods() {
//     return [
//       FoodItemModel(
//           id: 1,
//           name: 'Beef Burger',
//           description: 'Juicy beef patty with cheese & veggies',
//           price: 8000,
//           image:
//               'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop',
//           rating: 4.5,
//           category: 'Burger'),
//       FoodItemModel(
//           id: 2,
//           name: 'Chicken Pizza',
//           description: 'Grilled chicken, cheese & special sauce',
//           price: 12000,
//           image:
//               'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=400&fit=crop',
//           rating: 4.7,
//           category: 'Pizza'),
//       FoodItemModel(
//           id: 3,
//           name: 'French Fries',
//           description: 'Crispy golden fries',
//           price: 4000,
//           image:
//               'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400&h=400&fit=crop',
//           rating: 4.0,
//           category: 'Burger'),
//       FoodItemModel(
//           id: 4,
//           name: 'Grilled Chicken',
//           description: 'Well grilled with spices',
//           price: 10000,
//           image:
//               'https://images.unsplash.com/photo-1594041680534-e8c8cdebd659?w=400&h=400&fit=crop',
//           rating: 4.3,
//           category: 'Chicken'),
//       FoodItemModel(
//           id: 5,
//           name: 'Fresh Juice',
//           description: 'Natural & healthy',
//           price: 3000,
//           image:
//               'https://images.unsplash.com/photo-1622597467836-f3824f29db43?w=400&h=400&fit=crop',
//           rating: 4.1,
//           category: 'Drinks'),
//     ];
//   }

//   Widget _statusChip(String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//           color: color.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(12)),
//       child: Text(label,
//           style: TextStyle(
//               color: color, fontSize: 12, fontWeight: FontWeight.bold)),
//     );
//   }
// }

// Widget _ratingChip(double rating, BuildContext context) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.circular(12)),
//     child: Row(mainAxisSize: MainAxisSize.min, children: [
//       const Icon(Icons.star, color: Colors.white, size: 12),
//       const SizedBox(width: 2),
//       Text(rating.toStringAsFixed(1),
//           style: const TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.bold)),
//     ]),
//   );
// }

// /// ==================== FOOD DETAIL ====================
// class FoodDetailScreen extends StatefulWidget {
//   final Food food;
//   const FoodDetailScreen({super.key, required this.food});
//   @override
//   State<FoodDetailScreen> createState() => _FoodDetailScreenState();
// }

// class _FoodDetailScreenState extends State<FoodDetailScreen> {
//   int _quantity = 1;
//   String? _selectedVariant;
//   final List<String> _selectedExtras = [];

//   @override
//   Widget build(BuildContext context) {
//     final app = Provider.of<AppState>(context);
//     final food = widget.food;
//     bool hasDiscount = food.discountPrice != null &&
//         food.price != null &&
//         food.discountPrice! < food.price!;

//     return Scaffold(
//       body: CustomScrollView(slivers: [
//         SliverAppBar(
//           expandedHeight: 260,
//           pinned: true,
//           backgroundColor: Theme.of(context).primaryColor,
//           leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => Navigator.pop(context)),
//           actions: [
//             IconButton(
//               icon: Icon(
//                   app.isFoodFavorite(food)
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   color: Colors.white),
//               onPressed: () => app.toggleFoodFavorite(food),
//             ),
//           ],
//           flexibleSpace: FlexibleSpaceBar(
//               background: Stack(fit: StackFit.expand, children: [
//             Image.network(food.image ?? '',
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) =>
//                     Container(color: Theme.of(context).primaryColor)),
//           ])),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                             child: Text(food.name ?? '',
//                                 style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.w800))),
//                       ]),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('TZS ${(food.discountPrice ?? food.price)!}',
//                           style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.w800,
//                               color: Theme.of(context).primaryColor)),
//                       if (hasDiscount)
//                         Text(
//                           '${food.currency ?? '\$'} ${food.price!.toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 17,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Text('Description',
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 6),
//                   Text(food.description ?? '',
//                       style: const TextStyle(fontSize: 14)),
//                   const SizedBox(height: 20),
//                 ]),
//           ),
//         ),
//       ]),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:ballon/home.dart';
import 'package:ballon/models/profile.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/reviewwidget.dart';
import 'package:ballon/screens/main/discover.dart';
import 'package:ballon/screens/main/event.dart';
import 'package:ballon/screens/main/home.dart';
import 'package:ballon/screens/main/main_settings.dart';
import 'package:ballon/screens/sub/profile/createprofile.dart';
import 'package:ballon/screens/sub/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_state.dart';
import '../../models.dart';
import '../../widgets.dart';
import '../../qr_scanner_screen.dart';
import '../../search_screen.dart';
import '../../l10n/app_strings.dart';

/// ==================== SPLASH SCREEN ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _scale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScaffold()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _blob(220, Theme.of(context).cardColor.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _blob(280, Theme.of(context).cardColor.withOpacity(0.06)),
          ),
          Positioned(
            top: 200,
            left: -50,
            child: _blob(120, Theme.of(context).cardColor.withOpacity(0.1)),
          ),
          Center(
            child: FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/img/menuscan_logo.png',
                          fit: BoxFit.contain,
                          height: 500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Image.asset(
                      'assets/img/splash.png',
                      fit: BoxFit.contain,
                      height: 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan · Posts · Enjoy',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white.withOpacity(0.7),
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// ==================== MAIN SCAFFOLD ====================
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final app = Provider.of<AppState>(context, listen: false);
      app.loadRestaurants();
    });
    fetchProfile();
  }

  static Future<void> _saveProfileData(Map<String, dynamic> profileData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('📝 Saving Profile Data:');
      print('   - PK: ${profileData['pk']}');

      await prefs.setInt('profid', profileData['pk'] ?? 0);
      await prefs.setString(
        'profile_name',
        profileData['name']?.toString() ?? '',
      );
      await prefs.setString(
        'profile_email',
        profileData['email']?.toString() ?? '',
      );
      await prefs.setString(
        'profile_phone',
        profileData['phone_number']?.toString() ?? '',
      );
      await prefs.setString(
        'profile_place',
        profileData['place']?.toString() ?? '',
      );
      await prefs.setString(
        'profile_bio',
        profileData['bio']?.toString() ?? '',
      );
      await prefs.setString(
        'profile_picture',
        profileData['picture']?.toString() ?? '',
      );
      // is_visible,banner,business_type
      await prefs.setBool(
        'profile_is_visible',
        profileData['is_visible'] ?? false,
      );
      print('   - is_visible: ${profileData['is_visible']}');
      await prefs.setString(
        'profile_banner',
        profileData['banner']?.toString() ?? '',
      );
      await prefs.setString(
        'profile_business_type',
        profileData['business_type']?.toString() ?? '',
      );

      if (profileData['user'] != null) {
        final user = profileData['user'] as Map<String, dynamic>;
        await prefs.setString(
          'profile_username',
          user['username']?.toString() ?? '',
        );
        await prefs.setString('user_data', jsonEncode(user));
      }

      await prefs.setString('profile_data', jsonEncode(profileData));
      print('✅ Profile data saved successfully!');
    } catch (e) {
      print('❌ Error saving profile data: $e');
    }
  }

  Future<Profile> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.parse('https://qopera.app/prof/api-prof/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          if (jsonData.isEmpty) {
            print('No profile found. Redirecting to CreateProfileScreen.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateProfileScreen(),
              ),
            );
            throw Exception('No profile found for this user');
          }

          print("Raw JSON data: $jsonData");
          print("First item: ${jsonData[0]}");
          _saveProfileData(jsonData[0]);

          return Profile.fromJson(jsonData[0] as Map<String, dynamic>);
        } else if (jsonData is Map<String, dynamic>) {
          return Profile.fromJson(jsonData);
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception(
          'Failed to load profile. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final screens = [
      HomePages(),
      DiscoverPage(),
      EventScreen(),
      SettingsPage(),
    ];

    return Scaffold(
      appBar: _buildAppBar(context), // pass context
      endDrawer: AppDrawer(),
      body: IndexedStack(index: app.currentIndex, children: screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QrScannerScreen()),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.qr_code_scanner,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Theme.of(context).cardColor,
        elevation: 10,
        shadowColor: Theme.of(
          context,
        ).textTheme.bodyMedium!.color!.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => app.changeTab(0),
              child: _buildNavItem(
                Icons.home_outlined,
                context.tr.home,
                app.currentIndex == 0,
                context,
              ),
            ),
            GestureDetector(
              onTap: () => app.changeTab(1),
              child: _buildNavItem(
                Icons.explore,
                context.tr.discover,
                app.currentIndex == 1,
                context,
              ),
            ),
            const SizedBox(width: 40),
            GestureDetector(
              onTap: () => app.changeTab(2),
              child: _buildNavItem(
                Icons.timeline,
                context.tr.events,
                app.currentIndex == 2,
                context,
              ),
            ),
            GestureDetector(
              onTap: () => app.changeTab(3),
              child: _buildNavItem(
                Icons.settings,
                context.tr.settings,
                app.currentIndex == 3,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // backgroundColor: Theme.of(context).,
      // elevation: 0,
      shadowColor: Colors.grey.withOpacity(0.3),
      toolbarHeight: 80.0, 
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
      //    actions: [
      //   Builder(
      //     builder: (context) => IconButton(
      //       icon: Icon(
      //         Icons.menu,
      //         color: Theme.of(context).textTheme.bodyMedium!.color!,
      //       ),
      //        onPressed: () => Scaffold.of(context).openEndDrawer(),   // 👈 opens drawer
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Header ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Image.asset(
                    "assets/img/menuscan_logo.png",
                    width: 40,
                    height: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qopera',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const Text(
                        'Scan • Discover • Access',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300, height: 1),

            // ---- Menu Items ----
            _drawerItem(context, Icons.home_outlined, 'Home', () {}),
            _drawerItem(context, Icons.qr_code_scanner, 'Scan QR', () {}),
            _drawerItem(context, Icons.restaurant_menu, 'Menu', () {}),
            _drawerItem(context, Icons.favorite_border, 'Favorites', () {}),
            _drawerItem(context, Icons.history, 'History', () {}),
            _drawerItem(context, Icons.person_outline, 'Profile', () {}),
            _drawerItem(context, Icons.settings_outlined, 'Settings', () {}),

            const Spacer(),
            Divider(color: Colors.grey.shade300, height: 1),

            // ---- Logout ----
            _drawerItem(context, Icons.logout, 'Logout', () {
              Navigator.pop(context);
              // TODO: handle logout
            }, color: Colors.red),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    final effectiveColor =
        color ?? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return ListTile(
      leading: Icon(icon, color: effectiveColor),
      title: Text(
        title,
        style: TextStyle(
          color: effectiveColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        onTap();
      },
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    BuildContext context,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Theme.of(context).primaryColor : Colors.grey,
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// ==================== HOME SCREEN ====================
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final nearby = app.allRestaurants.take(5).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _searchBar(context),
                  const SizedBox(height: 20),
                  _sectionTitle('Nearby Restaurants', context),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nearby.length,
                      itemBuilder: (context, i) =>
                          _nearbyCard(context, nearby[i]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Popular Categories', context),
                  const SizedBox(height: 12),
                  _categoriesRow(context),
                  const SizedBox(height: 24),
                  _sectionTitle('Offers', context),
                  const SizedBox(height: 12),
                  _offersCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 54),
            decoration: const BoxDecoration(color: Color(0xFFE71D36)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/img/white-logo.png',
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Balloon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Positioned(
            bottom: 0,
            top: 90,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrScannerScreen()),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
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
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE71D36),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Color.fromARGB(255, 253, 252, 252),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scan QR Code',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE71D36),
                            ),
                          ),
                          Text(
                            'Scan to view menu & order instantly',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final app = Provider.of<AppState>(context, listen: false);
        app.changeTab(1);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade400),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search restaurants by name...',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        Text(
          'See all',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _nearbyCard(BuildContext context, Result r, {bool featured = false}) {
    return GestureDetector(
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    'https://qopera.app/${r.banner}',
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _ratingChipSimple((r.rating ?? 0).toDouble()),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.name ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    r.place ?? '',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingChipSimple(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE71D36),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 12),
          const SizedBox(width: 2),
          Text(
            '${rating.toStringAsFixed(1)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoriesRow(BuildContext context) {
    final cats = [
      ('Pizza', Icons.local_pizza, const Color(0xFFFF6B6B)),
      ('Burger', Icons.lunch_dining, const Color(0xFFFFA94D)),
      ('Rice', Icons.rice_bowl, const Color(0xFF51CF66)),
      ('Chicken', Icons.local_dining, const Color(0xFFFCC419)),
      ('Dessert', Icons.cake, const Color(0xFFE71D36)),
      ('Drinks', Icons.local_cafe, const Color(0xFF339AF0)),
    ];
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        itemBuilder: (context, i) => Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: cats[i].$3.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(cats[i].$2, color: cats[i].$3, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              cats[i].$1,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ).padding(r: 16),
      ),
    );
  }

  Widget _offersCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE71D36), Color(0xFFa3152a)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '50% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'On your first order!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 10),
                Text(
                  'Use code: BALLOON50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.local_offer, color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }
}

/// ==================== RESTAURANT SCREEN ====================
class RestaurantScreen extends StatefulWidget {
  final Result restaurant;

  const RestaurantScreen({super.key, required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  String _selectedCategory = 'All';
  String _selectedTab = 'menu';
  EventOrganizer? _selectedEvent;

  Future<void> _openDirections(BuildContext context) async {
    final r = widget.restaurant;

    String destination;

    if (r.latitude != null && r.longitude != null) {
      destination = '${r.latitude},${r.longitude}';
    } else if (r.place != null && r.place!.isNotEmpty) {
      destination = r.place!;
    } else {
      destination = r.name ?? '';
    }

    final mapsAppUri = Uri.parse(
      'google.navigation:q=${Uri.encodeComponent(destination)}',
    );

    final webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${Uri.encodeComponent(destination)}',
    );

    try {
      if (await canLaunchUrl(mapsAppUri)) {
        await launchUrl(mapsAppUri, mode: LaunchMode.externalApplication);
        return;
      }
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  final Set<String> _expandedIds = {}; // session IDs that are open

  void _toggle(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
        print('🔽 Collapsed session ID: $id');
      } else {
        _expandedIds.add(id);
        print('🔼 Expanded session ID: $id');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    restaurant.banner!.isNotEmpty
                        ? '${restaurant.banner}'
                        : 'no ',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Theme.of(context).primaryColor),
                  ),
                  Container(color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              (restaurant.picture != null &&
                                  restaurant.picture!.isNotEmpty)
                              ? NetworkImage(restaurant.picture!)
                              : null,
                          child:
                              (restaurant.picture == null ||
                                  restaurant.picture!.isEmpty)
                              ? Icon(
                                  Icons.restaurant,
                                  size: 30,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.color,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name ?? context.tr.noName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              (restaurant.place != null &&
                                      restaurant.place!.isNotEmpty)
                                  ? ' · ${restaurant.place!}'
                                  : context.tr.noLocation,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _ratingChip(restaurant.rating ?? 0.0, context),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statusChip(
                        restaurant.isOpen == true
                            ? context.tr.open
                            : context.tr.closed,
                        restaurant.isOpen == true
                            ? const Color(0xFF2ecc71)
                            : const Color(0xFFe74c3c),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    restaurant.bio ?? context.tr.noDescription,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openDirections(context),
                      icon: Icon(
                        Icons.directions,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        context.tr.getDirections,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  ReviewWidget(profileId: restaurant.id!),
                ],
              ),
            ),
          ),

          // ✅ MENU / EVENTS SWITCHER
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(child: _contentSwitcher(context)),
          ),
        ],
      ),
    );
  }

  // ================================================================
  //  CONTENT SWITCHER — Menu / Events
  // ================================================================
  Widget _contentSwitcher(BuildContext context) {
    final restaurant = widget.restaurant;

    final bool hasFoods =
        restaurant.foods != null && restaurant.foods!.isNotEmpty;
    final bool hasEvents =
        restaurant.organizer != null && restaurant.organizer!.isNotEmpty;

    if (!hasFoods && !hasEvents) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            context.tr.noMenuAvailable,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    if (hasFoods && !hasEvents) {
      return _menuSection(context);
    }

    if (!hasFoods && hasEvents) {
      return _eventsSection(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          // decoration: BoxDecoration(
          //   color: Theme.of(context).cardColor,
          //   borderRadius: BorderRadius.circular(14),
          //   border: Border.all(
          //     color: Theme.of(context).dividerColor.withOpacity(0.3),
          //   ),
          // ),
          child: Row(
            children: [
              _switchButton(
                context,
                label: context.tr.menu,
                icon: Icons.restaurant_menu,
                value: 'menu',
              ),
              _switchButton(
                context,
                label: context.tr.eventer,
                icon: Icons.event,
                value: 'events',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedTab == 'menu')
          _menuSection(context)
        else
          _eventsSection(context),
      ],
    );
  }

  Widget _switchButtonx(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String value,
  }) {
    final bool isActive = _selectedTab == value;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? theme.colorScheme.onPrimary
                      : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String value,
  }) {
    final bool isActive = _selectedTab == value;
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = value),
        splashColor: theme.primaryColor.withOpacity(0.1),
        highlightColor: theme.primaryColor.withOpacity(0.05),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? theme.primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   icon,
              //   size: 18,
              //   color: isActive
              //       ? theme.primaryColor
              //       : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              // ),
              // const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? theme.primaryColor
                      : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  //  EVENTS SECTION — Opera-style timetable + detail panel
  // ================================================================
  Widget _eventsSection(BuildContext context) {
    final theme = Theme.of(context);
    final events = widget.restaurant.organizer ?? [];

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            'No events available',
            style: TextStyle(
              fontSize: 15,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    final sortedEvents = [...events]
      ..sort((a, b) {
        if (a.startTime == null) return 1;
        if (b.startTime == null) return -1;
        return a.startTime!.compareTo(b.startTime!);
      });

    if (_selectedEvent == null && sortedEvents.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _selectedEvent == null) {
          setState(() => _selectedEvent = sortedEvents.first);
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Timetable Header ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: theme.primaryColor, size: 22),
              const SizedBox(width: 8),
              Text(
                context.tr.eventTimetable,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:
                      theme.textTheme.headlineSmall?.color ??
                      theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ---------- Timetable List ----------
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.25 : 0.04,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < sortedEvents.length; i++) ...[
                _eventCard(context, sortedEvents[i]),
                if (i != sortedEvents.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 66,
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ---------- Detail Panel Below ----------
        if (_selectedEvent != null) _eventDetailPanel(context, _selectedEvent!),

        const SizedBox(height: 20),
      ],
    );
  }

  // ================================================================
  //  TIMETABLE ROW — Theme aware
  // ================================================================
  Widget _eventCard(BuildContext context, EventOrganizer event) {
    final theme = Theme.of(context);
    final bool isSelected = _selectedEvent?.id == event.id;

    // Soft tint = primary color at very low opacity (works in light + dark)
    final Color softTint = theme.primaryColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.15 : 0.10,
    );
    final Color selectedRowBg = theme.primaryColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.08 : 0.08,
    );

    IconData getEventIcon(String? title) {
      final t = (title ?? '').toLowerCase().trim();

      // ============================================================
      // ---- Ceremony / opening / closing ----
      // ============================================================
      if (t.contains('open') || // en: opening, open
          t.contains('ceremony') || // en
          t.contains('inaugurat') || // en: inauguration
          t.contains('launch') || // en
          t.contains('closing') || // en
          t.contains('graduation') || // en
          t.contains('apertura') || // es
          t.contains('ceremonia') || // es
          t.contains('inauguraci') || // es
          t.contains('clausura') || // es
          t.contains('graduaci') || // es
          t.contains('cérémonie') || // fr
          t.contains('ouverture') || // fr
          t.contains('clôture') || // fr
          t.contains('remise') || // fr: remise des diplômes
          t.contains('افتتاح') || // ar
          t.contains('حفل') || // ar: ceremony
          t.contains('ختام') || // ar: closing
          t.contains('تخرج') || // ar: graduation
          t.contains('개회') || // ko
          t.contains('폐회') || // ko
          t.contains('졸업') || // ko
          t.contains('개막') || // ko
          t.contains('開会') || // ja
          t.contains('閉会') || // ja
          t.contains('卒業') || // ja
          t.contains('開幕') || // ja
          t.contains('开幕') || // zh
          t.contains('闭幕') || // zh
          t.contains('毕业') || // zh
          t.contains('典礼')) {
        // zh
        return Icons.event_note;
      }

      // ============================================================
      // ---- Keynote / talk / speaker / lecture ----
      // ============================================================
      if (t.contains('keynote') || // en
          t.contains('talk') || // en
          t.contains('speech') || // en
          t.contains('speaker') || // en
          t.contains('lecture') || // en
          t.contains('presentation') || // en
          t.contains('seminar') || // en
          t.contains('charla') || // es: talk
          t.contains('conferencia') || // es: lecture/conference
          t.contains('ponencia') || // es: presentation
          t.contains('discurso') || // es
          t.contains('seminario') || // es
          t.contains('conférence') || // fr
          t.contains('discours') || // fr
          t.contains('présentation') || // fr
          t.contains('séminaire') || // fr
          t.contains('محاضرة') || // ar: lecture
          t.contains('خطاب') || // ar: speech
          t.contains('ندوة') || // ar: seminar
          t.contains('كلمة') || // ar: talk
          t.contains('강연') || // ko
          t.contains('연설') || // ko
          t.contains('발표') || // ko
          t.contains('세미나') || // ko
          t.contains('講演') || // ja
          t.contains('スピーチ') || // ja
          t.contains('発表') || // ja
          t.contains('セミナー') || // ja
          t.contains('演讲') || // zh
          t.contains('讲座') || // zh
          t.contains('发言') || // zh
          t.contains('研讨会')) {
        // zh
        return Icons.people_alt;
      }

      // ============================================================
      // ---- Food / lunch / dinner / breakfast / coffee ----
      // ============================================================
      if (t.contains('lunch') || // en
          t.contains('dinner') || // en
          t.contains('breakfast') || // en
          t.contains('brunch') || // en
          t.contains('food') || // en
          t.contains('buffet') || // en
          t.contains('coffee') || // en
          t.contains('cocktail') || // en
          t.contains('meal') || // en
          t.contains('almuerzo') || // es
          t.contains('comida') || // es
          t.contains('cena') || // es
          t.contains('desayuno') || // es
          t.contains('café') || // es / fr
          t.contains('buffet') || // es / fr
          t.contains('déjeuner') || // fr
          t.contains('dîner') || // fr
          t.contains('petit-déjeuner') || // fr
          t.contains('repas') || // fr
          t.contains('غداء') || // ar: lunch
          t.contains('عشاء') || // ar: dinner
          t.contains('فطور') || // ar: breakfast
          t.contains('طعام') || // ar: food
          t.contains('مأدبة') || // ar: banquet
          t.contains('قهوة') || // ar: coffee
          t.contains('점심') || // ko
          t.contains('저녁') || // ko
          t.contains('아침') || // ko
          t.contains('식사') || // ko
          t.contains('음식') || // ko
          t.contains('커피') || // ko
          t.contains('ランチ') || // ja
          t.contains('ディナー') || // ja
          t.contains('朝食') || // ja
          t.contains('昼食') || // ja
          t.contains('夕食') || // ja
          t.contains('食事') || // ja
          t.contains('コーヒー') || // ja
          t.contains('午餐') || // zh
          t.contains('晚餐') || // zh
          t.contains('早餐') || // zh
          t.contains('美食') || // zh
          t.contains('餐饮') || // zh
          t.contains('咖啡')) {
        // zh
        return Icons.restaurant;
      }

      // ============================================================
      // ---- Workshop / training / class / tutorial ----
      // ============================================================
      if (t.contains('workshop') || // en / es / fr
          t.contains('training') || // en
          t.contains('class') || // en
          t.contains('tutorial') || // en
          t.contains('bootcamp') || // en
          t.contains('lab') || // en
          t.contains('hands-on') || // en
          t.contains('taller') || // es: workshop
          t.contains('capacitación') || // es: training
          t.contains('clase') || // es: class
          t.contains('tutorial') || // es
          t.contains('atelier') || // fr: workshop
          t.contains('formation') || // fr: training
          t.contains('cours') || // fr: class
          t.contains('ورشة') || // ar: workshop
          t.contains('تدريب') || // ar: training
          t.contains('دورة') || // ar: course
          t.contains('워크숍') || // ko
          t.contains('교육') || // ko
          t.contains('클래스') || // ko
          t.contains('워크샵') || // ko
          t.contains('ワークショップ') || // ja
          t.contains('トレーニング') || // ja
          t.contains('教室') || // ja
          t.contains('工作坊') || // zh
          t.contains('培训') || // zh
          t.contains('课程')) {
        // zh
        return Icons.lightbulb_outline;
      }

      // ============================================================
      // ---- Panel / discussion / roundtable / Q&A ----
      // ============================================================
      if (t.contains('panel') || // en / es / fr
          t.contains('discussion') || // en / fr
          t.contains('roundtable') || // en
          t.contains('round table') || // en
          t.contains('q&a') || // en
          t.contains('forum') || // en
          t.contains('debate') || // en / es
          t.contains('interview') || // en
          t.contains('discusión') || // es
          t.contains('mesa redonda') || // es
          t.contains('debate') || // es
          t.contains('entrevista') || // es
          t.contains('table ronde') || // fr
          t.contains('débat') || // fr
          t.contains('entretien') || // fr
          t.contains('نقاش') || // ar: discussion
          t.contains('حوار') || // ar: dialogue
          t.contains('مائدة') || // ar: roundtable
          t.contains('مقابلة') || // ar: interview
          t.contains('토론') || // ko
          t.contains('패널') || // ko
          t.contains('인터뷰') || // ko
          t.contains('ディスカッション') || // ja
          t.contains('パネル') || // ja
          t.contains('討論') || // zh
          t.contains('圆桌') || // zh
          t.contains('访谈')) {
        // zh
        return Icons.groups_outlined;
      }

      // ============================================================
      // ---- Party / gala / evening / concert / music ----
      // ============================================================
      if (t.contains('gala') || // en / es / fr
          t.contains('party') || // en
          t.contains('evening') || // en
          t.contains('concert') || // en / fr
          t.contains('music') || // en
          t.contains('dj') || // en
          t.contains('performance') || // en
          t.contains('show') || // en
          t.contains('dance') || // en
          t.contains('fiesta') || // es: party
          t.contains('noche') || // es: night
          t.contains('música') || // es
          t.contains('concierto') || // es
          t.contains('baile') || // es
          t.contains('fête') || // fr: party
          t.contains('soirée') || // fr: evening
          t.contains('musique') || // fr
          t.contains('spectacle') || // fr
          t.contains('danse') || // fr
          t.contains('حفلة') || // ar: party
          t.contains('سهرة') || // ar: evening
          t.contains('موسيقى') || // ar: music
          t.contains('حفل') || // ar: celebration
          t.contains('رقص') || // ar: dance
          t.contains('파티') || // ko
          t.contains('공연') || // ko
          t.contains('음악') || // ko
          t.contains('축제') || // ko
          t.contains('パーティー') || // ja
          t.contains('コンサート') || // ja
          t.contains('音楽') || // ja
          t.contains('ダンス') || // ja
          t.contains('派对') || // zh
          t.contains('音乐会') || // zh
          t.contains('演出') || // zh
          t.contains('舞会')) {
        // zh
        return Icons.celebration;
      }

      // ============================================================
      // ---- Sports / fitness / yoga ----
      // ============================================================
      if (t.contains('sport') || // en / fr
          t.contains('fitness') || // en / es / fr
          t.contains('yoga') || // en / es / fr
          t.contains('run') || // en
          t.contains('match') || // en
          t.contains('game') || // en
          t.contains('tournament') || // en
          t.contains('deporte') || // es
          t.contains('partido') || // es: match
          t.contains('juego') || // es: game
          t.contains('torneo') || // es
          t.contains('course') || // fr: race
          t.contains('match') || // fr
          t.contains('jeu') || // fr
          t.contains('tournoi') || // fr
          t.contains('رياضة') || // ar: sports
          t.contains('مباراة') || // ar: match
          t.contains('لعبة') || // ar: game
          t.contains('بطولة') || // ar
          t.contains('운동') || // ko
          t.contains('경기') || // ko
          t.contains('경기') || // ko
          t.contains('스포츠') || // ko
          t.contains('スポーツ') || // ja
          t.contains('試合') || // ja
          t.contains('運動') || // ja
          t.contains('体育') || // zh
          t.contains('比赛') || // zh
          t.contains('运动')) {
        // zh
        return Icons.sports_soccer;
      }

      // ============================================================
      // ---- Meeting / business / networking ----
      // ============================================================
      if (t.contains('meeting') || // en
          t.contains('networking') || // en
          t.contains('business') || // en
          t.contains('conference') || // en / fr
          t.contains('summit') || // en
          t.contains('session') || // en / fr
          t.contains('standup') || // en
          t.contains('stand-up') || // en
          t.contains('reunión') || // es
          t.contains('negocio') || // es
          t.contains('cumbre') || // es
          t.contains('sesión') || // es
          t.contains('réunion') || // fr
          t.contains('affaires') || // fr
          t.contains('sommet') || // fr
          t.contains('اجتماع') || // ar
          t.contains('أعمال') || // ar
          t.contains('قمة') || // ar
          t.contains('جلسة') || // ar
          t.contains('회의') || // ko
          t.contains('비즈니스') || // ko
          t.contains('네트워킹') || // ko
          t.contains('会議') || // ja
          t.contains('ビジネス') || // ja
          t.contains('ネットワーキング') || // ja
          t.contains('会议') || // zh
          t.contains('商务') || // zh
          t.contains('峰会')) {
        // zh
        return Icons.groups;
      }

      // ============================================================
      // ---- Prayer / religious ----
      // ============================================================
      if (t.contains('prayer') || // en
          t.contains('mass') || // en
          t.contains('worship') || // en
          t.contains('meditation') || // en
          t.contains('service') || // en
          t.contains('oración') || // es
          t.contains('misa') || // es
          t.contains('culto') || // es
          t.contains('meditación') || // es
          t.contains('prière') || // fr
          t.contains('messe') || // fr
          t.contains('culte') || // fr
          t.contains('méditation') || // fr
          t.contains('صلاة') || // ar
          t.contains('قداس') || // ar
          t.contains('تأمل') || // ar
          t.contains('기도') || // ko
          t.contains('예배') || // ko
          t.contains('명상') || // ko
          t.contains('祈り') || // ja
          t.contains('礼拝') || // ja
          t.contains('瞑想') || // ja
          t.contains('祈祷') || // zh
          t.contains('礼拜') || // zh
          t.contains('冥想')) {
        // zh
        return Icons.self_improvement;
      }

      // ============================================================
      // ---- Art / exhibition / culture ----
      // ============================================================
      if (t.contains('art') || // en / fr
          t.contains('exhibit') || // en
          t.contains('gallery') || // en
          t.contains('museum') || // en
          t.contains('culture') || // en / fr
          t.contains('theater') || // en
          t.contains('theatre') || // en / fr
          t.contains('arte') || // es
          t.contains('exposición') || // es
          t.contains('galería') || // es
          t.contains('museo') || // es
          t.contains('cultura') || // es
          t.contains('teatro') || // es
          t.contains('art') || // fr: art
          t.contains('exposition') || // fr
          t.contains('galerie') || // fr
          t.contains('musée') || // fr
          t.contains('théâtre') || // fr
          t.contains('فن') || // ar: art
          t.contains('معرض') || // ar: exhibition
          t.contains('متحف') || // ar: museum
          t.contains('ثقافة') || // ar: culture
          t.contains('مسرح') || // ar: theater
          t.contains('예술') || // ko
          t.contains('전시') || // ko
          t.contains('박물관') || // ko
          t.contains('문화') || // ko
          t.contains('극장') || // ko
          t.contains('芸術') || // ja
          t.contains('展示') || // ja
          t.contains('美術館') || // ja
          t.contains('文化') || // ja
          t.contains('劇場') || // ja
          t.contains('艺术') || // zh
          t.contains('展览') || // zh
          t.contains('博物馆') || // zh
          t.contains('文化') || // zh
          t.contains('剧院')) {
        // zh
        return Icons.palette;
      }

      // ============================================================
      // ---- Fallback ----
      // ============================================================
      return Icons.event;
    }

    final String timeRange = event.startTime != null
        ? _formatTimeRange(event.startTime!, event.endTime)
        : 'Time TBA';

    return InkWell(
      onTap: () => setState(() => _selectedEvent = event),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          // color: isSelected ? selectedRowBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle icon — soft tinted circle
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: softTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                getEventIcon(event.title),
                color: theme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeRange,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title ?? context.tr.untitledEvent,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.venueDetails?.name ??
                              (event.venueDetails?.address ?? 'Main Hall'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: isSelected ? 0.25 : 0,
                child: Icon(
                  Icons.chevron_right,
                  color: theme.primaryColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  //  EVENT DETAIL PANEL — Theme aware
  // ================================================================
  Widget _eventDetailPanel(BuildContext context, EventOrganizer event) {
    final theme = Theme.of(context);
    final bool isFull = event.isFull == true;
    final bool canAttend = event.canAttend == true;

    // Tinted backgrounds derived from theme.primaryColor
    final Color headerBg = theme.primaryColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.04 : 0.04,
    );
    final Color chipBg = theme.primaryColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.04 : 0.04,
    );
    final Color softBorder = theme.primaryColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.4 : 0.4,
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 1),
        // decoration: BoxDecoration(
        //   color: theme.cardColor,
        //   borderRadius: BorderRadius.circular(16),
        //   border: Border.all(color: softBorder, width: 1.5),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(
        //           theme.brightness == Brightness.dark ? 0.30 : 0.05),
        //       blurRadius: 14,
        //       offset: const Offset(0, 6),
        //     ),
        //   ],
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header strip ----------
            // Container(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //   decoration: BoxDecoration(
            //     color: headerBg,
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(14),
            //       topRight: Radius.circular(14),
            //     ),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(Icons.info_outline,
            //           color: theme.primaryColor, size: 20),
            //       const SizedBox(width: 8),
            //       Expanded(
            //         child: Text(
            //           context.tr.eventDetails,
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //             color: theme.primaryColor,
            //           ),
            //         ),
            //       ),
            //       _statusBadge(context, event.status),
            //     ],
            //   ),
            // ),

            // ---------- Body ----------
            Padding(
              padding: const EdgeInsets.all(1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    padding: const EdgeInsets.only(bottom: 20,  left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,

                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            theme.brightness == Brightness.dark ? 0.25 : 0.04,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            // color: headerBg,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: theme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  context.tr.eventDetails,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                              _statusBadge(context, event.status),
                            ],
                          ),
                        ),
                        Text(
                          event.title ?? context.tr.untitledEvent,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: theme.textTheme.headlineSmall?.color,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        if ((event.description ?? '').isNotEmpty) ...[
                          Text(
                            event.description!,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.45,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Meta chips
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            if (event.startTime != null)
                              _metaChip(
                                context,
                                icon: Icons.schedule,
                                label: _formatTimeRange(
                                  event.startTime!,
                                  event.endTime,
                                ),
                                chipBg: chipBg,
                              ),
                            if (event.categoryDetails?.name != null)
                              _metaChip(
                                context,
                                icon: Icons.category_outlined,
                                label: event.categoryDetails!.name!,
                                chipBg: chipBg,
                              ),
                            if (event.venueDetails?.name != null)
                              _metaChip(
                                context,
                                icon: Icons.place_outlined,
                                label: event.venueDetails!.name!,
                                chipBg: chipBg,
                              ),
                            if (event.venueDetails?.capacity != null)
                              _metaChip(
                                context,
                                icon: Icons.groups_outlined,
                                label:
                                    '${context.tr.capacity} ${event.venueDetails!.capacity}',
                                chipBg: chipBg,
                              ),
                            if (event.maxAttendees != null)
                              _metaChip(
                                context,
                                icon: Icons.people_outline,
                                label:
                                    '${context.tr.max} ${event.maxAttendees}',
                                chipBg: chipBg,
                              ),
                            _metaChip(
                              context,
                              icon: Icons.lock_open_outlined,
                              label: _attendanceLabel(event.attendanceType),
                              chipBg: chipBg,
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Full venue address
                        if ((event.venueDetails?.address ?? '').isNotEmpty) ...[
                          Divider(
                            height: 1,
                            color: theme.dividerColor.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: theme.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  event.venueDetails!.address!,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withOpacity(0.75),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Sessions
                  if ((event.sessions ?? []).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    // Divider(
                    //   height: 1,
                    //   color: theme.dividerColor.withOpacity(0.4),
                    // ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr.sessions,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...event.sessions!.map((s) => _sessionTile(context, s)),
                  ],

                  const SizedBox(height: 16),

                  // Attendance availability banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isFull
                          ? Colors.red.withOpacity(
                              theme.brightness == Brightness.dark ? 0.18 : 0.08,
                            )
                          : (canAttend
                                ? Colors.green.withOpacity(
                                    theme.brightness == Brightness.dark
                                        ? 0.18
                                        : 0.08,
                                  )
                                : Colors.orange.withOpacity(
                                    theme.brightness == Brightness.dark
                                        ? 0.18
                                        : 0.08,
                                  )),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFull
                            ? Colors.red.withOpacity(0.3)
                            : (canAttend
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.orange.withOpacity(0.3)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isFull
                              ? Icons.block
                              : (canAttend
                                    ? Icons.check_circle_outline
                                    : Icons.info_outline),
                          size: 20,
                          color: isFull
                              ? Colors.red
                              : (canAttend
                                    ? Colors.green.shade700
                                    : Colors.orange.shade800),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isFull
                                ? context.tr.thisEventIsFull
                                : (canAttend
                                      ? context.tr.youCanAttend
                                      : context.tr.youAreNotEligible),
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isFull
                                  ? Colors.red
                                  : (canAttend
                                        ? Colors.green.shade800
                                        : Colors.orange.shade900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // CTA
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton.icon(
                  //     onPressed: (!canAttend || isFull)
                  //         ? null
                  //         : () {
                  //             ScaffoldMessenger.of(context).showSnackBar(
                  //               SnackBar(
                  //                 content:
                  //                     Text('RSVP for "${event.title}" — TODO'),
                  //               ),
                  //             );
                  //           },
                  //     icon: const Icon(Icons.event_available, size: 18),
                  //     label: Text(
                  //       isFull
                  //           ? context.tr.eventFull
                  //           : (canAttend ? context.tr.rsvpNow : context.tr.notAvailable),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: theme.primaryColor,
                  //       foregroundColor: theme.colorScheme.onPrimary,
                  //       disabledBackgroundColor:
                  //           theme.disabledColor.withOpacity(0.3),
                  //       disabledForegroundColor:
                  //           theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
                  //       padding: const EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color chipBg,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // color: chipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.textTheme.bodyMedium?.color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String? status) {
    final s = (status ?? 'draft').toLowerCase();
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    Color bg;
    Color fg;
    String label;

    switch (s) {
      case 'published':
        bg = Colors.green.withOpacity(isDark ? 0.22 : 0.15);
        fg = isDark ? Colors.green.shade300 : Colors.green.shade800;
        label = 'Published';
        break;
      case 'cancelled':
        bg = Colors.red.withOpacity(isDark ? 0.22 : 0.15);
        fg = isDark ? Colors.red.shade300 : Colors.red.shade800;
        label = 'Cancelled';
        break;
      case 'completed':
        bg = Colors.blueGrey.withOpacity(isDark ? 0.22 : 0.15);
        fg = isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade700;
        label = 'Completed';
        break;
      default:
        bg = Colors.orange.withOpacity(isDark ? 0.22 : 0.15);
        fg = isDark ? Colors.orange.shade300 : Colors.orange.shade800;
        label = 'Draft';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _sessionTilex(BuildContext context, EventSession s) {
    bool isExpanded = false;

    // ── The toggle function ──
    void onToggle() {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : const Color.fromARGB(255, 245, 245, 244),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),

      // child: Row(
      //   children: [
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         if (s.startTime != null)
      //               Text(
      //                 _formatTimeRange(s.startTime!, s.endTime),
      //                 style: TextStyle(
      //                   fontSize: 11,
      //                   fontWeight: FontWeight.w600,
      //                   color: theme.primaryColor,
      //                 ),
      //               ),
      //         //   ],
      //         // Row(
      //         //   children: [
      //             Expanded(
      //               child: Text(
      //                 s.title ?? 'Session',
      //                 style: TextStyle(
      //                   fontSize: 13,
      //                   fontWeight: FontWeight.w700,
      //                   color: theme.textTheme.titleMedium?.color,
      //                 ),
      //               ),
      //             ),
      //         //     if (s.startTime != null)
      //         //       Text(
      //         //         _formatTimeRange(s.startTime!, s.endTime),
      //         //         style: TextStyle(
      //         //           fontSize: 11,
      //         //           fontWeight: FontWeight.w600,
      //         //           color: theme.primaryColor,
      //         //         ),
      //         //       ),
      //         //   ],
      //         // ),
      //         // Row(
      //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         //   children: [ Column(children: [
      //         // if ((s.description ?? '').isNotEmpty) ...[
      //         //   const SizedBox(height: 4),
      //         //   Text(
      //         //     s.description!,
      //         //     style: TextStyle(
      //         //       fontSize: 12,
      //         //       color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
      //         //       height: 1.35,
      //         //     ),
      //         //   ),
      //         // ],
      //         // const SizedBox(height: 6),
      //         // Wrap(
      //         //   spacing: 12,
      //         //   runSpacing: 4,
      //         //   children: [
      //             if ((s.speaker ?? '').isNotEmpty)
      //               Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Icon(Icons.person_outline,
      //                       size: 12,
      //                       color: theme.textTheme.bodyMedium?.color
      //                           ?.withOpacity(0.6)),
      //                   const SizedBox(width: 4),
      //                   Text(
      //                     s.speaker!,
      //                     style: TextStyle(
      //                       fontSize: 11,
      //                       color: theme.textTheme.bodyMedium?.color
      //                           ?.withOpacity(0.75),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             if ((s.location ?? '').isNotEmpty)
      //               Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Icon(Icons.place_outlined,
      //                       size: 12,
      //                       color: theme.textTheme.bodyMedium?.color
      //                           ?.withOpacity(0.6)),
      //                   const SizedBox(width: 4),
      //                   Text(
      //                     s.location!,
      //                     style: TextStyle(
      //                       fontSize: 11,
      //                       color: theme.textTheme.bodyMedium?.color
      //                           ?.withOpacity(0.75),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //           // ],)
      //         // ),],),
      //         // Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColor,)
      //         // ],)
      //       ],
      //     ),
      //     Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColor,)
      //   ],
      // ),
      //       child:Row(
      //   children: [
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           if (s.startTime != null)
      //             Text(
      //               _formatTimeRange(s.startTime!, s.endTime),
      //               style: TextStyle(
      //                 fontSize: 11,
      //                 fontWeight: FontWeight.w600,
      //                 color: theme.primaryColor,
      //               ),
      //             ),
      //           Text(
      //             s.title ?? 'Session',
      //             style: TextStyle(
      //               fontSize: 13,
      //               fontWeight: FontWeight.w700,
      //               color: theme.textTheme.titleMedium?.color,
      //             ),
      //           ),
      //           if ((s.description ?? '').isNotEmpty) ...[
      //             const SizedBox(height: 4),
      //             Text(
      //               s.description!,
      //               style: TextStyle(
      //                 fontSize: 12,
      //                 color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
      //                 height: 1.35,
      //               ),
      //             ),
      //           ],
      //           const SizedBox(height: 6),
      //           Wrap(
      //             spacing: 12,
      //             runSpacing: 4,
      //             children: [
      //               if ((s.speaker ?? '').isNotEmpty)
      //                 Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     Icon(Icons.person_outline,
      //                         size: 12,
      //                         color: theme.textTheme.bodyMedium?.color
      //                             ?.withOpacity(0.6)),
      //                     const SizedBox(width: 4),
      //                     Text(
      //                       s.speaker!,
      //                       style: TextStyle(
      //                         fontSize: 11,
      //                         color: theme.textTheme.bodyMedium?.color
      //                             ?.withOpacity(0.75),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               if ((s.location ?? '').isNotEmpty)
      //                 Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     Icon(Icons.place_outlined,
      //                         size: 12,
      //                         color: theme.textTheme.bodyMedium?.color
      //                             ?.withOpacity(0.6)),
      //                     const SizedBox(width: 4),
      //                     Text(
      //                       s.location!,
      //                       style: TextStyle(
      //                         fontSize: 11,
      //                         color: theme.textTheme.bodyMedium?.color
      //                             ?.withOpacity(0.75),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //     Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
      //   ],
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (s.startTime != null)
                  Text(
                    _formatTimeRange(s.startTime!, s.endTime),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),

                // Title: 1 line when collapsed, full when expanded
                Text(
                  s.title ?? 'Session',
                  maxLines: isExpanded ? null : 1,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),

                // Description: only shown when expanded, with smooth animation
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: isExpanded && (s.description ?? '').isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            s.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                              height: 1.35,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    if ((s.speaker ?? '').isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 12,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s.speaker!,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    if ((s.location ?? '').isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 12,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s.location!,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Tappable arrow — rotates when expanded
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AnimatedRotation(
                turns: isExpanded ? 0.25 : 0, // 90° clockwise
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionTilexx(BuildContext context, EventSession s) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isExpanded = _expandedIds.contains(
      s.id.toString(),
    ); // ← from parent state

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : const Color.fromARGB(255, 245, 245, 244),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (s.startTime != null)
                  Text(
                    _formatTimeRange(s.startTime!, s.endTime),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),

                // Title: 1 line when collapsed, full when expanded
                Text(
                  s.title ?? 'Session',
                  maxLines: isExpanded ? null : 1,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),

                // Description: only when expanded
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: isExpanded && (s.description ?? '').isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            s.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                              height: 1.35,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    if ((s.speaker ?? '').isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 12,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s.speaker!,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    if ((s.location ?? '').isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 12,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s.location!,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Tappable arrow — toggles THIS row
          InkWell(
            onTap: () =>
                _toggle(s.id.toString()), // ← calls the parent's toggle
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AnimatedRotation(
                turns: isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionTile(BuildContext context, EventSession s) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isExpanded = _expandedIds.contains(s.id.toString());

    // Pick an icon based on the session title (same logic as events)
    IconData getSessionIcon(String? title) {
      final t = (title ?? '').toLowerCase();
      if (t.contains('open') || t.contains('ceremony')) return Icons.event_note;
      if (t.contains('keynote') || t.contains('talk')) return Icons.people_alt;
      if (t.contains('lunch') || t.contains('dinner') || t.contains('food')) {
        return Icons.restaurant;
      }
      if (t.contains('workshop') || t.contains('training')) {
        return Icons.lightbulb_outline;
      }
      if (t.contains('panel') || t.contains('discussion')) {
        return Icons.groups_outlined;
      }
      if (t.contains('gala') || t.contains('party') || t.contains('evening')) {
        return Icons.calendar_today;
      }
      return Icons.event;
    }

    // Soft blue tint that works in light and dark
    final Color softTint = theme.primaryColor.withOpacity(isDark ? 0.18 : 0.10);
    final Color softBorder = theme.primaryColor.withOpacity(
      isDark ? 0.30 : 0.15,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        // border: Border.all(color: softBorder),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Circle icon (left) ----------
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(color: softTint, shape: BoxShape.circle),
            child: Icon(
              getSessionIcon(s.title),
              color: theme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // ---------- Text column ----------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time range (top, small blue)
                if (s.startTime != null)
                  Text(
                    _formatTimeRange(s.startTime!, s.endTime),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 156, 156, 156),
                    ),
                  ),
                const SizedBox(height: 3),

                // Title (bold, 1 line collapsed / full expanded)
                Text(
                  s.title ?? 'Session',
                  maxLines: isExpanded ? null : 1,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),

                // Location row (below title, with pin)
                if ((s.location ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 13,
                        color: const Color.fromARGB(255, 156, 156, 156),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          s.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 156, 156, 156),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Description (only when expanded)
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: isExpanded && (s.description ?? '').isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            s.description!,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.75),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Speaker (optional, only when expanded)
                if (isExpanded && (s.speaker ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 13,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          s.speaker!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.75),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ---------- Chevron (right) ----------
          InkWell(
            onTap: () => _toggle(s.id.toString()),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AnimatedRotation(
                turns: isExpanded ? 0.25 : 0, // points down when expanded
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _attendanceLabel(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'public':
        return 'Public';
      case 'registered':
        return 'Registered Users';
      case 'staff':
        return 'Staff Only';
      case 'invite':
        return 'Invitation Only';
      case 'members':
        return 'Members Only';
      default:
        return 'Public';
    }
  }

  String _formatTimeRange(DateTime start, DateTime? end) {
    String fmt(DateTime d) {
      final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final minute = d.minute.toString().padLeft(2, '0');
      final period = d.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:$minute $period';
    }

    if (end == null) return fmt(start);
    return '${fmt(start)} - ${fmt(end)}';
  }

  // ================================================================
  //  MENU SECTION
  // ================================================================
  Widget _menuSection(BuildContext context) {
    final restaurant = widget.restaurant;
    final List<Food>? foods = restaurant.foods;

    if (foods == null || foods.isEmpty) {
      return Center(
        child: Text(
          context.tr.noMenuAvailable,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    final List<String> categories = [
      'All',
      ...foods
          .map((f) => f.category?.name)
          .where((name) => name != null && name.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList(),
    ];

    final selectedCategory = _selectedCategory;

    final List<Food> filteredFoods = selectedCategory == 'All'
        ? foods
        : foods.where((f) => f.category?.name == selectedCategory).toList();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.menu,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final category = categories[i];
              final isSelected = category == selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primaryColor : theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : theme.dividerColor.withOpacity(0.4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.textTheme.bodyMedium?.color?.withOpacity(
                                0.75,
                              ),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 9),
        Column(
          children: filteredFoods
              .map(
                (f) => FoodCard(
                  food: f,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FoodDetailScreen(food: f),
                    ),
                  ),
                  onAdd: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FoodDetailScreen(food: f),
                    ),
                  ),
                ).padding(b: 4),
              )
              .toList(),
        ),
      ],
    );
  }

  List<FoodItemModel> _fallbackFoods() {
    return [
      FoodItemModel(
        id: 1,
        name: 'Beef Burger',
        description: 'Juicy beef patty with cheese & veggies',
        price: 8000,
        image:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop',
        rating: 4.5,
        category: 'Burger',
      ),
      FoodItemModel(
        id: 2,
        name: 'Chicken Pizza',
        description: 'Grilled chicken, cheese & special sauce',
        price: 12000,
        image:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=400&fit=crop',
        rating: 4.7,
        category: 'Pizza',
      ),
      FoodItemModel(
        id: 3,
        name: 'French Fries',
        description: 'Crispy golden fries',
        price: 4000,
        image:
            'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400&h=400&fit=crop',
        rating: 4.0,
        category: 'Burger',
      ),
      FoodItemModel(
        id: 4,
        name: 'Grilled Chicken',
        description: 'Well grilled with spices',
        price: 10000,
        image:
            'https://images.unsplash.com/photo-1594041680534-e8c8cdebd659?w=400&h=400&fit=crop',
        rating: 4.3,
        category: 'Chicken',
      ),
      FoodItemModel(
        id: 5,
        name: 'Fresh Juice',
        description: 'Natural & healthy',
        price: 3000,
        image:
            'https://images.unsplash.com/photo-1622597467836-f3824f29db43?w=400&h=400&fit=crop',
        rating: 4.1,
        category: 'Drinks',
      ),
    ];
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Widget _ratingChip(double rating, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: Colors.white, size: 12),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

/// ==================== FOOD DETAIL ====================
class FoodDetailScreen extends StatefulWidget {
  final Food food;
  const FoodDetailScreen({super.key, required this.food});
  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  String? _selectedVariant;
  final List<String> _selectedExtras = [];

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final food = widget.food;
    bool hasDiscount =
        food.discountPrice != null &&
        food.price != null &&
        food.discountPrice! < food.price!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  app.isFoodFavorite(food)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () => app.toggleFoodFavorite(food),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    food.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          food.name ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TZS ${(food.discountPrice ?? food.price)!}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (hasDiscount)
                        Text(
                          '${food.currency ?? '\$'} ${food.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    food.description ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
