import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 状态管理示例
/// 这个文件展示了如何使用Provider进行状态管理
/// 
/// Provider是Flutter官方推荐的状态管理方案之一

// ==================== 使用Provider进行状态管理 ====================

/// 计数器模型 - 使用ChangeNotifier
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // 通知监听者数据已变化
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

/// 用户信息模型
class UserModel extends ChangeNotifier {
  String _name = '未登录';
  bool _isLoggedIn = false;

  String get name => _name;
  bool get isLoggedIn => _isLoggedIn;

  void login(String name) {
    _name = name;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _name = '未登录';
    _isLoggedIn = false;
    notifyListeners();
  }
}

/// 主状态管理示例页面
class StateManagementExample extends StatelessWidget {
  const StateManagementExample({super.key});

  @override
  Widget build(BuildContext context) {
    // 提供状态管理服务
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('状态管理示例 (Provider)'),
          backgroundColor: Colors.teal,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. 基础计数器示例
            _buildSectionCard(
              context,
              title: '1. 基础计数器',
              description: '使用Provider管理计数器状态',
              child: const _CounterExample(),
            ),
            const SizedBox(height: 20),

            // 2. 多个组件共享状态
            _buildSectionCard(
              context,
              title: '2. 多组件共享状态',
              description: '多个Widget共享同一个状态',
              child: const _SharedStateExample(),
            ),
            const SizedBox(height: 20),

            // 3. 用户登录状态
            _buildSectionCard(
              context,
              title: '3. 用户状态管理',
              description: '管理用户登录状态和信息',
              child: const _UserStateExample(),
            ),
            const SizedBox(height: 20),

            // 4. Consumer vs Provider.of
            _buildSectionCard(
              context,
              title: '4. 两种使用方式对比',
              description: 'Consumer和Provider.of的使用',
              child: const _UsageComparisonExample(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

/// 基础计数器示例
class _CounterExample extends StatelessWidget {
  const _CounterExample();

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        return Column(
          children: [
            Text(
              '计数: ${counter.count}',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => counter.decrement(),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => counter.reset(),
                  child: const Text('重置'),
                ),
                ElevatedButton(
                  onPressed: () => counter.increment(),
                  child: const Text('+'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// 多组件共享状态示例
class _SharedStateExample extends StatelessWidget {
  const _SharedStateExample();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('多个组件共享同一个计数器状态：'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _CounterDisplay(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CounterButtons(),
            ),
          ],
        ),
      ],
    );
  }
}

/// 计数器显示组件
class _CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${counter.count}',
              style: const TextStyle(fontSize: 48),
            ),
          ),
        );
      },
    );
  }
}

/// 计数器按钮组件
class _CounterButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<CounterModel>(context);
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => counter.increment(),
          child: const Text('增加'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => counter.decrement(),
          child: const Text('减少'),
        ),
      ],
    );
  }
}

/// 用户状态示例
class _UserStateExample extends StatelessWidget {
  const _UserStateExample();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, user, child) {
        return Column(
          children: [
            if (user.isLoggedIn) ...[
              const Icon(Icons.check_circle, size: 60, color: Colors.green),
              const SizedBox(height: 10),
              Text(
                '欢迎, ${user.name}!',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => user.logout(),
                child: const Text('退出登录'),
              ),
            ] else ...[
              const Icon(Icons.person_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 10),
              const Text(
                '未登录',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  user.login('张三');
                },
                child: const Text('登录'),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// 使用方式对比示例
class _UsageComparisonExample extends StatelessWidget {
  const _UsageComparisonExample();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '方式1: 使用 Consumer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Consumer<CounterModel>(
          builder: (context, counter, child) {
            return Text('当前计数: ${counter.count}');
          },
        ),
        const SizedBox(height: 16),
        const Text(
          '方式2: 使用 Provider.of',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final counter = Provider.of<CounterModel>(context);
            return Text('当前计数: ${counter.count}');
          },
        ),
        const SizedBox(height: 16),
        const Text(
          '提示: Consumer 会在状态变化时自动重建Widget',
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

