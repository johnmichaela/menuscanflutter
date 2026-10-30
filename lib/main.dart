
import 'dart:async';

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
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Mobile Ads SDK
  unawaited(MobileAds.instance.initialize());
  AppServiceLocator.initAppServiceLocator();
  runApp(const QoperaApp());
}

class QoperaApp extends StatelessWidget {
  const QoperaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInState()),
        ChangeNotifierProvider(create: (_) => AppStateType()),
        ChangeNotifierProvider(create: (_) => LanguageController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      // Builder is required so we can read the providers we just created
    //   MediaQuery(
    //   data: MediaQuery.of(context).copyWith(
    //     textScaler: TextScaler.noScaling, // Force all text not to scale with system
    //   ),
    //   child: child!,
    // );
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
             builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.noScaling, // force all text not to scale with system
                  ),
                  child: child!,
                );
              },
            home:  SplashScreen(),
          );
        },
      ),
    );
  }
}

