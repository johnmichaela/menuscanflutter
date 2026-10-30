// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:ballon/home.dart';
// // import 'package:ballon/models/profile.dart';
// // import 'package:ballon/models/resturants.dart';
// // import 'package:ballon/reviewwidget.dart';
// // import 'package:ballon/screens/main/discover.dart';
// // import 'package:ballon/screens/main/event.dart';
// // import 'package:ballon/screens/main/home.dart';
// // import 'package:ballon/screens/main/main_settings.dart';
// // import 'package:ballon/screens/sub/profile/createprofile.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import '../../app_state.dart';
// // import '../../models.dart';
// // import '../../widgets.dart';
// // import '../../qr_scanner_screen.dart';
// // import '../../search_screen.dart';
// // import '../../l10n/app_strings.dart';

// // /// ==================== SPLASH SCREEN ====================
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _scale;
// //   late Animation<double> _opacity;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //         vsync: this, duration: const Duration(milliseconds: 1800));
// //     _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
// //         CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
// //     _opacity = Tween<double>(begin: 0, end: 1).animate(
// //         CurvedAnimation(parent: _controller, curve: Curves.easeIn));
// //     _controller.forward();

// //     Timer(const Duration(seconds: 3), () {
// //       if (mounted) {
// //         Navigator.pushReplacement(
// //             context, MaterialPageRoute(builder: (_) => const MainScaffold()));
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Theme.of(context).primaryColor,
// //       body: Stack(
// //         children: [
// //           Positioned(
// //               top: -80,
// //               right: -60,
// //               child: _blob(220,
// //                   Theme.of(context).cardColor.withOpacity(0.08))),
// //           Positioned(
// //               bottom: -100,
// //               left: -80,
// //               child: _blob(280,
// //                   Theme.of(context).cardColor.withOpacity(0.06))),
// //           Positioned(
// //               top: 200,
// //               left: -50,
// //               child: _blob(120,
// //                   Theme.of(context).cardColor.withOpacity(0.1))),
// //           Center(
// //             child: FadeTransition(
// //               opacity: _opacity,
// //               child: ScaleTransition(
// //                 scale: _scale,
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Container(
// //                       width: 280,
// //                       height: 280,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(30),
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(10),
// //                         child: Image.asset('assets/img/menuscan_logo.png',
// //                             fit: BoxFit.contain, height: 500),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 24),
// //                     Image.asset('assets/img/splash.png',
// //                         fit: BoxFit.contain, height: 50),
// //                     const SizedBox(height: 8),
// //                     Text(
// //                       'Scan · Posts · Enjoy',
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.w600,
// //                         color: Colors.white.withOpacity(0.85),
// //                         fontSize: 16,
// //                         letterSpacing: 2,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             bottom: 40,
// //             left: 0,
// //             right: 0,
// //             child: Center(
// //               child: CircularProgressIndicator(
// //                   color: Colors.white.withOpacity(0.7), strokeWidth: 2),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _blob(double size, Color color) {
// //     return Container(
// //         width: size,
// //         height: size,
// //         decoration: BoxDecoration(color: color, shape: BoxShape.circle));
// //   }
// // }

// // /// ==================== MAIN SCAFFOLD ====================
// // class MainScaffold extends StatefulWidget {
// //   const MainScaffold({super.key});
// //   @override
// //   State<MainScaffold> createState() => _MainScaffoldState();
// // }

// // class _MainScaffoldState extends State<MainScaffold> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final app = Provider.of<AppState>(context, listen: false);
// //       app.loadRestaurants();
// //     });
// //     fetchProfile();
// //   }

// //   static Future<void> _saveProfileData(
// //       Map<String, dynamic> profileData) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       print('📝 Saving Profile Data:');
// //       print('   - PK: ${profileData['pk']}');

// //       await prefs.setInt('profid', profileData['pk'] ?? 0);
// //       await prefs.setString(
// //           'profile_name', profileData['name']?.toString() ?? '');
// //       await prefs.setString(
// //           'profile_email', profileData['email']?.toString() ?? '');
// //       await prefs.setString(
// //           'profile_phone', profileData['phone_number']?.toString() ?? '');
// //       await prefs.setString(
// //           'profile_place', profileData['place']?.toString() ?? '');
// //       await prefs.setString(
// //           'profile_bio', profileData['bio']?.toString() ?? '');
// //       await prefs.setString(
// //           'profile_picture', profileData['picture']?.toString() ?? '');

// //       if (profileData['user'] != null) {
// //         final user = profileData['user'] as Map<String, dynamic>;
// //         await prefs.setString(
// //             'profile_username', user['username']?.toString() ?? '');
// //         await prefs.setString('user_data', jsonEncode(user));
// //       }

// //       await prefs.setString('profile_data', jsonEncode(profileData));
// //       print('✅ Profile data saved successfully!');
// //     } catch (e) {
// //       print('❌ Error saving profile data: $e');
// //     }
// //   }

// //   Future<Profile> fetchProfile() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final String? token = prefs.getString('token');

// //     final url = Uri.parse('http://192.168.1.115:8000 /prof/api-prof/');

// //     try {
// //       final response = await http.get(url, headers: {
// //         'Authorization': 'Token $token',
// //         'Content-Type': 'application/json',
// //         'Accept': 'application/json',
// //       });

// //       if (response.statusCode == 200) {
// //         final jsonData = jsonDecode(response.body);

// //         if (jsonData is List) {
// //           if (jsonData.isEmpty) {
// //             print('No profile found. Redirecting to CreateProfileScreen.');
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(
// //                   builder: (context) => const CreateProfileScreen()),
// //             );
// //             throw Exception('No profile found for this user');
// //           }

// //           print("Raw JSON data: $jsonData");
// //           print("First item: ${jsonData[0]}");
// //           _saveProfileData(jsonData[0]);

// //           return Profile.fromJson(jsonData[0] as Map<String, dynamic>);
// //         } else if (jsonData is Map<String, dynamic>) {
// //           return Profile.fromJson(jsonData);
// //         } else {
// //           throw Exception('Unexpected data format');
// //         }
// //       } else {
// //         throw Exception(
// //             'Failed to load profile. Status code: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       throw Exception('Error fetching data: $e');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final app = Provider.of<AppState>(context);
// //     final screens = [
// //       RestaurantHomePage(),
// //       DiscoverPage(),
// //       EventScreen(),
// //       SettingsPage(),
// //     ];

// //     return Scaffold(
// //       body: IndexedStack(index: app.currentIndex, children: screens),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// //       floatingActionButton: Container(
// //         margin: const EdgeInsets.only(top: 10),
// //         height: 65,
// //         width: 65,
// //         child: FloatingActionButton(
// //           onPressed: () => Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                   builder: (_) => const QrScannerScreen())),
// //           backgroundColor: Theme.of(context).primaryColor,
// //           elevation: 4,
// //           shape: const CircleBorder(),
// //           child: const Icon(Icons.qr_code_scanner,
// //               size: 32, color: Colors.white),
// //         ),
// //       ),
// //       bottomNavigationBar: BottomAppBar(
// //         shape: const CircularNotchedRectangle(),
// //         notchMargin: 8.0,
// //         color: Theme.of(context).cardColor,
// //         elevation: 10,
// //         shadowColor:
// //             Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
// //         padding: const EdgeInsets.symmetric(vertical: 8),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: [
// //             GestureDetector(
// //               onTap: () => app.changeTab(0),
// //               child: _buildNavItem(Icons.home_outlined, context.tr.home,
// //                   app.currentIndex == 0, context),
// //             ),
// //             GestureDetector(
// //               onTap: () => app.changeTab(1),
// //               child: _buildNavItem(Icons.explore, context.tr.discover,
// //                   app.currentIndex == 1, context),
// //             ),
// //             const SizedBox(width: 40),
// //             GestureDetector(
// //               onTap: () => app.changeTab(2),
// //               child: _buildNavItem(Icons.timeline, context.tr.events,
// //                   app.currentIndex == 2, context),
// //             ),
// //             GestureDetector(
// //               onTap: () => app.changeTab(3),
// //               child: _buildNavItem(Icons.settings, context.tr.settings,
// //                   app.currentIndex == 3, context),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildNavItem(
// //       IconData icon, String label, bool isActive, BuildContext context) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(icon,
// //             color: isActive ? Theme.of(context).primaryColor : Colors.grey,
// //             size: 26),
// //         const SizedBox(height: 4),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 11,
// //             color: isActive ? Theme.of(context).primaryColor : Colors.grey,
// //             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
// //           ),
// //         )
// //       ],
// //     );
// //   }
// // }

// // /// ==================== HOME SCREEN ====================
// // class HomeScreen extends StatelessWidget {
// //   HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final app = Provider.of<AppState>(context);
// //     final nearby = app.allRestaurants.take(5).toList();

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F5F7),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             _header(context),
// //             Expanded(
// //               child: ListView(
// //                 padding: const EdgeInsets.all(16),
// //                 children: [
// //                   _searchBar(context),
// //                   const SizedBox(height: 20),
// //                   _sectionTitle('Nearby Restaurants', context),
// //                   const SizedBox(height: 12),
// //                   SizedBox(
// //                     height: 150,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       itemCount: nearby.length,
// //                       itemBuilder: (context, i) =>
// //                           _nearbyCard(context, nearby[i]),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),
// //                   _sectionTitle('Popular Categories', context),
// //                   const SizedBox(height: 12),
// //                   _categoriesRow(context),
// //                   const SizedBox(height: 24),
// //                   _sectionTitle('Offers', context),
// //                   const SizedBox(height: 12),
// //                   _offersCard(),
// //                   const SizedBox(height: 20),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _header(BuildContext context) {
// //     return Container(
// //       height: 200,
// //       child: Stack(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.fromLTRB(20, 30, 20, 54),
// //             decoration: const BoxDecoration(color: Color(0xFFE71D36)),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Row(children: [
// //                   Image.asset('assets/img/white-logo.png',
// //                       width: 60, height: 60),
// //                   const SizedBox(width: 8),
// //                   const Text('Balloon',
// //                       style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 40,
// //                           fontWeight: FontWeight.w900)),
// //                 ]),
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.2),
// //                       shape: BoxShape.circle),
// //                   child: const Icon(Icons.notifications,
// //                       color: Colors.white, size: 22),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 18),
// //           Positioned(
// //             bottom: 0,
// //             top: 90,
// //             left: 0,
// //             right: 0,
// //             child: GestureDetector(
// //               onTap: () => Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                       builder: (_) => const QrScannerScreen())),
// //               child: Container(
// //                 margin: const EdgeInsets.symmetric(horizontal: 16),
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(18),
// //                   boxShadow: [
// //                     BoxShadow(
// //                         color: Colors.black.withOpacity(0.1),
// //                         blurRadius: 20,
// //                         offset: const Offset(0, 8)),
// //                   ],
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.all(15),
// //                       decoration: BoxDecoration(
// //                           color: const Color(0xFFE71D36),
// //                           borderRadius: BorderRadius.circular(12)),
// //                       child: const Icon(Icons.qr_code_scanner,
// //                           color: Color.fromARGB(255, 253, 252, 252),
// //                           size: 30),
// //                     ),
// //                     const SizedBox(width: 14),
// //                     const Expanded(
// //                       child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text('Scan QR Code',
// //                                 style: TextStyle(
// //                                     fontSize: 18,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Color(0xFFE71D36))),
// //                             Text('Scan to view menu & order instantly',
// //                                 style: TextStyle(
// //                                     fontSize: 14, color: Colors.grey)),
// //                           ]),
// //                     ),
// //                     const Icon(Icons.arrow_forward_ios,
// //                         size: 14, color: Colors.grey),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _searchBar(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         final app = Provider.of<AppState>(context, listen: false);
// //         app.changeTab(1);
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //                 color: Colors.black.withOpacity(0.04),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 4)),
// //           ],
// //         ),
// //         child: Row(children: [
// //           Icon(Icons.search, color: Colors.grey.shade400),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Text('Search restaurants by name...',
// //                 style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }

