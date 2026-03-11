import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';

const String _keyEntries = 'mydatelog_entries';

/// 日记本地存储（SharedPreferences + JSON）
class DiaryStorage {
  static Future<List<DiaryEntry>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyEntries);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>?;
      return list?.map((e) => DiaryEntry.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveAll(List<DiaryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final list = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_keyEntries, jsonEncode(list));
  }

  static Future<void> saveEntry(DiaryEntry entry) async {
    final list = await loadAll();
    final i = list.indexWhere((e) => e.date == entry.date);
    if (i >= 0) {
      list[i] = entry;
    } else {
      list.add(entry);
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    await saveAll(list);
  }

  static Future<void> deleteByDate(String date) async {
    final list = await loadAll();
    list.removeWhere((e) => e.date == date);
    await saveAll(list);
  }
}
