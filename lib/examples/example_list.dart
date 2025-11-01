import 'package:flutter/material.dart';
import '01_basic_widgets.dart';
import '02_layouts.dart';
import '03_interactions.dart';

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

