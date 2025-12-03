import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// GetIt 依赖注入示例
/// 展示 GetIt 的核心功能：服务定位、依赖注入、单例模式、工厂模式等
class GetItExample extends StatelessWidget {
  const GetItExample({super.key});

  @override
  Widget build(BuildContext context) {
    // 初始化 GetIt（通常在应用启动时调用一次）
    _setupGetIt();

    return MaterialApp(
      title: 'GetIt 示例',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GetItHomePage(),
    );
  }

  /// 配置 GetIt 依赖注入容器
  void _setupGetIt() {
    final getIt = GetIt.instance;

    // 1. 注册单例（Singleton）- 整个应用生命周期只有一个实例
    getIt.registerSingleton<UserService>(
      UserService(),
    );

    // 2. 注册懒加载单例（Lazy Singleton）- 第一次使用时才创建
    getIt.registerLazySingleton<ApiService>(
      () => ApiService(),
    );

    // 3. 注册工厂（Factory）- 每次获取都创建新实例
    getIt.registerFactory<DataRepository>(
      () => DataRepository(getIt<ApiService>()), // 依赖注入 ApiService
    );

    // 4. 注册命名实例
    getIt.registerSingleton<Logger>(
      ConsoleLogger(),
      instanceName: 'console',
    );
    getIt.registerSingleton<Logger>(
      FileLogger(),
      instanceName: 'file',
    );

    // 5. 注册异步单例（需要异步初始化）
    getIt.registerSingletonAsync<DatabaseService>(
      () async {
        final db = DatabaseService();
        await db.initialize();
        return db;
      },
    );

    // 6. 注册带参数工厂
    getIt.registerFactoryParam<HttpClient, String, void>(
      (baseUrl, _) => HttpClient(baseUrl),
    );

    print('✅ GetIt 依赖注入容器已配置完成');
  }
}

// ==================== 首页 ====================

