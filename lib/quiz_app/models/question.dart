/// 题目模型
class Question {
  final int? id;
  final String stem; // 题干
  final String? stemImage; // 题干图片路径
  final QuestionType type; // 题型
  final List<Option> options; // 选项
  final String answer; // 答案
  final String? analysis; // 解析
  final String? analysisImage; // 解析图片路径
  final String? category; // 分类/章节
  final List<String> tags; // 标签
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite; // 是否收藏
  final int wrongCount; // 错误次数

  Question({
    this.id,
    required this.stem,
    this.stemImage,
    required this.type,
    required this.options,
    required this.answer,
    this.analysis,
    this.analysisImage,
    this.category,
    this.tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isFavorite = false,
    this.wrongCount = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 从 Map 创建（用于数据库）
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int?,
      stem: map['stem'] as String,
      stemImage: map['stem_image'] as String?,
      type: _questionTypeFromString(map['type'] as String),
      options: (map['options'] as String?)
              ?.split('|||')
              .map((e) => Option.fromString(e))
              .toList() ??
          [],
      answer: map['answer'] as String,
      analysis: map['analysis'] as String?,
      analysisImage: map['analysis_image'] as String?,
      category: map['category'] as String?,
      tags: (map['tags'] as String?)?.split(',') ?? [],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      wrongCount: map['wrong_count'] as int? ?? 0,
    );
  }

  /// 转换为 Map（用于数据库）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stem': stem,
      'stem_image': stemImage,
      'type': _questionTypeToString(type), // 使用辅助函数转换为正确的字符串格式
      'options': options.map((e) => e.toString()).join('|||'),
      'answer': answer,
      'analysis': analysis,
      'analysis_image': analysisImage,
      'category': category,
      'tags': tags.join(','),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_favorite': isFavorite ? 1 : 0,
      'wrong_count': wrongCount,
    };
  }

  Question copyWith({
    int? id,
    String? stem,
    String? stemImage,
    QuestionType? type,
    List<Option>? options,
    String? answer,
    String? analysis,
    String? analysisImage,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    int? wrongCount,
  }) {
    return Question(
      id: id ?? this.id,
      stem: stem ?? this.stem,
      stemImage: stemImage ?? this.stemImage,
      type: type ?? this.type,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      analysis: analysis ?? this.analysis,
      analysisImage: analysisImage ?? this.analysisImage,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      wrongCount: wrongCount ?? this.wrongCount,
    );
  }
}

/// 选项模型
class Option {
  final String label; // A, B, C, D
  final String content; // 选项内容
  final String? image; // 选项图片路径

  Option({
    required this.label,
    required this.content,
    this.image,
  });

  factory Option.fromString(String str) {
    final parts = str.split('::');
    return Option(
      label: parts[0],
      content: parts.length > 1 ? parts[1] : '',
      image: parts.length > 2 ? parts[2] : null,
    );
  }

  @override
  String toString() {
    return '$label::$content${image != null ? '::$image' : ''}';
  }
}

/// 题型枚举
enum QuestionType {
  single, // 单选题
  multiple, // 多选题
  judgment, // 判断题
  fill, // 填空题
}

/// 题型扩展方法
extension QuestionTypeExtension on QuestionType {
  String get displayName {
    switch (this) {
      case QuestionType.single:
        return '单选题';
      case QuestionType.multiple:
        return '多选题';
      case QuestionType.judgment:
        return '判断题';
      case QuestionType.fill:
        return '填空题';
    }
  }
}

/// 辅助函数：从字符串创建 QuestionType
QuestionType _questionTypeFromString(String str) {
  // 处理可能的 "QuestionType.single" 格式
  final cleanStr = str.replaceAll('QuestionType.', '').toLowerCase();
  
  switch (cleanStr) {
    case 'single':
      return QuestionType.single;
    case 'multiple':
      return QuestionType.multiple;
    case 'judgment':
      return QuestionType.judgment;
    case 'fill':
      return QuestionType.fill;
    default:
      print('⚠️ 无法识别的题型字符串: "$str" (清理后: "$cleanStr")，使用默认值: single');
      return QuestionType.single;
  }
}

/// 辅助函数：将 QuestionType 转换为字符串（用于数据库存储）
String _questionTypeToString(QuestionType type) {
  switch (type) {
    case QuestionType.single:
      return 'single';
    case QuestionType.multiple:
      return 'multiple';
    case QuestionType.judgment:
      return 'judgment';
    case QuestionType.fill:
      return 'fill';
  }
}

