// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Caller UI',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF000000),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.black,
//           elevation: 0,
//         ),
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// // --- Data Model ---
// class Contact {
//   final String name;
//   final Color avatarColor;
//   final String subtitle;
//   final IconData subtitleIcon;
//   final bool isVerified;
//   final bool isRead;
//   final double distance; // Mock distance in km
//   final double reviewScore; // Mock review score out of 5

//   Contact({
//     required this.name,
//     required this.avatarColor,
//     required this.subtitle,
//     required this.subtitleIcon,
//     this.isVerified = false,
//     this.isRead = true,
//     this.distance = 0.0,
//     this.reviewScore = 0.0,
//   });
// }

// // --- Main Page ---
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // Mock Data
//   final List<Contact> _allContacts = [
//     Contact(
//       name: 'Debora Gr...',
//       avatarColor: const  const Color.fromARGB(255, 141, 6, 6),
//       subtitle: 'Mobile',
//       subtitleIcon: Icons.phone,
//       distance: 2.5,
//       reviewScore: 4.8,
//     ),
//     Contact(
//       name: 'Joy Mteja...',
//       avatarColor: const  const Color.fromARGB(255, 141, 6, 6),
//       subtitle: 'Mobile',
//       subtitleIcon: Icons.phone,
//       distance: 5.1,
//       reviewScore: 4.2,
//     ),
//     Contact(
//       name: 'Asumta',
//       avatarColor: const Color(0xFF2E7D32),
//       subtitle: 'WhatsApp',
//       subtitleIcon: Icons.message,
//       distance: 1.0,
//       reviewScore: 4.9,
//     ),
//     Contact(
//       name: 'Glory Aru...',
//       avatarColor: const Color(0xFF4527A0),
//       subtitle: 'Mobile',
//       subtitleIcon: Icons.phone,
//       distance: 8.4,
//       reviewScore: 3.5,
//     ),
//     Contact(
//       name: 'Mama Tina',
//       avatarColor: const Color(0xFF00695C),
//       subtitle: '1 Yesterday',
//       subtitleIcon: Icons.check,
//       distance: 0.5,
//       reviewScore: 5.0,
//     ),
//     Contact(
//       name: 'Ma Mkubwa',
//       avatarColor: const Color(0xFF00695C),
//       subtitle: '2 Yesterday',
//       subtitleIcon: Icons.check,
//       isVerified: true,
//       distance: 3.2,
//       reviewScore: 4.5,
//     ),
//   ];

//   // Filter State
//   String _selectedFilter = 'Default';
//   List<Contact> _displayedContacts = [];

//   @override
//   void initState() {
//     super.initState();
//     _displayedContacts = List.from(_allContacts);
//   }

//   void _applyFilter(String? newValue) {
//     if (newValue == null) return;
//     setState(() {
//       _selectedFilter = newValue;
//       _displayedContacts = List.from(_allContacts);
      
//       if (_selectedFilter == 'Distance') {
//         _displayedContacts.sort((a, b) => a.distance.compareTo(b.distance));
//       } else if (_selectedFilter == 'Review') {
//         _displayedContacts.sort((a, b) => b.reviewScore.compareTo(a.reviewScore));
//       } else {
//         _displayedContacts = List.from(_allContacts);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Custom Top Bar (Search)
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Container(
//                       height: 45,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF252525),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'Search numbers, names & more',
//                               style: TextStyle(color: Colors.grey, fontSize: 16),
//                             ),
//                           ),
//                           Icon(Icons.more_vert, color: Colors.white),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     height: 45,
//                     width: 45,
//                     decoration: BoxDecoration(
//                       color: const  const Color.fromARGB(255, 141, 6, 6),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.people_alt, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),

//             // Promotion Card
//             Container(
//               margin: const EdgeInsets.all(12.0),
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1C1C1E),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Now you can manage your\nTruecaller profile for your\nsecond SIM',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Want to set up a second SIM?',
//                           style: TextStyle(color: Colors.grey, fontSize: 13),
//                         ),
//                         SizedBox(height: 10),
//                         Row(
//                           children: [
//                             Text(
//                               'Add now',
//                               style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 20),
//                             Text(
//                               'Dismiss',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Sim card icon placeholder
//                   Container(
//                     width: 60,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.blueGrey.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(Icons.sim_card, color: Colors.blueAccent, size: 40),
//                   ),
//                 ],
//               ),
//             ),

