import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

/// GetX 状态管理示例
/// 展示 GetX 的三种核心能力：状态管理、依赖注入、路由
class GetXExample extends StatelessWidget {
  GetXExample({super.key});

  final CounterController counterController = Get.put(CounterController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX 示例',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      getPages: [
        GetPage(
          name: '/',
          page: () => const GetXHomePage(),
          binding: BindingsBuilder(() {
            // 页面专属依赖也可以在这里注入
            if (!Get.isRegistered<ThemeController>()) {
              Get.put(ThemeController());
            }
          }),
        ),
        GetPage(
          name: '/detail',
          page: () => const DetailPage(),
        ),
      ],
      home: const GetXHomePage(),
    );
  }
}

/// 计数器控制器
class CounterController extends GetxController {
  // 使用 RxInt 进行响应式数据绑定
  final RxInt count = 0.obs;

  void increment() => count.value++;
  void decrement() => count.value--;
  void reset() => count.value = 0;
}

/// 主题控制器
class ThemeController extends GetxController {
  final RxBool isDark = false.obs;

  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(themeMode);
  }
}

/// 首页
class GetXHomePage extends StatelessWidget {
  const GetXHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final counterController = Get.find<CounterController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX 状态管理'),
        actions: [
          Obx(
            () => IconButton(
              tooltip: themeController.isDark.value ? '切换到浅色模式' : '切换到深色模式',
              onPressed: themeController.toggleTheme,
              icon: Icon(
                themeController.isDark.value ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: '1. 状态管理 (Obx)',
              child: Column(
                children: [
                  Obx(
                    () => Text(
                      '计数: ${counterController.count}',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: counterController.decrement,
                        child: const Text('-'),
                      ),
                      ElevatedButton(
                        onPressed: counterController.reset,
                        child: const Text('重置'),
                      ),
                      ElevatedButton(
                        onPressed: counterController.increment,
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '2. GetBuilder (按需刷新)',
              child: GetBuilder<CounterController>(
                init: counterController,
                builder: (controller) {
                  return Column(
                    children: [
                      Text(
                        'GetBuilder 计数: ${controller.count}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: controller.increment,
                        child: const Text('增加'),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '3. 路由和参数传递',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('点击按钮跳转到详情页，并传递参数'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        '/detail',
                        arguments: {'count': counterController.count.value},
                      );
                    },
                    child: const Text('跳转到详情页面'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '4. Snackbar / Dialog / BottomSheet',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        '提示',
                        '现在的计数是 ${counterController.count.value}',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text('显示 Snackbar'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: '确认重置',
                        middleText: '确定要把计数器重置为 0 吗？',
                        onConfirm: () {
                          counterController.reset();
                          Get.back();
                        },
                        onCancel: Get.back,
                      );
                    },
                    child: const Text('显示 Dialog'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '选择主题模式',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              ListTile(
                                leading: const Icon(Icons.light_mode),
                                title: const Text('浅色模式'),
                                onTap: () {
                                  themeController.isDark.value = false;
                                  themeController.toggleTheme();
                                  Get.back();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.dark_mode),
                                title: const Text('深色模式'),
                                onTap: () {
                                  themeController.isDark.value = true;
                                  themeController.toggleTheme();
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text('显示 BottomSheet'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// 详情页面：演示路由参数读取
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final int count = args['count'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('详情页面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('从上一页获取到的计数是：', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text(
              '$count',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(result: '返回值：$count'),
              child: const Text('返回上一页并带回结果'),
            ),
          ],
        ),
      ),
    );
  }
}
