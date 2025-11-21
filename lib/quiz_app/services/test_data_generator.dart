import '../models/question.dart';

/// 测试数据生成器
class TestDataGenerator {
  /// 生成示例题目列表
  static List<Question> generateSampleQuestions() {
    return [
      // 单选题示例
      Question(
        stem: 'Flutter是由哪个公司开发的？',
        type: QuestionType.single,
        options: [
          Option(label: 'A', content: 'Google'),
          Option(label: 'B', content: 'Facebook'),
          Option(label: 'C', content: 'Microsoft'),
          Option(label: 'D', content: 'Apple'),
        ],
        answer: 'A',
        analysis: 'Flutter是由Google开发的跨平台UI框架。',
        category: 'Flutter基础',
        tags: ['Flutter', '基础'],
      ),

      // 多选题示例
      Question(
        stem: '以下哪些是Flutter的状态管理方案？（多选）',
        type: QuestionType.multiple,
        options: [
          Option(label: 'A', content: 'Provider'),
          Option(label: 'B', content: 'GetX'),
          Option(label: 'C', content: 'Bloc'),
          Option(label: 'D', content: 'Redux'),
        ],
        answer: 'A,B,C',
        analysis: 'Provider、GetX和Bloc都是Flutter常用的状态管理方案。Redux虽然也可以使用，但不是Flutter原生的。',
        category: '状态管理',
        tags: ['Flutter', '状态管理'],
      ),

      // 判断题示例
      Question(
        stem: 'Flutter使用Dart语言开发。',
        type: QuestionType.judgment,
        options: [
          Option(label: 'A', content: '正确'),
          Option(label: 'B', content: '错误'),
        ],
        answer: 'A',
        analysis: 'Flutter确实使用Dart语言开发，Dart是Google开发的编程语言。',
        category: 'Flutter基础',
        tags: ['Flutter', 'Dart'],
      ),

      // 填空题示例
      Question(
        stem: '在Flutter中，使用______关键字可以创建无状态组件。',
        type: QuestionType.fill,
        options: [],
        answer: 'StatelessWidget',
        analysis: 'StatelessWidget是Flutter中用于创建无状态组件的基类。',
        category: 'Flutter基础',
        tags: ['Flutter', 'Widget'],
      ),

      // 带图片的题目示例（图片路径需要实际存在）
      Question(
        stem: '下面哪个Widget用于显示文本？',
        type: QuestionType.single,
        options: [
          Option(label: 'A', content: 'Container'),
          Option(label: 'B', content: 'Text'),
          Option(label: 'C', content: 'Image'),
          Option(label: 'D', content: 'Icon'),
        ],
        answer: 'B',
        analysis: 'Text Widget专门用于显示文本内容。',
        category: 'Widget基础',
        tags: ['Widget', 'Text'],
      ),

      // 更多示例题目
      Question(
        stem: 'Flutter的热重载功能可以做什么？',
        type: QuestionType.single,
        options: [
          Option(label: 'A', content: '快速更新UI，无需重启应用'),
          Option(label: 'B', content: '自动保存代码'),
          Option(label: 'C', content: '优化应用性能'),
          Option(label: 'D', content: '生成APK文件'),
        ],
        answer: 'A',
        analysis: '热重载（Hot Reload）可以让开发者快速看到代码更改的效果，无需完全重启应用。',
        category: '开发工具',
        tags: ['热重载', '开发'],
      ),

      Question(
        stem: '在Flutter中，以下哪些布局Widget可以包含多个子Widget？（多选）',
        type: QuestionType.multiple,
        options: [
          Option(label: 'A', content: 'Column'),
          Option(label: 'B', content: 'Row'),
          Option(label: 'C', content: 'Stack'),
          Option(label: 'D', content: 'Container'),
        ],
        answer: 'A,B,C',
        analysis: 'Column、Row和Stack都可以包含多个子Widget。Container通常只包含一个子Widget。',
        category: '布局',
        tags: ['布局', 'Widget'],
      ),

      Question(
        stem: 'Flutter可以同时支持Android和iOS平台。',
        type: QuestionType.judgment,
        options: [
          Option(label: 'A', content: '正确'),
          Option(label: 'B', content: '错误'),
        ],
        answer: 'A',
        analysis: 'Flutter是跨平台框架，一套代码可以同时运行在Android和iOS平台上。',
        category: 'Flutter基础',
        tags: ['跨平台'],
      ),

      Question(
        stem: '在Flutter中，使用______可以管理有状态的组件。',
        type: QuestionType.fill,
        options: [],
        answer: 'StatefulWidget',
        analysis: 'StatefulWidget用于创建有状态的组件，可以保存和更新状态。',
        category: 'Flutter基础',
        tags: ['Widget', '状态'],
      ),

      Question(
        stem: 'GetX的主要特点包括哪些？（多选）',
        type: QuestionType.multiple,
        options: [
          Option(label: 'A', content: '状态管理'),
          Option(label: 'B', content: '路由管理'),
          Option(label: 'C', content: '依赖注入'),
          Option(label: 'D', content: '网络请求'),
        ],
        answer: 'A,B,C',
        analysis: 'GetX是一个功能强大的Flutter框架，集成了状态管理、路由管理和依赖注入等功能。',
        category: '状态管理',
        tags: ['GetX', '状态管理'],
      ),
    ];
  }

  /// 生成CSV格式的示例数据（用于测试）
  static String generateCsvExample() {
    return '''题干,题型,选项A,选项B,选项C,选项D,答案,解析,分类,标签
Flutter是由哪个公司开发的？,单选题,Google,Facebook,Microsoft,Apple,A,Flutter是由Google开发的跨平台UI框架。,Flutter基础,Flutter;基础
以下哪些是Flutter的状态管理方案？,多选题,Provider,GetX,Bloc,Redux,A;B;C,Provider、GetX和Bloc都是Flutter常用的状态管理方案。,状态管理,Flutter;状态管理
Flutter使用Dart语言开发。,判断题,正确,错误,,,A,Flutter确实使用Dart语言开发。,Flutter基础,Flutter;Dart
在Flutter中，使用______关键字可以创建无状态组件。,填空题,,,,,,StatelessWidget,StatelessWidget是Flutter中用于创建无状态组件的基类。,Flutter基础,Flutter;Widget''';
  }

  /// 生成Excel格式说明
  static String getExcelFormatDescription() {
    return '''
Excel/CSV 导入格式说明：

【必需字段】
- 题干（或"题目"、"stem"）：题目的主要内容
- 答案（或"answer"）：正确答案

【可选字段】
- 题型（或"类型"、"type"）：单选题/多选题/判断题/填空题
- 选项A/B/C/D（或"选项A"/"A"等）：选项内容
- 选项A图片/B图片/C图片/D图片：选项对应的图片路径或URL
- 题干图片（或"题目图片"、"stem_image"）：题干图片路径或URL
- 解析（或"analysis"）：题目解析说明
- 解析图片（或"analysis_image"）：解析图片路径或URL
- 分类（或"章节"、"category"）：题目分类
- 标签（或"tags"）：用逗号分隔的标签

【题型说明】
- 单选题：只能选择一个答案，答案格式如：A
- 多选题：可以选择多个答案，答案格式如：A,B,C
- 判断题：答案格式如：A（正确）或B（错误）
- 填空题：不需要选项，答案直接填写内容

【图片支持】
- 本地路径：C:/images/question1.jpg
- 网络URL：https://example.com/image.jpg
''';
  }
}

