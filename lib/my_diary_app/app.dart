import 'package:flutter/material.dart';
import 'pages/diary_page.dart';

/// 记事日记应用入口：打开即进入日记页
class MyDateLogApp extends StatelessWidget {
  const MyDateLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '记事日记',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DiaryPage(),
    );
  }
}
