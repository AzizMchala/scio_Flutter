import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_entry.dart';

class FavoritesService {
  static const _key = 'favorites_v1';

  static Future<List<FavoriteEntry>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = json.decode(raw) as List<dynamic>;
    return list.map((e) => FavoriteEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> add(FavoriteEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getAll();
    // avoid duplicates by barcode
    if (list.any((e) => e.barcode == entry.barcode)) return;
    list.insert(0, entry);
    final raw = json.encode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  static Future<void> removeByBarcode(String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getAll();
    final updated = list.where((e) => e.barcode != barcode).toList();
    final raw = json.encode(updated.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<bool> isFavorite(String barcode) async {
    final list = await getAll();
    return list.any((e) => e.barcode == barcode);
  }
} 