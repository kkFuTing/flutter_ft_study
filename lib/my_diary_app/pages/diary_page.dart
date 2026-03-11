import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/diary_entry.dart';
import '../services/diary_storage.dart';
import 'history_page.dart';

/// 记事日记主页面：全屏无边框书写今日日记
class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> with WidgetsBindingObserver {
  static String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  late final TextEditingController _controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _loading = true;
  bool _saving = false;
  String _currentDate = _todayStr(); // 当前正在编辑的日期（不一定是今天）
  // 常用事件模板（按一级分类分组）
  final Map<String, List<String>> _quickEventGroups = <String, List<String>>{
    '休息': [
      '睡觉',
      '午休',
      '尝试入睡睡不着'
    ],
    '卫生': [
      '洗漱',
      '厕所-大',
      '厕所-小',
      '刷牙',
      '洗澡',
    ],
    '饮食': [
      '吃饭',
      '热饭',
      '洗碗',
      '倒水'
    ],
    '通勤/外出': [
      '通勤',
      '外出买东西',
      '买菜',
    ],
    '工作': [
      '工作-专注',
      '工作-摸鱼',
      '工作-开会',
      '工作-聊天',
    ],
    '学习': [
      '背单词',
      '英语学习',
      '朗诵',
      '看博客/文章',
      '编程学习',
    ],
    '运动': [
      '爵士舞',
      '散步/走路',
      '跑步',
      '跳绳',
      '打羽毛球',
      '打乒乓球',
      '打篮球',
    ],
    '娱乐': [
      '刷抖音',
      '刷小红书',
      '看视频',
    ],
    '杂事': [
      '家务',
      '整理/收拾',
      '其他',
    ],
  };
  late String _currentEventGroupKey;

