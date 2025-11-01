import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 数据持久化示例
/// 这个文件展示了如何使用SharedPreferences存储简单数据
class DataPersistenceExample extends StatefulWidget {
  const DataPersistenceExample({super.key});

  @override
  State<DataPersistenceExample> createState() => _DataPersistenceExampleState();
}

class _DataPersistenceExampleState extends State<DataPersistenceExample> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _savedName = '未保存';
  int _savedAge = 0;
  bool _savedSwitch = false;
  int _visitCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  /// 加载保存的数据
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('user_name') ?? '未保存';
      _savedAge = prefs.getInt('user_age') ?? 0;
      _savedSwitch = prefs.getBool('switch_state') ?? false;
      _visitCount = prefs.getInt('visit_count') ?? 0;

      // 更新访问次数
      _visitCount++;
      prefs.setInt('visit_count', _visitCount);
    });
  }

  /// 保存字符串数据
  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    setState(() {
      _savedName = _nameController.text;
    });
    _showSnackBar('名字已保存');
  }

  /// 保存整数数据
  Future<void> _saveAge() async {
    final age = int.tryParse(_ageController.text) ?? 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_age', age);
    setState(() {
      _savedAge = age;
    });
    _showSnackBar('年龄已保存');
  }

  /// 保存布尔值数据
  Future<void> _saveSwitch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switch_state', value);
    setState(() {
      _savedSwitch = value;
    });
    _showSnackBar('开关状态已保存');
  }

  /// 清除所有数据
  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _savedName = '未保存';
      _savedAge = 0;
      _savedSwitch = false;
      _visitCount = 0;
      _nameController.clear();
      _ageController.clear();
    });
    _showSnackBar('所有数据已清除');
  }

  /// 显示提示消息
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据持久化示例'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 保存字符串
            _buildSectionCard(
              title: '1. 保存字符串数据',
              description: '使用 setString/getString 存储文本',
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '输入名字',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _saveName,
                    child: const Text('保存名字'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '已保存的名字: $_savedName',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. 保存整数
            _buildSectionCard(
              title: '2. 保存整数数据',
              description: '使用 setInt/getInt 存储数字',
              child: Column(
                children: [
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '输入年龄',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _saveAge,
                    child: const Text('保存年龄'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '已保存的年龄: $_savedAge',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. 保存布尔值
            _buildSectionCard(
              title: '3. 保存布尔值数据',
              description: '使用 setBool/getBool 存储开关状态',
              child: Column(
                children: [
                  Switch(
                    value: _savedSwitch,
                    onChanged: _saveSwitch,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '当前状态: ${_savedSwitch ? "开启" : "关闭"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '提示: 切换开关会自动保存状态',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. 访问次数统计
            _buildSectionCard(
              title: '4. 访问次数统计',
              description: '记录应用打开次数',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 40),
                      const SizedBox(width: 16),
                      Text(
                        '$_visitCount',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '这是你第 $_visitCount 次打开这个页面',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. 数据类型列表
            _buildSectionCard(
              title: '5. 支持的数据类型',
              description: 'SharedPreferences支持的数据类型',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeItem('String', '字符串', Icons.text_fields),
                  _buildTypeItem('int', '整数', Icons.numbers),
                  _buildTypeItem('double', '浮点数', Icons.point_of_sale),
                  _buildTypeItem('bool', '布尔值', Icons.toggle_on),
                  _buildTypeItem('StringList', '字符串列表', Icons.list),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. 清除数据
            _buildSectionCard(
              title: '6. 清除数据',
              description: '删除所有保存的数据',
              child: ElevatedButton(
                onPressed: _clearAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('清除所有数据'),
              ),
            ),
            const SizedBox(height: 20),

            // 提示信息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 提示',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• SharedPreferences适合存储简单的键值对数据\n'
                    '• 数据会在应用重启后保留\n'
                    '• 不适合存储大量数据或复杂对象\n'
                    '• 对于复杂数据，可以考虑使用sqflite或Hive',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildTypeItem(String type, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Text(
            type,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '- $desc',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

