import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/question.dart';

/// 数据库助手类
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static Box<Map>? _hiveBox;
  static int _nextId = 1;

  DatabaseHelper._init();

  // Web平台初始化Hive
  Future<void> _initHive() async {
    if (_hiveBox != null) return;
    await Hive.initFlutter();
    _hiveBox = await Hive.openBox<Map>('questions');
    // 获取最大ID
    if (_hiveBox!.isNotEmpty) {
      final allKeys = _hiveBox!.keys.cast<int>();
      _nextId = (allKeys.isEmpty ? 0 : allKeys.reduce((a, b) => a > b ? a : b)) + 1;
    }
  }

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Web平台使用Hive，请使用Hive方法');
    }
    if (_database != null) return _database!;
    _database = await _initDB('quiz_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stem TEXT NOT NULL,
        stem_image TEXT,
        type TEXT NOT NULL,
        options TEXT NOT NULL,
        answer TEXT NOT NULL,
        analysis TEXT,
        analysis_image TEXT,
        category TEXT,
        tags TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_favorite INTEGER DEFAULT 0,
        wrong_count INTEGER DEFAULT 0
      )
    ''');

    // 创建索引
    await db.execute('CREATE INDEX idx_category ON questions(category)');
    await db.execute('CREATE INDEX idx_is_favorite ON questions(is_favorite)');
  }

  /// 插入题目
  Future<int> insertQuestion(Question question) async {
    if (kIsWeb) {
      await _initHive();
      final id = _nextId++;
      final map = question.copyWith(id: id).toMap();
      await _hiveBox!.put(id, map);
      return id;
    }
    final db = await database;
    return await db.insert('questions', question.toMap());
  }

  /// 批量插入题目
  Future<void> insertQuestions(List<Question> questions) async {
    if (kIsWeb) {
      await _initHive();
      for (var question in questions) {
        final id = _nextId++;
        final map = question.copyWith(id: id).toMap();
        await _hiveBox!.put(id, map);
      }
      return;
    }
    final db = await database;
    final batch = db.batch();
    for (var question in questions) {
      batch.insert('questions', question.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// 获取所有题目
  Future<List<Question>> getAllQuestions() async {
    if (kIsWeb) {
      await _initHive();
      final questions = <Question>[];
      for (var key in _hiveBox!.keys) {
        final map = _hiveBox!.get(key);
        if (map != null) {
          try {
            questions.add(Question.fromMap(Map<String, dynamic>.from(map)));
          } catch (e) {
            print('解析题目失败 (key: $key): $e');
          }
        }
      }
      // 按创建时间降序排序
      questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return questions;
    }
    final db = await database;
    final maps = await db.query('questions', orderBy: 'created_at DESC');
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  /// 根据ID获取题目
  Future<Question?> getQuestionById(int id) async {
    if (kIsWeb) {
      await _initHive();
      final map = _hiveBox!.get(id);
      if (map == null) return null;
      return Question.fromMap(Map<String, dynamic>.from(map));
    }
    final db = await database;
    final maps = await db.query(
      'questions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Question.fromMap(maps.first);
  }

  /// 根据分类获取题目
  Future<List<Question>> getQuestionsByCategory(String category) async {
    if (kIsWeb) {
      await _initHive();
      final questions = <Question>[];
      for (var key in _hiveBox!.keys) {
        final map = _hiveBox!.get(key);
        if (map != null) {
          final question = Question.fromMap(Map<String, dynamic>.from(map));
          if (question.category == category) {
            questions.add(question);
          }
        }
      }
      questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return questions;
    }
    final db = await database;
    final maps = await db.query(
      'questions',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  /// 获取收藏的题目
  Future<List<Question>> getFavoriteQuestions() async {
    if (kIsWeb) {
      await _initHive();
      final questions = <Question>[];
      for (var key in _hiveBox!.keys) {
        final map = _hiveBox!.get(key);
        if (map != null) {
          final question = Question.fromMap(Map<String, dynamic>.from(map));
          if (question.isFavorite) {
            questions.add(question);
          }
        }
      }
      questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return questions;
    }
    final db = await database;
    final maps = await db.query(
      'questions',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  /// 获取错题（错误次数大于0）
  Future<List<Question>> getWrongQuestions() async {
    if (kIsWeb) {
      await _initHive();
      final questions = <Question>[];
      for (var key in _hiveBox!.keys) {
        final map = _hiveBox!.get(key);
        if (map != null) {
          final question = Question.fromMap(Map<String, dynamic>.from(map));
          if (question.wrongCount > 0) {
            questions.add(question);
          }
        }
      }
      questions.sort((a, b) {
        if (b.wrongCount != a.wrongCount) {
          return b.wrongCount.compareTo(a.wrongCount);
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      return questions;
    }
    final db = await database;
    final maps = await db.query(
      'questions',
      where: 'wrong_count > ?',
      whereArgs: [0],
      orderBy: 'wrong_count DESC, created_at DESC',
    );
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  /// 更新题目
  Future<int> updateQuestion(Question question) async {
    if (kIsWeb) {
      await _initHive();
      if (question.id == null) return 0;
      final map = question.copyWith(updatedAt: DateTime.now()).toMap();
      await _hiveBox!.put(question.id, map);
      return 1;
    }
    final db = await database;
    return await db.update(
      'questions',
      question.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  /// 删除题目
  Future<int> deleteQuestion(int id) async {
    if (kIsWeb) {
      await _initHive();
      await _hiveBox!.delete(id);
      return 1;
    }
    final db = await database;
    return await db.delete(
      'questions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 切换收藏状态
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    if (kIsWeb) {
      await _initHive();
      final question = await getQuestionById(id);
      if (question == null) return 0;
      final updated = question.copyWith(
        isFavorite: isFavorite,
        updatedAt: DateTime.now(),
      );
      await _hiveBox!.put(id, updated.toMap());
      return 1;
    }
    final db = await database;
    return await db.update(
      'questions',
      {'is_favorite': isFavorite ? 1 : 0, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 增加错误次数
  Future<int> incrementWrongCount(int id) async {
    if (kIsWeb) {
      await _initHive();
      final question = await getQuestionById(id);
      if (question == null) return 0;
      final updated = question.copyWith(
        wrongCount: question.wrongCount + 1,
        updatedAt: DateTime.now(),
      );
      await _hiveBox!.put(id, updated.toMap());
      return 1;
    }
    final db = await database;
    final question = await getQuestionById(id);
    if (question == null) return 0;
    return await db.update(
      'questions',
      {
        'wrong_count': question.wrongCount + 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 获取题目总数
  Future<int> getQuestionCount() async {
    if (kIsWeb) {
      await _initHive();
      return _hiveBox!.length;
    }
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM questions');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// 关闭数据库
  Future<void> close() async {
    if (kIsWeb) {
      await _hiveBox?.close();
      return;
    }
    final db = await database;
    await db.close();
  }
}
