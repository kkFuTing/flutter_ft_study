/// 事件分类配置：同时用于
/// 1) `diary_page.dart` 的事件选择 chips
/// 2) `time_parser.dart` 的统计分类（饼图/分类统计）
class EventCategoryDef {
  final String key;
  final List<String> chips;

  const EventCategoryDef({required this.key, required this.chips});
}

/// 事件选择 chips 的展示顺序（也会影响 `diary_page.dart` 上方分类按钮的顺序）
const List<EventCategoryDef> kEventCategories = <EventCategoryDef>[
  EventCategoryDef(
    key: '卫生',
    chips: ['洗漱', '厕所-小', '收拾出门', '刷牙', '洗澡', '吹头发', '护肤', '厕所-大'],
  ),
  EventCategoryDef(key: '工作', chips: ['工作-专注', '工作-摸鱼', '工作-开会', '工作-聊天']),
  EventCategoryDef(key: '零嘴', chips: ['零食', '饮料', '水果','夜宵']),
  EventCategoryDef(key: '饮食', chips: ['吃饭', '热饭', '洗碗', '倒水','点外卖']),
  EventCategoryDef(key: '休息', chips: ['睡觉', '午休', '小睡']),
  EventCategoryDef(key: '通勤', chips: ['工作通勤，外出通勤']),
  EventCategoryDef(
    key: '编程学习',
    chips: ['C视频课', 'AI视频课', 'Android视频课', 'Flutter视频课', '博客', '书籍'],
  ),
  EventCategoryDef(key: '个人成长', chips: ['背单词', '英语学习', '口语表达训练','阅读']),
  EventCategoryDef(
    key: '运动',
    chips: ['爵士舞', '散步', '跑步', '跳绳', '羽毛球', '乒乓球', '篮球', '爬山'],
  ),
  EventCategoryDef(key: '娱乐', chips: ['刷抖音', '刷小红书', '看视频','听音乐','公众号']),
  EventCategoryDef(key: '家务', chips: ['晾衣服', '备菜', '打扫卫生', '打扫房间', '收拾厨房']),
  EventCategoryDef(
    key: '线上购物',
    chips: ['线上纯逛', '线上买菜', '线上买衣服', '线上买鞋', '线上买化妆品', '线上买其他'],
  ),
  EventCategoryDef(key: '线下购物', chips: ['线下买菜', '线下买水果','线下买零食','线下买衣服', '线下买鞋', '线下买化妆品', '线下买其他']),
  EventCategoryDef(key: '外出放松', chips: ['纯逛', '逛街', '逛公园', '逛商场', '逛超市', '逛菜市场', '逛夜市', '逛其他']),
  EventCategoryDef(key: '杂事', chips: ['拿快递', '取外卖']),
  EventCategoryDef(
    key: '化妆',
    chips: ['日常化妆', '化妆在家练习', '化妆课', '化妆课上练习', '化妆课上模特','卸妆洗脸'],
  ),
  EventCategoryDef(key: '放空', chips: ['放空', '发呆', '胡思乱想', '尝试入睡睡不着']),
  EventCategoryDef(key: '小工具制作', chips: ['小工具制作', '每日记录APP']),
  EventCategoryDef(key: '复盘', chips: ['每日总结复盘', '每周总结复盘', '每月总结复盘','随机复盘调整']),
  EventCategoryDef(key: '社交', chips: ['线下社交','线下聊天','社交软件聊天','电话','水群']),
  EventCategoryDef(key: '其他', chips: ['其他','玩手机']),
];

/// `diary_page.dart` 使用的事件分组（key -> chips 列表）
final Map<String, List<String>> kQuickEventGroups =
    Map<String, List<String>>.unmodifiable(<String, List<String>>{
      for (final c in kEventCategories)
        c.key: List<String>.unmodifiable(c.chips),
    });

bool _validatedNoDuplicateChips = false;

void _validateNoDuplicateChips() {
  if (_validatedNoDuplicateChips) return;
  _validatedNoDuplicateChips = true;

  final seen = <String, String>{}; // chip(lowercased) -> key
  final duplicates = <String, List<String>>{};

  for (final def in kEventCategories) {
    for (final chip in def.chips) {
      final c = chip.toLowerCase();
      final prevKey = seen[c];
      if (prevKey == null) {
        seen[c] = def.key;
      } else if (prevKey != def.key) {
        duplicates.putIfAbsent(c, () => <String>[]).addAll(<String>[
          prevKey,
          def.key,
        ]);
      }
    }
  }

  if (duplicates.isNotEmpty) {
    final lines =
        duplicates.entries.map((e) {
          final keys = e.value.toSet().toList()..sort();
          return '${e.key}：${keys.join("、")}';
        }).toList();
    throw AssertionError(
      'event_categories.dart chips 存在重复：\n${lines.join("\n")}',
    );
  }
}

/// 根据事件文本归类到大类（用于统计/饼图）
String categorizeEvent(String event) {
  // debug 模式下自检：确保所有分类的 chips 不重复。
  // 这样 `categorizeEvent()` 不需要优先级就能保持稳定归类。
  assert(() {
    _validateNoDuplicateChips();
    return true;
  }());

  if (event.trim().isEmpty) return '其他';
  final e = event.toLowerCase();

  // 简化目标：分类之间不重复（同一个 chip 不会出现在多个 key 下），因此不需要优先级。
  for (final def in kEventCategories) {
    for (final p in def.chips) {
      if (e.contains(p.toLowerCase())) return def.key;
    }
  }
  return '其他';
}
