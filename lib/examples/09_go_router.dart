import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// GoRouter 路由管理示例
/// 展示 GoRouter 的核心功能：声明式路由、参数传递、嵌套路由、路由守卫等
class GoRouterExample extends StatelessWidget {
  const GoRouterExample({super.key});

  // 创建路由配置
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // 1. 基础路由
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const GoRouterHomePage(),
      ),

      // 2. 带路径参数的路由
      GoRoute(
        path: '/user/:id',
        name: 'user',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UserDetailPage(userId: id);
        },
      ),

      // 3. 带查询参数的路由
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          final category = state.uri.queryParameters['category'] ?? '';
          return SearchPage(query: query, category: category);
        },
      ),

      // 4. 嵌套路由（Shell Route）
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(state.uri.path),
              onTap: (index) => _onItemTapped(index, context),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: '收藏',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/tabs/home',
            name: 'tabs-home',
            builder: (context, state) => const TabsHomePage(),
          ),
          GoRoute(
            path: '/tabs/favorite',
            name: 'tabs-favorite',
            builder: (context, state) => const TabsFavoritePage(),
          ),
          GoRoute(
            path: '/tabs/profile',
            name: 'tabs-profile',
            builder: (context, state) => const TabsProfilePage(),
          ),
        ],
      ),

      // 5. 带路由守卫的路由（需要登录）
      GoRoute(
        path: '/protected',
        name: 'protected',
        redirect: (context, state) {
          // 模拟检查登录状态
          final isLoggedIn = AuthService.instance.isLoggedIn;
          if (!isLoggedIn) {
            return '/login';
          }
          return null; // null 表示允许访问
        },
        builder: (context, state) => const ProtectedPage(),
      ),

      // 6. 登录页面
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // 7. 详情页面（带可选参数）
      GoRoute(
        path: '/product/:id',
        name: 'product',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final color = state.uri.queryParameters['color'];
          return ProductDetailPage(productId: id, color: color);
        },
      ),

      // 8. 错误页面
      GoRoute(
        path: '/error',
        name: 'error',
        builder: (context, state) {
          final error = state.uri.queryParameters['message'] ?? '未知错误';
          return ErrorPage(message: error);
        },
      ),
    ],

    // 错误处理
    errorBuilder:
        (context, state) => ErrorPage(message: '页面未找到: ${state.uri.path}'),

    // 路由重定向（全局守卫）
    redirect: (context, state) {
      // 可以在这里实现全局路由守卫逻辑
      // 例如：检查用户权限、维护模式等
      return null;
    },
  );

  // 计算底部导航栏选中索引
  static int _calculateSelectedIndex(String location) {
    if (location.startsWith('/tabs/home')) return 0;
    if (location.startsWith('/tabs/favorite')) return 1;
    if (location.startsWith('/tabs/profile')) return 2;
    return 0;
  }

  // 底部导航栏点击处理
  static void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/tabs/home');
        break;
      case 1:
        context.go('/tabs/favorite');
        break;
      case 2:
        context.go('/tabs/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter 示例',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

// ==================== 页面组件 ====================

/// 首页
class GoRouterHomePage extends StatelessWidget {
  const GoRouterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoRouter 示例'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('基础路由'),
          _buildExampleCard(
            context,
            title: '路径参数示例',
            description: '访问 /user/:id 路由',
            icon: Icons.person,
            color: Colors.blue,
            onTap: () {
              // 使用 context.push() 推入新页面（可以返回）
              context.push('/user/123');
            },
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '查询参数示例',
            description: '访问 /search?q=flutter&category=tech',
            icon: Icons.search,
            color: Colors.green,
            onTap: () {
              // 使用 Uri 构建查询参数
              context.go('/search?q=flutter&category=tech');
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('嵌套路由'),
          _buildExampleCard(
            context,
            title: '底部导航栏示例',
            description: '使用 ShellRoute 实现嵌套路由',
            icon: Icons.view_quilt,
            color: Colors.purple,
            onTap: () {
              context.go('/tabs/home');
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('路由守卫'),
          _buildExampleCard(
            context,
            title: '受保护页面',
            description: '需要登录才能访问',
            icon: Icons.lock,
            color: Colors.orange,
            onTap: () {
              context.go('/protected');
            },
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '登录页面',
            description: '模拟登录功能',
            icon: Icons.login,
            color: Colors.teal,
            onTap: () {
              context.go('/login');
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('其他功能'),
          _buildExampleCard(
            context,
            title: '产品详情（可选参数）',
            description: '访问 /product/:id?color=red',
            icon: Icons.shopping_bag,
            color: Colors.red,
            onTap: () {
              context.go('/product/456?color=red');
            },
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '错误页面',
            description: '展示错误处理',
            icon: Icons.error,
            color: Colors.red,
            onTap: () {
              context.go('/error?message=这是一个错误示例');
            },
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '404 页面',
            description: '访问不存在的路由',
            icon: Icons.help_outline,
            color: Colors.grey,
            onTap: () {
              context.go('/not-exists');
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('导航方法对比'),
          _buildInfoCard(
            'context.go(path)',
            '替换当前路由栈，不能返回\n适用场景：底部导航、登录后跳转、重置导航栈',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'context.push(path)',
            '推入新路由，可以返回\n适用场景：详情页、表单页、需要返回的页面',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildInfoCard('context.pop()', '返回上一页（仅用于 push 的页面）', Colors.orange),
          const SizedBox(height: 24),
          _buildSectionTitle('go() 使用场景演示'),
          _buildExampleCard(
            context,
            title: '场景1：底部导航切换',
            description: '使用 go() 切换标签页（不需要返回）',
            icon: Icons.swap_horiz,
            color: Colors.blue,
            onTap: () {
              context.go('/tabs/home');
            },
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '场景2：登录后跳转',
            description: '登录成功后使用 go() 清除登录页',
            icon: Icons.login,
            color: Colors.green,
            onTap: () {
              // 模拟登录后跳转
              AuthService.instance.login();
              context.go('/protected');
            },
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '场景3：重置导航栈',
            description: '从任意页面直接返回首页（清除所有历史）',
            icon: Icons.home,
            color: Colors.orange,
            onTap: () {
              context.go('/');
            },
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

/// 用户详情页（路径参数）
class UserDetailPage extends StatelessWidget {
  final String userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 检查是否可以返回（使用 push 进入的可以返回）
            if (context.canPop()) {
              context.pop();
            } else {
              // 如果不能返回，使用 go 返回首页
              context.go('/');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              '用户ID: $userId',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 使用 context.push() 推入新页面（可以返回）
                context.push('/user/999');
              },
              child: const Text('查看另一个用户'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 使用 context.go() 替换当前页面（不能返回）
                context.go('/user/888');
              },
              child: const Text('替换为其他用户'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 搜索页面（查询参数）
class SearchPage extends StatelessWidget {
  final String query;
  final String category;

  const SearchPage({super.key, required this.query, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索结果'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              '搜索关键词: ${query.isEmpty ? "无" : query}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              '分类: ${category.isEmpty ? "全部" : category}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 修改查询参数
                context.go('/search?q=dart&category=mobile');
              },
              child: const Text('修改搜索条件'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部导航栏 - 首页
class TabsHomePage extends StatelessWidget {
  const TabsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('首页'), backgroundColor: Colors.blue),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: Colors.blue),
            SizedBox(height: 24),
            Text('这是首页', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

/// 底部导航栏 - 收藏页
class TabsFavoritePage extends StatelessWidget {
  const TabsFavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收藏'), backgroundColor: Colors.purple),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 80, color: Colors.purple),
            SizedBox(height: 24),
            Text('这是收藏页', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

/// 底部导航栏 - 个人中心
class TabsProfilePage extends StatelessWidget {
  const TabsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的'), backgroundColor: Colors.teal),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.teal),
            SizedBox(height: 24),
            Text('这是个人中心', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

/// 受保护页面（需要登录）
class ProtectedPage extends StatelessWidget {
  const ProtectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('受保护页面'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            const Text('这是受保护页面', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text(
              '当前登录状态: ${AuthService.instance.isLoggedIn ? "已登录" : "未登录"}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                AuthService.instance.logout();
                context.go('/');
              },
              child: const Text('退出登录'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 登录页面
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录'), backgroundColor: Colors.teal),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                '模拟登录',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // 模拟登录成功
                  AuthService.instance.login();
                  // 登录成功后返回上一页或跳转到受保护页面
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/protected');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text('点击登录'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/');
                },
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 产品详情页（路径参数 + 查询参数）
class ProductDetailPage extends StatelessWidget {
  final String productId;
  final String? color;

  const ProductDetailPage({super.key, required this.productId, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('产品详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              '产品ID: $productId',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (color != null) ...[
              const SizedBox(height: 16),
              Text(
                '颜色: $color',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // 修改查询参数
                context.go('/product/$productId?color=blue');
              },
              child: const Text('切换颜色'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 错误页面
class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('错误'), backgroundColor: Colors.red),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                '发生错误',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 服务类 ====================

/// 认证服务（模拟）
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static AuthService get instance => _instance;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
  }

  void logout() {
    _isLoggedIn = false;
  }
}
