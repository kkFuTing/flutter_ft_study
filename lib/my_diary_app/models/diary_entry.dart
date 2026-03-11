/// 单条日记
class DiaryEntry {
  final String date; // yyyy-MM-dd
  final String content;
  final DateTime updatedAt;

  const DiaryEntry({
    required this.date,
    required this.content,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'content': content,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        date: json['date'] as String,
        content: json['content'] as String? ?? '',
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      );

  DiaryEntry copyWith({String? date, String? content, DateTime? updatedAt}) =>
      DiaryEntry(
        date: date ?? this.date,
        content: content ?? this.content,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
