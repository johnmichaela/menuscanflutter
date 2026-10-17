// import 'package:ballon/core/services/services_locator.dart';
// import 'package:ballon/language_controller.dart';
// import 'package:ballon/theme_controller.dart';
// import 'package:ballon/typeapp_state.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'app_state.dart';
// import 'screens.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'services/notification_service.dart';
// import 'l10n/app_localizations.dart'; // genera

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize Firebase
//   // await Firebase.initializeApp();
  
//   // Initialize Notification Service
//   // await NotificationService.initialize();
//   AppServiceLocator.initAppServiceLocator();
//   runApp( QoperaApp());
// }

// class BalloonApp extends StatelessWidget {
//    BalloonApp({super.key});
//    ThemeMode _themeMode = ThemeMode.system; 
//   @override
//   Widget build(BuildContext context) {
//     return  MultiProvider(
//   providers: [
//     ChangeNotifierProvider(
//       create: (_) => AppState(),
//     ),
//     ChangeNotifierProvider(
//       create: (_) => AppStateType(),
//     ),
//     ChangeNotifierProvider(create: (_) => LanguageController()),
//     ChangeNotifierProvider(create: (context) => ThemeController())
//   ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
  
//       themeMode: _themeMode,
//       // Light Theme
//       // theme: ThemeData(
//       //   useMaterial3: true,
//       //   brightness: Brightness.light,
//       //   scaffoldBackgroundColor: const Color.fromARGB(255, 233, 236, 236),
//       //   primaryColor: const Color(0xFF0163dc),
//       //   cardColor: Colors.white,
//       //   textTheme: const TextTheme(
//       //     bodyMedium: TextStyle(color: Color.fromARGB(255, 29, 29, 29)),
//       //     titleMedium: TextStyle(color: Color.fromARGB(255, 26, 25, 25)),
//       //   ),
//       //   colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1ee8fd)),
//       // ),
//   //     // Dark Theme
//   //     darkTheme: ThemeData(
//   //       useMaterial3: true,
//   //       brightness: Brightness.dark,
//   //       scaffoldBackgroundColor: const Color(0xFF0b141a),
//   //       primaryColor: const Color(0xFF0163dc),
//   //       cardColor: const Color(0xFF1c1c1c),
//   //       textTheme: const TextTheme(
//   //         bodyMedium: TextStyle(color: Colors.white),
//   //         titleMedium: TextStyle(color: Colors.white),
//   //       ),
//   //       colorScheme: ColorScheme.fromSeed(
//   //         seedColor: const Color(0xFF1ee8fd),
//   //         brightness: Brightness.dark,
//   //       ),
//   //     ),
//        theme: ThemeData(
//          fontFamily: 'Poppins',              // your custom font
//   fontFamilyFallback: const [
//     'Noto Sans KR',                   // Korean
//     'Noto Sans JP',                   // Japanese
//     'Noto Sans SC',                   // Simplified Chinese
//     'Noto Sans',                      // Generic fallback
//   ],
//     useMaterial3: true,
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: const Color(0xFFF5F7FA),
//     primaryColor: const Color(0xFF2563EB),
//     primaryColorLight: const Color(0xFF3B82F6),
//     primaryColorDark: const Color(0xFF1D4ED8),
//     cardColor: Colors.white,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.white,
//       foregroundColor: Color(0xFF1E293B),
//       elevation: 0,
//     ),
//     textTheme: const TextTheme(
//       bodyMedium: TextStyle(color: Color(0xFF1E293B)),
//       titleMedium: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
//       headlineSmall: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700),
//     ),
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: const Color(0xFF2563EB),
//       brightness: Brightness.light,
//     ),
//   ),
  