// //   Widget _sectionTitle(String title, BuildContext context) {
// //     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// //       Text(title,
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
// //       Text('See all',
// //           style: TextStyle(
// //               color: Theme.of(context).colorScheme.error,
// //               fontWeight: FontWeight.w600,
// //               fontSize: 13)),
// //     ]);
// //   }

// //   Widget _nearbyCard(BuildContext context, Result r, {bool featured = false}) {
// //     return GestureDetector(
// //       child: Container(
// //         width: 150,
// //         margin: const EdgeInsets.only(right: 14),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //                 color: Colors.black.withOpacity(0.05),
// //                 blurRadius: 12,
// //                 offset: const Offset(0, 5)),
// //           ],
// //         ),
// //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Stack(children: [
// //             ClipRRect(
// //               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //               child: Image.network(
// //                 'http://192.168.1.115:8000 /${r.banner}',
// //                 height: 90,
// //                 width: double.infinity,
// //                 fit: BoxFit.cover,
// //                 errorBuilder: (_, __, ___) => Container(
// //                     height: 90,
// //                     color: Colors.grey.shade200,
// //                     child:
// //                         const Icon(Icons.restaurant, color: Colors.grey)),
// //               ),
// //             ),
// //             Positioned(
// //                 top: 8,
// //                 right: 8,
// //                 child: _ratingChipSimple((r.rating ?? 0).toDouble())),
// //           ]),
// //           Padding(
// //             padding: const EdgeInsets.all(10),
// //             child:
// //                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //               Text(r.name ?? '',
// //                   style: const TextStyle(
// //                       fontWeight: FontWeight.bold, fontSize: 13),
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis),
// //               const SizedBox(height: 2),
// //               Text(r.place ?? '',
// //                   style:
// //                       TextStyle(color: Colors.grey.shade500, fontSize: 11),
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis),
// //             ]),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }

