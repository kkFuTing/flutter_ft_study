import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod 状态管理示例
/// 展示 Riverpod 的核心功能：Provider、状态管理、依赖注入、生命周期管理等
class RiverpodExample extends StatelessWidget {
  const RiverpodExample({super.key});

  @override
  Widget build(BuildContext context) {

    // 使用 ProviderScope 包裹整个应用
    return ProviderScope(
      child: MaterialApp(
        title: 'Riverpod 示例',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const RiverpodHomePage(),
      ),
    );
  }
}

// ==================== 首页 ====================

class RiverpodHomePage extends StatelessWidget {
  const RiverpodHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod 状态管理示例'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('基础 Provider'),
          _buildExampleCard(
            context,
            title: '1. Provider（只读数据）',
            description: '提供不可变的数据',
            icon: Icons.data_object,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProviderExamplePage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '2. StateProvider（简单状态）',
            description: '管理简单的可变状态',
            icon: Icons.toggle_on,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StateProviderExamplePage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '3. StateNotifierProvider（复杂状态）',
            description: '管理复杂的状态逻辑',
            icon: Icons.settings,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StateNotifierExamplePage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('异步 Provider'),
          _buildExampleCard(
            context,
            title: '4. FutureProvider（异步数据）',
            description: '处理异步数据加载',
            icon: Icons.cloud_download,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FutureProviderExamplePage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '5. StreamProvider（流数据）',
            description: '处理流式数据',
            icon: Icons.stream,
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StreamProviderExamplePage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('高级用法'),
          _buildExampleCard(
            context,
            title: '6. Provider 组合和依赖',
            description: 'Provider 之间相互依赖',
            icon: Icons.link,
            color: Colors.indigo,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProviderDependencyPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '7. Provider 过滤和选择',
            description: '只监听部分状态变化',
            icon: Icons.filter_list,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProviderSelectPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '8. 自动处理生命周期',
            description: 'Provider 自动管理资源',
            icon: Icons.auto_awesome,
            color: Colors.pink,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LifecycleExamplePage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('实际应用场景'),
          _buildExampleCard(
            context,
            title: '9. 完整示例：用户管理',
            description: '展示实际项目中的使用方式',
            icon: Icons.person,
            color: Colors.deepPurple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserManagementPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Riverpod API 说明'),
          _buildInfoCard(
            'Provider<T>',
            '提供不可变的数据，只读',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'StateProvider<T>',
            '管理简单的可变状态',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'StateNotifierProvider',
            '管理复杂的状态逻辑',
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'FutureProvider<T>',
            '处理异步数据加载',
            Colors.purple,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'StreamProvider<T>',
            '处理流式数据',
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(width: 4, height: 40, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 1. Provider 示例 ====================

/// 定义 Provider（只读数据）
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(
    appName: 'Riverpod 示例',
    version: '1.0.0',
    apiBaseUrl: 'https://api.example.com',
  );
});

class AppConfig {
  final String appName;
  final String version;
  final String apiBaseUrl;

  AppConfig({
    required this.appName,
    required this.version,
    required this.apiBaseUrl,
  });
}

class ProviderExamplePage extends ConsumerWidget {
  const ProviderExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 ref.watch 监听 Provider
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 示例'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.data_object, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                '应用配置',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('应用名称: ${config.appName}'),
                      const SizedBox(height: 8),
                      Text('版本号: ${config.version}'),
                      const SizedBox(height: 8),
                      Text('API 地址: ${config.apiBaseUrl}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '💡 Provider 提供不可变的数据，适合配置、常量等',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 2. StateProvider 示例 ====================

/// 定义 StateProvider（简单状态）
final counterProvider = StateProvider<int>((ref) => 0);

class StateProviderExamplePage extends ConsumerWidget {
  const StateProviderExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 ref.watch 监听状态
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StateProvider 示例'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.toggle_on, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              '计数器',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text(
              '$count',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 使用 ref.read 读取并修改状态
                    ref.read(counterProvider.notifier).state--;
                  },
                  child: const Text('-'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state = 0;
                  },
                  child: const Text('重置'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
                  },
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 StateProvider 适合管理简单的可变状态',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 3. StateNotifierProvider 示例 ====================

/// 定义状态类
class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

/// 定义 StateNotifier
class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  void addTodo(String title) {
    state = [
      ...state,
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      ),
    ];
  }

  void toggleTodo(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

/// 定义 StateNotifierProvider
final todoListProvider = StateNotifierProvider<TodoNotifier, List<Todo>>(
  (ref) => TodoNotifier(),
);

class StateNotifierExamplePage extends ConsumerWidget {
  const StateNotifierExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final todoNotifier = ref.read(todoListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StateNotifierProvider 示例'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '输入待办事项',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        todoNotifier.addTodo(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final controller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('添加待办'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: '输入待办事项',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                todoNotifier.addTodo(controller.text);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('添加'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('添加'),
                ),
              ],
            ),
          ),
          Expanded(
            child: todos.isEmpty
                ? const Center(
                    child: Text('暂无待办事项'),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (_) => todoNotifier.toggleTodo(todo.id),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => todoNotifier.removeTodo(todo.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ==================== 4. FutureProvider 示例 ====================

/// 模拟 API 服务
class ApiService {
  Future<String> fetchUserData() async {
    await Future.delayed(const Duration(seconds: 2));
    return '用户数据加载完成';
  }
}

/// 定义 FutureProvider
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final userDataProvider = FutureProvider<String>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchUserData();
});

class FutureProviderExamplePage extends ConsumerWidget {
  const FutureProviderExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureProvider 示例'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_download, size: 80, color: Colors.purple),
              const SizedBox(height: 24),
              const Text(
                '异步数据加载',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              userDataAsync.when(
                data: (data) => Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      data,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // 刷新数据
                        ref.invalidate(userDataProvider);
                      },
                      child: const Text('重新加载'),
                    ),
                  ],
                ),
                loading: () => const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('加载中...'),
                  ],
                ),
                error: (error, stack) => Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      '错误: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(userDataProvider);
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '💡 FutureProvider 自动处理异步状态（loading、data、error）',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 5. StreamProvider 示例 ====================

/// 定义 StreamProvider
final timerProvider = StreamProvider<int>((ref) async* {
  for (int i = 0; i <= 60; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
});

class StreamProviderExamplePage extends ConsumerWidget {
  const StreamProviderExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamProvider 示例'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stream, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                '流式数据',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              timerAsync.when(
                data: (seconds) => Column(
                  children: [
                    Text(
                      '$seconds',
                      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '秒',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text(
                  '错误: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // 重置 Stream
                  ref.invalidate(timerProvider);
                },
                child: const Text('重置'),
              ),
              const SizedBox(height: 24),
              const Text(
                '💡 StreamProvider 用于处理流式数据（WebSocket、定时器等）',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 6. Provider 依赖示例 ====================

/// 基础配置 Provider
final baseUrlProvider = Provider<String>((ref) => 'https://api.example.com');

/// 依赖 baseUrlProvider 的 API 服务
final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return ApiClient(baseUrl);
});

/// 依赖 apiClientProvider 的数据仓库
final repositoryProvider = Provider<DataRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DataRepository(apiClient);
});

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  String fetchData() => '从 $baseUrl 获取数据';
}

class DataRepository {
  final ApiClient apiClient;

  DataRepository(this.apiClient);

  String getData() => apiClient.fetchData();
}

class ProviderDependencyPage extends ConsumerWidget {
  const ProviderDependencyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    final baseUrl = ref.watch(baseUrlProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 依赖示例'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.link, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              const Text(
                'Provider 依赖链',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Base URL: $baseUrl'),
                      const SizedBox(height: 16),
                      Text('数据: ${repository.getData()}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '💡 Provider 可以相互依赖，Riverpod 自动管理依赖关系',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 7. Provider 选择示例 ====================

/// 用户信息
class User {
  final String name;
  final int age;
  final String email;

  User({
    required this.name,
    required this.age,
    required this.email,
  });
}

final userProvider = StateProvider<User>((ref) => User(
      name: '张三',
      age: 25,
      email: 'zhangsan@example.com',
    ));

class ProviderSelectPage extends ConsumerWidget {
  const ProviderSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 只监听 name 属性
    final name = ref.watch(userProvider.select((user) => user.name));
    // 只监听 age 属性
    final age = ref.watch(userProvider.select((user) => user.age));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 选择示例'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.filter_list, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                '选择性监听',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('姓名: $name'),
                      const SizedBox(height: 8),
                      Text('年龄: $age'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final user = ref.read(userProvider);
                  ref.read(userProvider.notifier).state = User(
                    name: user.name == '张三' ? '李四' : '张三',
                    age: user.age + 1,
                    email: user.email,
                  );
                },
                child: const Text('更新用户信息'),
              ),
              const SizedBox(height: 24),
              const Text(
                '💡 使用 select 只监听部分状态，避免不必要的重建',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 8. 生命周期示例 ====================

/// 需要清理的资源
class ResourceService {
  ResourceService() {
    print('ResourceService 已创建');
  }

  void dispose() {
    print('ResourceService 已销毁');
  }
}

/// 使用 autoDispose 自动管理生命周期
final resourceProvider = Provider.autoDispose<ResourceService>((ref) {
  final service = ResourceService();

  // 当 Provider 被销毁时自动清理
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

class LifecycleExamplePage extends ConsumerWidget {
  const LifecycleExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听 Provider 以触发创建
    ref.watch(resourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('生命周期示例'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 80, color: Colors.pink),
              const SizedBox(height: 24),
              const Text(
                '自动生命周期管理',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              const Text(
                'ResourceService 已创建',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // 手动销毁 Provider
                  ref.invalidate(resourceProvider);
                },
                child: const Text('销毁资源'),
              ),
              const SizedBox(height: 24),
              const Text(
                '💡 autoDispose Provider 在不再使用时自动清理资源',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 9. 完整示例：用户管理 ====================

/// 用户状态
class UserState {
  final String? name;
  final bool isLoading;
  final String? error;

  UserState({
    this.name,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    String? name,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 用户状态管理
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        name: '李四',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearUser() {
    state = UserState();
  }
}

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(),
);

class UserManagementPage extends ConsumerWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    final userNotifier = ref.read(userNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理示例'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '实际应用场景',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (userState.error != null)
                      Text(
                        '错误: ${userState.error}',
                        style: const TextStyle(color: Colors.red),
                      )
                    else if (userState.name != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('用户名: ${userState.name}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: userNotifier.clearUser,
                            child: const Text('清除用户'),
                          ),
                        ],
                      )
                    else
                      const Text('未加载用户'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: userState.isLoading
                          ? null
                          : userNotifier.loadUser,
                      child: const Text('加载用户'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 实际项目中的最佳实践',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• 使用 StateNotifier 管理复杂状态\n'
                      '• 分离业务逻辑和 UI\n'
                      '• 使用 Provider 组合实现依赖注入\n'
                      '• 利用 autoDispose 自动管理资源\n'
                      '• 使用 select 优化性能',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