class GetItHomePage extends StatelessWidget {
  const GetItHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetIt 依赖注入示例'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('基础用法'),
          _buildExampleCard(
            context,
            title: '1. 单例模式（Singleton）',
            description: '整个应用只有一个实例',
            icon: Icons.storage,
            color: Colors.blue,
            onTap: () => _showSingletonExample(context),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '2. 懒加载单例（Lazy Singleton）',
            description: '第一次使用时才创建',
            icon: Icons.timer,
            color: Colors.green,
            onTap: () => _showLazySingletonExample(context),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '3. 工厂模式（Factory）',
            description: '每次获取都创建新实例',
            icon: Icons.build,
            color: Colors.orange,
            onTap: () => _showFactoryExample(context),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('高级用法'),
          _buildExampleCard(
            context,
            title: '4. 依赖注入',
            description: '自动注入依赖的服务',
            icon: Icons.link,
            color: Colors.purple,
            onTap: () => _showDependencyInjectionExample(context),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '5. 命名注册',
            description: '同一个接口注册多个实现',
            icon: Icons.label,
            color: Colors.teal,
            onTap: () => _showNamedRegistrationExample(context),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '6. 异步注册',
            description: '需要异步初始化的服务',
            icon: Icons.sync,
            color: Colors.indigo,
            onTap: () => _showAsyncRegistrationExample(context),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '7. 带参数工厂',
            description: '创建时需要传入参数',
            icon: Icons.settings,
            color: Colors.red,
            onTap: () => _showParamFactoryExample(context),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('实际应用场景'),
          _buildExampleCard(
            context,
            title: '8. 完整示例：用户管理',
            description: '展示实际项目中的使用方式',
            icon: Icons.person,
            color: Colors.pink,
            onTap: () => _showUserManagementExample(context),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('GetIt API 说明'),
          _buildInfoCard(
            'getIt.registerSingleton<T>()',
            '注册单例，立即创建实例',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'getIt.registerLazySingleton<T>()',
            '注册懒加载单例，第一次使用时创建',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'getIt.registerFactory<T>()',
            '注册工厂，每次获取都创建新实例',
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'getIt<T>() 或 getIt.get<T>()',
            '获取已注册的服务实例',
            Colors.purple,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'getIt.isRegistered<T>()',
            '检查服务是否已注册',
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

  // ==================== 示例方法 ====================

  void _showSingletonExample(BuildContext context) {
    final getIt = GetIt.instance;
    final userService1 = getIt<UserService>();
    final userService2 = getIt<UserService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('单例模式示例'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('单例模式确保整个应用只有一个实例：'),
            const SizedBox(height: 16),
            Text('实例1: ${userService1.hashCode}'),
            Text('实例2: ${userService2.hashCode}'),
            const SizedBox(height: 8),
            Text(
              userService1 == userService2
                  ? '✅ 是同一个实例（单例）'
                  : '❌ 不是同一个实例',
              style: TextStyle(
                color: userService1 == userService2 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                userService1.setUserName('张三');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('用户名已设置为: ${userService2.getUserName()}'),
                  ),
                );
              },
              child: const Text('测试共享状态'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showLazySingletonExample(BuildContext context) {
    final getIt = GetIt.instance;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('懒加载单例示例'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('懒加载单例在第一次使用时才创建：'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final apiService = getIt<ApiService>();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ApiService 已创建: ${apiService.hashCode}'),
                  ),
                );
              },
              child: const Text('获取 ApiService（懒加载）'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showFactoryExample(BuildContext context) {
    final getIt = GetIt.instance;
    final repo1 = getIt<DataRepository>();
    final repo2 = getIt<DataRepository>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('工厂模式示例'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('工厂模式每次获取都创建新实例：'),
            const SizedBox(height: 16),
            Text('实例1: ${repo1.hashCode}'),
            Text('实例2: ${repo2.hashCode}'),
            const SizedBox(height: 8),
            Text(
              repo1 != repo2
                  ? '✅ 是不同的实例（工厂模式）'
                  : '❌ 是同一个实例',
              style: TextStyle(
                color: repo1 != repo2 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Repository 1 获取数据: ${repo1.fetchData()}'),
                  ),
                );
              },
              child: const Text('测试工厂实例'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showDependencyInjectionExample(BuildContext context) {
    final getIt = GetIt.instance;
    final repository = getIt<DataRepository>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('依赖注入示例'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DataRepository 自动注入了 ApiService：'),
            const SizedBox(height: 16),
            Text('Repository: ${repository.hashCode}'),
            Text('ApiService: ${repository.apiService.hashCode}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('数据: ${repository.fetchData()}'),
                  ),
                );
              },
              child: const Text('测试依赖注入'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showNamedRegistrationExample(BuildContext context) {
    final getIt = GetIt.instance;
    final consoleLogger = getIt<Logger>(instanceName: 'console');
    final fileLogger = getIt<Logger>(instanceName: 'file');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('命名注册示例'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('同一个接口可以注册多个实现：'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                consoleLogger.log('这是控制台日志');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已输出到控制台')),
                );
              },
              child: const Text('使用控制台日志'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                fileLogger.log('这是文件日志');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已保存到文件')),
                );
              },
              child: const Text('使用文件日志'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showAsyncRegistrationExample(BuildContext context) async {
    final getIt = GetIt.instance;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('异步注册示例'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('正在初始化数据库...'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final db = await getIt.getAsync<DatabaseService>();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('数据库已初始化: ${db.isInitialized}'),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('错误: $e')),
                  );
                }
              },
              child: const Text('初始化数据库'),
            ),
          ],
        ),
      ),
    );
  }

  void _showParamFactoryExample(BuildContext context) {
    final getIt = GetIt.instance;
    final client1 = getIt<HttpClient>(param1: 'https://api.example.com');
    final client2 = getIt<HttpClient>(param1: 'https://api.test.com');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('带参数工厂示例'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('工厂可以接收参数创建实例：'),
            const SizedBox(height: 16),
            Text('客户端1: ${client1.baseUrl}'),
            Text('客户端2: ${client2.baseUrl}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('请求: ${client1.makeRequest('GET', '/users')}'),
                  ),
                );
              },
              child: const Text('测试 HTTP 客户端'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showUserManagementExample(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserManagementPage(),
      ),
    );
  }
}

// ==================== 服务类 ====================

/// 用户服务（单例）
class UserService {
  String _userName = '未设置';

  void setUserName(String name) {
    _userName = name;
    print('用户名已设置为: $_userName');
  }

  String getUserName() => _userName;
}

/// API 服务（懒加载单例）
class ApiService {
  ApiService() {
    print('ApiService 已创建（懒加载）');
  }

  String fetchData() {
    return '从 API 获取的数据';
  }
}

/// 数据仓库（工厂模式，依赖注入 ApiService）
class DataRepository {
  final ApiService apiService;

  DataRepository(this.apiService) {
    print('DataRepository 已创建，注入了 ApiService');
  }

  String fetchData() {
    return apiService.fetchData();
  }
}

/// 日志接口
abstract class Logger {
  void log(String message);
}

/// 控制台日志实现
class ConsoleLogger implements Logger {
  @override
  void log(String message) {
    print('[Console] $message');
  }
}

/// 文件日志实现
class FileLogger implements Logger {
  @override
  void log(String message) {
    print('[File] $message (模拟写入文件)');
  }
}

/// 数据库服务（异步初始化）
class DatabaseService {
  bool _isInitialized = false;

  Future<void> initialize() async {
    print('正在初始化数据库...');
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
    print('数据库初始化完成');
  }

  bool get isInitialized => _isInitialized;
}

/// HTTP 客户端（带参数工厂）
class HttpClient {
  final String baseUrl;

  HttpClient(this.baseUrl) {
    print('HttpClient 已创建，baseUrl: $baseUrl');
  }

  String makeRequest(String method, String path) {
    return '$method $baseUrl$path';
  }
}

// ==================== 实际应用场景示例 ====================

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 从 GetIt 获取服务
    final userService = GetIt.instance<UserService>();
    final apiService = GetIt.instance<ApiService>();
    final repository = GetIt.instance<DataRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理示例'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '实际应用场景',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前用户: ${userService.getUserName()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        userService.setUserName('李四');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('用户名已更新')),
                        );
                      },
                      child: const Text('更新用户名'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '数据获取',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('API 服务: ${apiService.hashCode}'),
                    Text('数据: ${repository.fetchData()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('数据: ${repository.fetchData()}'),
                          ),
                        );
                      },
                      child: const Text('刷新数据'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 提示',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '在实际项目中，GetIt 通常用于：\n'
                      '• 管理全局服务（API、数据库、缓存）\n'
                      '• 实现依赖注入，降低耦合\n'
                      '• 方便单元测试（可以替换 mock 对象）\n'
                      '• 管理应用生命周期内的单例',
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