//             // Favorites Row
//             SizedBox(
//               height: 100,
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _allContacts.length, // Use all contacts for the top row
//                 separatorBuilder: (ctx, i) => const SizedBox(width: 20),
//                 itemBuilder: (context, index) {
//                   final c = _allContacts[index];
//                   return Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 28,
//                         backgroundColor: c.avatarColor,
//                         child: Text(
//                           c.name[0],
//                           style: const TextStyle(fontSize: 24, color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         c.name.split(' ')[0],
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(c.subtitleIcon, size: 12, color: Colors.grey),
//                           const SizedBox(width: 2),
//                           Text(c.subtitle.split(' ')[0], style: const TextStyle(fontSize: 10, color: Colors.grey)),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),

//             // FILTER SECTION (Requested Feature)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Recent Calls',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   DropdownButton<String>(
//                     value: _selectedFilter,
//                     dropdownColor: const Color(0xFF1C1C1E),
//                     icon: const Icon(Icons.filter_list, color: Colors.white),
//                     underline: const SizedBox(),
//                     style: const TextStyle(color: Colors.white, fontSize: 14),
//                     items: const [
//                       DropdownMenuItem(value: 'Default', child: Text('Default')),
//                       DropdownMenuItem(value: 'Distance', child: Text('Filter by Distance')),
//                       DropdownMenuItem(value: 'Review', child: Text('Filter by Review')),
//                     ],
//                     onChanged: _applyFilter,
//                   ),
//                 ],
//               ),
//             ),

