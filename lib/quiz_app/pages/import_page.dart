import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';
import '../services/import_service.dart';
import '../models/question.dart';

/// 导入页面
class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final ImportService _importService = ImportService.instance;
  final QuestionController _questionController = Get.find<QuestionController>();

  String? _selectedFilePath;
  String? _selectedFileName;
  List<int>? _selectedFileBytes; // Web平台使用
  List<Question> _previewQuestions = [];
  List<String> _errors = [];
  bool _isLoading = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入题目'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文件选择区域
            _buildFileSelectionSection(),

            const SizedBox(height: 24),

            // 预览区域
            if (_previewQuestions.isNotEmpty) _buildPreviewSection(),

            // 错误信息
            if (_errors.isNotEmpty) _buildErrorSection(),

            // 导入说明
            _buildInstructionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelectionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择文件',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedFilePath ?? '未选择文件',
                    style: TextStyle(
                      color: _selectedFilePath != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _selectFile,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('选择文件'),
                ),
              ],
            ),
            if (_selectedFilePath != null || _selectedFileBytes != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _parseFile,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.preview),
                label: const Text('预览'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '预览 (${_previewQuestions.length} 道题目)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_errors.isNotEmpty)
                  Chip(
                    label: Text('${_errors.length} 个错误'),
                    backgroundColor: Colors.red.shade100,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _previewQuestions.length,
                itemBuilder: (context, index) {
                  final question = _previewQuestions[index];
                  return _buildQuestionPreviewItem(question, index);
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isImporting ? null : _importQuestions,
              icon: _isImporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_isImporting ? '导入中...' : '导入题目'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPreviewItem(Question question, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(
          question.stem,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${question.type.displayName} | 答案: ${question.answer}',
        ),
        trailing: question.stemImage != null
            ? const Icon(Icons.image, color: Colors.blue)
            : null,
      ),
    );
  }

  Widget _buildErrorSection() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '错误信息',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ..._errors.take(10).map((error) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                )),
            if (_errors.length > 10)
              Text('... 还有 ${_errors.length - 10} 个错误'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '导入说明',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '支持的格式：Excel (.xlsx, .xls)、CSV (.csv) 或 Markdown (.md)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('必需字段：'),
            const Text('• 题干（或"题目"、"stem"）'),
            const Text('• 答案（或"answer"）'),
            const SizedBox(height: 8),
            const Text('可选字段：'),
            const Text('• 题型（单选题/多选题/判断题/填空题）'),
            const Text('• 选项A/B/C/D（或"选项A"/"A"等）'),
            const Text('• 选项A图片/B图片/C图片/D图片'),
            const Text('• 题干图片（或"题目图片"、"stem_image"）'),
            const Text('• 解析（或"analysis"）'),
            const Text('• 解析图片（或"analysis_image"）'),
            const Text('• 分类（或"章节"、"category"）'),
            const Text('• 标签（用逗号分隔）'),
            const SizedBox(height: 8),
            const Text(
              'Markdown格式示例：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('## 题目内容[单选题]'),
            const Text('**题型**: 单选题'),
            const Text('**题干**: 这是题目内容'),
            const Text('**选项A**: 选项A内容'),
            const Text('**选项B**: 选项B内容'),
            const Text('**答案**: A'),
            const Text('**解析**: 这是解析内容'),
            const Text('---'),
            const Text('（使用 --- 或空行分隔多个题目）'),
            const SizedBox(height: 8),
            const Text(
              '图片支持：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• 本地文件路径（如：C:/images/question1.jpg）'),
            const Text('• 网络URL（如：https://example.com/image.jpg）'),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    try {
      print('📁 开始选择文件...');
      final result = await _importService.pickFile();
      
      if (result == null) {
        print('⚠️ 用户取消了文件选择');
        Get.snackbar('提示', '未选择文件', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (result.files.isEmpty) {
        print('⚠️ 选择的文件列表为空');
        Get.snackbar('错误', '未选择文件', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final file = result.files.single;
      print('📄 选择的文件: ${file.name}');
      print('📊 文件大小: ${file.size} bytes');
      print('🔤 文件扩展名: ${file.extension}');
      print('🌐 平台: ${kIsWeb ? "Web" : "其他平台"}');

      if (kIsWeb) {
        // Web平台：使用bytes
        if (file.bytes == null) {
          print('❌ Web平台：文件bytes为空');
          Get.snackbar('错误', '无法读取文件内容', snackPosition: SnackPosition.BOTTOM);
          return;
        }
        setState(() {
          _selectedFilePath = null;
          _selectedFileName = file.name;
          _selectedFileBytes = file.bytes;
          _previewQuestions = [];
          _errors = [];
        });
        print('✅ Web平台：文件选择成功，文件名: $_selectedFileName');
      } else {
        // 其他平台：使用path
        if (file.path == null || file.path!.isEmpty) {
          print('❌ 文件路径为空');
          Get.snackbar('错误', '文件路径无效', snackPosition: SnackPosition.BOTTOM);
          return;
        }
        print('📂 文件路径: ${file.path}');
        setState(() {
          _selectedFilePath = file.path;
          _selectedFileName = file.name;
          _selectedFileBytes = null;
          _previewQuestions = [];
          _errors = [];
        });
        print('✅ 文件选择成功: $_selectedFilePath');
      }
      Get.snackbar(
        '成功',
        '已选择文件：${file.name}\n请点击"预览"按钮解析文件',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      print('❌ 选择文件失败: $e');
      print('📋 堆栈跟踪:');
      print(stackTrace);
      Get.snackbar(
        '错误',
        '选择文件失败: $e\n请查看控制台日志获取详细信息',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> _parseFile() async {
    if (_selectedFilePath == null && _selectedFileBytes == null) {
      Get.snackbar('提示', '请先选择文件', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Web平台：检查bytes
    if (kIsWeb) {
      if (_selectedFileBytes == null || _selectedFileBytes!.isEmpty) {
        Get.snackbar('错误', '文件内容为空', snackPosition: SnackPosition.BOTTOM);
        return;
      }
    } else {
      // 其他平台：检查文件是否存在
      if (_selectedFilePath == null) {
        Get.snackbar('错误', '文件路径无效', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final file = File(_selectedFilePath!);
      if (!await file.exists()) {
        Get.snackbar('错误', '文件不存在: $_selectedFilePath', snackPosition: SnackPosition.BOTTOM);
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _previewQuestions = [];
      _errors = [];
    });

    try {
      Get.snackbar('提示', '正在解析文件...', snackPosition: SnackPosition.BOTTOM);
      
      ImportResult result;
      if (kIsWeb) {
        // Web平台：使用bytes
        final fileName = _selectedFileName ?? 'file';
        print('🌐 Web平台：解析文件 $fileName');
        if (fileName.endsWith('.csv')) {
          result = await _importService.parseCsvFromBytes(_selectedFileBytes!, fileName);
        } else if (fileName.endsWith('.md')) {
          result = await _importService.parseMarkdownFromBytes(_selectedFileBytes!, fileName);
        } else {
          result = await _importService.parseExcelFromBytes(_selectedFileBytes!);
        }
      } else {
        // 其他平台：使用文件路径
        print('💻 其他平台：解析文件 $_selectedFilePath');
        if (_selectedFilePath!.endsWith('.csv')) {
          result = await _importService.parseCsvFile(_selectedFilePath!);
        } else if (_selectedFilePath!.endsWith('.md')) {
          result = await _importService.parseMarkdownFile(_selectedFilePath!);
        } else {
          result = await _importService.parseExcelFile(_selectedFilePath!);
        }
      }

      setState(() {
        _previewQuestions = result.questions;
        _errors = result.errors;
        _isLoading = false;
      });

      // 显示解析结果
      if (result.questions.isNotEmpty) {
        Get.snackbar(
          '解析成功',
          '成功解析 ${result.questions.length} 道题目${result.errors.isNotEmpty ? '，${result.errors.length} 个错误' : ''}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else if (result.errors.isNotEmpty) {
        Get.snackbar(
          '解析失败',
          '发现 ${result.errors.length} 个错误，请查看错误信息',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar('提示', '文件中没有找到有效题目，请检查文件格式', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      print('解析文件错误: $e');
      print('堆栈跟踪: $stackTrace');
      Get.snackbar(
        '错误',
        '解析文件失败: $e\n请检查文件格式是否正确',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> _importQuestions() async {
    if (_previewQuestions.isEmpty) return;

    setState(() {
      _isImporting = true;
    });

    try {
      await _questionController.addQuestions(_previewQuestions);
      Get.back(); // 返回上一页
      Get.snackbar('成功', '成功导入 ${_previewQuestions.length} 道题目');
    } catch (e) {
      Get.snackbar('错误', '导入失败: $e');
      print('导入失败: $e');
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }
}
