import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';
import '../services/test_data_generator.dart';
import '../services/import_service.dart';
import 'question_list_page.dart';
import 'practice_page.dart';
import 'import_page.dart';
import 'statistics_page.dart';

/// 刷题工具主页
class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final questionController = Get.put(QuestionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('刷题工具'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (questionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              title: '题库',
              icon: Icons.library_books,
              color: Colors.blue,
              onTap: () => Get.to(() => const QuestionListPage()),
            ),
            _buildMenuCard(
              context,
              title: '开始练习',
              icon: Icons.play_circle_filled,
              color: Colors.green,
              onTap: () => Get.to(() => const PracticePage()),
            ),
            _buildMenuCard(
              context,
              title: '导入题目',
              icon: Icons.upload_file,
              color: Colors.orange,
              onTap: () => Get.to(() => const ImportPage()),
            ),
            _buildMenuCard(
              context,
              title: '错题本',
              icon: Icons.error_outline,
              color: Colors.red,
              onTap: () {
                questionController.loadWrongQuestions();
                Get.to(() => const QuestionListPage());
              },
            ),
            _buildMenuCard(
              context,
              title: '收藏夹',
              icon: Icons.favorite,
              color: Colors.pink,
              onTap: () {
                questionController.loadFavoriteQuestions();
                Get.to(() => const QuestionListPage());
              },
            ),
            _buildMenuCard(
              context,
              title: '统计',
              icon: Icons.bar_chart,
              color: Colors.purple,
              onTap: () => Get.to(() => const StatisticsPage()),
            ),
            _buildMenuCard(
              context,
              title: '生成测试数据',
              icon: Icons.data_object,
              color: Colors.cyan,
              onTap: () => _generateTestData(context, questionController),
            ),
            _buildMenuCard(
              context,
              title: '导入内置题库',
              icon: Icons.folder_special,
              color: Colors.teal,
              onTap: () => _importBuiltInQuestions(context, questionController),
            ),
          ],
        );
      }),
    );
  }

  void _generateTestData(BuildContext context, QuestionController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('生成测试数据'),
        content: const Text('这将添加10道示例题目到题库中，是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                final questions = TestDataGenerator.generateSampleQuestions();
                await controller.addQuestions(questions);
                Get.snackbar(
                  '成功',
                  '已添加 ${questions.length} 道测试题目',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar('错误', '生成测试数据失败: $e');
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _importBuiltInQuestions(BuildContext context, QuestionController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('导入内置题库'),
        content: const Text('这将从assets目录导入"高级安卓工程师刷题.md"文件（200道题目），是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _loadAndImportQuestions(context, controller);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadAndImportQuestions(
    BuildContext context,
    QuestionController controller,
  ) async {
    // 显示加载对话框
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 从assets读取Markdown文件
      print('📖 开始从assets读取文件...');
      final content = await rootBundle.loadString('assets/高级安卓工程师刷题.md');
      
      if (content.isEmpty) {
        Get.back(); // 关闭加载对话框
        Get.snackbar('错误', '文件内容为空', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      print('✅ 文件读取成功，内容长度: ${content.length}');
      
      // 解析Markdown内容
      print('📝 开始解析Markdown内容...');
      final importService = ImportService.instance;
      final result = await importService.parseMarkdownFromBytes(
        content.codeUnits,
        '高级安卓工程师刷题.md',
      );

      Get.back(); // 关闭加载对话框

      if (result.questions.isEmpty) {
        Get.snackbar(
          '提示',
          '未能解析出题目，请检查文件格式\n错误: ${result.errors.take(3).join('\n')}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
        return;
      }

      // 导入题目
      print('📥 开始导入 ${result.questions.length} 道题目...');
      await controller.addQuestions(result.questions);

      // 显示成功消息
      final errorMsg = result.errors.isNotEmpty
          ? '\n警告: ${result.errors.length} 个题目解析失败'
          : '';
      
      Get.snackbar(
        '导入成功',
        '已导入 ${result.questions.length} 道题目$errorMsg',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      print('✅ 导入完成！成功: ${result.questions.length}, 失败: ${result.errors.length}');
    } catch (e, stackTrace) {
      Get.back(); // 关闭加载对话框
      print('❌ 导入失败: $e');
      print('堆栈: $stackTrace');
      Get.snackbar(
        '错误',
        '导入失败: $e\n请检查assets目录中是否存在该文件',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
