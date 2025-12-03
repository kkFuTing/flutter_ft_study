# Riverpod 状态管理学习指南

## 📚 目录

- [什么是 Riverpod](#什么是-riverpod)
- [为什么使用 Riverpod](#为什么使用-riverpod)
- [核心概念](#核心概念)
- [基础 Provider](#基础-provider)
  - [Provider（只读数据）](#1-provider只读数据)
  - [StateProvider（简单状态）](#2-stateprovider简单状态)
  - [StateNotifierProvider（复杂状态）](#3-statenotifierprovider复杂状态)
- [异步 Provider](#异步-provider)
  - [FutureProvider（异步数据）](#4-futureprovider异步数据)
  - [StreamProvider（流数据）](#5-streamprovider流数据)
- [高级用法](#高级用法)
  - [Provider 组合和依赖](#6-provider-组合和依赖)
  - [Provider 过滤和选择](#7-provider-过滤和选择)
  - [自动处理生命周期](#8-自动处理生命周期)
- [实际应用场景](#实际应用场景)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## 什么是 Riverpod

Riverpod 是 Flutter 的一个**编译时安全**的状态管理和依赖注入框架，是 Provider 的改进版本。

### 核心特点

- ✅ **编译时安全**：编译期就能发现错误，而不是运行时
- ✅ **自动处理生命周期**：Provider 自动管理资源，避免内存泄漏
- ✅ **类型安全**：使用泛型，完全类型安全
- ✅ **易于测试**：可以轻松替换 Provider 进行测试
- ✅ **性能优化**：支持选择性监听，避免不必要的重建
- ✅ **依赖注入**：自动管理依赖关系

---

## 为什么使用 Riverpod

### 1. **编译时安全**

Riverpod 在编译时就能发现错误，而不是运行时：

```dart
// ❌ 编译错误：Provider 未找到
final value = ref.watch(nonExistentProvider);

// ✅ 编译通过：Provider 存在
final value = ref.watch(existingProvider);
```

### 2. **自动生命周期管理**

Provider 自动管理资源，无需手动清理：

```dart
// 使用 autoDispose 自动清理
final provider = Provider.autoDispose((ref) {
  final service = ResourceService();
  ref.onDispose(() => service.dispose());
  return service;
});
```

### 3. **性能优化**

支持选择性监听，只重建需要的部分：

```dart
// 只监听 name 属性，age 变化不会重建
final name = ref.watch(userProvider.select((user) => user.name));
```

### 4. **依赖注入**

自动管理 Provider 之间的依赖关系：

```dart
final apiProvider = Provider((ref) => ApiService());
final repositoryProvider = Provider((ref) {
  final api = ref.watch(apiProvider); // 自动注入
  return Repository(api);
});
```

---

## 核心概念

### ProviderScope

使用 `ProviderScope` 包裹整个应用，提供 Provider 容器：

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### WidgetRef

通过 `WidgetRef` 访问 Provider：

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}
```

### ref.watch vs ref.read

- **`ref.watch`**：监听 Provider，当值变化时自动重建 Widget
- **`ref.read`**：读取 Provider 的当前值，不监听变化

```dart
// 监听变化（会重建）
final count = ref.watch(counterProvider);

// 只读取一次（不重建）
ref.read(counterProvider.notifier).increment();
```

---

## 基础 Provider

### 1. Provider（只读数据）

**特点**：提供不可变的数据，适合配置、常量等。

#### 定义方式

```dart
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(
    appName: 'My App',
    version: '1.0.0',
  );
});
```

#### 使用示例

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    return Text(config.appName);
  }
}
```

#### 适用场景

- 应用配置
- 常量数据
- 只读的服务实例
- 依赖注入的基础服务

---

### 2. StateProvider（简单状态）

**特点**：管理简单的可变状态，适合计数器、开关等。

#### 定义方式

```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

#### 使用示例

```dart
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: Text('增加'),
        ),
      ],
    );
  }
}
```

#### 修改状态

```dart
// 方式1：直接修改 state
ref.read(counterProvider.notifier).state = 10;

// 方式2：基于当前值修改
ref.read(counterProvider.notifier).state++;

// 方式3：使用 update
ref.read(counterProvider.notifier).update((state) => state + 1);
```

#### 适用场景

- 简单的计数器
- 开关状态
- 简单的表单字段
- 不需要复杂逻辑的状态

---

### 3. StateNotifierProvider（复杂状态）

**特点**：管理复杂的状态逻辑，适合列表、表单等。

#### 定义方式

```dart
// 定义状态类
class Todo {
  final String id;
  final String title;
  final bool completed;
  
  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });
  
  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

// 定义 StateNotifier
class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);
  
  void addTodo(String title) {
    state = [
      ...state,
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      ),
    ];
  }
  
  void toggleTodo(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
  }
  
  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

// 定义 Provider
final todoListProvider = StateNotifierProvider<TodoNotifier, List<Todo>>(
  (ref) => TodoNotifier(),
);
```

#### 使用示例

```dart
class TodoListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final notifier = ref.read(todoListProvider.notifier);
    
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.title),
          leading: Checkbox(
            value: todo.completed,
            onChanged: (_) => notifier.toggleTodo(todo.id),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => notifier.removeTodo(todo.id),
          ),
        );
      },
    );
  }
}
```

#### 适用场景

- 列表管理（待办事项、购物车等）
- 复杂表单状态
- 需要业务逻辑的状态
- 需要多个操作的状态

---

## 异步 Provider

### 4. FutureProvider（异步数据）

**特点**：处理异步数据加载，自动管理 loading、data、error 状态。

#### 定义方式

```dart
final userDataProvider = FutureProvider<String>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  return '用户数据';
});
```

#### 使用示例

```dart
class UserDataWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);
    
    return userDataAsync.when(
      data: (data) => Text('数据: $data'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('错误: $error'),
    );
  }
}
```

#### 刷新数据

```dart
// 方式1：使用 invalidate 刷新
ref.invalidate(userDataProvider);

