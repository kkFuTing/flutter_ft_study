import 'package:flutter/material.dart';

/// 交互示例
/// 这个文件展示了Flutter中的用户交互和状态管理
class InteractionsExample extends StatefulWidget {
  const InteractionsExample({super.key});

  @override
  State<InteractionsExample> createState() => _InteractionsExampleState();
}

class _InteractionsExampleState extends State<InteractionsExample> {
  // 状态变量
  int _counter = 0;
  String _inputText = '';
  bool _isLiked = false;
  double _sliderValue = 50.0;

  // 增加计数器
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // 减少计数器
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  // 切换喜欢状态
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('交互示例'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 计数器示例
            const Text(
              '1. 计数器示例（StatefulWidget）',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '计数: $_counter',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _decrementCounter,
                        child: const Text('-'),
                      ),
                      ElevatedButton(
                        onPressed: _incrementCounter,
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. 文本输入
            const Text(
              '2. 文本输入（TextField）',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: '请输入文本',
                hintText: '输入后会在下方显示',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
            ),
            const SizedBox(height: 8),
            if (_inputText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('你输入了: $_inputText'),
              ),
            const SizedBox(height: 20),

            // 3. 开关切换
            const Text(
              '3. 开关切换（Switch）',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('开关状态:'),
                Switch(
                  value: _isLiked,
                  onChanged: (value) {
                    setState(() {
                      _isLiked = value;
                    });
                  },
                ),
              ],
            ),
            Text('当前状态: ${_isLiked ? "开启" : "关闭"}'),
            const SizedBox(height: 20),

            // 4. 点赞按钮
            const Text(
              '4. 点赞按钮（图标点击）',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _toggleLike,
              child: Row(
                children: [
                  Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : Colors.grey,
                    size: 40,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isLiked ? '已点赞' : '点击点赞',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. 滑块
            const Text(
              '5. 滑块（Slider）',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('当前值: ${_sliderValue.toInt()}'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _sliderValue.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // 6. 对话框
            const Text(
              '6. 对话框（AlertDialog）',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('提示'),
                    content: const Text('这是一个对话框示例！'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('显示对话框'),
            ),
            const SizedBox(height: 20),

            // 7. 提示信息（SnackBar）
            const Text(
              '7. 底部提示（SnackBar）',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('这是一条提示信息！'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('显示底部提示'),
            ),
          ],
        ),
      ),
    );
  }
}

