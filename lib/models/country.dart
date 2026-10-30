import 'dart:convert';
import 'package:flutter/services.dart';

class Country {
  final String name;
  final String iso;
  final String dial;
  final String flag;

  const Country({
    required this.name,
    required this.iso,
    required this.dial,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> j) => Country(
        name: j['name'] as String,
        iso: j['iso'] as String,
        dial: j['dial'] as String,
        flag: j['flag'] as String,
      );

  static List<Country>? _cache;

  static Future<List<Country>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/countries.json');
    final list = (json.decode(raw) as List)
        .map((e) => Country.fromJson(e as Map<String, dynamic>))
        .toList();
    _cache = list;
    return list;
  }
}