import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/question_controller.dart';
import 'pages/home_page.dart';

/// 刷题工具应用入口
class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  // 初始化Hive（Web平台需要）
  static Future<void> init() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 初始化控制器
    Get.put(QuestionController());

    return GetMaterialApp(
      title: '刷题工具',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const QuizHomePage(),
    );
  }
}

