import 'package:flutter/material.dart';
import '01_basic_widgets.dart';
import '02_layouts.dart';
import '03_interactions.dart';
import '04_navigation.dart';
import '05_state_management.dart';
import '06_network_request.dart';
import '07_data_persistence.dart';
import '08_getx_state_management.dart';

/// 示例列表页面
/// 可以在这里选择查看不同的示例
class ExampleListPage extends StatelessWidget {
  const ExampleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 学习示例'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          // 示例1：基础Widget
          _buildExampleCard(
            context,
            title: '示例1：基础Widget',
            description: '学习Text、Container、Row、Column等基础组件',
            icon: Icons.widgets,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BasicWidgetsExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 示例2：布局Widget
          _buildExampleCard(
            context,
            title: '示例2：布局Widget',
            description: '学习Padding、SizedBox、Expanded、Stack等布局组件',
            icon: Icons.view_quilt,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LayoutsExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 示例3：交互示例
          _buildExampleCard(
            context,
            title: '示例3：交互示例',
            description: '学习状态管理、用户交互、表单输入等',
            icon: Icons.touch_app,
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InteractionsExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 示例4：路由和导航
          _buildExampleCard(
            context,
            title: '示例4：路由和导航',
            description: '学习页面跳转、底部导航、抽屉导航等',
            icon: Icons.navigation,
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 示例5：状态管理
          _buildExampleCard(
            context,
            title: '示例5：状态管理 (Provider)',
            description: '学习使用Provider进行全局状态管理',
            icon: Icons.storage,
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StateManagementExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 示例6：网络请求
          _buildExampleCard(
            context,
            title: '示例6：网络请求',
            description: '学习HTTP请求、JSON解析、错误处理',
            icon: Icons.cloud,
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NetworkRequestExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 示例7：数据持久化
          _buildExampleCard(
            context,
            title: '示例7：数据持久化',
            description: '学习使用SharedPreferences保存数据',
            icon: Icons.save,
            color: Colors.deepPurple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataPersistenceExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 示例8：GetX 状态管理
          _buildExampleCard(
            context,
            title: '示例8：GetX 状态管理',
            description: '学习使用GetX进行响应式、依赖注入和路由管理',
            icon: Icons.bolt,
            color: Colors.orangeAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GetXExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建示例卡片
  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
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
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