// 方式2：使用 refresh 刷新（返回新的 Future）
final newData = await ref.refresh(userDataProvider.future);
```

#### 适用场景

- API 数据加载
- 文件读取
- 数据库查询
- 任何异步操作

---

### 5. StreamProvider（流数据）

**特点**：处理流式数据，适合 WebSocket、定时器等。

#### 定义方式

```dart
final timerProvider = StreamProvider<int>((ref) async* {
  for (int i = 0; i <= 60; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
});
```

#### 使用示例

```dart
class TimerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);
    
    return timerAsync.when(
      data: (seconds) => Text('$seconds 秒'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('错误: $error'),
    );
  }
}
```

#### 适用场景

- WebSocket 连接
- 定时器
- 传感器数据
- 实时数据流

---

## 高级用法

### 6. Provider 组合和依赖

Provider 可以相互依赖，Riverpod 自动管理依赖关系。

#### 定义方式

```dart
// 基础配置
final baseUrlProvider = Provider<String>((ref) => 'https://api.example.com');

// 依赖 baseUrlProvider
final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return ApiClient(baseUrl);
});

// 依赖 apiClientProvider
final repositoryProvider = Provider<DataRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DataRepository(apiClient);
});
```

#### 使用示例

```dart
class DataWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    return Text(repository.getData());
  }
}
```

#### 依赖注入的优势

- ✅ **自动管理依赖**：Riverpod 自动处理依赖关系
- ✅ **延迟初始化**：只有在需要时才创建
- ✅ **单例保证**：同一个 Provider 只创建一次
- ✅ **易于测试**：可以轻松替换依赖

---

### 7. Provider 过滤和选择

使用 `select` 只监听部分状态，避免不必要的重建。

#### 使用方式

```dart
class User {
  final String name;
  final int age;
  final String email;
  
  User({required this.name, required this.age, required this.email});
}

final userProvider = StateProvider<User>((ref) => User(
  name: '张三',
  age: 25,
  email: 'zhangsan@example.com',
));
```

#### 选择性监听

```dart
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 只监听 name 属性，age 或 email 变化不会重建
    final name = ref.watch(userProvider.select((user) => user.name));
    
    return Text('姓名: $name');
  }
}
```

#### 性能优化

```dart
// ❌ 不推荐：监听整个对象
final user = ref.watch(userProvider); // 任何属性变化都会重建

// ✅ 推荐：只监听需要的属性
final name = ref.watch(userProvider.select((user) => user.name)); // 只有 name 变化才重建
```

---

### 8. 自动处理生命周期

使用 `autoDispose` 自动管理资源，避免内存泄漏。

#### 定义方式

```dart
final resourceProvider = Provider.autoDispose<ResourceService>((ref) {
  final service = ResourceService();
  
  // 当 Provider 被销毁时自动清理
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});
```

#### 生命周期钩子

```dart
final provider = Provider.autoDispose((ref) {
  // 创建时调用
  ref.onAddListener(() {
    print('Provider 被监听');
  });
  
  // 销毁时调用
  ref.onDispose(() {
    print('Provider 被销毁');
  });
  
  // 移除监听时调用
  ref.onRemoveListener(() {
    print('Provider 不再被监听');
  });
  
  return MyService();
});
```

#### 适用场景

- 需要清理资源的服务
- 临时使用的 Provider
- 页面级别的状态
- 避免内存泄漏的场景

---

## 实际应用场景

### 完整的应用结构

```dart
// 1. 配置 Provider
final apiBaseUrlProvider = Provider<String>((ref) => 'https://api.example.com');

// 2. 服务 Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return ApiService(baseUrl);
});

// 3. 数据仓库 Provider
final repositoryProvider = Provider<DataRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return DataRepository(apiService);
});