// //   Widget _ratingChipSimple(double rating) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //           color: const Color(0xFFE71D36),
// //           borderRadius: BorderRadius.circular(12)),
// //       child: Row(mainAxisSize: MainAxisSize.min, children: [
// //         const Icon(Icons.star, color: Colors.white, size: 12),
// //         const SizedBox(width: 2),
// //         Text('${rating.toStringAsFixed(1)}',
// //             style: const TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 11,
// //                 fontWeight: FontWeight.bold)),
// //       ]),
// //     );
// //   }

// //   Widget _categoriesRow(BuildContext context) {
// //     final cats = [
// //       ('Pizza', Icons.local_pizza, const Color(0xFFFF6B6B)),
// //       ('Burger', Icons.lunch_dining, const Color(0xFFFFA94D)),
// //       ('Rice', Icons.rice_bowl, const Color(0xFF51CF66)),
// //       ('Chicken', Icons.local_dining, const Color(0xFFFCC419)),
// //       ('Dessert', Icons.cake, const Color(0xFFE71D36)),
// //       ('Drinks', Icons.local_cafe, const Color(0xFF339AF0)),
// //     ];
// //     return SizedBox(
// //       height: 90,
// //       child: ListView.builder(
// //         scrollDirection: Axis.horizontal,
// //         itemCount: cats.length,
// //         itemBuilder: (context, i) => Column(children: [
// //           Container(
// //               width: 56,
// //               height: 56,
// //               decoration: BoxDecoration(
// //                   color: cats[i].$3.withOpacity(0.15), shape: BoxShape.circle),
// //               child: Icon(cats[i].$2, color: cats[i].$3, size: 26)),
// //           const SizedBox(height: 6),
// //           Text(cats[i].$1,
// //               style:
// //                   const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
// //         ]).padding(r: 16),
// //       ),
// //     );
// //   }

