import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';

/// 统计页面
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final questionController = Get.find<QuestionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: questionController.getStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('暂无数据'));
          }

          final stats = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatCard(
                context,
                title: '题目总数',
                value: stats['total'] ?? 0,
                icon: Icons.library_books,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                context,
                title: '收藏题目',
                value: stats['favorites'] ?? 0,
                icon: Icons.favorite,
                color: Colors.pink,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                context,
                title: '错题数量',
                value: stats['wrongs'] ?? 0,
                icon: Icons.error_outline,
                color: Colors.red,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$value',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
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

