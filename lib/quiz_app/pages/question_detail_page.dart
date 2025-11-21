import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';
import '../models/question.dart';

/// 题目详情页面
class QuestionDetailPage extends StatelessWidget {
  final Question question;

  const QuestionDetailPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final questionController = Get.find<QuestionController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(question.type.displayName),
        actions: [
          IconButton(
            icon: Icon(
              question.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: question.isFavorite ? Colors.red : null,
            ),
            onPressed: () => questionController.toggleFavorite(question.id!),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题干
            Text(
              '题目',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              question.stem,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (question.stemImage != null) ...[
              const SizedBox(height: 8),
              Image.asset(question.stemImage!),
            ],
            const Divider(height: 32),

            // 选项
            Text(
              '选项',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...question.options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            option.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.content),
                            if (option.image != null)
                              Image.asset(option.image!),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const Divider(height: 32),

            // 答案
            Text(
              '答案',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                question.answer,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 32),

            // 解析
            if (question.analysis != null) ...[
              Text(
                '解析',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(question.analysis!),
              if (question.analysisImage != null) ...[
                const SizedBox(height: 8),
                Image.asset(question.analysisImage!),
              ],
            ],

            // 其他信息
            const Divider(height: 32),
            if (question.category != null)
              Text('分类: ${question.category}'),
            if (question.tags.isNotEmpty)
              Text('标签: ${question.tags.join(", ")}'),
            Text('错误次数: ${question.wrongCount}'),
          ],
        ),
      ),
    );
  }
}

