import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';
import '../models/question.dart';

/// 练习页面
class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final QuestionController questionController = Get.find<QuestionController>();
  int currentIndex = 0;
  final Map<int, List<String>> selectedAnswers = {};
  final Map<int, TextEditingController> fillAnswerControllers = {}; // 填空题答案输入框控制器

  @override
  void dispose() {
    // 清理所有TextEditingController
    for (var controller in fillAnswerControllers.values) {
      controller.dispose();
    }
    fillAnswerControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('开始练习'),
        actions: [
          TextButton(
            onPressed: _submitAnswer,
            child: const Text('提交答案', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Obx(() {
        if (questionController.questions.isEmpty) {
          return const Center(
            child: Text('暂无题目，快去导入一些题目吧！'),
          );
        }

        if (currentIndex >= questionController.questions.length) {
          return const Center(
            child: Text('练习完成！'),
          );
        }

        final question = questionController.questions[currentIndex];
        return _buildQuestionView(question);
      }),
      bottomNavigationBar: Obx(() {
        if (questionController.questions.isEmpty) return const SizedBox();
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentIndex > 0 ? _previousQuestion : null,
                child: const Text('上一题'),
              ),
              Text(
                '${currentIndex + 1} / ${questionController.questions.length}',
                style: const TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: currentIndex < questionController.questions.length - 1
                    ? _nextQuestion
                    : null,
                child: const Text('下一题'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuestionView(Question question) {
    final questionId = question.id;
    
    // 为填空题初始化输入框控制器
    if (question.type == QuestionType.fill && questionId != null) {
      fillAnswerControllers[questionId] ??= TextEditingController(
        text: selectedAnswers[questionId]?.join(',') ?? '',
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题干
          Text(
            question.stem,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 根据题型显示不同的输入方式
          if (question.type == QuestionType.fill)
            _buildFillBlankInput(question)
          else
            ...question.options.map((option) => _buildOptionItem(question, option)),

          const SizedBox(height: 16),

          // 显示答案按钮
          ElevatedButton(
            onPressed: _showAnswer,
            child: const Text('查看答案'),
          ),
        ],
      ),
    );
  }

  /// 构建填空题输入框
  Widget _buildFillBlankInput(Question question) {
    final questionId = question.id;
    if (questionId == null) return const SizedBox();
    
    final controller = fillAnswerControllers[questionId] ?? TextEditingController();
    
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: '请输入答案',
        hintText: '在此输入你的答案',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          // 将输入的答案保存到 selectedAnswers
          selectedAnswers[questionId] = value.trim().isEmpty ? [] : [value.trim()];
        });
      },
      maxLines: 3,
    );
  }

  Widget _buildOptionItem(Question question, Option option) {
    final questionId = question.id;
    if (questionId == null) return const SizedBox();
    
    final isSelected = selectedAnswers[questionId]?.contains(option.label) ?? false;
    final isMultiple = question.type == QuestionType.multiple;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue.shade100 : null,
      child: isMultiple
          ? _buildMultipleChoiceItem(question, option, isSelected)
          : _buildSingleChoiceItem(question, option, isSelected),
    );
  }

  Widget _buildMultipleChoiceItem(Question question, Option option, bool isSelected) {
    return InkWell(
      onTap: () => _toggleOption(question, option.label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                // 只通过 Checkbox 触发，不通过 ListTile
                _toggleOption(question, option.label);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(option.content)),
                    ],
                  ),
                  if (option.image != null) ...[
                    const SizedBox(height: 8),
                    Image.network(
                      option.image!,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('图片加载失败');
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleChoiceItem(Question question, Option option, bool isSelected) {
    final questionId = question.id!;
    return ListTile(
      leading: Radio<String>(
        value: option.label,
        groupValue: selectedAnswers[questionId]?.firstOrNull,
        onChanged: (value) => _toggleOption(question, option.label),
      ),
      title: Text(option.content),
      subtitle: option.image != null
          ? Image.network(
              option.image!,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Text('图片加载失败');
              },
            )
          : null,
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
      onTap: () => _toggleOption(question, option.label),
    );
  }

  void _toggleOption(Question question, String optionLabel) {
    final questionId = question.id;
    if (questionId == null) return;
    
    print('🔘 切换选项: 题目ID=$questionId, 选项=$optionLabel, 题型=${question.type}');
    
    setState(() {
      // 确保列表已初始化
      selectedAnswers[questionId] ??= [];

      if (question.type == QuestionType.single || question.type == QuestionType.judgment) {
        // 单选题或判断题，只能选一个
        print('  单选/判断：直接替换为 $optionLabel');
        selectedAnswers[questionId] = [optionLabel];
      } else if (question.type == QuestionType.multiple) {
        // 多选题：切换选中状态
        final answers = selectedAnswers[questionId]!;
        print('  多选：当前答案=$answers');
        if (answers.contains(optionLabel)) {
          answers.remove(optionLabel);
          print('  多选：移除 $optionLabel，现在=$answers');
        } else {
          answers.add(optionLabel);
          print('  多选：添加 $optionLabel，现在=$answers');
        }
      }
    });
    
    // 打印最终状态
    print('✅ 最终答案: ${selectedAnswers[questionId]}');
  }

  void _showAnswer() {
    final question = questionController.questions[currentIndex];
    final questionId = question.id;
    if (questionId == null) return;
    
    String userAnswer;
    String correctAnswer;
    bool isCorrect;
    
    if (question.type == QuestionType.fill) {
      // 填空题：直接比较文本，不排序
      userAnswer = selectedAnswers[questionId]?.firstOrNull ?? '';
      correctAnswer = question.answer;
      // 去除首尾空格后比较
      isCorrect = userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
    } else {
      // 选择题：对答案进行排序后比较
      final userAnswerList = selectedAnswers[questionId] ?? [];
      userAnswerList.sort();
      userAnswer = userAnswerList.join(',');
      
      final correctAnswerList = question.answer.split(',').map((e) => e.trim()).toList()..sort();
      correctAnswer = correctAnswerList.join(',');
      
      isCorrect = userAnswer == correctAnswer;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isCorrect ? '回答正确！' : '回答错误'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('你的答案: ${userAnswer.isEmpty ? "未作答" : userAnswer}'),
                const SizedBox(height: 8),
                Text('正确答案: $correctAnswer'),
                if (question.analysis != null) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('解析:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(question.analysis!),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!isCorrect) {
                  questionController.recordWrongAnswer(questionId);
                }
                Navigator.of(dialogContext).pop(); // 只关闭当前Dialog
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _submitAnswer() {
    final question = questionController.questions[currentIndex];
    final questionId = question.id;
    if (questionId == null) return;
    
    String userAnswer;
    String correctAnswer;
    bool isCorrect;
    
    if (question.type == QuestionType.fill) {
      // 填空题：直接比较文本，不排序
      userAnswer = selectedAnswers[questionId]?.firstOrNull ?? '';
      correctAnswer = question.answer;
      // 去除首尾空格后比较（不区分大小写）
      isCorrect = userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
    } else {
      // 选择题：对答案进行排序后比较
      final userAnswerList = selectedAnswers[questionId] ?? [];
      userAnswerList.sort();
      userAnswer = userAnswerList.join(',');
      
      final correctAnswerList = question.answer.split(',').map((e) => e.trim()).toList()..sort();
      correctAnswer = correctAnswerList.join(',');
      
      isCorrect = userAnswer == correctAnswer;
    }

    if (!isCorrect) {
      questionController.recordWrongAnswer(questionId);
    }

    Get.snackbar(
      isCorrect ? '回答正确！' : '回答错误',
      '你的答案: ${userAnswer.isEmpty ? "未作答" : userAnswer}\n正确答案: $correctAnswer',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _nextQuestion() {
    if (currentIndex < questionController.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }
}
