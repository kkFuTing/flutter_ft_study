import 'dart:io';
import 'package:excel/excel.dart';

/// 生成Excel模板文件的脚本
/// 运行方式：dart run scripts/generate_excel_template.dart
void main() {
  // 创建Excel文件
  final excel = Excel.createExcel();
  
  // 删除默认的Sheet1
  excel.delete('Sheet1');
  
  // 创建新的工作表
  final sheet = excel['题目模板'];
  
  // 设置表头
  final headers = [
    '题干',
    '题型',
    '选项A',
    '选项B',
    '选项C',
    '选项D',
    '答案',
    '解析',
    '分类',
    '标签',
    '题干图片',
    '选项A图片',
    '选项B图片',
    '选项C图片',
    '选项D图片',
    '解析图片',
  ];
  
  // 写入表头
  for (int i = 0; i < headers.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value = TextCellValue(headers[i]);
  }
  
  // 写入示例数据
  final examples = [
    [
      'Flutter是由哪个公司开发的？',
      '单选题',
      'Google',
      'Facebook',
      'Microsoft',
      'Apple',
      'A',
      'Flutter是由Google开发的跨平台UI框架。',
      'Flutter基础',
      'Flutter;基础',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      '以下哪些是Flutter的状态管理方案？',
      '多选题',
      'Provider',
      'GetX',
      'Bloc',
      'Redux',
      'A,B,C',
      'Provider、GetX和Bloc都是Flutter常用的状态管理方案。',
      '状态管理',
      'Flutter;状态管理',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      'Flutter使用Dart语言开发。',
      '判断题',
      '正确',
      '错误',
      '',
      '',
      'A',
      'Flutter确实使用Dart语言开发，Dart是Google开发的编程语言。',
      'Flutter基础',
      'Flutter;Dart',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      '在Flutter中，使用______关键字可以创建无状态组件。',
      '填空题',
      '',
      '',
      '',
      '',
      'StatelessWidget',
      'StatelessWidget是Flutter中用于创建无状态组件的基类。',
      'Flutter基础',
      'Flutter;Widget',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      '下面哪个Widget用于显示文本？',
      '单选题',
      'Container',
      'Text',
      'Image',
      'Icon',
      'B',
      'Text Widget专门用于显示文本内容。',
      'Widget基础',
      'Widget;Text',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      'Flutter的热重载功能可以做什么？',
      '单选题',
      '快速更新UI，无需重启应用',
      '自动保存代码',
      '优化应用性能',
      '生成APK文件',
      'A',
      '热重载（Hot Reload）可以让开发者快速看到代码更改的效果，无需完全重启应用。',
      '开发工具',
      '热重载;开发',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      '在Flutter中，以下哪些布局Widget可以包含多个子Widget？',
      '多选题',
      'Column',
      'Row',
      'Stack',
      'Container',
      'A,B,C',
      'Column、Row和Stack都可以包含多个子Widget。Container通常只包含一个子Widget。',
      '布局',
      '布局;Widget',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      'Flutter可以同时支持Android和iOS平台。',
      '判断题',
      '正确',
      '错误',
      '',
      '',
      'A',
      'Flutter是跨平台框架，一套代码可以同时运行在Android和iOS平台上。',
      'Flutter基础',
      '跨平台',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      '在Flutter中，使用______可以管理有状态的组件。',
      '填空题',
      '',
      '',
      '',
      '',
      'StatefulWidget',
      'StatefulWidget用于创建有状态的组件，可以保存和更新状态。',
      'Flutter基础',
      'Widget;状态',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    [
      'GetX的主要特点包括哪些？',
      '多选题',
      '状态管理',
      '路由管理',
      '依赖注入',
      '网络请求',
      'A,B,C',
      'GetX是一个功能强大的Flutter框架，集成了状态管理、路由管理和依赖注入等功能。',
      '状态管理',
      'GetX;状态管理',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
  ];
  
  // 写入示例数据
  for (int rowIndex = 0; rowIndex < examples.length; rowIndex++) {
    final row = examples[rowIndex];
    for (int colIndex = 0; colIndex < row.length; colIndex++) {
      sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: colIndex,
        rowIndex: rowIndex + 1,
      )).value = TextCellValue(row[colIndex]);
    }
  }
  
  // 保存文件
  final fileBytes = excel.save();
  if (fileBytes != null) {
    final file = File('示例题目.xlsx');
    file.writeAsBytesSync(fileBytes);
    print('✅ Excel文件已生成：示例题目.xlsx');
    print('📁 文件位置：${file.absolute.path}');
  } else {
    print('❌ 生成Excel文件失败');
  }
}

