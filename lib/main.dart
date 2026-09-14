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
//   runApp( BalloonApp());
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
import 'screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppServiceLocator.initAppServiceLocator();
  runApp(const BalloonApp());
}

class BalloonApp extends StatelessWidget {
  const BalloonApp({super.key});

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
              primaryColor: const Color(0xFF2563EB),
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
              primaryColor: const Color(0xFF3B82F6),
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