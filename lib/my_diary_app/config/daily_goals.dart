/// 每日必完成项目配置
/// 会在 `DiaryPage` 顶部展示为复选框：
/// - 若你的日记内容满足目标，会自动勾上
/// - 你也可以手动勾选（会持久化到本地）
class DailyGoalDef {
  final String id;
  final String label;
  final String keyword;

  /// 若设置，则尝试从日记文本中解析 `keyword` 后面的数字：
  /// 例如：`背单词100个`、`背单词 100`、`背单词：100`
  /// >= minCount 即视为完成
  final int? minCount;

  const DailyGoalDef({
    required this.id,
    required this.label,
    required this.keyword,
    this.minCount,
  });

  bool isSatisfied(String diaryText) {
    if (diaryText.trim().isEmpty) return false;

    if (minCount == null) {
      return diaryText.contains(keyword);
    }

    final reg = RegExp('${RegExp.escape(keyword)}\\D*(\\d+)');
    for (final m in reg.allMatches(diaryText)) {
      final n = int.tryParse(m.group(1) ?? '');
      if (n != null && n >= minCount!) return true;
    }
    return false;
  }
}

const List<DailyGoalDef> kDailyGoals = <DailyGoalDef>[
  DailyGoalDef(
    id: 'word_100',
    label: '背单词100个',
    keyword: '背单词',
    minCount: 100,
  ),
  DailyGoalDef(
    id: 'jazz_dance',
    label: '爵士舞',
    keyword: '爵士舞',
  ),
    DailyGoalDef(
    id: 'english_study',
    label: '英语学习',
    keyword: '英语学习',
  ),
  DailyGoalDef(
    id: 'expression_ability',
    label: '口语表达训练',
    keyword: '口语表达训练',
  ),
];