// //   Widget _offersCard() {
// //     return Container(
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //             colors: [Color(0xFFE71D36), Color(0xFFa3152a)]),
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //       child: Row(children: [
// //         const Expanded(
// //             child:
// //                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Text('50% OFF',
// //               style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.w900)),
// //           SizedBox(height: 4),
// //           Text('On your first order!',
// //               style: TextStyle(color: Colors.white70, fontSize: 13)),
// //           SizedBox(height: 10),
// //           Text('Use code: BALLOON50',
// //               style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.bold)),
// //         ])),
// //         Container(
// //             width: 70,
// //             height: 70,
// //             decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.2),
// //                 borderRadius: BorderRadius.circular(16)),
// //             child: const Icon(Icons.local_offer,
// //                 color: Colors.white, size: 34)),
// //       ]),
// //     );
// //   }
// // }

// // /// ==================== RESTAURANT SCREEN ====================
// // class RestaurantScreen extends StatefulWidget {
// //   final Result restaurant;

// //   const RestaurantScreen({
// //     super.key,
// //     required this.restaurant,
// //   });

// //   @override
// //   State<RestaurantScreen> createState() => _RestaurantScreenState();
// // }

// // class _RestaurantScreenState extends State<RestaurantScreen> {
// //   String _selectedCategory = 'All';
// //   String _selectedTab = 'menu'; // 'menu' or 'events'

// //   Future<void> _openDirections(BuildContext context) async {
// //     final r = widget.restaurant;

// //     String destination;

// //     if (r.latitude != null && r.longitude != null) {
// //       destination = '${r.latitude},${r.longitude}';
// //     } else if (r.place != null && r.place!.isNotEmpty) {
// //       destination = r.place!;
// //     } else {
// //       destination = r.name ?? '';
// //     }

// //     final mapsAppUri = Uri.parse(
// //       'google.navigation:q=${Uri.encodeComponent(destination)}',
// //     );

// //     final webUri = Uri.parse(
// //       'https://www.google.com/maps/dir/?api=1'
// //       '&destination=${Uri.encodeComponent(destination)}',
// //     );

// //     try {
// //       if (await canLaunchUrl(mapsAppUri)) {
// //         await launchUrl(mapsAppUri, mode: LaunchMode.externalApplication);
// //         return;
// //       }
// //       if (await canLaunchUrl(webUri)) {
// //         await launchUrl(webUri, mode: LaunchMode.externalApplication);
// //         return;
// //       }
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Could not open Google Maps')),
// //         );
// //       }
// //     } catch (e) {
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Could not open Google Maps')),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final restaurant = widget.restaurant;

