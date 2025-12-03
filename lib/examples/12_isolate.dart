import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Isolate 并发编程示例
/// 展示 Dart Isolate 的核心功能：并发执行、消息传递、compute 函数等
class IsolateExample extends StatelessWidget {
  const IsolateExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate 示例',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const IsolateHomePage(),
    );
  }
}

// ==================== 首页 ====================

class IsolateHomePage extends StatelessWidget {
  const IsolateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate 并发编程示例'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('基础 Isolate'),
          _buildExampleCard(
            context,
            title: '1. 基础 Isolate 创建',
            description: '创建独立的 Isolate 执行任务',
            icon: Icons.play_arrow,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BasicIsolatePage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '2. Isolate 消息传递',
            description: '主 Isolate 和子 Isolate 之间的通信',
            icon: Icons.message,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessagePassingPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '3. 双向通信',
            description: 'Isolate 之间的双向消息传递',
            icon: Icons.swap_horiz,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BidirectionalCommunicationPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('compute 函数'),
          _buildExampleCard(
            context,
            title: '4. compute 函数（简化版）',
            description: '使用 compute 简化 Isolate 创建',
            icon: Icons.functions,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ComputeFunctionPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '5. 大量数据处理',
            description: '使用 compute 处理大量数据',
            icon: Icons.data_usage,
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HeavyDataProcessingPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('实际应用场景'),
          _buildExampleCard(
            context,
            title: '6. 斐波那契数列计算',
            description: 'CPU 密集型任务示例',
            icon: Icons.calculate,
            color: Colors.indigo,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FibonacciPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '7. 长时间运行的任务',
            description: '在后台执行长时间任务',
            icon: Icons.timer,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LongRunningTaskPage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            title: '8. 错误处理',
            description: 'Isolate 中的错误捕获和处理',
            icon: Icons.error_outline,
            color: Colors.pink,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ErrorHandlingPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Isolate API 说明'),
          _buildInfoCard(
            'Isolate.spawn()',
            '创建新的 Isolate',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'compute()',
            '简化 Isolate 创建（Flutter）',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'SendPort / ReceivePort',
            'Isolate 之间的消息传递',
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            'Isolate.exit()',
            '退出 Isolate',
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

// ==================== 1. 基础 Isolate 创建 ====================

/// Isolate 入口函数（必须是顶级函数或静态方法）
void isolateEntryPoint(SendPort sendPort) {
  // 在独立的 Isolate 中执行任务
  final result = heavyComputation();
  
  // 通过 SendPort 发送结果
  sendPort.send(result);
}

/// 模拟耗时计算
int heavyComputation() {
  int sum = 0;
  for (int i = 0; i < 100000000; i++) {
    sum += i;
  }
  return sum;
}

class BasicIsolatePage extends StatefulWidget {
  const BasicIsolatePage({super.key});

  @override
  State<BasicIsolatePage> createState() => _BasicIsolatePageState();
}

class _BasicIsolatePageState extends State<BasicIsolatePage> {
  String _result = '未开始';
  bool _isLoading = false;

  Future<void> _runInIsolate() async {
    setState(() {
      _isLoading = true;
      _result = '计算中...';
    });

    // 创建 ReceivePort 接收消息
    final receivePort = ReceivePort();

    // 创建新的 Isolate
    await Isolate.spawn(
      isolateEntryPoint,
      receivePort.sendPort,
    );

    // 监听消息
    receivePort.listen((message) {
      setState(() {
        _result = '结果: $message';
        _isLoading = false;
      });
      receivePort.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('基础 Isolate 创建'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                '基础 Isolate',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  _result,
                  style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _runInIsolate,
                child: const Text('在 Isolate 中执行计算'),
              ),
              const SizedBox(height: 24),
              const Text(
                '💡 Isolate 在独立线程中运行，不会阻塞 UI',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 2. Isolate 消息传递 ====================

/// Isolate 入口函数（接收消息）
void messagePassingEntryPoint(SendPort sendPort) {
  // 创建 ReceivePort 接收主 Isolate 的消息
  final receivePort = ReceivePort();
  
  // 将 ReceivePort 的 SendPort 发送给主 Isolate
  sendPort.send(receivePort.sendPort);

  // 监听消息
  receivePort.listen((message) {
    if (message is String) {
      // 处理消息并返回结果
      final result = 'Isolate 收到: $message，已处理';
      sendPort.send(result);
    } else if (message == 'exit') {
      // 收到退出信号
      receivePort.close();
      Isolate.exit();
    }
  });
}

class MessagePassingPage extends StatefulWidget {
  const MessagePassingPage({super.key});

  @override
  State<MessagePassingPage> createState() => _MessagePassingPageState();
}

class _MessagePassingPageState extends State<MessagePassingPage> {
  String _result = '未发送消息';
  SendPort? _isolateSendPort;
  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<void> _createIsolate() async {
    final receivePort = ReceivePort();
    
    // 创建 Isolate
    _isolate = await Isolate.spawn(
      messagePassingEntryPoint,
      receivePort.sendPort,
    );

    // 接收 Isolate 的 SendPort
    receivePort.listen((message) {
      if (message is SendPort) {
        setState(() {
          _isolateSendPort = message;
          _result = 'Isolate 已创建，可以发送消息';
        });
      } else if (message is String) {
        setState(() {
          _result = message;
        });
      }
    });

    _receivePort = receivePort;
  }

  void _sendMessage(String message) {
    if (_isolateSendPort != null) {
      _isolateSendPort!.send(message);
      setState(() {
        _result = '已发送: $message';
      });
    }
  }

  void _disposeIsolate() {
    if (_isolateSendPort != null) {
      _isolateSendPort!.send('exit');
      _isolateSendPort = null;
    }
    _isolate?.kill();
    _receivePort?.close();
    setState(() {
      _result = 'Isolate 已销毁';
    });
  }

  @override
  void dispose() {
    _disposeIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate 消息传递'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.message, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              '消息传递',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text(
              _result,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isolate == null ? _createIsolate : null,
              child: const Text('创建 Isolate'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isolateSendPort != null
                  ? () => _sendMessage('Hello from main!')
                  : null,
              child: const Text('发送消息'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isolate != null ? _disposeIsolate : null,
              child: const Text('销毁 Isolate'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 通过 SendPort 和 ReceivePort 实现 Isolate 之间的通信',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 3. 双向通信 ====================

/// 双向通信的 Isolate 入口函数
void bidirectionalEntryPoint(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  
  // 发送 ReceivePort 的 SendPort 给主 Isolate
  mainSendPort.send(receivePort.sendPort);

  int counter = 0;

  // 监听主 Isolate 的消息
  receivePort.listen((message) {
    if (message == 'increment') {
      counter++;
      mainSendPort.send('计数器: $counter');
    } else if (message == 'reset') {
      counter = 0;
      mainSendPort.send('计数器已重置');
    } else if (message == 'exit') {
      receivePort.close();
      Isolate.exit();
    }
  });
}

class BidirectionalCommunicationPage extends StatefulWidget {
  const BidirectionalCommunicationPage({super.key});

  @override
  State<BidirectionalCommunicationPage> createState() =>
      _BidirectionalCommunicationPageState();
}

class _BidirectionalCommunicationPageState
    extends State<BidirectionalCommunicationPage> {
  String _status = '未创建';
  SendPort? _isolateSendPort;
  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<void> _createIsolate() async {
    final receivePort = ReceivePort();
    
    _isolate = await Isolate.spawn(
      bidirectionalEntryPoint,
      receivePort.sendPort,
    );

    receivePort.listen((message) {
      if (message is SendPort) {
        setState(() {
          _isolateSendPort = message;
          _status = 'Isolate 已创建，可以通信';
        });
      } else if (message is String) {
        setState(() {
          _status = message;
        });
      }
    });

    _receivePort = receivePort;
  }

  void _sendCommand(String command) {
    _isolateSendPort?.send(command);
  }

  void _disposeIsolate() {
    _isolateSendPort?.send('exit');
    _isolate?.kill();
    _receivePort?.close();
    _isolateSendPort = null;
    setState(() {
      _status = 'Isolate 已销毁';
    });
  }

  @override
  void dispose() {
    _disposeIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('双向通信'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.swap_horiz, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              '双向通信',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text(
              _status,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isolate == null ? _createIsolate : null,
              child: const Text('创建 Isolate'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isolateSendPort != null
                      ? () => _sendCommand('increment')
                      : null,
                  child: const Text('增加'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isolateSendPort != null
                      ? () => _sendCommand('reset')
                      : null,
                  child: const Text('重置'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isolate != null ? _disposeIsolate : null,
              child: const Text('销毁 Isolate'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 主 Isolate 和子 Isolate 可以相互发送消息',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 4. compute 函数 ====================

/// 计算函数（必须是顶级函数或静态方法）
int calculateSum(int n) {
  int sum = 0;
  for (int i = 0; i < n; i++) {
    sum += i;
  }
  return sum;
}

class ComputeFunctionPage extends StatefulWidget {
  const ComputeFunctionPage({super.key});

  @override
  State<ComputeFunctionPage> createState() => _ComputeFunctionPageState();
}

class _ComputeFunctionPageState extends State<ComputeFunctionPage> {
  String _result = '未计算';
  bool _isLoading = false;
  final _inputController = TextEditingController(text: '100000000');

  Future<void> _calculate() async {
    final input = int.tryParse(_inputController.text) ?? 0;
    
    if (input <= 0) {
      setState(() {
        _result = '请输入有效的数字';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '计算中...';
    });

    try {
      // 使用 compute 函数在 Isolate 中执行
      final result = await compute(calculateSum, input);
      
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

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('compute 函数'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.functions, size: 80, color: Colors.purple),
            const SizedBox(height: 24),
            const Text(
              'compute 函数',
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
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _calculate,
              child: const Text('计算'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 compute 函数简化了 Isolate 的创建和使用',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 5. 大量数据处理 ====================

/// 处理大量数据
List<int> processLargeData(List<int> data) {
  // 模拟耗时处理
  return data.map((e) => e * 2).toList();
}

class HeavyDataProcessingPage extends StatefulWidget {
  const HeavyDataProcessingPage({super.key});

  @override
  State<HeavyDataProcessingPage> createState() =>
      _HeavyDataProcessingPageState();
}

class _HeavyDataProcessingPageState extends State<HeavyDataProcessingPage> {
  String _result = '未处理';
  bool _isLoading = false;
  List<int>? _processedData;

  Future<void> _processData() async {
    setState(() {
      _isLoading = true;
      _result = '处理中...';
    });

    // 生成大量数据
    final data = List.generate(10000000, (index) => index);

    try {
      // 在 Isolate 中处理
      final processed = await compute(processLargeData, data);
      
      setState(() {
        _processedData = processed;
        _result = '处理完成！数据量: ${processed.length}';
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
        title: const Text('大量数据处理'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.data_usage, size: 80, color: Colors.teal),
            const SizedBox(height: 24),
            const Text(
              '大量数据处理',
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
            if (_processedData != null) ...[
              const SizedBox(height: 16),
              Text(
                '前 10 个结果: ${_processedData!.take(10).join(", ")}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _processData,
              child: const Text('处理 1000 万条数据'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 使用 compute 处理大量数据，不会阻塞 UI',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 6. 斐波那契数列计算 ====================

/// 计算斐波那契数列（递归版本，CPU 密集型）
int fibonacci(int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

class FibonacciPage extends StatefulWidget {
  const FibonacciPage({super.key});

  @override
  State<FibonacciPage> createState() => _FibonacciPageState();
}

class _FibonacciPageState extends State<FibonacciPage> {
  String _result = '未计算';
  bool _isLoading = false;
  Duration? _duration;
  final _inputController = TextEditingController(text: '40');

  Future<void> _calculate() async {
    final n = int.tryParse(_inputController.text) ?? 0;
    
    if (n < 0 || n > 45) {
      setState(() {
        _result = '请输入 0-45 之间的数字';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '计算中...';
    });

    final stopwatch = Stopwatch()..start();

    try {
      // 在 Isolate 中计算
      final result = await compute(fibonacci, n);
      stopwatch.stop();

      setState(() {
        _result = 'F($n) = $result';
        _duration = stopwatch.elapsed;
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
        title: const Text('斐波那契数列计算'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate, size: 80, color: Colors.indigo),
            const SizedBox(height: 24),
            const Text(
              '斐波那契数列',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: '输入 n (0-45)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (_duration != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '耗时: ${_duration!.inMilliseconds}ms',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _calculate,
              child: const Text('计算'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 CPU 密集型任务适合在 Isolate 中执行',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 7. 长时间运行的任务 ====================

/// 长时间运行的任务
String longRunningTask(int duration) {
  for (int i = 0; i < duration; i++) {
    // 模拟工作（计算大量数据）
    List.generate(1000000, (j) => j).fold(0, (a, b) => a + b);
    if (i % 10 == 0) {
      print('进度: $i/$duration');
    }
  }
  return '任务完成！执行了 $duration 次迭代';
}

class LongRunningTaskPage extends StatefulWidget {
  const LongRunningTaskPage({super.key});

  @override
  State<LongRunningTaskPage> createState() => _LongRunningTaskPageState();
}

class _LongRunningTaskPageState extends State<LongRunningTaskPage> {
  String _result = '未开始';
  bool _isLoading = false;
  final _inputController = TextEditingController(text: '100');

  Future<void> _runTask() async {
    final duration = int.tryParse(_inputController.text) ?? 0;
    
    if (duration <= 0) {
      setState(() {
        _result = '请输入有效的数字';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '任务执行中...';
    });

    try {
      // 在 Isolate 中执行长时间任务
      final result = await compute(longRunningTask, duration);
      
      setState(() {
        _result = result;
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
        title: const Text('长时间运行的任务'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              '长时间任务',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: '迭代次数',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('任务执行中，UI 仍然流畅...'),
                ],
              )
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _runTask,
              child: const Text('执行任务'),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 长时间任务在 Isolate 中执行，不会阻塞 UI',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 8. 错误处理 ====================

/// 可能抛出异常的函数
int riskyCalculation(int n) {
  if (n < 0) {
    throw ArgumentError('n 不能为负数');
  }
  if (n > 100) {
    throw StateError('n 不能大于 100');
  }
  return n * 2;
}

class ErrorHandlingPage extends StatefulWidget {
  const ErrorHandlingPage({super.key});

  @override
  State<ErrorHandlingPage> createState() => _ErrorHandlingPageState();
}

class _ErrorHandlingPageState extends State<ErrorHandlingPage> {
  String _result = '未计算';
  bool _isLoading = false;
  final _inputController = TextEditingController(text: '10');

  Future<void> _calculate() async {
    final n = int.tryParse(_inputController.text);
    
    if (n == null) {
      setState(() {
        _result = '请输入有效的数字';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '计算中...';
    });

    try {
      // 在 Isolate 中执行，异常会被传播
      final result = await compute(riskyCalculation, n);
      
      setState(() {
        _result = '结果: $result';
        _isLoading = false;
      });
    } on ArgumentError catch (e) {
      setState(() {
        _result = '参数错误: $e';
        _isLoading = false;
      });
    } on StateError catch (e) {
      setState(() {
        _result = '状态错误: $e';
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      setState(() {
        _result = '未知错误: $e';
        _isLoading = false;
      });
      print('错误堆栈: $stackTrace');
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
        title: const Text('错误处理'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.pink),
            const SizedBox(height: 24),
            const Text(
              '错误处理',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: '输入数字 (0-100)',
                border: OutlineInputBorder(),
                helperText: '负数或大于 100 会触发错误',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _calculate,
              child: const Text('计算'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _inputController.text = '-5';
                          _calculate();
                        },
                  child: const Text('测试负数'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _inputController.text = '150';
                          _calculate();
                        },
                  child: const Text('测试大数'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 Isolate 中的异常会被传播到主 Isolate',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

