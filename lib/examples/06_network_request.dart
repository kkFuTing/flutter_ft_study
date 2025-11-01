import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// 网络请求示例
/// 这个文件展示了如何使用http包进行网络请求
class NetworkRequestExample extends StatefulWidget {
  const NetworkRequestExample({super.key});

  @override
  State<NetworkRequestExample> createState() => _NetworkRequestExampleState();
}

class _NetworkRequestExampleState extends State<NetworkRequestExample> {
  String _response = '点击按钮开始请求';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络请求示例'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GET 请求示例
            _buildSectionCard(
              title: '1. GET 请求',
              description: '获取JSONPlaceholder的示例数据',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _fetchPost,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('获取帖子数据'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _response,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. 请求方法说明
            _buildSectionCard(
              title: '2. 常用HTTP方法',
              description: 'GET、POST、PUT、DELETE等',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMethodItem('GET', '获取数据', Colors.blue),
                  _buildMethodItem('POST', '创建数据', Colors.green),
                  _buildMethodItem('PUT', '更新数据', Colors.orange),
                  _buildMethodItem('DELETE', '删除数据', Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. 错误处理
            _buildSectionCard(
              title: '3. 错误处理',
              description: '处理网络请求的错误情况',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _fetchWithError,
                    child: const Text('模拟错误请求'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '注意：实际开发中要处理网络错误、超时等情况',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. 请求带参数
            _buildSectionCard(
              title: '4. 带参数的请求',
              description: 'URL参数和请求体参数',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _fetchWithParams,
                    child: const Text('获取指定ID的帖子'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取帖子数据
  Future<void> _fetchPost() async {
    setState(() {
      _isLoading = true;
      _response = '正在加载...';
    });

    try {
      // 使用 http.get 发送 GET 请求
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );

      if (response.statusCode == 200) {
        // 解析JSON数据
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          _response = '''
标题: ${data['title']}
内容: ${data['body']}
用户ID: ${data['userId']}
帖子ID: ${data['id']}
''';
          _isLoading = false;
        });
      } else {
        setState(() {
          _response = '请求失败: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = '请求出错: $e';
        _isLoading = false;
      });
    }
  }

  /// 模拟错误请求
  Future<void> _fetchWithError() async {
    setState(() {
      _isLoading = true;
      _response = '正在加载...';
    });

    try {
      // 故意使用错误的URL
      final response = await http.get(
        Uri.parse('https://invalid-url-that-does-not-exist.com/data'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _response = response.body;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = '捕获到错误: $e\n\n这是正常的，因为我们使用了错误的URL';
        _isLoading = false;
      });
    }
  }

  /// 带参数的请求
  Future<void> _fetchWithParams() async {
    setState(() {
      _isLoading = true;
      _response = '正在加载...';
    });

    try {
      // URL参数可以通过Uri.parse时添加，或者使用Uri.https构造
      final uri = Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        {'userId': '1'}, // URL查询参数
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _response = '成功获取到 ${data.length} 条数据\n\n'
              '第一条数据:\n'
              '标题: ${data[0]['title']}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = '请求出错: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildSectionCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMethodItem(String method, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              method,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(desc),
        ],
      ),
    );
  }
}

/// POST请求示例（单独页面）
class PostRequestExample extends StatefulWidget {
  const PostRequestExample({super.key});

  @override
  State<PostRequestExample> createState() => _PostRequestExampleState();
}

class _PostRequestExampleState extends State<PostRequestExample> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    setState(() {
      _isLoading = true;
      _response = '正在提交...';
    });

    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'title': _titleController.text,
          'body': _bodyController.text,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _response = '提交成功！\n\n'
              '标题: ${data['title']}\n'
              '内容: ${data['body']}\n'
              'ID: ${data['id']}';
          _isLoading = false;
        });
      } else {
        setState(() {
          _response = '提交失败: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = '请求出错: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POST请求示例'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: '内容',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitPost,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('提交'),
            ),
            if (_response.isNotEmpty) ...[
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(_response),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

