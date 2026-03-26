import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 每日必完成目标的本地勾选状态存储（按日期隔离）
class DailyGoalsStorage {
  static String _keyForDate(String date) => 'mydatelog_goal_done_$date';

  static Future<Map<String, bool>> loadForDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyForDate(date));
    if (raw == null || raw.isEmpty) return <String, bool>{};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v == true));
    } catch (_) {
      return <String, bool>{};
    }
  }

  static Future<void> saveForDate(
    String date,
    Map<String, bool> doneByGoalId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final map = doneByGoalId.map((k, v) => MapEntry(k, v));
    await prefs.setString(_keyForDate(date), jsonEncode(map));
  }

  /// 清空某日全部每日必完成勾选（与「清空今日日志」联动）
  static Future<void> clearForDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyForDate(date));
  }
}