//             // Main List
//             Expanded(
//               child: ListView.separated(
//                 itemCount: _displayedContacts.length,
//                 separatorBuilder: (ctx, i) => const Divider(color: Colors.grey, height: 1, thickness: 0.5),
//                 itemBuilder: (context, index) {
//                   final c = _displayedContacts[index];
//                   return ListTile(
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     leading: CircleAvatar(
//                       radius: 28,
//                       backgroundColor: c.avatarColor,
//                       child: Text(
//                         c.name[0],
//                         style: const TextStyle(fontSize: 24, color: Colors.white),
//                       ),
//                     ),
//                     title: Row(
//                       children: [
//                         Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                         if (c.isVerified) ...[
//                           const SizedBox(width: 6),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Text('true', style: TextStyle(fontSize: 10, color: Colors.white)),
//                           ),
//                         ],
//                       ],
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             if (!c.isRead) const Icon(Icons.check, size: 14, color: Colors.green) else const Icon(Icons.done_all, size: 14, color: Colors.green),
//                             const SizedBox(width: 4),
//                             Text(c.subtitle, style: const TextStyle(color: Colors.grey)),
//                           ],
//                         ),
//                         // Displaying Mock Distance & Review data
//                         Row(
//                           children: [
//                             const Icon(Icons.place_outlined, size: 12, color: Colors.grey),
//                             const SizedBox(width: 2),
//                             Text('${c.distance} km', style: const TextStyle(color: Colors.grey, fontSize: 10)),
//                             const SizedBox(width: 10),
//                             const Icon(Icons.star_outline, size: 12, color: Colors.grey),
//                             const SizedBox(width: 2),
//                             Text('${c.reviewScore}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
//                           ],
//                         ),
//                       ],
//                     ),
//                     trailing: const Icon(Icons.call, color: Colors.grey),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: 0,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
//           BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
//           BottomNavigationBarItem(icon: Icon(Icons.warning_amber), label: 'Scams'),
//           BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Restaurant Finder',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF000000),
//         appBarTheme: const AppBarTheme(backgroundColor: Colors.black, elevation: 0),
//       ),
//       home: const RestaurantHomePage(),
//     );
//   }
// }

// // --- Data Model ---
// class Restaurant {
//   final String name;
//   final String imageUrl;
//   final double distance; // in km
//   final double reviewScore; // out of 5
//   final int reviewCount;

//   Restaurant({
//     required this.name,
//     required this.imageUrl,
//     required this.distance,
//     required this.reviewScore,
//     required this.reviewCount,
//   });
// }

// // --- Main Page ---
// class RestaurantHomePage extends StatefulWidget {
//   const RestaurantHomePage({super.key});

//   @override
//   State<RestaurantHomePage> createState() => _RestaurantHomePageState();
// }

// class _RestaurantHomePageState extends State<RestaurantHomePage> {
//   // Mock Data
//   final List<Restaurant> _allRestaurants = [
//     Restaurant(
//       name: 'Debora\'s Kitchen',
//       imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=400&fit=crop',
//       distance: 2.5,
//       reviewScore: 4.8,
//       reviewCount: 120,
//     ),
//     Restaurant(
//       name: 'Joy Mteja Bistro',
//       imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=400&fit=crop',
//       distance: 5.1,
//       reviewScore: 4.2,
//       reviewCount: 85,
//     ),
//     Restaurant(
//       name: 'Asumta Grill House',
//       imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&h=400&fit=crop',
//       distance: 1.0,
//       reviewScore: 4.9,
//       reviewCount: 210,
//     ),
//     Restaurant(
//       name: 'Glory Aru Cafe',
//       imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400&h=400&fit=crop',
//       distance: 8.4,
//       reviewScore: 3.5,
//       reviewCount: 45,
//     ),
//     Restaurant(
//       name: 'Mama Tina Pizza',
//       imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=400&fit=crop',
//       distance: 0.5,
//       reviewScore: 5.0,
//       reviewCount: 350,
//     ),
//     Restaurant(
//       name: 'Ma Mkubwa Sushi',
//       imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&h=400&fit=crop',
//       distance: 3.2,
//       reviewScore: 4.5,
//       reviewCount: 190,
//     ),
//   ];

//   // Filter State
//   String _selectedFilter = 'Default';
//   List<Restaurant> _displayedRestaurants = [];

//   @override
//   void initState() {
//     super.initState();
//     _displayedRestaurants = List.from(_allRestaurants);
//   }

//   void _applyFilter(String? newValue) {
//     if (newValue == null) return;
//     setState(() {
//       _selectedFilter = newValue;
//       _displayedRestaurants = List.from(_allRestaurants);

//       if (_selectedFilter == 'Distance') {
//         _displayedRestaurants.sort((a, b) => a.distance.compareTo(b.distance));
//       } else if (_selectedFilter == 'Review') {
//         _displayedRestaurants.sort((a, b) => b.reviewScore.compareTo(a.reviewScore));
//       } else {
//         _displayedRestaurants = List.from(_allRestaurants);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top Bar (Search)
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Container(
//                       height: 45,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF252525),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(Icons.search, color: Colors.grey),
//                           SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               'Search restaurants...',
//                               style: TextStyle(color: Colors.grey, fontSize: 16),
//                             ),
//                           ),
//                           Icon(Icons.more_vert, color: Colors.white),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     height: 45,
//                     width: 45,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 141, 6, 6), // Blue button
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.favorite_border, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),

//             // Offer Banner
//             Container(
//               margin: const EdgeInsets.all(12.0),
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1C1C1E),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Get 50% off on your first order!',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Use code: FOODIE50',
//                           style: TextStyle(color: Colors.grey, fontSize: 13),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Order now',
//                           style: TextStyle(color: Color.fromARGB(255, 199, 17, 17), fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(Icons.local_offer, color: Colors.orangeAccent, size: 50),
//                 ],
//               ),
//             ),

//             // Trending Row (Horizontal Restaurants)
//             SizedBox(
//               height: 110,
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _allRestaurants.length,
//                 separatorBuilder: (ctx, i) => const SizedBox(width: 15),
//                 itemBuilder: (context, index) {
//                   final r = _allRestaurants[index];
//                   return Column(
//                     children: [
//                       ClipOval(
//                         child: SizedBox(
//                           width: 60,
//                           height: 60,
//                           child: Image.network(r.imageUrl, fit: BoxFit.cover),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         r.name.split(' ')[0],
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(Icons.star, size: 12, color: Colors.amber),
//                           const SizedBox(width: 2),
//                           Text(r.reviewScore.toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),

