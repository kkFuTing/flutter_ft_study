import '../config/event_categories.dart';

/// 从日记文本中解析出每段时间记录
class TimeBlock {
  final String startTime; // HH:MM
  final String endTime;   // HH:MM
  final int minutes;      // 耗时（分钟）
  final String event;     // 事件描述

  const TimeBlock({
    required this.startTime,
    required this.endTime,
    required this.minutes,
    required this.event,
  });
}

class TimeParser {
  // 匹配格式：HH:MM-HH:MM XhYm 事件描述
  static final _lineReg = RegExp(
    r'(\d{1,2}:\d{2})-(\d{1,2}:\d{2})\s+(\d+h)?(\d+m)?\s*(.*)',
  );

  static List<TimeBlock> parse(String text) {
    final blocks = <TimeBlock>[];
    for (final line in text.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final match = _lineReg.firstMatch(trimmed);
      if (match == null) continue;

      final start = match.group(1)!;
      final end = match.group(2)!;
      final hStr = match.group(3); // e.g. "2h" or null
      final mStr = match.group(4); // e.g. "30m" or null
      final event = (match.group(5) ?? '').trim();

      int minutes = 0;
      if (hStr != null) {
        minutes += int.tryParse(hStr.replaceAll('h', '')) ?? 0;
        minutes *= 60;
      }
      if (mStr != null) {
        minutes += int.tryParse(mStr.replaceAll('m', '')) ?? 0;
      }

      // 如果没解析到时长，自己算
      if (minutes == 0) {
        minutes = _calcMinutes(start, end);
      }

      if (minutes > 0 && event.isNotEmpty) {
        blocks.add(TimeBlock(
          startTime: start,
          endTime: end,
          minutes: minutes,
          event: event,
        ));
      }
    }
    return blocks;
  }

  static int _calcMinutes(String start, String end) {
    final s = _toMinutes(start);
    final e = _toMinutes(end);
    if (s == null || e == null) return 0;
    var diff = e - s;
    if (diff < 0) diff += 24 * 60; // 跨午夜
    return diff;
  }

  static int? _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  /// 按事件关键词归类到大类
  static Map<String, int> groupByCategory(List<TimeBlock> blocks) {
    final map = <String, int>{};
    for (final b in blocks) {
      final cat = _categorize(b.event);
      map[cat] = (map[cat] ?? 0) + b.minutes;
    }
    // 按时长降序排列
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted);
  }

  static String _categorize(String event) {
    return categorizeEvent(event);
  }

  static String formatMinutes(int m) {
    if (m < 60) return '${m}m';
    final h = m ~/ 60;
    final r = m % 60;
    if (r == 0) return '${h}h';
    return '${h}h${r}m';
  }
}