// 4. 状态管理 Provider
final userStateProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(repositoryProvider);
  return UserNotifier(repository);
});

// 5. 在 Widget 中使用
class UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    final notifier = ref.read(userStateProvider.notifier);
    
    return Scaffold(
      body: userState.when(
        loading: () => CircularProgressIndicator(),
        data: (user) => UserInfo(user: user),
        error: (error, stack) => ErrorWidget(error),
      ),
    );
  }
}
```

---

## 最佳实践

### 1. **使用 ProviderScope 包裹应用**

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 2. **合理选择 Provider 类型**

- **Provider**：只读数据、配置、服务
- **StateProvider**：简单状态（计数器、开关）
- **StateNotifierProvider**：复杂状态（列表、表单）
- **FutureProvider**：异步数据加载
- **StreamProvider**：流式数据

### 3. **使用 select 优化性能**

```dart
// ✅ 推荐：只监听需要的部分
final name = ref.watch(userProvider.select((user) => user.name));

// ❌ 不推荐：监听整个对象
final user = ref.watch(userProvider);
```

### 4. **使用 autoDispose 管理资源**

```dart
// ✅ 推荐：需要清理的资源使用 autoDispose
final resourceProvider = Provider.autoDispose((ref) {
  final service = ResourceService();
  ref.onDispose(() => service.dispose());
  return service;
});
```

### 5. **分离业务逻辑和 UI**

```dart
// ✅ 推荐：业务逻辑在 StateNotifier 中
class UserNotifier extends StateNotifier<UserState> {
  final Repository repository;
  
  UserNotifier(this.repository) : super(UserState());
  
  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await repository.fetchUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

### 6. **使用 ref.read 进行一次性操作**

```dart
// ✅ 推荐：不需要监听的操作使用 read
ElevatedButton(
  onPressed: () {
    ref.read(counterProvider.notifier).increment();
  },
  child: Text('增加'),
);

// ❌ 不推荐：不需要监听却使用 watch
final notifier = ref.watch(counterProvider.notifier); // 会不必要地重建
```

---

## 常见问题

### Q1: 什么时候使用 StateProvider，什么时候使用 StateNotifierProvider？

**A**: 
- **StateProvider**：简单的状态（计数器、开关、简单的字符串/数字）
- **StateNotifierProvider**：复杂的状态（列表、对象、需要业务逻辑的状态）

### Q2: ref.watch 和 ref.read 的区别？

**A**: 
- **`ref.watch`**：监听 Provider，值变化时自动重建 Widget
- **`ref.read`**：只读取一次，不监听变化，适合一次性操作

### Q3: 如何刷新 FutureProvider？

**A**: 使用 `invalidate` 或 `refresh`：

```dart
// 方式1：invalidate（下次访问时重新加载）
ref.invalidate(userDataProvider);

// 方式2：refresh（立即重新加载）
final newData = await ref.refresh(userDataProvider.future);
```

### Q4: 如何处理 Provider 之间的循环依赖？

**A**: 使用 `ref.read` 而不是 `ref.watch` 来打破循环：

```dart
final providerA = Provider((ref) {
  final b = ref.read(providerB); // 使用 read 而不是 watch
  return A(b);
});

final providerB = Provider((ref) {
  final a = ref.read(providerA);
  return B(a);
});
```

### Q5: 如何在测试中替换 Provider？

**A**: 使用 `ProviderScope` 的 `overrides` 参数：

```dart
testWidgets('测试', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiServiceProvider.overrideWithValue(MockApiService()),
      ],
      child: MyApp(),
    ),
  );
});
```

### Q6: autoDispose 什么时候使用？

**A**: 
- 需要清理资源的服务
- 临时使用的 Provider
- 页面级别的状态
- 避免内存泄漏的场景

---

## 总结

Riverpod 是一个强大而灵活的状态管理框架，通过合理使用可以：

- ✅ 实现编译时安全的状态管理
- ✅ 自动管理资源生命周期
- ✅ 优化性能（选择性监听）
- ✅ 简化依赖注入
- ✅ 提高代码可测试性

### 快速参考

```dart
// Provider 类型
Provider<T>              // 只读数据
StateProvider<T>         // 简单状态
StateNotifierProvider    // 复杂状态
FutureProvider<T>        // 异步数据
StreamProvider<T>        // 流数据

// 使用方式
ref.watch(provider)     // 监听变化
ref.read(provider)       // 只读一次
ref.select(provider)     // 选择性监听

// 生命周期
Provider.autoDispose    // 自动清理
ref.onDispose()         // 清理钩子
```

---

## 相关资源

- [Riverpod 官方文档](https://riverpod.dev/)
- [示例代码](../lib/examples/11_riverpod.dart)
- [Flutter 状态管理最佳实践](https://flutter.dev/docs/development/data-and-backend/state-mgmt)

---

**最后更新**: 2024年