//             // FILTER SECTION
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'All Restaurants',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   DropdownButton<String>(
//                     value: _selectedFilter,
//                     dropdownColor: const Color(0xFF1C1C1E),
//                     icon: const Icon(Icons.filter_list, color: Colors.white),
//                     underline: const SizedBox(),
//                     style: const TextStyle(color: Colors.white, fontSize: 14),
//                     items: const [
//                       DropdownMenuItem(value: 'Default', child: Text('Default Sort')),
//                       DropdownMenuItem(value: 'Distance', child: Text('Filter by Distance')),
//                       DropdownMenuItem(value: 'Review', child: Text('Filter by Review')),
//                     ],
//                     onChanged: _applyFilter,
//                   ),
//                 ],
//               ),
//             ),

//             // Main List
//             Expanded(
//               child: ListView.separated(
//                 itemCount: _displayedRestaurants.length,
//                 separatorBuilder: (ctx, i) => const Divider(color: Colors.grey, height: 1, thickness: 0.5),
//                 itemBuilder: (context, index) {
//                   final r = _displayedRestaurants[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                     child: Row(
//                       children: [
//                         // Restaurant Image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: SizedBox(
//                             width: 70,
//                             height: 70,
//                             child: Image.network(r.imageUrl, fit: BoxFit.cover),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         // Details
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 r.name,
//                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.place_outlined, size: 14, color: Colors.grey),
//                                   const SizedBox(width: 2),
//                                   Text('${r.distance} km away', style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.star, size: 14, color: Colors.amber),
//                                   const SizedBox(width: 2),
//                                   Text('${r.reviewScore}', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
//                                   const SizedBox(width: 4),
//                                   Text('(${r.reviewCount} reviews)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Action Button
//                         const Icon(Icons.favorite_border, color: Colors.grey),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: const Color.fromARGB(255, 167, 7, 7),
//         unselectedItemColor: Colors.grey,
//         currentIndex: 0,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'pagination/data/data_source/urls.dart';

// // --- MOCK SERVICES (Replace with your actual services) ---
// // class Urls {
// //   static const String baseUrl = "https://your-api.com/api/v1"; // Replace with your actual base URL
// // }

// class ServerException implements Exception {
//   final String message;
//   ServerException({required this.message});
//   @override
//   String toString() => message;
// }

// class Position {
//   final double latitude;
//   final double longitude;
//   Position(this.latitude, this.longitude);
// }

// class LocationService {
//   Future<Position> getCurrentLocation() async {
//     // Mock location (Dar es Salaam, Tanzania)
//     await Future.delayed(const Duration(seconds: 1)); 
//     return Position(-6.7924, 39.2083);
//   }
// }

// // --- MODELS (Pasted from your do.txt) ---
// double? _parseDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value);
//     return null;
// }
// Resturants resturantsFromJson(String str) => Resturants.fromJson(json.decode(str));
// String resturantsToJson(Resturants data) => json.encode(data.toJson());

// class Resturants {
//     final String? status;
//     final String? message;
//     final Data? data;

//     Resturants({this.status, this.message, this.data});

//     factory Resturants.fromJson(Map<String, dynamic> json) => Resturants(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data?.toJson(),
//     };
// }

// class Data {
//     final List<Result>? results;
//     final Pagination? pagination;
//     final Filters? filters;

//     Data({this.results, this.pagination, this.filters});

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
//         pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
//         filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
//         "pagination": pagination?.toJson(),
//         "filters": filters?.toJson(),
//     };
// }

// class Filters {
//     final dynamic search;
//     final double? minRating;
//     final int? minReviews;
//     final dynamic isOpen;
//     final String? sortBy;

//     Filters({this.search, this.minRating, this.minReviews, this.isOpen, this.sortBy});

//     factory Filters.fromJson(Map<String, dynamic> json) => Filters(
//         search: json["search"],
//         minRating: _parseDouble(json["min_rating"]),
//         minReviews: json["min_reviews"],
//         isOpen: json["is_open"],
//         sortBy: json["sort_by"],
//     );

//     Map<String, dynamic> toJson() => {
//         "search": search,
//         "min_rating": minRating,
//         "min_reviews": minReviews,
//         "is_open": isOpen,
//         "sort_by": sortBy,
//     };
// }

// class Pagination {
//     final int? currentPage;
//     final int? totalPages;
//     final int? totalCount;
//     final int? pageSize;
//     final bool? hasNext;
//     final bool? hasPrevious;

//     Pagination({this.currentPage, this.totalPages, this.totalCount, this.pageSize, this.hasNext, this.hasPrevious});

//     factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
//         currentPage: json["current_page"],
//         totalPages: json["total_pages"],
//         totalCount: json["total_count"],
//         pageSize: json["page_size"],
//         hasNext: json["has_next"],
//         hasPrevious: json["has_previous"],
//     );

//     Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "total_pages": totalPages,
//         "total_count": totalCount,
//         "page_size": pageSize,
//         "has_next": hasNext,
//         "has_previous": hasPrevious,
//     };
// }

// class Result {
//     final int? id;
//     final String? name;
//     final String? place;
//     final String? bio;
//     final String? picture;
//     final String? banner;
//     final List<Food>? foods;
//     final double? rating;
//     final int? reviews;
//     final bool? isOpen;
//     final dynamic distance;
//     final double? averageRating;
//     final int? totalReviews;
//     final String? slug;
//     final double? latitude;
//     final double? longitude;
//     final TypeBusiness? typeBusiness;

//     Result({
//         this.id, this.name, this.place, this.bio, this.picture, this.banner,
//         this.foods, this.rating, this.reviews, this.isOpen, this.distance,
//         this.averageRating, this.totalReviews, this.slug, this.latitude,
//         this.longitude, this.typeBusiness,
//     });

//     factory Result.fromJson(Map<String, dynamic> json) => Result(
//         id: json["id"],
//         name: json["name"],
//         place: json["place"],
//         bio: json["bio"],
//         picture: json["picture"],
//         banner: json["banner"],
//         foods: json["foods"] == null ? [] : List<Food>.from(json["foods"]!.map((x) => Food.fromJson(x))),
//         rating: _parseDouble(json["rating"]),
//         reviews: json["reviews"],
//         isOpen: json["is_open"],
//         distance: json["distance"],
//         averageRating: _parseDouble(json["average_rating"]),
//         totalReviews: json["total_reviews"],
//         slug: json["slug"],
//         latitude: _parseDouble(json["latitude"]),
//         longitude: _parseDouble(json["longitude"]),
//         typeBusiness: json["type_business"] == null ? null : TypeBusiness.fromJson(json["type_business"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id, "name": name, "place": place, "bio": bio, "picture": picture,
//         "banner": banner, "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
//         "rating": rating, "reviews": reviews, "is_open": isOpen, "distance": distance,
//         "average_rating": averageRating, "total_reviews": totalReviews, "slug": slug,
//         "latitude": latitude, "longitude": longitude, "type_business": typeBusiness?.toJson(),
//     };
// }

// class Food {
//     final int? id;
//     final String? name;
//     final String? description;
//     final String? image;
//     final double? price;
//     final String? currency;
//     final double? discountPrice;
//     final bool? isAvailable;
//     final bool? isVeg;
//     final double? rating;
//     final int? ratingCount;
//     final List<dynamic>? variants;
//     final List<dynamic>? extras;

//     Food({
//         this.id, this.name, this.description, this.image, this.price, this.currency,
//         this.discountPrice, this.isAvailable, this.isVeg, this.rating,
//         this.ratingCount, this.variants, this.extras,
//     });

//     factory Food.fromJson(Map<String, dynamic> json) => Food(
//         id: json["id"], name: json["name"], description: json["description"],
//         image: json["image"], price: _parseDouble(json["price"]),
//         currency: json["currency"], discountPrice: _parseDouble(json["discount_price"]),
//         isAvailable: json["is_available"], isVeg: json["is_veg"],
//         rating: _parseDouble(json["rating"]), ratingCount: json["rating_count"],
//         variants: json["variants"] == null ? [] : List<dynamic>.from(json["variants"]!.map((x) => x)),
//         extras: json["extras"] == null ? [] : List<dynamic>.from(json["extras"]!.map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id, "name": name, "description": description, "image": image,
//         "price": price, "currency": currency, "discount_price": discountPrice,
//         "is_available": isAvailable, "is_veg": isVeg, "rating": rating,
//         "rating_count": ratingCount, "variants": variants == null ? [] : List<dynamic>.from(variants!.map((x) => x)),
//         "extras": extras == null ? [] : List<dynamic>.from(extras!.map((x) => x)),
//     };
// }

// class TypeBusiness {
//     final int? id;
//     final String? name;
//     final String? description;
//     final String? color;
//     final String? textColor;
//     final String? icon;
//     final DateTime? timestamp;

//     TypeBusiness({this.id, this.name, this.description, this.color, this.textColor, this.icon, this.timestamp});

//     factory TypeBusiness.fromJson(Map<String, dynamic> json) => TypeBusiness(
//         id: json["id"], name: json["name"], description: json["description"],
//         color: json["color"], textColor: json["text_color"], icon: json["icon"],
//         timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id, "name": name, "description": description, "color": color,
//         "text_color": textColor, "icon": icon, "timestamp": timestamp?.toIso8601String(),
//     };
// }

// // --- API SERVICE ---
// class ApiService {
//   // Fetch by Distance
//   Future<List<Result>> fetchRestaurantsByDistance(int pageNumber) async {
//     try {
//       LocationService locationService = LocationService();
//       Position currentPosition = await locationService.getCurrentLocation();

//       String url = "${Urls.baseUrl}/prof/restaurants-high-rated/"
//           "?lat=${currentPosition.latitude}"
//           "&lon=${currentPosition.longitude}"
//           "&sort_by=distance"
//           "&page=$pageNumber";

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

//   // Fetch by Reviews
//   Future<List<Result>> fetchRestaurantsByReviews(int pageNumber) async {
//     try {
//       String url = "${Urls.baseUrl}/prof/restaurants-high-rated/"
//           "?sort_by=reviews"
//           "&page=$pageNumber";

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

// // --- UI ---
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF000000),
//       ),
//       home: const RestaurantHomePage(),
//     );
//   }
// }

