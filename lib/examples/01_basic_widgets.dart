import 'package:flutter/material.dart';

/// 基础Widget示例
/// 这个文件展示了Flutter中最常用的基础组件
class BasicWidgetsExample extends StatelessWidget {
  const BasicWidgetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('基础Widget示例'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Text - 文本组件
            const Text(
              '1. Text 文本组件',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('这是普通文本'),
            const Text(
              '这是大号文本',
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              '这是带颜色的文本',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 20),

            // 2. Container - 容器组件
            const Text(
              '2. Container 容器组件',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.blue.shade100,
              padding: const EdgeInsets.all(16),
              child: const Center(
                child: Text('这是一个Container容器'),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Row - 横向布局
            const Text(
              '3. Row 横向布局',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.red,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.green,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Column - 纵向布局（当前正在使用）
            const Text(
              '4. Column 纵向布局',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.orange,
                  child: const Center(child: Text('第一行')),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.purple,
                  child: const Center(child: Text('第二行')),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 5. Icon - 图标
            const Text(
              '5. Icon 图标',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home, size: 40, color: Colors.blue),
                Icon(Icons.favorite, size: 40, color: Colors.red),
                Icon(Icons.settings, size: 40, color: Colors.grey),
                Icon(Icons.search, size: 40, color: Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // 6. Image - 图片（使用占位符）
            const Text(
              '6. Image 图片组件',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.image,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // 7. Button - 按钮
            const Text(
              '7. Button 按钮组件',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 点击事件
                    debugPrint('ElevatedButton 被点击了');
                  },
                  child: const Text('ElevatedButton 凸起按钮'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    debugPrint('TextButton 被点击了');
                  },
                  child: const Text('TextButton 文本按钮'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    debugPrint('OutlinedButton 被点击了');
                  },
                  child: const Text('OutlinedButton 边框按钮'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

