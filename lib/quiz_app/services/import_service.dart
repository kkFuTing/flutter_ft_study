import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import '../models/question.dart';
import 'image_service.dart';

/// 导入结果
class ImportResult {
  final List<Question> questions;
  final List<String> errors;
  final int successCount;
  final int failCount;

  ImportResult({
    required this.questions,
    required this.errors,
  })  : successCount = questions.length,
        failCount = errors.length;
}

/// 导入服务
class ImportService {
  static final ImportService instance = ImportService._init();
  final ImageService _imageService = ImageService.instance;

  ImportService._init();

  /// 选择文件
  Future<FilePickerResult?> pickFile() async {
    try {
      print('🔍 打开文件选择器...');
      print('📋 允许的扩展名: xlsx, xls, csv, md');
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv', 'md'],
      );

      if (result == null) {
        print('⚠️ 文件选择器返回null（用户可能取消了）');
        return null;
      }

      print('✅ 文件选择器返回结果');
      print('📁 选择的文件数量: ${result.files.length}');
      
      if (result.files.isNotEmpty) {
        final file = result.files.first;
        print('📄 第一个文件: ${file.name}');
        if (kIsWeb) {
          // Web平台：只访问bytes，不访问path
          print('📦 文件bytes: ${file.bytes?.length ?? 0} bytes');
        } else {
          // 其他平台：可以访问path
          if (file.path != null) {
            print('📂 文件路径: ${file.path}');
          }
        }
      }

      return result;
    } catch (e, stackTrace) {
      print('❌ 选择文件失败: $e');
      print('📋 错误类型: ${e.runtimeType}');
      print('📋 堆栈跟踪:');
      print(stackTrace);
      rethrow; // 重新抛出异常，让调用者处理
    }
  }

  /// 解析Excel文件（从文件路径）
  Future<ImportResult> parseExcelFile(String filePath) async {
    final questions = <Question>[];
    final errors = <String>[];

    try {
      // 检查文件是否存在
      final file = File(filePath);
      if (!await file.exists()) {
        errors.add('文件不存在: $filePath');
        return ImportResult(questions: questions, errors: errors);
      }

      // 读取文件
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        errors.add('文件为空');
        return ImportResult(questions: questions, errors: errors);
      }

      final rows = _decodeExcelRows(bytes, errors);
      if (rows == null) {
        return ImportResult(questions: questions, errors: errors);
      }

      // 检测并读取表头
      final headers = <String, int>{};
      int dataStartIndex = 1; // 默认从第二行开始（第一行是表头）
      
      if (rows.isEmpty) {
        errors.add('Excel文件为空，没有数据行');
        return ImportResult(questions: questions, errors: errors);
      }
      
      final firstRow = rows[0];
      if (firstRow.isEmpty) {
        errors.add('第一行为空');
        return ImportResult(questions: questions, errors: errors);
      }

      // 检测第一行是否是表头
      final hasHeader = _isHeaderRow(firstRow);
      
      if (hasHeader) {
        // 第一行是表头，解析表头
        print('📋 检测到表头行，解析表头...');
        for (int i = 0; i < firstRow.length; i++) {
          final header = _getCellValueFromDynamic(firstRow, i);
          if (header.isNotEmpty) {
            headers[header.toLowerCase()] = i;
          }
        }

        // 检查必需字段
        if (!headers.containsKey('题干') && !headers.containsKey('题目') && !headers.containsKey('stem')) {
          errors.add('缺少必需字段：题干（或"题目"、"stem"）');
        }
        if (!headers.containsKey('答案') && !headers.containsKey('answer')) {
          errors.add('缺少必需字段：答案（或"answer"）');
        }
        
        dataStartIndex = 1; // 从第二行开始读取数据
      } else {
        // 第一行不是表头，使用默认表头映射
        print('📋 未检测到表头，使用默认列映射（第0列=题干，第1列=答案，第2列=题型，第3列起=选项）');
        final columnCount = firstRow.length;
        headers.addAll(_createDefaultHeaders(columnCount));
        dataStartIndex = 0; // 从第一行开始读取数据
      }

      // 检查是否有数据行
      if (rows.length <= dataStartIndex) {
        if (errors.isEmpty) {
          errors.add('Excel文件中没有数据行');
        }
        return ImportResult(questions: questions, errors: errors);
      }

      for (int rowIndex = dataStartIndex; rowIndex < rows.length; rowIndex++) {
        try {
          final row = rows[rowIndex];
          if (row.isEmpty) {
            continue; // 跳过空行
          }

          // 检查是否整行都为空
          bool isEmptyRow = true;
          for (var cell in row) {
            final value = _getCellValue(cell);
            if (value.trim().isNotEmpty) {
              isEmptyRow = false;
              break;
            }
          }
          if (isEmptyRow) continue;

          final question = await _parseRow(row, headers, rowIndex + 1);
          if (question != null) {
            questions.add(question);
          } else {
            errors.add('第${rowIndex + 1}行：数据格式错误或缺少必需字段');
          }
        } catch (e, stackTrace) {
          print('解析第${rowIndex + 1}行时出错: $e');
          print('堆栈: $stackTrace');
          errors.add('第${rowIndex + 1}行：${e.toString()}');
        }
      }
    } catch (e) {
      errors.add('解析Excel文件失败：$e');
    }

    return ImportResult(questions: questions, errors: errors);
  }

  /// 解析Excel文件（从bytes，用于Web平台）
  Future<ImportResult> parseExcelFromBytes(List<int> bytes) async {
    final questions = <Question>[];
    final errors = <String>[];

    try {
      if (bytes.isEmpty) {
        errors.add('文件内容为空');
        return ImportResult(questions: questions, errors: errors);
      }

      final rows = _decodeExcelRows(bytes, errors);
      if (rows == null) {
        return ImportResult(questions: questions, errors: errors);
      }

      // 检测并读取表头
      final headers = <String, int>{};
      int dataStartIndex = 1; // 默认从第二行开始（第一行是表头）
      
      if (rows.isEmpty) {
        errors.add('Excel文件为空，没有数据行');
        return ImportResult(questions: questions, errors: errors);
      }
      
      final firstRow = rows[0];
      if (firstRow.isEmpty) {
        errors.add('第一行为空');
        return ImportResult(questions: questions, errors: errors);
      }

      // 检测第一行是否是表头
      final hasHeader = _isHeaderRow(firstRow);
      
      if (hasHeader) {
        // 第一行是表头，解析表头
        print('📋 检测到表头行，解析表头...');
        for (int i = 0; i < firstRow.length; i++) {
          final header = _getCellValueFromDynamic(firstRow, i);
          if (header.isNotEmpty) {
            headers[header.toLowerCase()] = i;
          }
        }

        // 检查必需字段
        if (!headers.containsKey('题干') && !headers.containsKey('题目') && !headers.containsKey('stem')) {
          errors.add('缺少必需字段：题干（或"题目"、"stem"）');
        }
        if (!headers.containsKey('答案') && !headers.containsKey('answer')) {
          errors.add('缺少必需字段：答案（或"answer"）');
        }
        
        dataStartIndex = 1; // 从第二行开始读取数据
      } else {
        // 第一行不是表头，使用默认表头映射
        print('📋 未检测到表头，使用默认列映射（第0列=题干，第1列=答案，第2列=题型，第3列起=选项）');
        final columnCount = firstRow.length;
        headers.addAll(_createDefaultHeaders(columnCount));
        dataStartIndex = 0; // 从第一行开始读取数据
      }

      // 检查是否有数据行
      if (rows.length <= dataStartIndex) {
        if (errors.isEmpty) {
          errors.add('Excel文件中没有数据行');
        }
        return ImportResult(questions: questions, errors: errors);
      }

      for (int rowIndex = dataStartIndex; rowIndex < rows.length; rowIndex++) {
        try {
          final row = rows[rowIndex];
          if (row.isEmpty) {
            continue; // 跳过空行
          }

          // 检查是否整行都为空
          bool isEmptyRow = true;
          for (var cellIndex = 0; cellIndex < row.length; cellIndex++) {
            final value = _getCellValueFromDynamic(row, cellIndex);
            if (value.trim().isNotEmpty) {
              isEmptyRow = false;
              break;
            }
          }
          if (isEmptyRow) continue;

          final question = await _parseRow(row, headers, rowIndex + 1);
          if (question != null) {
            questions.add(question);
          } else {
            errors.add('第${rowIndex + 1}行：数据格式错误或缺少必需字段');
          }
        } catch (e, stackTrace) {
          print('解析第${rowIndex + 1}行时出错: $e');
          print('堆栈: $stackTrace');
          errors.add('第${rowIndex + 1}行：${e.toString()}');
        }
      }
    } catch (e) {
      errors.add('解析Excel文件失败：$e');
      print('解析Excel文件失败：$e');
    }

    return ImportResult(questions: questions, errors: errors);
  }

  /// 解析CSV文件（从文件路径）
  Future<ImportResult> parseCsvFile(String filePath) async {
    final questions = <Question>[];
    final errors = <String>[];

    try {
      final lines = await File(filePath).readAsLines();
      if (lines.isEmpty) {
        errors.add('CSV文件为空');
        return ImportResult(questions: questions, errors: errors);
      }

      // 检测并解析表头
      final headers = <String, int>{};
      int dataStartIndex = 1; // 默认从第二行开始（第一行是表头）
      
      final firstLine = lines[0];
      final firstLineValues = _parseCsvLine(firstLine);
      
      // 检测第一行是否是表头
      final hasHeader = _isHeaderRowFromStrings(firstLineValues);
      
      if (hasHeader) {
        // 第一行是表头，解析表头
        print('📋 检测到表头行，解析表头...');
        for (int i = 0; i < firstLineValues.length; i++) {
          final header = firstLineValues[i].trim().toLowerCase();
          if (header.isNotEmpty) {
            headers[header] = i;
          }
        }
        dataStartIndex = 1; // 从第二行开始读取数据
      } else {
        // 第一行不是表头，使用默认表头映射
        print('📋 未检测到表头，使用默认列映射（第0列=题干，第1列=答案，第2列=题型，第3列起=选项）');
        final columnCount = firstLineValues.length;
        headers.addAll(_createDefaultHeaders(columnCount));
        dataStartIndex = 0; // 从第一行开始读取数据
      }

      // 解析数据行
      for (int rowIndex = dataStartIndex; rowIndex < lines.length; rowIndex++) {
        try {
          final line = lines[rowIndex];
          if (line.trim().isEmpty) continue;

          final values = _parseCsvLine(line);
          final question = await _parseRow(values, headers, rowIndex + 1);
          if (question != null) {
            questions.add(question);
          } else {
            errors.add('第${rowIndex + 1}行：数据格式错误');
          }
        } catch (e) {
          errors.add('第${rowIndex + 1}行：${e.toString()}');
        }
      }
    } catch (e) {
      errors.add('解析CSV文件失败：$e');
    }

    return ImportResult(questions: questions, errors: errors);
  }

  /// 解析CSV文件（从bytes，用于Web平台）
  Future<ImportResult> parseCsvFromBytes(List<int> bytes, String fileName) async {
    final questions = <Question>[];
    final errors = <String>[];

    try {
      // 将bytes转换为字符串
      final content = String.fromCharCodes(bytes);
      if (content.isEmpty) {
        errors.add('CSV文件为空');
        return ImportResult(questions: questions, errors: errors);
      }

      final lines = content.split('\n');
      if (lines.isEmpty) {
        errors.add('CSV文件为空');
        return ImportResult(questions: questions, errors: errors);
      }

      // 检测并解析表头
      final headers = <String, int>{};
      int dataStartIndex = 1; // 默认从第二行开始（第一行是表头）
      
      final firstLine = lines[0];
      final firstLineValues = _parseCsvLine(firstLine);
      
      // 检测第一行是否是表头
      final hasHeader = _isHeaderRowFromStrings(firstLineValues);
      
      if (hasHeader) {
        // 第一行是表头，解析表头
        print('📋 检测到表头行，解析表头...');
        for (int i = 0; i < firstLineValues.length; i++) {
          final header = firstLineValues[i].trim().toLowerCase();
          if (header.isNotEmpty) {
            headers[header] = i;
          }
        }
        dataStartIndex = 1; // 从第二行开始读取数据
      } else {
        // 第一行不是表头，使用默认表头映射
        print('📋 未检测到表头，使用默认列映射（第0列=题干，第1列=答案，第2列=题型，第3列起=选项）');
        final columnCount = firstLineValues.length;
        headers.addAll(_createDefaultHeaders(columnCount));
        dataStartIndex = 0; // 从第一行开始读取数据
      }

      // 解析数据行
      for (int rowIndex = dataStartIndex; rowIndex < lines.length; rowIndex++) {
        try {
          final line = lines[rowIndex];
          if (line.trim().isEmpty) continue;

          final values = _parseCsvLine(line);
          final question = await _parseRow(values, headers, rowIndex + 1);
          if (question != null) {
            questions.add(question);
          } else {
            errors.add('第${rowIndex + 1}行：数据格式错误');
          }
        } catch (e) {
          errors.add('第${rowIndex + 1}行：${e.toString()}');
        }
      }
    } catch (e) {
      errors.add('解析CSV文件失败：$e');
    }

    return ImportResult(questions: questions, errors: errors);
  }

  /// 解码Excel字节为行数据
  List<List<dynamic>>? _decodeExcelRows(List<int> bytes, List<String> errors) {
    try {
      final excel = Excel.decodeBytes(bytes);
      if (excel.tables.isEmpty) {
        errors.add('Excel文件中没有工作表');
        return null;
      }
      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName];
      if (sheet == null) {
        errors.add('Excel文件格式错误：找不到工作表');
        return null;
      }
      return sheet.rows;
    } catch (e) {
      print('⚠️ Excel包解析失败，尝试备用解析: $e');
      try {
        final decoder = SpreadsheetDecoder.decodeBytes(Uint8List.fromList(bytes), update: false);
        if (decoder.tables.isEmpty) {
          errors.add('Excel文件中没有工作表');
          return null;
        }
        final tableName = decoder.tables.keys.first;
        final table = decoder.tables[tableName];
        if (table == null) {
          errors.add('Excel文件格式错误：找不到工作表');
          return null;
        }
        return table.rows;
      } catch (e2) {
        final message = 'Excel文件格式不兼容或已损坏。\n错误: $e2\n\n解决建议：\n1. 在Excel中打开文件，另存为新的.xlsx格式\n2. 或转换为CSV格式导入（推荐）\n3. 检查文件是否损坏';
        errors.add(message);
        print('❌ Excel备用解析失败: $e2');
        return null;
      }
    }
  }

  String _getCellValueFromDynamic(List<dynamic> row, int index) {
    if (index >= row.length) return '';
    final cell = row[index];
    return _getCellValue(cell);
  }

  /// 检测第一行是否是表头
  /// 如果第一行包含表头关键词（如"题干"、"答案"等），返回true
  bool _isHeaderRow(List<dynamic> row) {
    if (row.isEmpty) return false;
    
    // 收集第一行的所有文本值
    final rowTexts = <String>[];
    for (var cell in row) {
      final value = _getCellValue(cell).trim().toLowerCase();
      if (value.isNotEmpty) {
        rowTexts.add(value);
      }
    }
    
    return _containsHeaderKeywords(rowTexts);
  }

  /// 检测字符串列表是否包含表头关键词（用于CSV）
  bool _isHeaderRowFromStrings(List<String> row) {
    if (row.isEmpty) return false;
    
    final rowTexts = row.map((s) => s.trim().toLowerCase()).where((s) => s.isNotEmpty).toList();
    return _containsHeaderKeywords(rowTexts);
  }

  /// 检查文本列表是否包含表头关键词
  bool _containsHeaderKeywords(List<String> rowTexts) {
    // 表头关键词列表
    final headerKeywords = [
      '题干', '题目', 'stem',
      '答案', 'answer',
      '题型', '类型', 'type',
      '选项a', '选项b', '选项c', '选项d', '选项e',
      'a', 'b', 'c', 'd', 'e',
      'option_a', 'option_b', 'option_c', 'option_d', 'option_e',
    ];
    
    // 检查第一行是否包含表头关键词
    for (var text in rowTexts) {
      for (var keyword in headerKeywords) {
        if (text.contains(keyword)) {
          print('✅ 检测到表头行，包含关键词: "$keyword"');
          return true;
        }
      }
    }
    
    print('ℹ️ 未检测到表头行，将第一行作为数据行处理');
    return false;
  }

  /// 创建默认表头映射（按列位置）
  /// 适用于没有表头的文件：0=题干, 1=答案, 2=题型, 3=选项A, 4=选项B, ...
  Map<String, int> _createDefaultHeaders(int columnCount) {
    final headers = <String, int>{};
    headers['题干'] = 0;
    headers['答案'] = 1;
    headers['题型'] = 2;
    
    // 选项从第3列开始（索引3）
    final optionHeaders = ['选项A', '选项B', '选项C', '选项D', '选项E'];
    for (int i = 0; i < optionHeaders.length && (i + 3) < columnCount; i++) {
      headers[optionHeaders[i]] = i + 3;
    }
    
    return headers;
  }

  /// 解析CSV行（处理引号和逗号）
  List<String> _parseCsvLine(String line) {
    final values = <String>[];
    String current = '';
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        values.add(current);
        current = '';
      } else {
        current += char;
      }
    }
    values.add(current);
    return values;
  }

  /// 解析数据行
  Future<Question?> _parseRow(
    dynamic row,
    Map<String, int> headers,
    int rowNumber,
  ) async {
    try {
      // 获取单元格值
      String getValue(String key) {
        final index = headers[key.toLowerCase()];
        if (index == null) return '';
        if (row is List) {
          return _getCellValueFromDynamic(row, index);
        }
        return '';
      }

      // 必填字段
      final stem = getValue('题干').isNotEmpty
          ? getValue('题干')
          : (getValue('题目').isNotEmpty ? getValue('题目') : getValue('stem'));
      if (stem.isEmpty) {
        return null;
      }

      // 答案
      final answer = getValue('答案').isNotEmpty ? getValue('答案') : getValue('answer');
      if (answer.isEmpty) {
        return null;
      }

      // 题型
      final typeStr = getValue('题型').isNotEmpty
          ? getValue('题型')
          : (getValue('类型').isNotEmpty
              ? getValue('类型')
              : (getValue('type').isNotEmpty ? getValue('type') : 'single'));
      
      final type = _parseQuestionType(typeStr);
      print('📝 第${rowNumber}行 - 题型字段值: "$typeStr" -> 解析结果: $type');

      // 选项
      final options = <Option>[];
      if (type != QuestionType.fill) {
        // 单选题、多选题、判断题需要选项
        final optionA = getValue('选项A').isNotEmpty
            ? getValue('选项A')
            : (getValue('A').isNotEmpty ? getValue('A') : getValue('option_a'));
        final optionB = getValue('选项B').isNotEmpty
            ? getValue('选项B')
            : (getValue('B').isNotEmpty ? getValue('B') : getValue('option_b'));
        final optionC = getValue('选项C').isNotEmpty
            ? getValue('选项C')
            : (getValue('C').isNotEmpty ? getValue('C') : getValue('option_c'));
        final optionD = getValue('选项D').isNotEmpty
            ? getValue('选项D')
            : (getValue('D').isNotEmpty ? getValue('D') : getValue('option_d'));

        if (optionA.isNotEmpty) options.add(Option(label: 'A', content: optionA));
        if (optionB.isNotEmpty) options.add(Option(label: 'B', content: optionB));
        if (optionC.isNotEmpty) options.add(Option(label: 'C', content: optionC));
        if (optionD.isNotEmpty) options.add(Option(label: 'D', content: optionD));

        // 处理选项图片
        final optionAImage = getValue('选项A图片').isNotEmpty
            ? getValue('选项A图片')
            : (getValue('A图片').isNotEmpty ? getValue('A图片') : getValue('option_a_image'));
        final optionBImage = getValue('选项B图片').isNotEmpty
            ? getValue('选项B图片')
            : (getValue('B图片').isNotEmpty ? getValue('B图片') : getValue('option_b_image'));
        final optionCImage = getValue('选项C图片').isNotEmpty
            ? getValue('选项C图片')
            : (getValue('C图片').isNotEmpty ? getValue('C图片') : getValue('option_c_image'));
        final optionDImage = getValue('选项D图片').isNotEmpty
            ? getValue('选项D图片')
            : (getValue('D图片').isNotEmpty ? getValue('D图片') : getValue('option_d_image'));

        if (optionAImage.isNotEmpty && options.isNotEmpty) {
          final imagePath = await _imageService.processImagePath(optionAImage);
          if (imagePath != null) {
            options[0] = Option(label: 'A', content: optionA, image: imagePath);
          }
        }
        if (optionBImage.isNotEmpty && options.length > 1) {
          final imagePath = await _imageService.processImagePath(optionBImage);
          if (imagePath != null) {
            options[1] = Option(label: 'B', content: optionB, image: imagePath);
          }
        }
        if (optionCImage.isNotEmpty && options.length > 2) {
          final imagePath = await _imageService.processImagePath(optionCImage);
          if (imagePath != null) {
            options[2] = Option(label: 'C', content: optionC, image: imagePath);
          }
        }
        if (optionDImage.isNotEmpty && options.length > 3) {
          final imagePath = await _imageService.processImagePath(optionDImage);
          if (imagePath != null) {
            options[3] = Option(label: 'D', content: optionD, image: imagePath);
          }
        }
      }

      // 解析
      final analysis = getValue('解析').isNotEmpty ? getValue('解析') : getValue('analysis');

      // 题干图片
      final stemImage = getValue('题干图片').isNotEmpty
          ? getValue('题干图片')
          : (getValue('题目图片').isNotEmpty ? getValue('题目图片') : getValue('stem_image'));
      final processedStemImage = stemImage.isNotEmpty
          ? await _imageService.processImagePath(stemImage)
          : null;

      // 解析图片
      final analysisImage = getValue('解析图片').isNotEmpty
          ? getValue('解析图片')
          : getValue('analysis_image');
      final processedAnalysisImage = analysisImage.isNotEmpty
          ? await _imageService.processImagePath(analysisImage)
          : null;

      // 分类
      final category = getValue('分类').isNotEmpty
          ? getValue('分类')
          : (getValue('章节').isNotEmpty ? getValue('章节') : getValue('category'));

      // 标签
      final tagsStr = getValue('标签').isNotEmpty ? getValue('标签') : getValue('tags');
      final tags = tagsStr.isNotEmpty
          ? tagsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : <String>[];

      return Question(
        stem: stem,
        stemImage: processedStemImage,
        type: type,
        options: options,
        answer: answer.trim().toUpperCase(),
        analysis: analysis.isNotEmpty ? analysis : null,
        analysisImage: processedAnalysisImage,
        category: category.isNotEmpty ? category : null,
        tags: tags,
      );
    } catch (e) {
      print('解析行失败: $e');
      return null;
    }
  }

  /// 获取单元格值
  String _getCellValue(dynamic cell) {
    if (cell == null) return '';
    if (cell is TextCellValue) {
      return cell.value.toString();
    }
    if (cell is IntCellValue) return cell.value.toString();
    if (cell is DoubleCellValue) return cell.value.toString();
    // 其他类型，尝试转换为字符串
    return '$cell';
  }

  /// 解析题型
  QuestionType _parseQuestionType(String typeStr) {
    if (typeStr.isEmpty) {
      print('⚠️ 题型字段为空，使用默认值: single');
      return QuestionType.single; // 默认单选题
    }
    
    // 去除首尾空格和特殊字符
    final cleaned = typeStr.trim().replaceAll(RegExp(r'[\s\u200B-\u200D\uFEFF]'), '');
    final lower = cleaned.toLowerCase();
    
    print('🔍 解析题型: 原始="$typeStr" -> 清理后="$cleaned" -> 小写="$lower"');
    
    // 优先匹配完整字符串（精确匹配）
    if (lower == 'single' || lower == '1' || lower == '单选题' || lower == '单选') {
      return QuestionType.single;
    } else if (lower == 'multiple' || lower == '2' || lower == '多选题' || lower == '多选') {
      return QuestionType.multiple;
    } else if (lower == 'judgment' || lower == '3' || lower == '判断题' || lower == '判断') {
      return QuestionType.judgment;
    } else if (lower == 'fill' || lower == '4' || lower == '填空题' || lower == '填空') {
      return QuestionType.fill;
    }
    
    // 然后匹配包含关键字
    if (lower.contains('单选')) {
      return QuestionType.single;
    } else if (lower.contains('多选')) {
      return QuestionType.multiple;
    } else if (lower.contains('判断')) {
      return QuestionType.judgment;
    } else if (lower.contains('填空')) {
      return QuestionType.fill;
    }
    
    print('⚠️ 无法识别题型: "$typeStr" (清理后: "$cleaned")，使用默认值: single');
    return QuestionType.single; // 默认单选题
  }

  /// 解析Markdown文件（从文件路径）
  Future<ImportResult> parseMarkdownFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(
          questions: [],
          errors: ['文件不存在: $filePath'],
        );
      }

      final content = await file.readAsString();
      if (content.isEmpty) {
        return ImportResult(
          questions: [],
          errors: ['文件为空'],
        );
      }

      return await _parseMarkdownContent(content);
    } catch (e) {
      return ImportResult(
        questions: [],
        errors: ['解析Markdown文件失败: $e'],
      );
    }
  }

  /// 解析Markdown文件（从bytes，用于Web平台）
  Future<ImportResult> parseMarkdownFromBytes(List<int> bytes, String fileName) async {
    try {
      if (bytes.isEmpty) {
        return ImportResult(
          questions: [],
          errors: ['文件内容为空'],
        );
      }

      final content = String.fromCharCodes(bytes);
      return await _parseMarkdownContent(content);
    } catch (e) {
      return ImportResult(
        questions: [],
        errors: ['解析Markdown文件失败: $e'],
      );
    }
  }

  /// 解析Markdown内容
  Future<ImportResult> _parseMarkdownContent(String content) async {
    final questions = <Question>[];
    final errors = <String>[];

    try {
      // 按题目分隔符分割（支持 --- 或 === 或空行分隔）
      final questionBlocks = _splitMarkdownQuestions(content);
      
      print('📝 检测到 ${questionBlocks.length} 个题目块');

      for (int i = 0; i < questionBlocks.length; i++) {
        try {
          final block = questionBlocks[i];
          if (block.trim().isEmpty) continue;

          final question = await _parseMarkdownQuestion(block, i + 1);
          if (question != null) {
            questions.add(question);
          } else {
            errors.add('第${i + 1}个题目块：解析失败或缺少必需字段');
          }
        } catch (e, stackTrace) {
          print('解析第${i + 1}个题目块时出错: $e');
          print('堆栈: $stackTrace');
          errors.add('第${i + 1}个题目块：${e.toString()}');
        }
      }
    } catch (e) {
      errors.add('解析Markdown内容失败: $e');
    }

    return ImportResult(questions: questions, errors: errors);
  }

  /// 分割Markdown题目块
  List<String> _splitMarkdownQuestions(String content) {
    // 按多个连续的分隔符分割（--- 或 === 或至少两个空行）
    final blocks = <String>[];
    final lines = content.split('\n');
    
    String currentBlock = '';
    int emptyLineCount = 0;

    for (final line in lines) {
      final trimmed = line.trim();
      
      // 检测分隔符
      if (trimmed == '---' || trimmed == '===' || trimmed.startsWith('---') || trimmed.startsWith('===')) {
        if (currentBlock.trim().isNotEmpty) {
          blocks.add(currentBlock.trim());
          currentBlock = '';
        }
        emptyLineCount = 0;
        continue;
      }

      // 检测空行
      if (trimmed.isEmpty) {
        emptyLineCount++;
        if (emptyLineCount >= 2 && currentBlock.trim().isNotEmpty) {
          // 两个连续空行，视为分隔符
          blocks.add(currentBlock.trim());
          currentBlock = '';
          emptyLineCount = 0;
          continue;
        }
      } else {
        emptyLineCount = 0;
      }

      currentBlock += line + '\n';
    }

    // 添加最后一个块
    if (currentBlock.trim().isNotEmpty) {
      blocks.add(currentBlock.trim());
    }

    return blocks;
  }

  /// 解析单个Markdown题目块
  Future<Question?> _parseMarkdownQuestion(String block, int questionNumber) async {
    try {
      final lines = block.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      if (lines.isEmpty) return null;

      String? stem;
      QuestionType type = QuestionType.single;
      final options = <Option>[];
      String? answer;
      String? analysis;
      String? stemImage;
      String? analysisImage;
      String? category;
      final tags = <String>[];

      // 解析每一行
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];

        // 解析题型和题干（格式：## 题目内容 或 ### 1. 题目内容[题型]）
        if (line.startsWith('##') || line.startsWith('###')) {
          final match = RegExp(r'^#+\s*(?:\d+\.\s*)?(.+?)(?:\[(.+?)\])?$').firstMatch(line);
          if (match != null) {
            stem = match.group(1)?.trim();
            final typeStr = match.group(2)?.trim();
            if (typeStr != null) {
              type = _parseQuestionType(typeStr);
            }
          }
          continue;
        }

        // 解析键值对（格式：**键**: 值）
        final kvMatch = RegExp(r'^\*\*(.+?)\*\*:\s*(.+)$').firstMatch(line);
        if (kvMatch != null) {
          final key = kvMatch.group(1)?.trim().toLowerCase() ?? '';
          final value = kvMatch.group(2)?.trim() ?? '';

          switch (key) {
            case '题型':
            case '类型':
            case 'type':
              type = _parseQuestionType(value);
              break;
            case '题干':
            case '题目':
            case 'stem':
              stem = value;
              break;
            case '答案':
            case 'answer':
              answer = value;
              break;
            case '解析':
            case 'analysis':
              analysis = value;
              break;
            case '题干图片':
            case '题目图片':
            case 'stem_image':
            case 'stemimage':
              stemImage = value;
              break;
            case '解析图片':
            case 'analysis_image':
            case 'analysisimage':
              analysisImage = value;
              break;
            case '分类':
            case '章节':
            case 'category':
              category = value;
              break;
            case '标签':
            case 'tags':
              tags.addAll(value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
              break;
            default:
              // 尝试解析选项（选项A、选项B等）
              if (key.startsWith('选项') || key.length == 1) {
                final optionLabel = key.replaceAll('选项', '').toUpperCase();
                if (optionLabel.length == 1 && optionLabel.compareTo('A') >= 0 && optionLabel.compareTo('Z') <= 0) {
                  options.add(Option(
                    label: optionLabel,
                    content: value,
                  ));
                }
              }
              break;
          }
          continue;
        }

        // 解析选项列表（格式：- A. 选项内容 或 * A. 选项内容）
        final optionMatch = RegExp(r'^[-*]\s*([A-Z])\.\s*(.+)$').firstMatch(line);
        if (optionMatch != null) {
          final label = optionMatch.group(1) ?? '';
          final content = optionMatch.group(2)?.trim() ?? '';
          options.add(Option(label: label, content: content));
          continue;
        }

        // 如果没有匹配到任何格式，可能是题干的一部分（多行题干）
        if (stem == null && !line.startsWith('#') && !line.startsWith('**')) {
          stem = line;
        }
      }

      // 验证必需字段
      if (stem == null || stem.isEmpty) {
        print('⚠️ 第$questionNumber题：缺少题干');
        return null;
      }

      if (answer == null || answer.isEmpty) {
        print('⚠️ 第$questionNumber题：缺少答案');
        return null;
      }

      // 处理图片路径
      if (stemImage != null && stemImage.isNotEmpty) {
        stemImage = await _imageService.processImagePath(stemImage);
      }
      if (analysisImage != null && analysisImage.isNotEmpty) {
        analysisImage = await _imageService.processImagePath(analysisImage);
      }

      // 创建题目对象
      return Question(
        stem: stem,
        stemImage: stemImage,
        type: type,
        options: options,
        answer: answer,
        analysis: analysis,
        analysisImage: analysisImage,
        category: category,
        tags: tags,
      );
    } catch (e, stackTrace) {
      print('解析Markdown题目块失败: $e');
      print('堆栈: $stackTrace');
      return null;
    }
  }
}