// class RestaurantHomePage extends StatefulWidget {
//   const RestaurantHomePage({super.key});

//   @override
//   State<RestaurantHomePage> createState() => _RestaurantHomePageState();
// }

// class _RestaurantHomePageState extends State<RestaurantHomePage> {
//   final ApiService _apiService = ApiService();
  
//   List<Result> _restaurants = [];
//   bool _isLoading = true;
//   String? _errorMessage;
//   int _currentPage = 1;
//   String _currentSort = 'distance'; // Default sort
  
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _loadRestaurants();
//     _scrollController.addListener(_onScroll);
//   }

//   Future<void> _loadRestaurants() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       List<Result> fetchedData;
//       if (_currentSort == 'distance') {
//         fetchedData = await _apiService.fetchRestaurantsByDistance(_currentPage);
//       } else {
//         fetchedData = await _apiService.fetchRestaurantsByReviews(_currentPage);
//       }

//       setState(() {
//         if (_currentPage == 1) {
//           _restaurants = fetchedData;
//         } else {
//           _restaurants.addAll(fetchedData);
//         }
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   // Pull to Refresh
//   Future<void> _refresh() async {
//     _currentPage = 1;
//     await _loadRestaurants();
//   }

//   // Infinite Scroll
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
//         _restaurants = [];
//       });
//       _loadRestaurants();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Restaurants'),
//         actions: [
//           DropdownButton<String>(
//             value: _currentSort,
//             dropdownColor: const Color(0xFF1C1C1E),
//             icon: const Icon(Icons.filter_list, color: Colors.white),
//             underline: const SizedBox(),
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//             items: const [
//               DropdownMenuItem(value: 'distance', child: Text('By Distance')),
//               DropdownMenuItem(value: 'reviews', child: Text('By Reviews')),
//             ],
//             onChanged: _changeSort,
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: _isLoading && _restaurants.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null && _restaurants.isEmpty
//               ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
//               : RefreshIndicator(
//                   onRefresh: _refresh,
//                   color: Colors.blue,
//                   backgroundColor: Colors.black,
//                   child: ListView.separated(
//                     controller: _scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     itemCount: _restaurants.length + 1,
//                     separatorBuilder: (ctx, i) => const Divider(color: Colors.grey, height: 1, thickness: 0.5),
//                     itemBuilder: (context, index) {
//                       if (index >= _restaurants.length) {
//                         return _isLoading 
//                             ? const Padding(
//                                 padding: EdgeInsets.all(16.0),
//                                 child: Center(child: CircularProgressIndicator()),
//                               )
//                             : const SizedBox(height: 50);
//                       }