//   // Dark Theme
//   darkTheme: ThemeData(
//      fontFamily: 'Poppins',              // your custom font
//   fontFamilyFallback: const [
//     'Noto Sans KR',                   // Korean
//     'Noto Sans JP',                   // Japanese
//     'Noto Sans SC',                   // Simplified Chinese
//     'Noto Sans',                      // Generic fallback
//   ],
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: const Color(0xFF0F172A),
//     primaryColor: const Color(0xFF3B82F6),
//     primaryColorLight: const Color(0xFF60A5FA),
//     primaryColorDark: const Color(0xFF2563EB),
//     cardColor: const Color(0xFF1E293B),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF0F172A),
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     textTheme: const TextTheme(
//       bodyMedium: TextStyle(color: Color(0xFFE2E8F0)),
//       titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//       headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//     ),
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: const Color(0xFF2563EB),
//       brightness: Brightness.dark,
//     ),
//   ),
//     locale: lang.locale,
//       // supportedLocales: const [
//       //   Locale('en'),
//       //   Locale('es'),
//       //   Locale('fr'),
//       //   Locale('ar'),
//       // ],
//       supportedLocales: const [
//         Locale('en'),
//         Locale('es'),
//         Locale('fr'),
//         Locale('ar'),
//         Locale('ko'),   // Korean
//         Locale('ja'),   // Japanese (optional)
//         Locale('zh'),   // Chinese (optional)
//       ],
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }
import 'package:ballon/core/services/services_locator.dart';
import 'package:ballon/language_controller.dart';
import 'package:ballon/theme_controller.dart';
import 'package:ballon/typeapp_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/sub/screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppServiceLocator.initAppServiceLocator();
  runApp(const QoperaApp());
}

class QoperaApp extends StatelessWidget {
  const QoperaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AppStateType()),
        ChangeNotifierProvider(create: (_) => LanguageController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      // Builder is required so we can read the providers we just created
      child: Builder(
        builder: (context) {
          final lang = context.watch<LanguageController>();
          final themeCtrl = context.watch<ThemeController>();

          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // Theme mode driven by controller
            themeMode: themeCtrl.mode,

            // ---------- Light Theme ----------
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              fontFamily: 'NotoSans',
              fontFamilyFallback: const [
                'NotoSansKR',
                'NotoSansJP',
                'NotoSansSC',
              ],
              scaffoldBackgroundColor: const Color(0xFFF5F7FA),
              // primaryColor: const Color.fromARGB(255, 212, 14, 14),
              primaryColor: const Color(0xFF0383fc),
              cardColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2563EB),
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF1E293B),
                elevation: 0,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFF1E293B)),
                titleMedium: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
                headlineSmall: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ---------- Dark Theme ----------
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              fontFamily: 'NotoSans',
              fontFamilyFallback: const [
                'NotoSansKR',
                'NotoSansJP',
                'NotoSansSC',
              ],
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              // primaryColor:  const Color.fromARGB(255, 212, 14, 14),
              primaryColor: const Color(0xFF0383fc),
              cardColor: const Color(0xFF1E293B),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2563EB),
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0F172A),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFFE2E8F0)),
                titleMedium: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                headlineSmall: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ---------- Localization ----------
            locale: lang.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
              Locale('ar'),
              Locale('ko'),
              Locale('ja'),
              Locale('zh'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:async';

// void main() {
//   runApp(const QoperaApp());
// }

// class QoperaApp extends StatelessWidget {
//   const QoperaApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Qopera UI',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF0052CC),
//         scaffoldBackgroundColor: Colors.white,
//         fontFamily: 'Roboto', // Default Flutter font, similar to the image
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
// // 1. Add the PageController and Timer variables
//   final PageController _promoPageController = PageController();
//   Timer? _promoTimer;
//   int _currentPromoPage = 0;

//   // 2. Setup the timer when the widget initializes
//   @override
//   void initState() {
//     super.initState();
//     _startPromoTimer();
//   }

//   void _startPromoTimer() {
//     _promoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
//       if (_promoPageController.hasClients) {
//         // If it's the last page, go back to the first page
//         if (_currentPromoPage == 2) { // Assuming 3 banners (0, 1, 2)
//           _promoPageController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           // Otherwise, go to the next page
//           _promoPageController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//       }
//     });
//   }

//   // 3. Clean up the timer when the widget is disposed
//   @override
//   void dispose() {
//     _promoTimer?.cancel();
//     _promoPageController.dispose();
//     super.dispose();
//   }

//   // ... rest of your build method

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               _buildPromoBanner(),
//                const SizedBox(height: 10),
//               _buildIndicators(), // 
//               const SizedBox(height: 20),
//               _buildSearchBar(),
//               const SizedBox(height: 24),
//               _buildSectionHeader(),
//               const SizedBox(height: 16),
//               _buildBusinessGrid(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavBar(),
//     );
//   }

//   // --- Widget Builders ---

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       titleSpacing: 16,
//       title: Row(
//         children: [
//           // Custom Logo
//           Container(
//             width: 36,
//             height: 36,
//             decoration: const BoxDecoration(
//               color: Color(0xFF0052CC),
//               shape: BoxShape.circle,
//             ),
//             child: const Center(
//               child: Icon(Icons.qr_code_2, color: Colors.white, size: 24),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Qopera',
//                 style: TextStyle(
//                   color: Color(0xFF001F5B),
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Scan • Discover • Access',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search, color: Color(0xFF001F5B)),
//           onPressed: () {},
//         ),
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.notifications_outlined, color: Color(0xFF001F5B)),
//               onPressed: () {},
//             ),
//             Positioned(
//               top: 10,
//               right: 10,
//               child: Container(
//                 width: 8,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 16.0, left: 4),
//           child: CircleAvatar(
//             radius: 16,
//             backgroundColor: const Color(0xFF0052CC),
//             child: const Icon(Icons.person, color: Colors.white, size: 20),
//           ),
//         ),
//       ],
//     );
//   }

