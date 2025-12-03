import 'dart:async';
import 'package:flutter/material.dart';

/// Future 异步编程示例
/// 展示 Dart Future 的核心功能：异步操作、async/await、错误处理、组合方法等
class FutureExample extends StatelessWidget {
  const FutureExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future 示例',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FutureHomePage(),
    );
  }
}

// ==================== 首页 ====================

class FutureHomePage extends StatelessWidget {
  const FutureHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future 异步编程示例'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('基础 Future'),
          _buildExampleCard(
            context,
            title: '1. 基础 Future 创建',
            description: '创建和使用 Future',
            icon: Icons.play_circle_outline,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BasicFuturePage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '2. async/await 语法',
            description: '使用 async/await 简化异步代码',
            icon: Icons.code,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AsyncAwaitPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '3. Future 链式调用',
            description: '使用 then、catchError 处理异步',
            icon: Icons.link,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FutureChainPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('错误处理'),
          _buildExampleCard(
            context,
            title: '4. Future 错误处理',
            description: 'try-catch 和 catchError 的使用',
            icon: Icons.error_outline,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ErrorHandlingPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '5. 超时处理',
            description: '使用 timeout 处理超时情况',
            icon: Icons.timer,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TimeoutPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Future 组合'),
          _buildExampleCard(
            context,
            title: '6. Future.wait（等待多个）',
            description: '等待多个 Future 全部完成',
            icon: Icons.queue,
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FutureWaitPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '7. Future.any（任意一个）',
            description: '等待任意一个 Future 完成',
            icon: Icons.check_circle_outline,
            color: Colors.indigo,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FutureAnyPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '8. Future.delayed（延迟执行）',
            description: '延迟执行异步操作',
            icon: Icons.schedule,
            color: Colors.pink,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FutureDelayedPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('实际应用场景'),
          _buildExampleCard(
            context,
            title: '9. 模拟网络请求',
            description: '模拟 API 调用和数据处理',
            icon: Icons.cloud,
            color: Colors.cyan,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NetworkRequestPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '10. 顺序执行多个任务',
            description: '按顺序执行多个异步任务',
            icon: Icons.list,
            color: Colors.deepOrange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SequentialTasksPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Future API 说明'),
          _buildInfoCard(
            'Future<T>',
            '表示异步操作的结果',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'async/await',
            '简化异步代码的语法糖',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'Future.wait()',
            '等待多个 Future 全部完成',
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'Future.any()',
            '等待任意一个 Future 完成',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(width: 4, height: 40, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 1. 基础 Future 创建 ====================

/// 模拟异步操作
Future<String> fetchData() async {
  await Future.delayed(const Duration(seconds: 2));
  return '数据加载完成';
}

/// 创建 Future 的几种方式
class BasicFuturePage extends StatefulWidget {
  const BasicFuturePage({super.key});

  @override
  State<BasicFuturePage> createState() => _BasicFuturePageState();
}

class _BasicFuturePageState extends State<BasicFuturePage> {
  String _result = '未执行';
  bool _isLoading = false;

  /// 方式1：使用 Future.value
  void _useFutureValue() {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    Future.value('立即返回的值').then((value) {
      setState(() {
        _result = '结果: $value';
        _isLoading = false;
      });
    });
  }

  /// 方式2：使用 Future.delayed
  void _useFutureDelayed() {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _result = '延迟 2 秒后返回';
        _isLoading = false;
      });
    });
  }

  /// 方式3：使用 async 函数
  void _useAsyncFunction() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    final result = await fetchData();
    setState(() {
      _result = '结果: $result';
      _isLoading = false;
    });
  }

  /// 方式4：使用 Future 构造函数
  void _useFutureConstructor() {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    Future(() {
      // 在下一个事件循环中执行
      return 'Future 构造函数创建';
    }).then((value) {
      setState(() {
        _result = '结果: $value';
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('基础 Future 创建'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              '基础 Future',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _useFutureValue,
                  child: const Text('Future.value'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _useFutureDelayed,
                  child: const Text('Future.delayed'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _useAsyncFunction,
                  child: const Text('async 函数'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _useFutureConstructor,
                  child: const Text('Future()'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 Future 表示异步操作的结果，有多种创建方式',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 2. async/await 语法 ====================

/// 模拟异步操作1
Future<String> fetchUser() async {
  await Future.delayed(const Duration(seconds: 1));
  return '用户数据';
}

/// 模拟异步操作2
Future<String> fetchProfile(String userId) async {
  await Future.delayed(const Duration(seconds: 1));
  return '用户资料: $userId';
}

class AsyncAwaitPage extends StatefulWidget {
  const AsyncAwaitPage({super.key});

  @override
  State<AsyncAwaitPage> createState() => _AsyncAwaitPageState();
}

class _AsyncAwaitPageState extends State<AsyncAwaitPage> {
  String _result = '未执行';
  bool _isLoading = false;

  /// 使用 async/await（推荐）
  Future<void> _useAsyncAwait() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    try {
      // 顺序执行，代码更清晰
      final user = await fetchUser();
      final profile = await fetchProfile(user);
      
      setState(() {
        _result = '结果: $profile';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  /// 使用 then（不推荐，但可以对比）
  void _useThen() {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    fetchUser().then((user) {
      return fetchProfile(user);
    }).then((profile) {
      setState(() {
        _result = '结果: $profile';
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _result = '错误: $error';
        _isLoading = false;
      });
    });
  }

  /// 并行执行多个异步操作
  Future<void> _parallelExecution() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    // 并行执行，总时间 = 最长的任务时间
    final results = await Future.wait([
      fetchUser(),
      Future.delayed(const Duration(seconds: 1), () => '其他数据'),
    ]);

    setState(() {
      _result = '结果: ${results.join(", ")}';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('async/await 语法'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.code, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'async/await',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _useAsyncAwait,
                  child: const Text('使用 async/await（推荐）'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _useThen,
                  child: const Text('使用 then（对比）'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _parallelExecution,
                  child: const Text('并行执行'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 async/await 让异步代码看起来像同步代码',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 3. Future 链式调用 ====================

/// 模拟数据处理步骤
Future<int> step1(int input) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return input * 2;
}

Future<String> step2(int input) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return '结果: $input';
}

Future<String> step3(String input) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return '$input (已处理)';
}

class FutureChainPage extends StatefulWidget {
  const FutureChainPage({super.key});

  @override
  State<FutureChainPage> createState() => _FutureChainPageState();
}

class _FutureChainPageState extends State<FutureChainPage> {
  String _result = '未执行';
  bool _isLoading = false;
  final _inputController = TextEditingController(text: '10');

  /// 使用 then 链式调用
  void _useThenChain() {
    final input = int.tryParse(_inputController.text) ?? 0;
    
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    step1(input)
        .then((value) => step2(value))
        .then((value) => step3(value))
        .then((value) {
          setState(() {
            _result = value;
            _isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            _result = '错误: $error';
            _isLoading = false;
          });
        });
  }

  /// 使用 async/await（更清晰）
  Future<void> _useAsyncAwait() async {
    final input = int.tryParse(_inputController.text) ?? 0;
    
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    try {
      final step1Result = await step1(input);
      final step2Result = await step2(step1Result);
      final step3Result = await step3(step2Result);
      
      setState(() {
        _result = step3Result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future 链式调用'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              '链式调用',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: '输入数字',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _useThenChain,
                  child: const Text('使用 then 链式调用'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _useAsyncAwait,
                  child: const Text('使用 async/await'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 链式调用可以顺序处理多个异步操作',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 4. 错误处理 ====================

/// 可能失败的异步操作
Future<String> riskyOperation(bool shouldFail) async {
  await Future.delayed(const Duration(seconds: 1));
  if (shouldFail) {
    throw Exception('操作失败');
  }
  return '操作成功';
}

class ErrorHandlingPage extends StatefulWidget {
  const ErrorHandlingPage({super.key});

  @override
  State<ErrorHandlingPage> createState() => _ErrorHandlingPageState();
}

class _ErrorHandlingPageState extends State<ErrorHandlingPage> {
  String _result = '未执行';
  bool _isLoading = false;

  /// 使用 try-catch（推荐）
  Future<void> _useTryCatch() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    try {
      final result = await riskyOperation(false);
      setState(() {
        _result = '结果: $result';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  /// 使用 catchError
  void _useCatchError() {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    riskyOperation(false)
        .then((value) {
          setState(() {
            _result = '结果: $value';
            _isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            _result = '错误: $error';
            _isLoading = false;
          });
        });
  }

  /// 测试错误情况
  Future<void> _testError() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    try {
      final result = await riskyOperation(true);
      setState(() {
        _result = '结果: $result';
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
      print('堆栈: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('错误处理'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              '错误处理',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: TextStyle(
                  fontSize: 16,
                  color: _result.contains('错误') ? Colors.red : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _useTryCatch,
                  child: const Text('使用 try-catch'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _useCatchError,
                  child: const Text('使用 catchError'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testError,
                  child: const Text('测试错误情况'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 使用 try-catch 或 catchError 处理异步错误',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 5. 超时处理 ====================

/// 模拟可能超时的操作
Future<String> slowOperation() async {
  await Future.delayed(const Duration(seconds: 5));
  return '操作完成';
}

class TimeoutPage extends StatefulWidget {
  const TimeoutPage({super.key});

  @override
  State<TimeoutPage> createState() => _TimeoutPageState();
}

class _TimeoutPageState extends State<TimeoutPage> {
  String _result = '未执行';
  bool _isLoading = false;

  /// 使用 timeout
  Future<void> _useTimeout() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    try {
      final result = await slowOperation().timeout(
        const Duration(seconds: 2),
        onTimeout: () => '操作超时',
      );
      
      setState(() {
        _result = '结果: $result';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  /// 使用 timeout 抛出异常
  Future<void> _useTimeoutWithException() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    try {
      final result = await slowOperation().timeout(
        const Duration(seconds: 2),
      );
      
      setState(() {
        _result = '结果: $result';
        _isLoading = false;
      });
    } on TimeoutException catch (e) {
      setState(() {
        _result = '超时异常: $e';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('超时处理'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 80, color: Colors.purple),
            const SizedBox(height: 24),
            const Text(
              '超时处理',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _useTimeout,
                  child: const Text('使用 timeout（返回默认值）'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _useTimeoutWithException,
                  child: const Text('使用 timeout（抛出异常）'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 使用 timeout 可以设置超时时间和处理方式',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 6. Future.wait ====================

/// 模拟多个异步任务
Future<String> task1() async {
  await Future.delayed(const Duration(seconds: 1));
  return '任务1完成';
}

Future<String> task2() async {
  await Future.delayed(const Duration(seconds: 2));
  return '任务2完成';
}

Future<String> task3() async {
  await Future.delayed(const Duration(seconds: 1));
  return '任务3完成';
}

class FutureWaitPage extends StatefulWidget {
  const FutureWaitPage({super.key});

  @override
  State<FutureWaitPage> createState() => _FutureWaitPageState();
}

class _FutureWaitPageState extends State<FutureWaitPage> {
  String _result = '未执行';
  bool _isLoading = false;

  /// 等待所有 Future 完成
  Future<void> _waitAll() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    final stopwatch = Stopwatch()..start();

    try {
      // 并行执行，等待所有完成
      final results = await Future.wait([
        task1(),
        task2(),
        task3(),
      ]);

      stopwatch.stop();

      setState(() {
        _result = '所有任务完成！\n'
            '结果: ${results.join(", ")}\n'
            '耗时: ${stopwatch.elapsedMilliseconds}ms';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  /// 顺序执行（对比）
  Future<void> _sequentialExecution() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    final stopwatch = Stopwatch()..start();

    try {
      final result1 = await task1();
      final result2 = await task2();
      final result3 = await task3();

      stopwatch.stop();

      setState(() {
        _result = '所有任务完成！\n'
            '结果: $result1, $result2, $result3\n'
            '耗时: ${stopwatch.elapsedMilliseconds}ms';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future.wait'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.queue, size: 80, color: Colors.teal),
            const SizedBox(height: 24),
            const Text(
              'Future.wait',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _waitAll,
                  child: const Text('并行执行（Future.wait）'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sequentialExecution,
                  child: const Text('顺序执行（对比）'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 Future.wait 可以并行执行多个任务，提高效率',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 7. Future.any ====================

/// 模拟多个数据源
Future<String> dataSource1() async {
  await Future.delayed(const Duration(seconds: 3));
  return '数据源1';
}

Future<String> dataSource2() async {
  await Future.delayed(const Duration(seconds: 1));
  return '数据源2';
}

Future<String> dataSource3() async {
  await Future.delayed(const Duration(seconds: 2));
  return '数据源3';
}

class FutureAnyPage extends StatefulWidget {
  const FutureAnyPage({super.key});

  @override
  State<FutureAnyPage> createState() => _FutureAnyPageState();
}

class _FutureAnyPageState extends State<FutureAnyPage> {
  String _result = '未执行';
  bool _isLoading = false;

  /// 等待任意一个完成
  Future<void> _waitAny() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    final stopwatch = Stopwatch()..start();

    try {
      // 等待任意一个完成
      final result = await Future.any([
        dataSource1(),
        dataSource2(),
        dataSource3(),
      ]);

      stopwatch.stop();

      setState(() {
        _result = '第一个完成的数据源: $result\n'
            '耗时: ${stopwatch.elapsedMilliseconds}ms';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future.any'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.indigo),
            const SizedBox(height: 24),
            const Text(
              'Future.any',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _waitAny,
              child: const Text('等待任意一个完成'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 Future.any 适合从多个数据源获取数据，使用最快的',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 8. Future.delayed ====================

class FutureDelayedPage extends StatefulWidget {
  const FutureDelayedPage({super.key});

  @override
  State<FutureDelayedPage> createState() => _FutureDelayedPageState();
}

class _FutureDelayedPageState extends State<FutureDelayedPage> {
  String _result = '未执行';
  bool _isLoading = false;
  int _countdown = 0;

  /// 延迟执行
  Future<void> _delayedExecution() async {
    setState(() {
      _isLoading = true;
      _result = '将在 3 秒后执行...';
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _result = '延迟执行完成！';
      _isLoading = false;
    });
  }

  /// 倒计时
  Future<void> _countdownTimer() async {
    setState(() {
      _isLoading = true;
      _countdown = 5;
      _result = '倒计时开始...';
    });

    for (int i = 5; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _countdown = i - 1;
        _result = '倒计时: ${i - 1}';
      });
    }

    setState(() {
      _result = '倒计时结束！';
      _isLoading = false;
    });
  }

  /// 延迟后执行回调
  void _delayedCallback() {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _result = '延迟回调执行完成！';
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future.delayed'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.schedule, size: 80, color: Colors.pink),
            const SizedBox(height: 24),
            const Text(
              'Future.delayed',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              Column(
                children: [
                  if (_countdown > 0)
                    Text(
                      '$_countdown',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    )
                  else
                    const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _delayedExecution,
                  child: const Text('延迟执行'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _countdownTimer,
                  child: const Text('倒计时'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _delayedCallback,
                  child: const Text('延迟回调'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 Future.delayed 可以延迟执行操作，常用于定时任务',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 9. 模拟网络请求 ====================

/// 模拟 API 响应
class ApiResponse {
  final bool success;
  final String data;
  final String? error;

  ApiResponse({
    required this.success,
    required this.data,
    this.error,
  });
}

/// 模拟网络请求
Future<ApiResponse> fetchUserData(String userId) async {
  await Future.delayed(const Duration(seconds: 1));
  
  if (userId.isEmpty) {
    return ApiResponse(
      success: false,
      data: '',
      error: '用户ID不能为空',
    );
  }
  
  return ApiResponse(
    success: true,
    data: '用户数据: $userId',
  );
}

/// 模拟数据处理
Future<String> processData(String rawData) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return '$rawData (已处理)';
}

class NetworkRequestPage extends StatefulWidget {
  const NetworkRequestPage({super.key});

  @override
  State<NetworkRequestPage> createState() => _NetworkRequestPageState();
}

class _NetworkRequestPageState extends State<NetworkRequestPage> {
  String _result = '未执行';
  bool _isLoading = false;
  final _userIdController = TextEditingController(text: '12345');

  /// 完整的网络请求流程
  Future<void> _fetchData() async {
    final userId = _userIdController.text;
    
    setState(() {
      _isLoading = true;
      _result = '请求中...';
    });

    try {
      // 1. 发起网络请求
      final response = await fetchUserData(userId);
      
      if (!response.success) {
        setState(() {
          _result = '错误: ${response.error}';
          _isLoading = false;
        });
        return;
      }

      // 2. 处理数据
      final processedData = await processData(response.data);
      
      setState(() {
        _result = '成功: $processedData';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '异常: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('模拟网络请求'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud, size: 80, color: Colors.cyan),
            const SizedBox(height: 24),
            const Text(
              '网络请求',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: '用户ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _result,
                style: TextStyle(
                  fontSize: 16,
                  color: _result.contains('错误') || _result.contains('异常')
                      ? Colors.red
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchData,
              child: const Text('获取数据'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 实际项目中的网络请求流程：请求 → 处理 → 显示',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 10. 顺序执行多个任务 ====================

/// 模拟任务
Future<String> task(String name, int duration) async {
  await Future.delayed(Duration(seconds: duration));
  return '$name 完成';
}

class SequentialTasksPage extends StatefulWidget {
  const SequentialTasksPage({super.key});

  @override
  State<SequentialTasksPage> createState() => _SequentialTasksPageState();
}

class _SequentialTasksPageState extends State<SequentialTasksPage> {
  String _result = '未执行';
  bool _isLoading = false;
  List<String> _progress = [];

  /// 顺序执行任务
  Future<void> _sequentialExecution() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
      _progress = [];
    });

    final stopwatch = Stopwatch()..start();

    try {
      // 顺序执行
      final result1 = await task('任务1', 1);
      _progress.add(result1);
      setState(() {});

      final result2 = await task('任务2', 1);
      _progress.add(result2);
      setState(() {});

      final result3 = await task('任务3', 1);
      _progress.add(result3);
      setState(() {});

      stopwatch.stop();

      setState(() {
        _result = '所有任务完成！\n耗时: ${stopwatch.elapsedMilliseconds}ms';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  /// 使用循环顺序执行
  Future<void> _sequentialWithLoop() async {
    setState(() {
      _isLoading = true;
      _result = '执行中...';
      _progress = [];
    });

    final stopwatch = Stopwatch()..start();
    final tasks = [
      ('任务1', 1),
      ('任务2', 1),
      ('任务3', 1),
    ];

    try {
      for (final (name, duration) in tasks) {
        final result = await task(name, duration);
        _progress.add(result);
        setState(() {});
      }

      stopwatch.stop();

      setState(() {
        _result = '所有任务完成！\n耗时: ${stopwatch.elapsedMilliseconds}ms';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '错误: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('顺序执行多个任务'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list, size: 80, color: Colors.deepOrange),
            const SizedBox(height: 24),
            const Text(
              '顺序执行',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  if (_progress.isNotEmpty)
                    ..._progress.map((p) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(p, style: const TextStyle(fontSize: 14)),
                        )),
                ],
              )
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _sequentialExecution,
                  child: const Text('顺序执行（手动）'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sequentialWithLoop,
                  child: const Text('顺序执行（循环）'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 顺序执行适合有依赖关系的任务',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

