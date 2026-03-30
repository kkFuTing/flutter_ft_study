import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/daily_goals.dart';
import '../services/time_parser.dart';

/// 时间分析页：饼图 + 分类明细
class TimeAnalysisPage extends StatelessWidget {
  final String content;
  final String date;

  /// 每日必完成勾选状态（来自日记页当前内存；未传则仅按正文 `isSatisfied` 推断）
  final Map<String, bool>? goalDoneById;

  const TimeAnalysisPage({
    super.key,
    required this.content,
    required this.date,
    this.goalDoneById,
  });

  static bool _effectiveGoalDone(
    DailyGoalDef g,
    String diaryText,
    Map<String, bool>? goalDoneById,
  ) {
    if (g.isSatisfied(diaryText)) return true;
    return goalDoneById?[g.id] ?? false;
  }

  /// `date` 为 `YYYY-MM-DD` 时追加「周几」；解析失败则原样返回。
  static String _dateWithWeekday(String date) {
    final d = DateTime.tryParse(date);
    if (d == null) return date;
    const names = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return '$date（${names[d.weekday - 1]}）';
  }

  String _buildTextReport(
    Map<String, int> categoryMap,
    List<TimeBlock> blocks,
    int totalMinutes,
  ) {
    final buf = StringBuffer();
    buf.writeln('📊 ${_dateWithWeekday(date)} 时间分析');
    buf.writeln('总计 ${TimeParser.formatMinutes(totalMinutes)}（${blocks.length}段）');
    buf.writeln('');
    if (kDailyGoals.isNotEmpty) {
      buf.writeln('【每日必完成】');
      for (final g in kDailyGoals) {
        final done = _effectiveGoalDone(g, content, goalDoneById);
        buf.writeln('${done ? '✓' : '○'} ${g.label}');
      }
      buf.writeln('');
    }
    buf.writeln('【分类统计】');
    for (final entry in categoryMap.entries) {
      final percent = totalMinutes > 0
          ? (entry.value / totalMinutes * 100).toStringAsFixed(1)
          : '0';
      buf.writeln('${entry.key}：${TimeParser.formatMinutes(entry.value)}（$percent%）');
    }
    buf.writeln('');
    buf.writeln('【详细记录】');
    for (final b in blocks) {
      buf.writeln('${b.startTime}-${b.endTime} ${TimeParser.formatMinutes(b.minutes)} ${b.event}');
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final blocks = TimeParser.parse(content);
    final categoryMap = TimeParser.groupByCategory(blocks);
    final totalMinutes = categoryMap.values.fold<int>(0, (a, b) => a + b);
    final hasGoals = kDailyGoals.isNotEmpty;
    final hasTimeData = blocks.isNotEmpty;
    final canCopy = hasTimeData || hasGoals;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_dateWithWeekday(date)} 时间分析'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: '复制分析结果',
            onPressed: !canCopy
                ? null
                : () {
                    final text = _buildTextReport(categoryMap, blocks, totalMinutes);
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已复制分析结果')),
                    );
                  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!hasTimeData)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '没有解析到时间记录\n请确保格式为：HH:MM-HH:MM 时长 事件',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (hasTimeData) ...[
              Text(
                '总计记录 ${TimeParser.formatMinutes(totalMinutes)}（${blocks.length} 段）',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 240,
                child: CustomPaint(
                  painter: _PieChartPainter(
                    data: categoryMap,
                    total: totalMinutes,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...categoryMap.entries.map((entry) {
                final percent = totalMinutes > 0
                    ? (entry.value / totalMinutes * 100).toStringAsFixed(1)
                    : '0';
                final colorIndex = categoryMap.keys.toList().indexOf(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _pieColors[colorIndex % _pieColors.length],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        TimeParser.formatMinutes(entry.value),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '$percent%',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            if (hasGoals) ...[
              if (hasTimeData) const SizedBox(height: 8),
              Text(
                '每日必完成',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              ...kDailyGoals.map((g) {
                final done = _effectiveGoalDone(g, content, goalDoneById);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        done ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 20,
                        color: done
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          g.label,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '文字版分析',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: !canCopy
                      ? null
                      : () {
                          final text =
                              _buildTextReport(categoryMap, blocks, totalMinutes);
                          Clipboard.setData(ClipboardData(text: text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已复制分析结果')),
                          );
                        },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('复制'),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _buildTextReport(categoryMap, blocks, totalMinutes),
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _pieColors = [
  Color(0xFF4CAF50), // 绿
  Color(0xFF2196F3), // 蓝
  Color(0xFFFF9800), // 橙
  Color(0xFF9C27B0), // 紫
  Color(0xFFF44336), // 红
  Color(0xFF00BCD4), // 青
  Color(0xFFFFEB3B), // 黄
  Color(0xFF795548), // 棕
  Color(0xFF607D8B), // 灰蓝
  Color(0xFFE91E63), // 粉
  Color(0xFF8BC34A), // 浅绿
  Color(0xFF3F51B5), // 靛蓝
];

class _PieChartPainter extends CustomPainter {
  final Map<String, int> data;
  final int total;

  _PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0 || data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2; // 从 12 点钟方向开始
    int i = 0;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final entry in data.entries) {
      final sweepAngle = (entry.value / total) * 2 * pi;
      paint.color = _pieColors[i % _pieColors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      // 在扇形中间画标签（占比 >= 5% 才显示）
      final percent = entry.value / total;
      if (percent >= 0.05) {
        final midAngle = startAngle + sweepAngle / 2;
        final labelRadius = radius * 0.65;
        final labelX = center.dx + labelRadius * cos(midAngle);
        final labelY = center.dy + labelRadius * sin(midAngle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${(percent * 100).toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