//                       final r = _restaurants[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: SizedBox(
//                                 width: 70,
//                                 height: 70,
//                                 child: r.picture != null
//                                     ? Image.network(r.picture!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey))
//                                     : Container(color: Colors.grey, child: const Icon(Icons.restaurant)),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     r.name ?? "Unknown",
//                                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.place_outlined, size: 14, color: Colors.grey),
//                                       const SizedBox(width: 2),
//                                       Text(r.distance != null ? '${r.distance} km away' : 'Unknown distance', style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.star, size: 14, color: Colors.amber),
//                                       const SizedBox(width: 2),
//                                       Text((r.rating ?? r.averageRating ?? 0).toStringAsFixed(1), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
//                                       const SizedBox(width: 4),
//                                       Text('(${r.reviews ?? r.totalReviews ?? 0} reviews)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                                     ],
//                                   ),
//                                   if (r.isOpen == false)
//                                     const Padding(
//                                       padding: EdgeInsets.only(top: 4),
//                                       child: Text('Closed', style: TextStyle(color: Colors.red, fontSize: 12)),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             const Icon(Icons.favorite_border, color: Colors.grey),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// --- MOCK SERVICES (Replace with your actual services) ---
// class Urls {
//   static const String baseUrl = "https://your-api.com/api/v1";
// }

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
  @override
  String toString() => message;
}

