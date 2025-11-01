import 'package:flutter/material.dart';

/// 布局Widget示例
/// 这个文件展示了Flutter中常用的布局组件
class LayoutsExample extends StatelessWidget {
  const LayoutsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('布局Widget示例'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Padding - 内边距
            const Text(
              '1. Padding 内边距',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.blue.shade300,
                  child: const Text('有内边距的容器'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. SizedBox - 尺寸控制
            const Text(
              '2. SizedBox 尺寸控制',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: Container(
                color: Colors.orange,
                child: const Center(child: Text('固定尺寸的容器')),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Expanded - 弹性布局
            const Text(
              '3. Expanded 弹性布局',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2, // 占据2份空间
                  child: Container(
                    height: 60,
                    color: Colors.red,
                    child: const Center(child: Text('flex: 2')),
                  ),
                ),
                Expanded(
                  flex: 1, // 占据1份空间
                  child: Container(
                    height: 60,
                    color: Colors.blue,
                    child: const Center(child: Text('flex: 1')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Stack - 层叠布局
            const Text(
              '4. Stack 层叠布局',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey.shade300,
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Center - 居中
            const Text(
              '5. Center 居中',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              color: Colors.purple.shade100,
              child: const Center(
                child: Text(
                  '居中显示的文本',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 6. ListView - 列表滚动
            const Text(
              '6. ListView 列表滚动',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal, // 横向滚动
                children: [
                  Container(
                    width: 100,
                    color: Colors.red,
                    child: const Center(child: Text('1')),
                  ),
                  Container(
                    width: 100,
                    color: Colors.orange,
                    child: const Center(child: Text('2')),
                  ),
                  Container(
                    width: 100,
                    color: Colors.yellow,
                    child: const Center(child: Text('3')),
                  ),
                  Container(
                    width: 100,
                    color: Colors.green,
                    child: const Center(child: Text('4')),
                  ),
                  Container(
                    width: 100,
                    color: Colors.blue,
                    child: const Center(child: Text('5')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 7. Wrap - 自动换行
            const Text(
              '7. Wrap 自动换行',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0, // 水平间距
              runSpacing: 8.0, // 垂直间距
              children: [
                Chip(label: const Text('标签1')),
                Chip(label: const Text('标签2')),
                Chip(label: const Text('标签3')),
                Chip(label: const Text('长标签4')),
                Chip(label: const Text('标签5')),
                Chip(label: const Text('标签6')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

