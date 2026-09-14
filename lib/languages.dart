// lib/languages.dart
import 'package:flutter/material.dart';

class AppLanguage {
  final String code;
  final String nativeName;
  final String englishName;
  final String flag;
  final bool isRtl;

  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.flag,
    this.isRtl = false,
  });

  Locale get locale => Locale(code);
}

const List<AppLanguage> kSupportedLanguages = [
  AppLanguage(
    code: 'en',
    nativeName: 'English',
    englishName: 'English',
    flag: '🇬🇧',
  ),
  AppLanguage(
    code: 'es',
    nativeName: 'Español',
    englishName: 'Spanish',
    flag: '🇪🇸',
  ),
  AppLanguage(
    code: 'fr',
    nativeName: 'Français',
    englishName: 'French',
    flag: '🇫🇷',
  ),
  AppLanguage(
    code: 'ar',
    nativeName: 'العربية',
    englishName: 'Arabic',
    flag: '🇸🇦',
    isRtl: true,
  ),
   AppLanguage(
    code: 'ko',
    nativeName: '한국어',
    englishName: 'Korean',
    flag: '🇰🇷',
  ),
  AppLanguage(
    code: 'ja',
    nativeName: '日本語',
    englishName: 'Japanese',
    flag: '🇯🇵',
  ),
  AppLanguage(
    code: 'zh',
    nativeName: '中文',
    englishName: 'Chinese',
    flag: '🇨🇳',
  ),
];