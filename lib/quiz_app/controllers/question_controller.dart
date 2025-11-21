import 'package:get/get.dart';
import '../data/database_helper.dart';
import '../models/question.dart';

/// 题目控制器
class QuestionController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // 响应式数据
  final RxList<Question> questions = <Question>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = ''.obs;
  final Rx<Question?> currentQuestion = Rx<Question?>(null);

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  /// 加载所有题目
  Future<void> loadQuestions() async {
    isLoading.value = true;
    try {
      final allQuestions = await _dbHelper.getAllQuestions();
      questions.value = allQuestions;
    } catch (e) {
      Get.snackbar('错误', '加载题目失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 根据分类加载题目
  Future<void> loadQuestionsByCategory(String category) async {
    isLoading.value = true;
    selectedCategory.value = category;
    try {
      final categoryQuestions = await _dbHelper.getQuestionsByCategory(category);
      questions.value = categoryQuestions;
    } catch (e) {
      Get.snackbar('错误', '加载题目失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载收藏的题目
  Future<void> loadFavoriteQuestions() async {
    isLoading.value = true;
    try {
      final favoriteQuestions = await _dbHelper.getFavoriteQuestions();
      questions.value = favoriteQuestions;
    } catch (e) {
      Get.snackbar('错误', '加载收藏题目失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载错题
  Future<void> loadWrongQuestions() async {
    isLoading.value = true;
    try {
      final wrongQuestions = await _dbHelper.getWrongQuestions();
      questions.value = wrongQuestions;
    } catch (e) {
      Get.snackbar('错误', '加载错题失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 添加题目
  Future<void> addQuestion(Question question) async {
    try {
      await _dbHelper.insertQuestion(question);
      await loadQuestions();
      Get.snackbar('成功', '题目添加成功');
    } catch (e) {
      Get.snackbar('错误', '添加题目失败: $e');
    }
  }

  /// 批量添加题目
  Future<void> addQuestions(List<Question> questions) async {
    try {
      print('📥 Controller: 开始批量插入 ${questions.length} 道题目...');
      await _dbHelper.insertQuestions(questions);
      print('✅ Controller: 数据库插入成功，开始重新加载题目列表...');
      await loadQuestions();
      print('✅ Controller: 题目列表重新加载完成，当前题目数: ${this.questions.length}');
      // 不在controller中显示snackbar，让调用者决定如何提示
    } catch (e, stackTrace) {
      print('❌ Controller: 导入题目失败: $e');
      print('堆栈: $stackTrace');
      rethrow; // 重新抛出异常，让调用者处理
    }
  }

  /// 更新题目
  Future<void> updateQuestion(Question question) async {
    try {
      await _dbHelper.updateQuestion(question);
      await loadQuestions();
      Get.snackbar('成功', '题目更新成功');
    } catch (e) {
      Get.snackbar('错误', '更新题目失败: $e');
    }
  }

  /// 删除题目
  Future<void> deleteQuestion(int id) async {
    try {
      await _dbHelper.deleteQuestion(id);
      // 重新加载题目列表
      await loadQuestions();
      // 使用更短的提示，避免干扰
      Get.snackbar(
        '成功',
        '题目删除成功',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        '错误',
        '删除题目失败: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      rethrow; // 重新抛出异常，让调用者知道删除失败
    }
  }

  /// 批量删除题目（不显示单个删除提示，提高效率）
  Future<void> deleteQuestionSilent(int id) async {
    await _dbHelper.deleteQuestion(id);
    // 不重新加载，由调用者统一处理
  }

  /// 批量删除所有题目
  Future<void> deleteAllQuestions() async {
    try {
      final allQuestions = await _dbHelper.getAllQuestions();
      for (var question in allQuestions) {
        if (question.id != null) {
          await _dbHelper.deleteQuestion(question.id!);
        }
      }
      // 重新加载题目列表
      await loadQuestions();
    } catch (e) {
      rethrow;
    }
  }

  /// 切换收藏状态
  Future<void> toggleFavorite(int id) async {
    try {
      final question = questions.firstWhere((q) => q.id == id);
      final newFavoriteStatus = !question.isFavorite;
      await _dbHelper.toggleFavorite(id, newFavoriteStatus);
      await loadQuestions();
    } catch (e) {
      Get.snackbar('错误', '操作失败: $e');
    }
  }

  /// 记录错误
  Future<void> recordWrongAnswer(int id) async {
    try {
      await _dbHelper.incrementWrongCount(id);
      await loadQuestions();
    } catch (e) {
      Get.snackbar('错误', '记录失败: $e');
    }
  }

  /// 设置当前题目
  void setCurrentQuestion(Question question) {
    currentQuestion.value = question;
  }

  /// 获取所有分类
  List<String> getCategories() {
    final categories = <String>{};
    for (var question in questions) {
      if (question.category != null && question.category!.isNotEmpty) {
        categories.add(question.category!);
      }
    }
    return categories.toList()..sort();
  }

  /// 获取题目统计
  Future<Map<String, int>> getStatistics() async {
    final total = await _dbHelper.getQuestionCount();
    final favorites = (await _dbHelper.getFavoriteQuestions()).length;
    final wrongs = (await _dbHelper.getWrongQuestions()).length;
    return {
      'total': total,
      'favorites': favorites,
      'wrongs': wrongs,
    };
  }
}