//   // Data for the banners (You can add your own images/text here)
//   final List<Map<String, String>> _promoData = [
//     {
//       'title1': 'Scan Anything.',
//       'title2': 'Discover More.',
//       'desc': 'From restaurants to bookstores,\neverything you need is just a scan away.',
//       'img': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?q=80&w=800&auto=format&fit=crop',
//     },
//     {
//       'title1': 'Shop Smart.',
//       'title2': 'Save Time.',
//       'desc': 'Find your favorite products\nand order them instantly.',
//       'img': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=800&auto=format&fit=crop',
//     },
//     {
//       'title1': 'Explore More.',
//       'title2': 'Every Day.',
//       'desc': 'Discover new places and services\nright at your fingertips.',
//       'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=800&auto=format&fit=crop',
//     },
//   ];

//   Widget _buildPromoBanner() {
//     return SizedBox(
//       height: 180,
//       child: PageView.builder(
//         controller: _promoPageController,
//         itemCount: _promoData.length,
//         onPageChanged: (index) {
//           setState(() {
//             _currentPromoPage = index;
//           });
//         },
//         itemBuilder: (context, index) {
//           final promo = _promoData[index];
//           return Container(
//             width: double.infinity,
//             margin: const EdgeInsets.symmetric(horizontal: 4), // Small margin between pages
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               image: DecorationImage(
//                 image: NetworkImage(promo['img']!),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF003399).withOpacity(0.9),
//                     Colors.transparent,
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     promo['title1']!,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       height: 1.1,
//                     ),
//                   ),
//                   Text(
//                     promo['title2']!,
//                     style: const TextStyle(
//                       color: Color(0xFF4DD0E1),
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       height: 1.1,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     promo['desc']!,
//                     style: const TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
                  
                
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Helper for the pagination dots (rebuilt dynamically based on the selected page)
//   Widget _buildIndicators() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center, // Center the dots
//       children: List.generate(_promoData.length, (index) {
//         return _buildIndicator(index == _currentPromoPage);
//       }),
//     );
//   }
//   Widget _buildIndicator(bool isActive) {
//   return Container(
//     width: isActive ? 16 : 6,
//     height: 6,
//     decoration: BoxDecoration(
//       color: isActive ? const Color(0xFF4DD0E1) : Colors.white54,
//       borderRadius: BorderRadius.circular(3),
//     ),
//   );
// }
//   Widget _buildPromoBannerxx() {
//     return Container(
//       width: double.infinity,
//       height: 180,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: const DecorationImage(
//           image: NetworkImage('https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?q=80&w=800&auto=format&fit=crop'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             colors: [const Color(0xFF003399).withOpacity(0.9), Colors.transparent],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Scan Anything.',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 height: 1.1,
//               ),
//             ),
//             const Text(
//               'Discover More.',
//               style: TextStyle(
//                 color: Color(0xFF4DD0E1),
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 height: 1.1,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'From restaurants to bookstores,\neverything you need is just a scan away.',
//               style: TextStyle(color: Colors.white70, fontSize: 12),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               children: [
//                 _buildIndicatorxx(true),
//                 const SizedBox(width: 4),
//                 _buildIndicatorxx(false),
//                 const SizedBox(width: 4),
//                 _buildIndicatorxx(false),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIndicatorxx(bool isActive) {
//     return Container(
//       width: isActive ? 16 : 6,
//       height: 6,
//       decoration: BoxDecoration(
//         color: isActive ? const Color(0xFF4DD0E1) : Colors.white54,
//         borderRadius: BorderRadius.circular(3),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'Search businesses, products or services...',
//           hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
//           prefixIcon: const Icon(Icons.search, color: Colors.grey),
//           suffixIcon: const Icon(Icons.tune, color: Color(0xFF0052CC)),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 15),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Our Businesses',
//           style: TextStyle(
//             color: Color(0xFF001F5B),
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         TextButton(
//           onPressed: () {},
//           child: const Row(
//             children: [
//               Text('View All', style: TextStyle(color: Color(0xFF0052CC), fontSize: 14)),
//               Icon(Icons.chevron_right, color: Color(0xFF0052CC), size: 18),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBusinessGrid() {
//     // Data list to generate the cards easily
//     final List<Map<String, dynamic>> businesses = [
//       {
//         'title': 'Restaurants & Cafés',
//         'count': '523+ businesses',
//         'icon': Icons.restaurant,
//         'color': const Color(0xFFFF9800),
//         'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=60'
//       },
//       {
//         'title': 'Shops & Supermarkets',
//         'count': '812+ businesses',
//         'icon': Icons.shopping_cart,
//         'color': const Color(0xFF4CAF50),
//         'img': 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&auto=format&fit=crop&q=60'
//       },
//       {
//         'title': 'Books & Stationery',
//         'count': '340+ businesses',
//         'icon': Icons.menu_book,
//         'color': const Color(0xFF9C27B0),
//         'img': 'https://images.unsplash.com/photo-1524578271613-d550eacf6090?w=500&auto=format&fit=crop&q=60'
//       },
//       {
//         'title': 'Electronics & Gadgets',
//         'count': '276+ businesses',
//         'icon': Icons.devices,
//         'color': const Color(0xFF2196F3),
//         'img': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=500&auto=format&fit=crop&q=60'
//       },
//       {
//         'title': 'Health & Pharmacy',
//         'count': '198+ businesses',
//         'icon': Icons.local_hospital,
//         'color': const Color(0xFFF44336),
//         'img': 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=500&auto=format&fit=crop&q=60'
//       },
//       {
//         'title': 'Beauty & Personal Care',
//         'count': '256+ businesses',
//         'icon': Icons.spa,
//         'color': const Color(0xFFE91E63),
//         'img': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500&auto=format&fit=crop&q=60'
//       },
//       {
//         'title': 'Education & Training',
//         'count': '165+ businesses',
//         'icon': Icons.school,
//         'color': const Color(0xFF00BCD4),
//         'img': 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=500&auto=format&fit=crop&q=60'
//       },
//       {
//         'title': 'Services & More',
//         'count': '420+ businesses',
//         'icon': Icons.build,
//         'color': const Color(0xFF3F51B5),
//         'img': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=500&auto=format&fit=crop&q=60'
//       },
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: businesses.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.85, // Adjusts height vs width ratio
//       ),
//       itemBuilder: (context, index) {
//         return _buildBusinessCard(
//           title: businesses[index]['title'],
//           count: businesses[index]['count'],
//           icon: businesses[index]['icon'],
//           iconColor: businesses[index]['color'],
//           imageUrl: businesses[index]['img'],
//         );
//       },
//     );
//   }

//   Widget _buildBusinessCard({
//     required String title,
//     required String count,
//     required IconData icon,
//     required Color iconColor,
//     required String imageUrl,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => const RestaurantsCafesScreen(),
//   ),
// );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Section
//             Expanded(
//               flex: 5,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   imageUrl,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
//                 ),
//               ),
//             ),
//             // Details Section
//             Expanded(
//               flex: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: iconColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(icon, color: Colors.white, size: 16),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             title,
//                             style: const TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF001F5B),
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             count,
//                             style: TextStyle(
//                               fontSize: 9,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Icon(Icons.chevron_right, size: 16, color: Color(0xFF001F5B)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return BottomNavigationBar(
//       currentIndex: _currentIndex,
//       onTap: (index) {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: const Color(0xFF0052CC),
//       unselectedItemColor: Colors.grey,
//       selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//       unselectedLabelStyle: const TextStyle(fontSize: 12),
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           activeIcon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.qr_code_scanner),
//           label: 'Scan',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.chat_bubble_outline),
//           label: 'Chat',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.bookmark_border),
//           label: 'Saved',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }
// // ---------------------------------------------------------------------------
// // 1. DATA MODEL CLASS
// // ---------------------------------------------------------------------------
// class Business {
//   final String name;
//   final double rating;
//   final int reviewCount;
//   final String location;
//   final String imageUrl;
//   final IconData logoIcon;
//   final Color logoBackgroundColor;
//   final bool isOpen;

//   Business({
//     required this.name,
//     required this.rating,
//     required this.reviewCount,
//     required this.location,
//     required this.imageUrl,
//     required this.logoIcon,
//     required this.logoBackgroundColor,
//     this.isOpen = true,
//   });
// }

// // ---------------------------------------------------------------------------
// // 2. MAIN SCREEN
// // ---------------------------------------------------------------------------
// class RestaurantsCafesScreen extends StatefulWidget {
//   const RestaurantsCafesScreen({super.key});

//   @override
//   State<RestaurantsCafesScreen> createState() => _RestaurantsCafesScreenState();
// }

// class _RestaurantsCafesScreenState extends State<RestaurantsCafesScreen> {
//   // Dummy data based on the image
//   final List<Business> businesses = [
//     Business(
//       name: 'The Grill House',
//       rating: 4.5,
//       reviewCount: 124,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.local_fire_department,
//       logoBackgroundColor: const Color(0xFF2C2C2C),
//     ),
//     Business(
//       name: 'Urban Café',
//       rating: 4.6,
//       reviewCount: 98,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.coffee,
//       logoBackgroundColor: const Color(0xFF6D4C41),
//     ),
//     Business(
//       name: 'Pizza Corner',
//       rating: 4.4,
//       reviewCount: 87,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.local_pizza,
//       logoBackgroundColor: const Color(0xFFE53935),
//     ),
//     Business(
//       name: 'Burger Zone',
//       rating: 4.3,
//       reviewCount: 72,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.lunch_dining,
//       logoBackgroundColor: const Color(0xFF212121),
//     ),
//     Business(
//       name: 'Fresh Bites',
//       rating: 4.7,
//       reviewCount: 65,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1622597467836-f3824f1c1f2b?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.eco,
//       logoBackgroundColor: const Color(0xFF43A047),
//     ),
//     Business(
//       name: 'Golden Bakery',
//       rating: 4.2,
//       reviewCount: 53,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.bakery_dining,
//       logoBackgroundColor: const Color(0xFF8D6E63),
//     ),
//     Business(
//       name: 'Ocean Delight',
//       rating: 4.6,
//       reviewCount: 91,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.set_meal,
//       logoBackgroundColor: const Color(0xFF1976D2),
//     ),
//     Business(
//       name: 'The Lounge Café',
//       rating: 4.4,
//       reviewCount: 68,
//       location: 'Dar es Salaam',
//       imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop&q=60',
//       logoIcon: Icons.local_cafe,
//       logoBackgroundColor: const Color(0xFF8E24AA),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FB),
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildSearchBar(),
//                   const SizedBox(height: 16),
//                   _buildFilterChips(),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 0.72, // Adjusts the height of the cards
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   return _buildBusinessCard(businesses[index]);
//                 },
//                 childCount: businesses.length,
//               ),
//             ),
//           ),
//           const SliverToBoxAdapter(child: SizedBox(height: 20)),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavBar(),
//     );
//   }

//   // --- Widget Builders ---

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 220.0,
//       floating: false,
//       pinned: true,
//       backgroundColor: const Color(0xFF0D47A1), // Dark blue
//       leading: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: CircleAvatar(
//           backgroundColor: Colors.white.withOpacity(0.2),
//           child: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Background Image
//             Image.network(
//               'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=60',
//               fit: BoxFit.cover,
//             ),
//             // Blue Gradient Overlay
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF0D47A1).withOpacity(0.95),
//                     const Color(0xFF0D47A1).withOpacity(0.6),
//                     Colors.transparent,
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//               ),
//             ),
//             // Header Content
//             Positioned(
//               left: 20,
//               top: 80,
//               right: 20,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF1E88E5),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.restaurant, color: Colors.white, size: 32),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Restaurants & Cafés',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           'Delicious food, great vibes,\njust around you.',
//                           style: TextStyle(color: Colors.white70, fontSize: 13),
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1E88E5),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.storefront, color: Colors.white, size: 16),
//                               SizedBox(width: 6),
//                               Text(
//                                 '523+ businesses',
//                                 style: TextStyle(color: Colors.white, fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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