class Position {
  final double latitude;
  final double longitude;
  Position(this.latitude, this.longitude);
}

class LocationService {
  Future<Position> getCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    return Position(-6.7924, 39.2083);
  }
}

// --- MODELS (Pasted from your do.txt) ---
double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
}
Resturants resturantsFromJson(String str) => Resturants.fromJson(json.decode(str));
String resturantsToJson(Resturants data) => json.encode(data.toJson());

class Resturants {
    final String? status;
    final String? message;
    final Data? data;
    Resturants({this.status, this.message, this.data});
    factory Resturants.fromJson(Map<String, dynamic> json) => Resturants(
        status: json["status"], message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
    Map<String, dynamic> toJson() => {"status": status, "message": message, "data": data?.toJson()};
}

class Data {
    final List<Result>? results;
    final Pagination? pagination;
    final Filters? filters;
    Data({this.results, this.pagination, this.filters});
    factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
        filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
    );
    Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(), "filters": filters?.toJson(),
    };
}

class Filters {
    final dynamic search; final double? minRating; final int? minReviews; final dynamic isOpen; final String? sortBy;
    Filters({this.search, this.minRating, this.minReviews, this.isOpen, this.sortBy});
    factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        search: json["search"], minRating: _parseDouble(json["min_rating"]),
        minReviews: json["min_reviews"], isOpen: json["is_open"], sortBy: json["sort_by"],
    );
    Map<String, dynamic> toJson() => {
        "search": search, "min_rating": minRating, "min_reviews": minReviews,
        "is_open": isOpen, "sort_by": sortBy,
    };
}

class Pagination {
    final int? currentPage; final int? totalPages; final int? totalCount; final int? pageSize; final bool? hasNext; final bool? hasPrevious;
    Pagination({this.currentPage, this.totalPages, this.totalCount, this.pageSize, this.hasNext, this.hasPrevious});
    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"], totalPages: json["total_pages"], totalCount: json["total_count"],
        pageSize: json["page_size"], hasNext: json["has_next"], hasPrevious: json["has_previous"],
    );
    Map<String, dynamic> toJson() => {
        "current_page": currentPage, "total_pages": totalPages, "total_count": totalCount,
        "page_size": pageSize, "has_next": hasNext, "has_previous": hasPrevious,
    };
}

