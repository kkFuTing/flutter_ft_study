import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';
import '../models/question.dart';
import 'question_detail_page.dart';

/// 题目列表页面
class QuestionListPage extends StatelessWidget {
  const QuestionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final questionController = Get.find<QuestionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('题目列表'),
        actions: [
          // 一键删除按钮
          if (questionController.questions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: '一键删除',
              onPressed: () => _showBatchDeleteDialog(context, questionController),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: () => questionController.loadQuestions(),
          ),
        ],
      ),
      body: Obx(() {
        if (questionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (questionController.questions.isEmpty) {
          return const Center(
            child: Text('暂无题目，快去导入一些题目吧！'),
          );
        }

        return ListView.builder(
          itemCount: questionController.questions.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final question = questionController.questions[index];
            return _buildQuestionCard(context, question, questionController, index);
          },
        );
      }),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    Question question,
    QuestionController controller,
    int index,
  ) {
    if (question.id == null) return const SizedBox();

    return Dismissible(
      key: Key('question_${question.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        if (!context.mounted) return false;
        return await _showDeleteConfirmDialog(context, question) ?? false;
      },
      onDismissed: (direction) {
        if (question.id != null) {
          // 滑动删除时直接删除，不需要确认（因为已经在confirmDismiss中确认过了）
          controller.deleteQuestion(question.id!);
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getTypeColor(question.type),
            child: Text(
              question.type.displayName[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            question.stem,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('答案: ${question.answer}'),
              if (question.category != null)
                Text('分类: ${question.category}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 删除按钮
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  // 阻止事件冒泡
                  _handleDelete(context, question, controller);
                },
                tooltip: '删除题目',
              ),
              if (question.isFavorite)
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                  onPressed: () {
                    // 阻止事件冒泡
                    controller.toggleFavorite(question.id!);
                  },
                  tooltip: '取消收藏',
                ),
              if (question.wrongCount > 0)
                Chip(
                  label: Text('错${question.wrongCount}次'),
                  backgroundColor: Colors.red.shade100,
                  labelStyle: const TextStyle(fontSize: 10),
                ),
            ],
          ),
          onTap: () {
            Get.to(() => QuestionDetailPage(question: question));
          },
          onLongPress: () {
            _showQuestionActions(context, question, controller);
          },
        ),
      ),
    );
  }

  /// 处理删除操作
  Future<void> _handleDelete(
    BuildContext context,
    Question question,
    QuestionController controller,
  ) async {
    if (question.id == null) return;
    if (!context.mounted) return;
    
    final confirmed = await _showDeleteConfirmDialog(context, question);
    if (confirmed == true && question.id != null) {
      try {
        // 删除前保存ID，因为删除后question可能被移除
        final questionId = question.id!;
        await controller.deleteQuestion(questionId);
        // 删除成功后，列表会自动刷新（因为controller会调用loadQuestions）
        // 页面会保持在当前状态，不会返回
      } catch (e) {
        if (context.mounted) {
          Get.snackbar('错误', '删除失败: $e');
        }
      }
    }
  }

  /// 显示删除确认对话框
  Future<bool?> _showDeleteConfirmDialog(BuildContext context, Question question) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // 允许点击外部关闭
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('确定要删除这道题目吗？'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    question.stem,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '此操作不可撤销！',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }

  /// 显示题目操作菜单
  void _showQuestionActions(
    BuildContext context,
    Question question,
    QuestionController controller,
  ) {
    if (question.id == null) return;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('查看详情'),
              onTap: () {
                Get.back();
                Get.to(() => QuestionDetailPage(question: question));
              },
            ),
            ListTile(
              leading: Icon(
                question.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: question.isFavorite ? Colors.red : null,
              ),
              title: Text(question.isFavorite ? '取消收藏' : '添加收藏'),
              onTap: () {
                Get.back();
                controller.toggleFavorite(question.id!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除题目', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _showDeleteConfirmDialog(context, question).then((confirmed) {
                  if (confirmed == true && question.id != null) {
                    controller.deleteQuestion(question.id!);
                  }
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('取消'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  /// 显示批量删除确认对话框
  void _showBatchDeleteDialog(
    BuildContext context,
    QuestionController controller,
  ) {
    final questionCount = controller.questions.length;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('一键删除'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('确定要删除所有 $questionCount 道题目吗？'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '此操作将删除题库中的所有题目，且不可撤销！',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _executeBatchDelete(context, controller);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('确认删除全部'),
            ),
          ],
        );
      },
    );
  }

  /// 执行批量删除
  Future<void> _executeBatchDelete(
    BuildContext context,
    QuestionController controller,
  ) async {
    if (!context.mounted) return;
    
    // 保存题目数量
    final questionCount = controller.questions.length;
    
    // 显示加载提示，并保存对话框的context
    BuildContext? loadingDialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        loadingDialogContext = dialogContext;
        return const Center(child: CircularProgressIndicator());
      },
    );

    // 确保对话框一定会被关闭
    try {
      print('🗑️ 开始批量删除 $questionCount 道题目...');
      
      // 使用批量删除方法
      await controller.deleteAllQuestions();
      
      print('✅ 批量删除完成');
    } catch (e, stackTrace) {
      print('❌ 批量删除失败: $e');
      print('堆栈: $stackTrace');
    } finally {
      // 无论成功还是失败，都要关闭加载提示
      if (loadingDialogContext != null) {
        try {
          Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
        } catch (e) {
          print('⚠️ 关闭对话框失败: $e');
          // 如果使用对话框context失败，尝试使用原始context
          if (context.mounted) {
            try {
              Navigator.of(context, rootNavigator: true).pop();
            } catch (e2) {
              print('⚠️ 使用原始context关闭对话框也失败: $e2');
            }
          }
        }
      } else if (context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (e) {
          print('⚠️ 关闭对话框失败: $e');
        }
      }
    }

    // 显示结果（在finally之后，确保对话框已关闭）
    if (context.mounted) {
      try {
        if (controller.questions.isEmpty) {
          Get.snackbar(
            '删除成功',
            '已删除 $questionCount 道题目',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            '删除完成',
            '已删除部分题目，剩余 ${controller.questions.length} 道',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        print('⚠️ 显示结果失败: $e');
      }
    }
  }

  Color _getTypeColor(QuestionType type) {
    switch (type) {
      case QuestionType.single:
        return Colors.blue;
      case QuestionType.multiple:
        return Colors.green;
      case QuestionType.judgment:
        return Colors.orange;
      case QuestionType.fill:
        return Colors.purple;
    }
  }
}