//   Widget _buildSearchBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: const TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search restaurants, cafés or food places...',
//                 hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(vertical: 15),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Container(
//           height: 50,
//           width: 50,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: const Icon(Icons.tune, color: Color(0xFF1E88E5)),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterChips() {
//     final List<String> filters = ['All', 'Restaurants', 'Cafés', 'Fast Food', 'Bars', 'Bakeries'];
//     int selectedIndex = 0; // 'All' is selected by default

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(filters.length, (index) {
//           bool isSelected = index == selectedIndex;
//           return Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF1E88E5) : const Color(0xFFF0F2F5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 filters[index],
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : const Color(0xFF333333),
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildBusinessCard(Business business) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image Section
//           Expanded(
//             flex: 5,
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                   child: Image.network(
//                     business.imageUrl,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
//                   ),
//                 ),
//                 if (business.isOpen)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
//                           SizedBox(width: 4),
//                           Text(
//                             'Open',
//                             style: TextStyle(
//                               color: Color(0xFF2E7D32),
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           // Details Section
//           Expanded(
//             flex: 6,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Logo Icon
//                       Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: business.logoBackgroundColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(business.logoIcon, color: Colors.white, size: 15),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                               business.name,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF001F5B),
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),]),
//                       // Text Information
                      
//                             const SizedBox(height: 4),