class Result {
    final int? id; final String? name; final String? place; final String? bio; final String? picture; final String? banner;
    final List<Food>? foods; final double? rating; final int? reviews; final bool? isOpen; final dynamic distance;
    final double? averageRating; final int? totalReviews; final String? slug; final double? latitude; final double? longitude;
    final TypeBusiness? typeBusiness;
    Result({this.id, this.name, this.place, this.bio, this.picture, this.banner, this.foods, this.rating, this.reviews,
        this.isOpen, this.distance, this.averageRating, this.totalReviews, this.slug, this.latitude, this.longitude, this.typeBusiness});
    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"], name: json["name"], place: json["place"], bio: json["bio"], picture: json["picture"],
        banner: json["banner"], foods: json["foods"] == null ? [] : List<Food>.from(json["foods"]!.map((x) => Food.fromJson(x))),
        rating: _parseDouble(json["rating"]), reviews: json["reviews"], isOpen: json["is_open"], distance: json["distance"],
        averageRating: _parseDouble(json["average_rating"]), totalReviews: json["total_reviews"], slug: json["slug"],
        latitude: _parseDouble(json["latitude"]), longitude: _parseDouble(json["longitude"]),
        typeBusiness: json["type_business"] == null ? null : TypeBusiness.fromJson(json["type_business"]),
    );
    Map<String, dynamic> toJson() => {
        "id": id, "name": name, "place": place, "bio": bio, "picture": picture, "banner": banner,
        "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
        "rating": rating, "reviews": reviews, "is_open": isOpen, "distance": distance, "average_rating": averageRating,
        "total_reviews": totalReviews, "slug": slug, "latitude": latitude, "longitude": longitude,
        "type_business": typeBusiness?.toJson(),
    };
}

class Food {
    final int? id; final String? name; final String? description; final String? image; final double? price; final String? currency;
    final double? discountPrice; final bool? isAvailable; final bool? isVeg; final double? rating; final int? ratingCount;
    final List<dynamic>? variants; final List<dynamic>? extras;
    Food({this.id, this.name, this.description, this.image, this.price, this.currency, this.discountPrice, this.isAvailable,
        this.isVeg, this.rating, this.ratingCount, this.variants, this.extras});
    factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"], name: json["name"], description: json["description"], image: json["image"],
        price: _parseDouble(json["price"]), currency: json["currency"], discountPrice: _parseDouble(json["discount_price"]),
        isAvailable: json["is_available"], isVeg: json["is_veg"], rating: _parseDouble(json["rating"]),
        ratingCount: json["rating_count"], variants: json["variants"] == null ? [] : List<dynamic>.from(json["variants"]!.map((x) => x)),
        extras: json["extras"] == null ? [] : List<dynamic>.from(json["extras"]!.map((x) => x)),
    );
    Map<String, dynamic> toJson() => {
        "id": id, "name": name, "description": description, "image": image, "price": price, "currency": currency,
        "discount_price": discountPrice, "is_available": isAvailable, "is_veg": isVeg, "rating": rating,
        "rating_count": ratingCount, "variants": variants == null ? [] : List<dynamic>.from(variants!.map((x) => x)),
        "extras": extras == null ? [] : List<dynamic>.from(extras!.map((x) => x)),
    };
}

class TypeBusiness {
    final int? id; final String? name; final String? description; final String? color; final String? textColor; final String? icon; final DateTime? timestamp;
    TypeBusiness({this.id, this.name, this.description, this.color, this.textColor, this.icon, this.timestamp});
    factory TypeBusiness.fromJson(Map<String, dynamic> json) => TypeBusiness(
        id: json["id"], name: json["name"], description: json["description"], color: json["color"],
        textColor: json["text_color"], icon: json["icon"], timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );
    Map<String, dynamic> toJson() => {
        "id": id, "name": name, "description": description, "color": color,
        "text_color": textColor, "icon": icon, "timestamp": timestamp?.toIso8601String(),
    };
}

// --- API SERVICE ---
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

// --- UI ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF000000)),
      home: const RestaurantHomePage(),
    );
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
  
  List<Result> _allRestaurants = []; // Keeps all API data
  List<Result> _displayedRestaurants = []; // Shows filtered list
  
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  String _currentSort = 'distance';
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterRestaurants);
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
        _filterRestaurants(); // Apply current search filter after loading
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
    }
  }

  // Filter logic based on search bar
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

  // Mock QR Scanner placeholder
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
                  // Search Input
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
                  // QR Scanner Button
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

            // --- FILTER DROPDOWN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                                      backgroundImage:r.picture != null ? NetworkImage(r.picture!) : null,
                                                      backgroundColor: r.picture == null ? Colors.grey : null,),
                                              ))
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                r.name ?? "Unknown",
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                                                  //  const SizedBox(width: 4),
                                                   
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