  List<String> get _currentEvents =>
      _quickEventGroups[_currentEventGroupKey] ?? const <String>[];
  String get _today => _todayStr();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentEventGroupKey = _quickEventGroups.keys.first;
    _controller = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _focusNode.dispose();
    // 退出页面时自动保存一次（不弹提示）
    DiaryStorage.saveEntry(
      DiaryEntry(
        date: _currentDate,
        content: _controller.text,
        updatedAt: DateTime.now(),
      ),
    );
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // App 进入后台或即将退出时自动保存
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      DiaryStorage.saveEntry(
        DiaryEntry(
          date: _currentDate,
          content: _controller.text,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await DiaryStorage.loadAll(); // 已按日期倒序
    // 找最近一条有内容的日记，如果没有就用今天
    DiaryEntry? latest;
    for (final e in list) {
      if (e.content.trim().isNotEmpty) {
        latest = e;
        break;
      }
    }
    if (mounted) {
      setState(() {
        if (latest != null) {
          _currentDate = latest.date;
          _controller.text = latest.content;
        } else {
          _currentDate = _today;
          _controller.text = '';
        }
        _loading = false;
      });
      _scrollToBottom();
      // 自动聚焦并把光标移到末尾
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await DiaryStorage.saveEntry(DiaryEntry(
      date: _currentDate,
      content: _controller.text,
      updatedAt: DateTime.now(),
    ));
    if (mounted) setState(() => _saving = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已保存')));
  }

  Future<void> _clearAll() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('当前已经是空的')));
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空今日日志'),
        content: const Text('确定要清空今天的全部记录吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    _controller.clear();
    await DiaryStorage.saveEntry(
      DiaryEntry(
        date: _today,
        content: '',
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已清空今日日志')));
    }
  }

  Future<void> _copyAll() async {
    final text = _controller.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('当前没有内容可以复制')));
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已复制全部内容')));
    }
  }

  /// 在当前光标位置插入文本
  void _insertAtCursor(String text) {
    final value = _controller.value;
    final selection = value.selection;
    final start = selection.start < 0 ? value.text.length : selection.start;
    final end = selection.end < 0 ? value.text.length : selection.end;
    final newText = value.text.replaceRange(start, end, text);
    final newSelectionIndex = start + text.length;
    _controller.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
      composing: TextRange.empty,
    );
    _scrollToBottom();
  }

  String _nowStr() {
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _todayHeader() {
    final now = DateTime.now();
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString();
    final w = weekdays[now.weekday - 1];
    return '$m-$d(星期$w)';
  }

  DateTime? _parseTime(String hhmm) {
    if (hhmm.length != 5 || hhmm[2] != ':') return null;
    final h = int.tryParse(hhmm.substring(0, 2));
    final m = int.tryParse(hhmm.substring(3, 5));
    if (h == null || m == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, h, m);
  }

  String _formatDuration(Duration d) {
    final totalMinutes = d.inMinutes;
    if (totalMinutes <= 0) return '0m';
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h${m}m';
  }

  void _insertStartTime() {
    final text = _controller.text;
    final timeStr = '${_nowStr()}-';

    // 情况1：内容为空 → 先插日期标题，换行，再插开始时间
    if (text.trim().isEmpty) {
      _controller.text = '${_todayHeader()}\n$timeStr';
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
      _scrollToBottom();
      return;
    }

    // 情况2：内容非空 → 判断当前行是否有内容，决定是否换行
    final cursor = _controller.selection.start < 0
        ? text.length
        : _controller.selection.start;
    final lineStart = cursor > 0 ? text.lastIndexOf('\n', cursor - 1) + 1 : 0;
    final lineEnd = text.indexOf('\n', cursor);
    final currentLine = text.substring(
      lineStart,
      lineEnd == -1 ? text.length : lineEnd,
    );

    final prefix = currentLine.trim().isNotEmpty ? '\n' : '';
    _insertAtCursor('$prefix$timeStr');
  }

  void _insertEndTime() {
    // 在当前行自动补结束时间 + 空格 + 耗时
    final value = _controller.value;
    final text = value.text;
    final cursor = value.selection.start < 0 ? text.length : value.selection.start;

    // 找到当前行的起始位置
    final lineStart = text.lastIndexOf('\n', cursor - 1) + 1;
    final lineEnd = text.indexOf('\n', cursor);
    final currentLine = text.substring(
      lineStart,
      lineEnd == -1 ? text.length : lineEnd,
    );

    // 在当前行中找形如 HH:MM- 的开始时间
    String? startStr;
    final dashIndex = currentLine.indexOf('-');
    if (dashIndex >= 5) {
      final candidate = currentLine.substring(dashIndex - 5, dashIndex);
      if (candidate[2] == ':') {
        startStr = candidate;
      }
    }

    final endStr = _nowStr();
    final endTime = _parseTime(endStr);
    final startTime = startStr != null ? _parseTime(startStr) : null;

    String insertText;
    if (startTime != null && endTime != null) {
      var diff = endTime.difference(startTime);
      // 跨午夜：结束时间比开始时间早，说明过了 0 点，加 24 小时
      if (diff.isNegative) {
        diff = endTime.add(const Duration(hours: 24)).difference(startTime);
      }
      insertText = '$endStr ${_formatDuration(diff)} ';
    } else {
      // 兜底：如果没解析到开始时间，就只插入结束时间和空格
      insertText = '$endStr ';
    }

    _insertAtCursor(insertText);
  }

  void _insertEvent(String event) {
    final value = _controller.value;
    final text = value.text;
    final cursor = value.selection.start < 0 ? text.length : value.selection.start;

    // 找到当前行的起始位置
    final lineStart = text.lastIndexOf('\n', cursor - 1) + 1;
    final lineEnd = text.indexOf('\n', cursor);
    final currentLine = text.substring(
      lineStart,
      lineEnd == -1 ? text.length : lineEnd,
    );

    // 如果当前行已有内容且末尾不是空格，就先补一个空格
    final needsSpace = currentLine.trim().isNotEmpty && !currentLine.endsWith(' ');
    final prefix = needsSpace ? ' ' : '';

    _insertAtCursor('$prefix$event');
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // 顶部：日期 + 右侧操作按钮
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 4, 0),
                      child: Row(
                        children: [
                          Text(
                            _currentDate == _today ? _today : '$_currentDate（非今天）',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.history, size: 20),
                            onPressed: _openHistory,
                            tooltip: '历史日记',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: _clearAll,
                            tooltip: '清空',
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_all_outlined, size: 20),
                            onPressed: _copyAll,
                            tooltip: '复制全部',
                          ),
                          if (_saving)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.save_outlined, size: 20),
                              onPressed: _save,
                              tooltip: '保存',
                            ),
                        ],
                      ),
                    ),
                    // 中间：编辑区（占满剩余空间，可滚动）
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: const InputDecoration(
                              hintText: '写点什么...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              alignLabelWithHint: true,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 底部：时间按钮 + 事件选择（固定在下方，不遮挡编辑区）
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).dividerColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: _insertStartTime,
                                icon: const Icon(Icons.play_arrow, size: 18),
                                label: const Text('开始时间'),
                              ),
                              TextButton.icon(
                                onPressed: _insertEndTime,
                                icon: const Icon(Icons.stop, size: 18),
                                label: const Text('结束+耗时'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 30,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _quickEventGroups.keys.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 6),
                              itemBuilder: (context, index) {
                                final key = _quickEventGroups.keys.elementAt(index);
                                final selected = key == _currentEventGroupKey;
                                return ChoiceChip(
                                  label: Text(key, style: const TextStyle(fontSize: 12)),
                                  selected: selected,
                                  onSelected: (v) {
                                    if (!v) return;
                                    setState(() {
                                      _currentEventGroupKey = key;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 34,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _currentEvents.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 6),
                              itemBuilder: (context, index) {
                                final e = _currentEvents[index];
                                return ActionChip(
                                  label: Text(e, style: const TextStyle(fontSize: 12)),
                                  onPressed: () => _insertEvent(e),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
