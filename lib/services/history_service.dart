import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_entry.dart';

class HistoryService {
  static const _key = 'scan_history_v1';

  static Future<List<HistoryEntry>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = json.decode(raw) as List<dynamic>;
    return list.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> add(HistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getAll();
    list.insert(0, entry); // prepend newest
    final raw = json.encode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
} 