// //     return DefaultTabController(
// //       length: 3,
// //       child: Scaffold(
// //         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //         body: CustomScrollView(slivers: [
// //           SliverAppBar(
// //             expandedHeight: 220,
// //             pinned: true,
// //             backgroundColor: Theme.of(context).primaryColor,
// //             leading: IconButton(
// //               icon: Icon(Icons.arrow_back,
// //                   color: Theme.of(context).textTheme.titleMedium?.color),
// //               onPressed: () => Navigator.pop(context),
// //             ),
// //             flexibleSpace: FlexibleSpaceBar(
// //               background: Stack(fit: StackFit.expand, children: [
// //                 Image.network(
// //                   restaurant.banner!.isNotEmpty ? '${restaurant.banner}' : 'no ',
// //                   fit: BoxFit.cover,
// //                   errorBuilder: (_, __, ___) =>
// //                       Container(color: const Color(0xFFE71D36)),
// //                 ),
// //                 Container(color: Colors.black.withOpacity(0.3)),
// //               ]),
// //             ),
// //           ),
// //           SliverToBoxAdapter(
// //             child: Container(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Container(
// //                         width: 60,
// //                         height: 60,
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(30),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black.withOpacity(0.1),
// //                               blurRadius: 10,
// //                             ),
// //                           ],
// //                         ),
// //                         child: CircleAvatar(
// //                           backgroundImage: (restaurant.picture != null &&
// //                                   restaurant.picture!.isNotEmpty)
// //                               ? NetworkImage(restaurant.picture!)
// //                               : null,
// //                           child: (restaurant.picture == null ||
// //                                   restaurant.picture!.isEmpty)
// //                               ? Icon(
// //                                   Icons.restaurant,
// //                                   size: 30,
// //                                   color: Theme.of(context)
// //                                       .textTheme
// //                                       .titleMedium
// //                                       ?.color,
// //                                 )
// //                               : null,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 14),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               restaurant.name ?? context.tr.noName,
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                               style: const TextStyle(
// //                                 fontSize: 20,
// //                                 fontWeight: FontWeight.w800,
// //                               ),
// //                             ),
// //                             Text(
// //                               (restaurant.place != null &&
// //                                       restaurant.place!.isNotEmpty)
// //                                   ? ' · ${restaurant.place!}'
// //                                   : context.tr.noLocation,
// //                               maxLines: 2,
// //                               overflow: TextOverflow.ellipsis,
// //                               style: TextStyle(
// //                                 color: Colors.grey.shade600,
// //                                 fontSize: 13,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       _ratingChip(restaurant.rating ?? 0.0, context),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 12),
// //                   Row(
// //                     children: [
// //                       _statusChip(
// //                         restaurant.isOpen == true
// //                             ? context.tr.open
// //                             : context.tr.closed,
// //                         restaurant.isOpen == true
// //                             ? const Color(0xFF2ecc71)
// //                             : const Color(0xFFe74c3c),
// //                       ),
// //                       const SizedBox(width: 8),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 12),
// //                   Text(
// //                     restaurant.bio ?? context.tr.noDescription,
// //                     style: TextStyle(
// //                       color: Colors.grey.shade600,
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: OutlinedButton.icon(
// //                       onPressed: () => _openDirections(context),
// //                       icon: Icon(
// //                         Icons.directions,
// //                         color: Theme.of(context).primaryColor,
// //                       ),
// //                       label: Text(
// //                         context.tr.getDirections,
// //                         style: TextStyle(
// //                           color: Theme.of(context).primaryColor,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       style: OutlinedButton.styleFrom(
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                         side: BorderSide(
// //                           color: Theme.of(context).primaryColor,
// //                         ),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(14),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   ReviewWidget(profileId: restaurant.id!),
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // ✅ MENU / EVENTS SWITCHER
// //           SliverPadding(
// //             padding: const EdgeInsets.symmetric(horizontal: 10),
// //             sliver: SliverToBoxAdapter(child: _contentSwitcher(context)),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }

// //   // ================================================================
// //   //  CONTENT SWITCHER — Menu / Events
// //   // ================================================================
// //   Widget _contentSwitcher(BuildContext context) {
// //     final restaurant = widget.restaurant;

// //     final bool hasFoods =
// //         restaurant.foods != null && restaurant.foods!.isNotEmpty;
// //     final bool hasEvents =
// //         restaurant.organizer != null && restaurant.organizer!.isNotEmpty;

// //     // Neither → placeholder
// //     if (!hasFoods && !hasEvents) {
// //       return Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 30),
// //         child: Center(
// //           child: Text(
// //             context.tr.noMenuAvailable,
// //             style: const TextStyle(fontSize: 15, color: Colors.grey),
// //           ),
// //         ),
// //       );
// //     }

// //     // Only foods
// //     if (hasFoods && !hasEvents) {
// //       return _menuSection(context);
// //     }

// //     // Only events
// //     if (!hasFoods && hasEvents) {
// //       return _eventsSection(context);
// //     }

// //     // Both → show switcher
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(4),
// //           decoration: BoxDecoration(
// //             color: Theme.of(context).cardColor,
// //             borderRadius: BorderRadius.circular(14),
// //             border: Border.all(color: Colors.grey.shade300),
// //           ),
// //           child: Row(
// //             children: [
// //               _switchButton(
// //                 context,
// //                 label: context.tr.menu,
// //                 icon: Icons.restaurant_menu,
// //                 value: 'menu',
// //               ),
// //               _switchButton(
// //                 context,
// //                 label: 'Events',
// //                 icon: Icons.event,
// //                 value: 'events',
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         if (_selectedTab == 'menu')
// //           _menuSection(context)
// //         else
// //           _eventsSection(context),
// //       ],
// //     );
// //   }

// //   Widget _switchButton(
// //     BuildContext context, {
// //     required String label,
// //     required IconData icon,
// //     required String value,
// //   }) {
// //     final bool isActive = _selectedTab == value;
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: () => setState(() => _selectedTab = value),
// //         child: AnimatedContainer(
// //           duration: const Duration(milliseconds: 200),
// //           padding: const EdgeInsets.symmetric(vertical: 12),
// //           decoration: BoxDecoration(
// //             color:
// //                 isActive ? Theme.of(context).primaryColor : Colors.transparent,
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(
// //                 icon,
// //                 size: 18,
// //                 color: isActive ? Colors.white : Colors.grey.shade700,
// //               ),
// //               const SizedBox(width: 6),
// //               Text(
// //                 label,
// //                 style: TextStyle(
// //                   color: isActive ? Colors.white : Colors.grey.shade700,
// //                   fontWeight: FontWeight.w700,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ================================================================
// //   //  EVENTS SECTION
// //   // ================================================================
// //   Widget _eventsSection(BuildContext context) {
// //     final events = widget.restaurant.organizer ?? [];

// //     if (events.isEmpty) {
// //       return Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 30),
// //         child: Center(
// //           child: Text(
// //             'No events available',
// //             style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
// //           ),
// //         ),
// //       );
// //     }

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text(
// //           'Upcoming Events',
// //           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
// //         ),
// //         const SizedBox(height: 12),
// //         ...events.map((e) => _eventCard(context, e)).toList(),
// //       ],
// //     );
// //   }

// //   Widget _eventCard(BuildContext context, EventOrganizer event) {
// //     final String? imageUrl = widget.restaurant.banner;

// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 14),
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).cardColor,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           if (imageUrl != null && imageUrl.isNotEmpty)
// //             ClipRRect(
// //               borderRadius:
// //                   const BorderRadius.vertical(top: Radius.circular(16)),
// //               child: Image.network(
// //                 imageUrl,
// //                 height: 130,
// //                 width: double.infinity,
// //                 fit: BoxFit.cover,
// //                 errorBuilder: (_, __, ___) => Container(
// //                   height: 130,
// //                   color: Colors.grey.shade200,
// //                   child:
// //                       const Icon(Icons.event, size: 40, color: Colors.grey),
// //                 ),
// //               ),
// //             ),
// //           Padding(
// //             padding: const EdgeInsets.all(14),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   event.title ?? 'Untitled Event',
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis,
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w800,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 6),
// //                 if (event.startTime != null)
// //                   Row(
// //                     children: [
// //                       Icon(Icons.calendar_today,
// //                           size: 13, color: Colors.blue.shade700),
// //                       const SizedBox(width: 5),
// //                       Text(
// //                         _formatEventDate(event.startTime!, event.endTime),
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.blue.shade700,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 const SizedBox(height: 4),
// //                 if (event.venueDetails?.name != null)
// //                   Row(
// //                     children: [
// //                       Icon(Icons.location_on,
// //                           size: 14, color: Theme.of(context).primaryColor),
// //                       const SizedBox(width: 4),
// //                       Expanded(
// //                         child: Text(
// //                           event.venueDetails!.name!,
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             color: Colors.grey.shade700,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 10, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         color: event.isFull == true
// //                             ? Colors.red.withOpacity(0.12)
// //                             : Colors.green.withOpacity(0.12),
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: Text(
// //                         event.isFull == true ? 'Full' : 'Open',
// //                         style: TextStyle(
// //                           fontSize: 11,
// //                           fontWeight: FontWeight.bold,
// //                           color: event.isFull == true
// //                               ? Colors.red
// //                               : Colors.green.shade700,
// //                         ),
// //                       ),
// //                     ),
// //                     TextButton.icon(
// //                       onPressed: () {
// //                         // TODO: navigate to EventDetailScreen(event)
// //                       },
// //                       icon: const Icon(Icons.arrow_forward, size: 16),
// //                       label: const Text('Details'),
// //                       style: TextButton.styleFrom(
// //                         foregroundColor: Theme.of(context).primaryColor,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   String _formatEventDate(DateTime start, DateTime? end) {
// //     const months = [
// //       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
// //       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
// //     ];
// //     final s = '${months[start.month - 1]} ${start.day}, ${start.year}';
// //     if (end != null) {
// //       final e = '${months[end.month - 1]} ${end.day}';
// //       return '$s – $e';
// //     }
// //     return s;
// //   }

// //   // ================================================================
// //   //  MENU SECTION
// //   // ================================================================
// //   Widget _menuSection(BuildContext context) {
// //     final restaurant = widget.restaurant;
// //     final List<Food>? foods = restaurant.foods;

// //     if (foods == null || foods.isEmpty) {
// //       return Center(
// //         child: Text(
// //           context.tr.noMenuAvailable,
// //           style: const TextStyle(fontSize: 16),
// //         ),
// //       );
// //     }

// //     final List<String> categories = [
// //       'All',
// //       ...foods
// //           .map((f) => f.category?.name)
// //           .where((name) => name != null && name.isNotEmpty)
// //           .cast<String>()
// //           .toSet()
// //           .toList(),
// //     ];

// //     final selectedCategory = _selectedCategory;

// //     final List<Food> filteredFoods = selectedCategory == 'All'
// //         ? foods
// //         : foods.where((f) => f.category?.name == selectedCategory).toList();

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           context.tr.menu,
// //           style: const TextStyle(
// //             fontSize: 17,
// //             fontWeight: FontWeight.w800,
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         SizedBox(
// //           height: 40,
// //           child: ListView.builder(
// //             scrollDirection: Axis.horizontal,
// //             itemCount: categories.length,
// //             itemBuilder: (context, i) {
// //               final category = categories[i];
// //               final isSelected = category == selectedCategory;

// //               return GestureDetector(
// //                 onTap: () {
// //                   setState(() {
// //                     _selectedCategory = category;
// //                   });
// //                 },
// //                 child: Container(
// //                   margin: const EdgeInsets.only(right: 10),
// //                   padding: const EdgeInsets.symmetric(
// //                       horizontal: 18, vertical: 8),
// //                   decoration: BoxDecoration(
// //                     color: isSelected
// //                         ? Theme.of(context).primaryColor
// //                         : Theme.of(context).cardColor,
// //                     borderRadius: BorderRadius.circular(10),
// //                     border: Border.all(
// //                       color: isSelected ? Colors.transparent : Colors.grey,
// //                     ),
// //                   ),
// //                   child: Center(
// //                     child: Text(
// //                       category,
// //                       style: TextStyle(
// //                         color: isSelected
// //                             ? Theme.of(context).colorScheme.onPrimary
// //                             : Colors.grey.shade700,
// //                         fontWeight: FontWeight.w600,
// //                         fontSize: 13,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //         const SizedBox(height: 9),
// //         Column(
// //           children: filteredFoods
// //               .map(
// //                 (f) => FoodCard(
// //                   food: f,
// //                   onTap: () => Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (_) => FoodDetailScreen(food: f),
// //                     ),
// //                   ),
// //                   onAdd: () => Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (_) => FoodDetailScreen(food: f),
// //                     ),
// //                   ),
// //                 ).padding(b: 12),
// //               )
// //               .toList(),
// //         ),
// //       ],
// //     );
// //   }

// //   List<FoodItemModel> _fallbackFoods() {
// //     return [
// //       FoodItemModel(
// //           id: 1,
// //           name: 'Beef Burger',
// //           description: 'Juicy beef patty with cheese & veggies',
// //           price: 8000,
// //           image:
// //               'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop',
// //           rating: 4.5,
// //           category: 'Burger'),
// //       FoodItemModel(
// //           id: 2,
// //           name: 'Chicken Pizza',
// //           description: 'Grilled chicken, cheese & special sauce',
// //           price: 12000,
// //           image:
// //               'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=400&fit=crop',
// //           rating: 4.7,
// //           category: 'Pizza'),
// //       FoodItemModel(
// //           id: 3,
// //           name: 'French Fries',
// //           description: 'Crispy golden fries',
// //           price: 4000,
// //           image:
// //               'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400&h=400&fit=crop',
// //           rating: 4.0,
// //           category: 'Burger'),
// //       FoodItemModel(
// //           id: 4,
// //           name: 'Grilled Chicken',
// //           description: 'Well grilled with spices',
// //           price: 10000,
// //           image:
// //               'https://images.unsplash.com/photo-1594041680534-e8c8cdebd659?w=400&h=400&fit=crop',
// //           rating: 4.3,
// //           category: 'Chicken'),
// //       FoodItemModel(
// //           id: 5,
// //           name: 'Fresh Juice',
// //           description: 'Natural & healthy',
// //           price: 3000,
// //           image:
// //               'https://images.unsplash.com/photo-1622597467836-f3824f29db43?w=400&h=400&fit=crop',
// //           rating: 4.1,
// //           category: 'Drinks'),
// //     ];
// //   }

// //   Widget _statusChip(String label, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //       decoration: BoxDecoration(
// //           color: color.withOpacity(0.12),
// //           borderRadius: BorderRadius.circular(12)),
// //       child: Text(label,
// //           style: TextStyle(
// //               color: color, fontSize: 12, fontWeight: FontWeight.bold)),
// //     );
// //   }
// // }

// // Widget _ratingChip(double rating, BuildContext context) {
// //   return Container(
// //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //     decoration: BoxDecoration(
// //         color: Theme.of(context).primaryColor,
// //         borderRadius: BorderRadius.circular(12)),
// //     child: Row(mainAxisSize: MainAxisSize.min, children: [
// //       const Icon(Icons.star, color: Colors.white, size: 12),
// //       const SizedBox(width: 2),
// //       Text(rating.toStringAsFixed(1),
// //           style: const TextStyle(
// //               color: Colors.white,
// //               fontSize: 11,
// //               fontWeight: FontWeight.bold)),
// //     ]),
// //   );
// // }

// // /// ==================== FOOD DETAIL ====================
// // class FoodDetailScreen extends StatefulWidget {
// //   final Food food;
// //   const FoodDetailScreen({super.key, required this.food});
// //   @override
// //   State<FoodDetailScreen> createState() => _FoodDetailScreenState();
// // }

// // class _FoodDetailScreenState extends State<FoodDetailScreen> {
// //   int _quantity = 1;
// //   String? _selectedVariant;
// //   final List<String> _selectedExtras = [];

// //   @override
// //   Widget build(BuildContext context) {
// //     final app = Provider.of<AppState>(context);
// //     final food = widget.food;
// //     bool hasDiscount = food.discountPrice != null &&
// //         food.price != null &&
// //         food.discountPrice! < food.price!;

// //     return Scaffold(
// //       body: CustomScrollView(slivers: [
// //         SliverAppBar(
// //           expandedHeight: 260,
// //           pinned: true,
// //           backgroundColor: Theme.of(context).primaryColor,
// //           leading: IconButton(
// //               icon: const Icon(Icons.arrow_back, color: Colors.white),
// //               onPressed: () => Navigator.pop(context)),
// //           actions: [
// //             IconButton(
// //               icon: Icon(
// //                   app.isFoodFavorite(food)
// //                       ? Icons.favorite
// //                       : Icons.favorite_border,
// //                   color: Colors.white),
// //               onPressed: () => app.toggleFoodFavorite(food),
// //             ),
// //           ],
// //           flexibleSpace: FlexibleSpaceBar(
// //               background: Stack(fit: StackFit.expand, children: [
// //             Image.network(food.image ?? '',
// //                 fit: BoxFit.cover,
// //                 errorBuilder: (_, __, ___) =>
// //                     Container(color: Theme.of(context).primaryColor)),
// //           ])),
// //         ),
// //         SliverToBoxAdapter(
// //           child: Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Expanded(
// //                             child: Text(food.name ?? '',
// //                                 style: const TextStyle(
// //                                     fontSize: 24,
// //                                     fontWeight: FontWeight.w800))),
// //                       ]),
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text('TZS ${(food.discountPrice ?? food.price)!}',
// //                           style: TextStyle(
// //                               fontSize: 22,
// //                               fontWeight: FontWeight.w800,
// //                               color: Theme.of(context).primaryColor)),
// //                       if (hasDiscount)
// //                         Text(
// //                           '${food.currency ?? '\$'} ${food.price!.toStringAsFixed(2)}',
// //                           style: const TextStyle(
// //                             color: Colors.grey,
// //                             fontSize: 17,
// //                             decoration: TextDecoration.lineThrough,
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //                   const Text('Description',
// //                       style: TextStyle(
// //                           fontSize: 16, fontWeight: FontWeight.w700)),
// //                   const SizedBox(height: 6),
// //                   Text(food.description ?? '',
// //                       style: const TextStyle(fontSize: 14)),
// //                   const SizedBox(height: 20),
// //                 ]),
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

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

//     final url = Uri.parse('http://192.168.1.115:8000 /prof/api-prof/');

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
//                 'http://192.168.1.115:8000 /${r.banner}',
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
//   //  EVENTS SECTION — Opera-style timetable
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

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
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
//       ],
//     );
//   }

//   Widget _eventCard(BuildContext context, EventOrganizer event) {
//     final primaryColor = Theme.of(context).primaryColor;

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
//         // TODO: navigate to EventDetailScreen(event)
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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

//             // Chevron
//             Padding(
//               padding: const EdgeInsets.only(top: 14),
//               child: Icon(
//                 Icons.chevron_right,
//                 color: primaryColor,
//                 size: 24,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
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