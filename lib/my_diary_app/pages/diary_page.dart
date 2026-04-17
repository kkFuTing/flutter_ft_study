import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/diary_entry.dart';
import '../services/diary_storage.dart';
import '../config/event_categories.dart';
import '../config/daily_goals.dart';
import '../services/daily_goals_storage.dart';
import 'history_page.dart';
import 'time_analysis_page.dart';

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
  // 常用事件模板（按一级分类分组），来源于公共配置
  final Map<String, List<String>> _quickEventGroups = kQuickEventGroups;
  late String _currentEventGroupKey;

  // 每日必完成目标：复选框状态（按日期持久化）
  final Map<String, bool> _goalDoneById = <String, bool>{};
  bool _goalsLoaded = false;
  bool _autoMarkingGoals = false;

  List<String> get _currentEvents =>
      _quickEventGroups[_currentEventGroupKey] ?? const <String>[];
  String get _today => _todayStr();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentEventGroupKey = _quickEventGroups.keys.first;
    _controller = TextEditingController();
    _controller.addListener(_onDiaryTextChanged);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _focusNode.dispose();
    // 退出页面时自动保存一次（不弹提示）；dispose 不可 await，尽量在 paused 时已落盘
    unawaited(_persistDiaryAndGoals());
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 进入后台时 await 写入，降低杀进程导致 SharedPreferences 未落盘概率
    if (state == AppLifecycleState.paused) {
      unawaited(_persistDiaryAndGoals());
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      DiaryStorage.saveEntry(
        DiaryEntry(
          date: _currentDate,
          content: _controller.text,
          updatedAt: DateTime.now(),
        ),
      );
      unawaited(_saveGoalsForCurrentDate());
    }
  }

  Future<void> _persistDiaryAndGoals() async {
    await DiaryStorage.saveEntry(
      DiaryEntry(
        date: _currentDate,
        content: _controller.text,
        updatedAt: DateTime.now(),
      ),
    );
    await _saveGoalsForCurrentDate();
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
      await _loadGoalsForCurrentDate();
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

  void _onDiaryTextChanged() {
    // 初始化加载 controller.text 时可能触发多次；只有在目标加载完成后才开始自动勾选。
    if (_loading || !_goalsLoaded || _autoMarkingGoals) return;
    _maybeAutoMarkGoalsFromText();
  }

  void _maybeAutoMarkGoalsFromText() {
    _autoMarkingGoals = true;
    try {
      bool changed = false;
      for (final g in kDailyGoals) {
        // 仅当正文满足时“自动勾上”；不在这里把 true 改成 false，否则会覆盖本地已保存的勾选
        if (g.isSatisfied(_controller.text)) {
          if (!(_goalDoneById[g.id] ?? false)) {
            _goalDoneById[g.id] = true;
            changed = true;
          }
        }
      }
      if (changed && mounted) {
        setState(() {});
        unawaited(_saveGoalsForCurrentDate());
      }
    } finally {
      _autoMarkingGoals = false;
    }
  }

  Future<void> _loadGoalsForCurrentDate() async {
    _goalsLoaded = false;
    final map = await DailyGoalsStorage.loadForDate(_currentDate);
    if (!mounted) return;
    setState(() {
      _goalDoneById.clear();
      for (final g in kDailyGoals) {
        final fromDisk = map[g.id] ?? false;
        final fromText = g.isSatisfied(_controller.text);
        _goalDoneById[g.id] = fromDisk || fromText;
      }
      _goalsLoaded = true;
    });
    // 加载后再根据正文补一次“完成”自动勾上（不会冲掉磁盘上的 true）
    _maybeAutoMarkGoalsFromText();
  }

  Future<void> _saveGoalsForCurrentDate() async {
    await DailyGoalsStorage.saveForDate(_currentDate, _goalDoneById);
  }

  Future<void> _toggleGoal(DailyGoalDef goal, bool value) async {
    setState(() {
      _goalDoneById[goal.id] = value;
    });
    await _saveGoalsForCurrentDate();
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
    await DiaryStorage.saveEntry(
      DiaryEntry(
        date: _currentDate,
        content: _controller.text,
        updatedAt: DateTime.now(),
      ),
    );
    await _saveGoalsForCurrentDate();
    if (mounted) setState(() => _saving = false);
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已保存')));
  }

  Future<void> _clearAll() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('当前已经是空的')));
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
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
      DiaryEntry(date: _today, content: '', updatedAt: DateTime.now()),
    );
    // 清空「今日」日志时，同步清空当日每日必完成勾选并落盘
    await DailyGoalsStorage.clearForDate(_today);
    if (mounted) {
      setState(() {
        for (final g in kDailyGoals) {
          _goalDoneById[g.id] = false;
        }
      });
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已清空今日日志')));
    }
  }

  Future<void> _copyAll() async {
    final text = _controller.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('当前没有内容可以复制')));
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已复制全部内容')));
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

  void _insertStartTime({String? hhmm}) {
    final text = _controller.text;
    final timeStr = '${hhmm ?? _nowStr()}-';

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
    final cursor =
        _controller.selection.start < 0
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
    final cursor =
        value.selection.start < 0 ? text.length : value.selection.start;

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
    final cursor =
        value.selection.start < 0 ? text.length : value.selection.start;

    // 找到当前行的起始位置
    final lineStart = text.lastIndexOf('\n', cursor - 1) + 1;
    final lineEnd = text.indexOf('\n', cursor);
    final currentLine = text.substring(
      lineStart,
      lineEnd == -1 ? text.length : lineEnd,
    );

    // 优化：点击事件时自动补“结束+耗时”
    // 场景：当前行是 `HH:MM-`（有开始、没结束） → 自动补全到 `HH:MM-HH:MM Xm `
    final hasStartOnly = RegExp(r'\d{1,2}:\d{2}-').hasMatch(currentLine) &&
        !RegExp(r'\d{1,2}:\d{2}-\d{1,2}:\d{2}').hasMatch(currentLine);
    bool autoInsertedEnd = false;
    if (hasStartOnly) {
      final m = RegExp(r'(\d{1,2}:\d{2})-').firstMatch(currentLine);
      final startStr = m?.group(1);
      final endStr = _nowStr();
      final endTime = _parseTime(endStr);
      final startTime = startStr != null ? _parseTime(startStr) : null;

      String insertText;
      if (startTime != null && endTime != null) {
        var diff = endTime.difference(startTime);
        if (diff.isNegative) {
          diff = endTime.add(const Duration(hours: 24)).difference(startTime);
        }

        // 避免连续点事件时生成“0m 新记录”：
        // 若当前行只是自动生成的 `HH:MM-`，且上一行已有完整时间段，
        // 则把事件并到上一行，不再结束这一条新记录。
        if (diff.inMinutes <= 0 &&
            RegExp(r'^\s*\d{1,2}:\d{2}-\s*$').hasMatch(currentLine) &&
            lineStart > 0) {
          final prevLineBreak = text.lastIndexOf('\n', lineStart - 2);
          final prevLineStart = prevLineBreak + 1;
          final prevLine = text.substring(prevLineStart, lineStart - 1);
          final prevHasEndTime =
              RegExp(r'\d{1,2}:\d{2}-\d{1,2}:\d{2}').hasMatch(prevLine);
          if (prevHasEndTime) {
            final prevNeedsSpace = prevLine.trim().isNotEmpty &&
                !prevLine.endsWith(' ');
            _controller.selection = TextSelection.collapsed(
              offset: lineStart - 1,
            );
            _insertAtCursor('${prevNeedsSpace ? ' ' : ''}$event');
            return;
          }
        }
        insertText = '$endStr ${_formatDuration(diff)} ';
      } else {
        insertText = '$endStr ';
      }
      _insertAtCursor(insertText);
      autoInsertedEnd = true;
    }

    // 如果当前行已有内容且末尾不是空格，就先补一个空格
    final needsSpace =
        currentLine.trim().isNotEmpty && !currentLine.endsWith(' ');
    final prefix = needsSpace ? ' ' : '';

    _insertAtCursor('$prefix$event');

    // 只有当当前行已经是完整的一段（包含：HH:MM-HH:MM），
    // 用户才可能在“结束+耗时”后补事件。
    // 这种情况下，插入事件后自动生成下一段开始时间，便于继续下一段记录。
    final hasEndTime =
        autoInsertedEnd ||
        RegExp(r'\d{1,2}:\d{2}-\d{1,2}:\d{2}').hasMatch(currentLine);
    if (!hasEndTime) return;

    // 简化规则：只要下一行有任何内容，就不要自动生成开始时间。
    final afterText = _controller.text;
    final afterCursor =
        _controller.selection.start < 0
            ? afterText.length
            : _controller.selection.start;
    final nextNewline = afterText.indexOf('\n', afterCursor);
    bool nextLineHasContent = false;
    if (nextNewline != -1) {
      final nextLineStart = nextNewline + 1;
      final nextLineEnd = afterText.indexOf('\n', nextLineStart);
      final nextLine = afterText.substring(
        nextLineStart,
        nextLineEnd == -1 ? afterText.length : nextLineEnd,
      );
      nextLineHasContent = nextLine.trim().isNotEmpty;
    }

    if (!nextLineHasContent) _insertStartTime();
  }

  void _openHistory() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const HistoryPage()));
  }

  void _openAnalysis() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) =>
                TimeAnalysisPage(
                  content: _controller.text,
                  date: _currentDate,
                  goalDoneById: Map<String, bool>.from(_goalDoneById),
                ),
      ),
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
          child:
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      // 顶部：日期 + 右侧操作按钮
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 4, 0),
                        child: Row(
                          children: [
                            Text(
                              _currentDate == _today
                                  ? _today
                                  : '$_currentDate（非今天）',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.pie_chart_outline,
                                size: 20,
                              ),
                              onPressed: _openAnalysis,
                              tooltip: '时间分析',
                            ),
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
                              icon: const Icon(
                                Icons.copy_all_outlined,
                                size: 20,
                              ),
                              onPressed: _copyAll,
                              tooltip: '复制全部',
                            ),
                            if (_saving)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
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
                      // 顶部：每日必完成项目（复选框）
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '每日必完成',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 40,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: kDailyGoals.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final g = kDailyGoals[index];
                                  final done = _goalDoneById[g.id] ?? false;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        value: done,
                                        onChanged: _goalsLoaded
                                            ? (v) {
                                                _toggleGoal(
                                                  g,
                                                  v ?? false,
                                                );
                                              }
                                            : null,
                                      ),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 220,
                                        ),
                                        child: Text(
                                          g.label,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
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
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(height: 1.6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 底部：时间按钮 + 事件选择（固定在下方，不遮挡编辑区）
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.3),
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
                                  onPressed: () => _insertStartTime(),
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
                                separatorBuilder:
                                    (_, __) => const SizedBox(width: 6),
                                itemBuilder: (context, index) {
                                  final key = _quickEventGroups.keys.elementAt(
                                    index,
                                  );
                                  final selected = key == _currentEventGroupKey;
                                  return ChoiceChip(
                                    label: Text(
                                      key,
                                      style: const TextStyle(fontSize: 12),
                                    ),
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
                                separatorBuilder:
                                    (_, __) => const SizedBox(width: 6),
                                itemBuilder: (context, index) {
                                  final e = _currentEvents[index];
                                  return ActionChip(
                                    label: Text(
                                      e,
                                      style: const TextStyle(fontSize: 12),
                                    ),
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