//                             Row(
//                               children: [
//                                 const Icon(Icons.star, color: Color(0xFFFFB300), size: 14),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   '${business.rating} (${business.reviewCount} reviews)',
//                                   style: TextStyle(fontSize: 10, color: Colors.grey[700]),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(Icons.location_on, color: Color(0xFF1E88E5), size: 14),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   business.location,
//                                   style: TextStyle(fontSize: 10, color: Colors.grey[700]),
//                                 ),
//                               ],
//                             ),
                        
                      
//                       // Arrow Icon
//                       const Align(
//                         alignment: Alignment.centerRight,
//                         child: Icon(Icons.chevron_right, color: Color(0xFF001F5B), size: 20),
//                       ),
                  
//                 ]   
//             ),)),
//         ]),
//           );
       
//   }

//   Widget _buildBottomNavBar() {
//     return BottomNavigationBar(
//       currentIndex: 1, // "Businesses" selected
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: const Color(0xFF1E88E5),
//       unselectedItemColor: Colors.grey,
//       selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
//       unselectedLabelStyle: const TextStyle(fontSize: 11),
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.grid_view),
//           activeIcon: Icon(Icons.grid_view_rounded),
//           label: 'Businesses',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.qr_code_scanner),
//           label: 'Scan',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.chat_bubble_outline),
//           label: 'Chat',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.bookmark_border),
//           label: 'Saved',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }