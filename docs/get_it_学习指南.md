# GetIt 依赖注入学习指南

## 📚 目录

- [什么是 GetIt](#什么是-getit)
- [为什么使用 GetIt](#为什么使用-getit)
- [核心概念](#核心概念)
- [基础用法](#基础用法)
  - [单例模式（Singleton）](#1-单例模式singleton)
  - [懒加载单例（Lazy Singleton）](#2-懒加载单例lazy-singleton)
  - [工厂模式（Factory）](#3-工厂模式factory)
- [高级用法](#高级用法)
  - [依赖注入](#4-依赖注入)
  - [命名注册](#5-命名注册)
  - [异步注册](#6-异步注册)
  - [带参数工厂](#7-带参数工厂)
- [实际应用场景](#实际应用场景)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## 什么是 GetIt

GetIt 是一个简单而强大的**服务定位器（Service Locator）**和**依赖注入（Dependency Injection）**库，用于 Flutter/Dart 应用。

### 核心特点

- ✅ **轻量级**：零依赖，体积小
- ✅ **类型安全**：使用泛型，编译时类型检查
- ✅ **简单易用**：API 简洁直观
- ✅ **高性能**：注册和获取服务都非常快速
- ✅ **支持异步**：可以注册需要异步初始化的服务

---

## 为什么使用 GetIt

### 1. **解耦合**
通过依赖注入，组件不需要直接创建依赖对象，降低耦合度。

```dart
// ❌ 不好的做法：直接创建依赖
class UserRepository {
  final apiService = ApiService(); // 紧耦合
}

// ✅ 好的做法：通过 GetIt 注入
class UserRepository {
  final ApiService apiService;
  UserRepository(this.apiService); // 松耦合
}
```

### 2. **便于测试**
可以轻松替换为 Mock 对象进行单元测试。

```dart
// 测试时可以替换为 Mock
GetIt.instance.registerSingleton<ApiService>(MockApiService());
```

### 3. **管理全局服务**
统一管理应用中的单例服务（API、数据库、缓存等）。

### 4. **生命周期管理**
自动管理服务的生命周期，避免内存泄漏。

---

## 核心概念

### GetIt 实例

GetIt 使用单例模式，通过 `GetIt.instance` 获取全局唯一实例：

```dart
final getIt = GetIt.instance;
```

### 注册方式对比

| 注册方式 | 创建时机 | 实例数量 | 适用场景 |
|---------|---------|---------|---------|
| `registerSingleton` | 立即创建 | 1个 | 全局服务（API、数据库） |
| `registerLazySingleton` | 首次使用时 | 1个 | 延迟初始化的服务 |
| `registerFactory` | 每次获取时 | 多个 | 需要新实例的场景 |

---

## 基础用法

### 1. 单例模式（Singleton）

**特点**：立即创建，整个应用只有一个实例。

#### 注册方式

```dart
final getIt = GetIt.instance;

// 方式1：直接注册实例
getIt.registerSingleton<UserService>(UserService());

// 方式2：使用工厂函数
getIt.registerSingleton<UserService>(
  () => UserService(),
);
```

#### 使用示例

```dart
// 注册
class UserService {
  String _userName = '未设置';
  void setUserName(String name) => _userName = name;
  String getUserName() => _userName;
}

getIt.registerSingleton<UserService>(UserService());

// 获取（始终是同一个实例）
final userService1 = getIt<UserService>();
final userService2 = getIt<UserService>();

print(userService1 == userService2); // true ✅
```

#### 适用场景

- 全局配置服务
- API 客户端
- 数据库服务
- 缓存服务
- 用户认证服务

---

### 2. 懒加载单例（Lazy Singleton）

**特点**：第一次使用时才创建，之后复用同一个实例。

#### 注册方式

```dart
getIt.registerLazySingleton<ApiService>(
  () => ApiService(),
);
```

#### 使用示例

```dart
// 注册（此时不会创建实例）
getIt.registerLazySingleton<ApiService>(() => ApiService());

// 第一次获取时才创建
final apiService1 = getIt<ApiService>(); // 此时创建
final apiService2 = getIt<ApiService>(); // 复用已创建的实例

print(apiService1 == apiService2); // true ✅
```

#### 适用场景

- 初始化成本较高的服务
- 可能不会使用的服务
- 需要延迟初始化的服务

---

### 3. 工厂模式（Factory）

**特点**：每次获取都创建新实例。

#### 注册方式

```dart
getIt.registerFactory<DataRepository>(
  () => DataRepository(),
);
```

#### 使用示例

```dart
// 注册
getIt.registerFactory<DataRepository>(
  () => DataRepository(),
);

// 每次获取都是新实例
final repo1 = getIt<DataRepository>();
final repo2 = getIt<DataRepository>();

print(repo1 == repo2); // false ✅（不同实例）
```

#### 适用场景

- 需要多个独立实例的场景
- 临时对象
- 状态不应该共享的对象

---

## 高级用法

### 4. 依赖注入

GetIt 可以自动注入依赖的服务。

#### 注册方式

```dart
// 先注册被依赖的服务
getIt.registerLazySingleton<ApiService>(() => ApiService());

// 注册依赖其他服务的服务
getIt.registerFactory<DataRepository>(
  () => DataRepository(getIt<ApiService>()), // 自动注入
);
```

#### 使用示例

```dart
class ApiService {
  String fetchData() => '从 API 获取的数据';
}

class DataRepository {
  final ApiService apiService;
  
  DataRepository(this.apiService); // 通过构造函数注入
  
  String fetchData() => apiService.fetchData();
}

// 注册
getIt.registerLazySingleton<ApiService>(() => ApiService());
getIt.registerFactory<DataRepository>(
  () => DataRepository(getIt<ApiService>()),
);

// 使用
final repository = getIt<DataRepository>();
print(repository.fetchData()); // 从 API 获取的数据
```

#### 依赖注入的优势

- ✅ **解耦合**：组件不直接依赖具体实现
- ✅ **可测试**：可以轻松替换为 Mock 对象
- ✅ **可维护**：修改依赖不影响使用方

---

### 5. 命名注册

同一个接口可以注册多个实现，通过名称区分。

#### 注册方式

```dart
// 注册多个实现
getIt.registerSingleton<Logger>(
  ConsoleLogger(),
  instanceName: 'console',
);

getIt.registerSingleton<Logger>(
  FileLogger(),
  instanceName: 'file',
);
```

#### 使用示例

```dart
abstract class Logger {
  void log(String message);
}

class ConsoleLogger implements Logger {
  @override
  void log(String message) => print('[Console] $message');
}

class FileLogger implements Logger {
  @override
  void log(String message) => print('[File] $message');
}

// 注册
getIt.registerSingleton<Logger>(ConsoleLogger(), instanceName: 'console');
getIt.registerSingleton<Logger>(FileLogger(), instanceName: 'file');

// 使用
final consoleLogger = getIt<Logger>(instanceName: 'console');
final fileLogger = getIt<Logger>(instanceName: 'file');

consoleLogger.log('控制台日志');
fileLogger.log('文件日志');
```

#### 适用场景

- 同一接口的多个实现
- 不同环境的配置（开发/生产）
- 策略模式实现

---

### 6. 异步注册

需要异步初始化的服务可以使用异步注册。

#### 注册方式

```dart
getIt.registerSingletonAsync<DatabaseService>(
  () async {
    final db = DatabaseService();
    await db.initialize();
    return db;
  },
);
```

#### 使用示例

```dart
class DatabaseService {
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    // 模拟异步初始化
    await Future.delayed(Duration(seconds: 1));
    _isInitialized = true;
  }
  
  bool get isInitialized => _isInitialized;
}

// 注册
getIt.registerSingletonAsync<DatabaseService>(
  () async {
    final db = DatabaseService();
    await db.initialize();
    return db;
  },
);

// 使用（需要 await）
final db = await getIt.getAsync<DatabaseService>();
print(db.isInitialized); // true
```

#### 注意事项

- 使用 `getAsync<T>()` 获取异步注册的服务
- 确保在使用前完成初始化
- 可以在应用启动时预初始化

```dart
// 应用启动时预初始化
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 配置 GetIt
  setupGetIt();
  
  // 预初始化异步服务
  await getIt.allReady();
  
  runApp(MyApp());
}
```

---

### 7. 带参数工厂

创建时需要传入参数的服务可以使用带参数工厂。

#### 注册方式

```dart
// registerFactoryParam 支持 1-2 个参数
getIt.registerFactoryParam<HttpClient, String, void>(
  (baseUrl, _) => HttpClient(baseUrl),
);
```

#### 使用示例

```dart
class HttpClient {
  final String baseUrl;
  
  HttpClient(this.baseUrl);
  
  String makeRequest(String method, String path) {
    return '$method $baseUrl$path';
  }
}

// 注册（支持 1-2 个参数）
getIt.registerFactoryParam<HttpClient, String, void>(
  (baseUrl, _) => HttpClient(baseUrl),
);

// 使用（传入参数）
final client1 = getIt<HttpClient>(param1: 'https://api.example.com');
final client2 = getIt<HttpClient>(param1: 'https://api.test.com');

print(client1.makeRequest('GET', '/users'));
// GET https://api.example.com/users
```

#### 参数类型说明

- `registerFactoryParam<T, P1, P2>`：支持 0-2 个参数
- `P1`：第一个参数类型
- `P2`：第二个参数类型（不需要时用 `void`）

---

## 实际应用场景

### 完整的服务配置示例

```dart
void setupGetIt() {
  final getIt = GetIt.instance;

  // 1. 注册 API 服务（懒加载单例）
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(baseUrl: 'https://api.example.com'),
  );

  // 2. 注册数据库服务（异步单例）
  getIt.registerSingletonAsync<DatabaseService>(
    () async {
      final db = DatabaseService();
      await db.initialize();
      return db;
    },
  );

  // 3. 注册数据仓库（工厂，依赖注入）
  getIt.registerFactory<DataRepository>(
    () => DataRepository(
      getIt<ApiService>(),
      getIt<DatabaseService>(),
    ),
  );

  // 4. 注册用户服务（单例）
  getIt.registerSingleton<UserService>(UserService());

  // 5. 注册日志服务（命名注册）
  getIt.registerSingleton<Logger>(
    ConsoleLogger(),
    instanceName: 'console',
  );
  getIt.registerSingleton<Logger>(
    FileLogger(),
    instanceName: 'file',
  );
}
```

### 在 Widget 中使用

```dart
class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 从 GetIt 获取服务
    final userService = GetIt.instance<UserService>();
    final repository = GetIt.instance<DataRepository>();
    
    return Scaffold(
      appBar: AppBar(title: Text('用户列表')),
      body: FutureBuilder(
        future: repository.fetchUsers(),
        builder: (context, snapshot) {
          // ...
        },
      ),
    );
  }
}
```

---

## 最佳实践

### 1. **统一配置位置**

将所有 GetIt 配置放在一个地方，通常在应用启动时调用：

```dart
void main() {
  setupGetIt(); // 统一配置
  runApp(MyApp());
}
```

### 2. **使用懒加载单例**

对于初始化成本高的服务，优先使用 `registerLazySingleton`：

```dart
// ✅ 推荐：懒加载
getIt.registerLazySingleton<HeavyService>(() => HeavyService());

// ❌ 不推荐：立即创建
getIt.registerSingleton<HeavyService>(HeavyService());
```

### 3. **检查服务是否已注册**

在获取服务前检查是否已注册，避免运行时错误：

```dart
if (getIt.isRegistered<UserService>()) {
  final userService = getIt<UserService>();
}
```

### 4. **使用接口而非具体类**

注册时使用接口，提高灵活性：

```dart
// ✅ 推荐：使用接口
getIt.registerSingleton<ILogger>(ConsoleLogger());

// ❌ 不推荐：使用具体类
getIt.registerSingleton<ConsoleLogger>(ConsoleLogger());
```

### 5. **异步服务预初始化**

对于异步服务，在应用启动时预初始化：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setupGetIt();
  
  // 预初始化所有异步服务
  await getIt.allReady();
  
  runApp(MyApp());
}
```

### 6. **测试时重置 GetIt**

在测试中，每次测试前重置 GetIt：

```dart
setUp(() {
  GetIt.instance.reset(); // 重置所有注册
  setupGetIt(); // 重新配置
});
```

---

## 常见问题

### Q1: 什么时候使用 Singleton，什么时候使用 Factory？

**A**: 
- **Singleton**：需要共享状态的服务（API、数据库、用户服务）
- **Factory**：需要独立实例的场景（每次使用都需要新对象）

### Q2: 如何替换已注册的服务？

**A**: 使用 `reset()` 重置后重新注册，或使用 `unregister()` 取消注册：

```dart
// 方式1：重置所有
GetIt.instance.reset();

// 方式2：取消特定注册
GetIt.instance.unregister<UserService>();
```

### Q3: 如何处理循环依赖？

**A**: 避免循环依赖，或使用懒加载单例延迟初始化：

```dart
// ❌ 循环依赖
class A {
  final B b;
  A(this.b);
}
class B {
  final A a;
  B(this.a);
}

// ✅ 使用懒加载解决
getIt.registerLazySingleton<A>(() => A(getIt<B>()));
getIt.registerLazySingleton<B>(() => B(getIt<A>()));
```

### Q4: 如何在测试中使用 Mock 对象？

**A**: 在测试中重新注册为 Mock 对象：

```dart
setUp(() {
  GetIt.instance.reset();
  GetIt.instance.registerSingleton<ApiService>(MockApiService());
});
```

### Q5: 异步服务初始化失败怎么办？

**A**: 使用 try-catch 处理异常，或使用 `allReady()` 等待所有服务就绪：

```dart
try {
  await getIt.allReady();
} catch (e) {
  print('服务初始化失败: $e');
}
```

---

## 总结

GetIt 是一个强大而简单的依赖注入库，通过合理使用可以：

- ✅ 降低代码耦合度
- ✅ 提高代码可测试性
- ✅ 统一管理全局服务
- ✅ 简化依赖管理

### 快速参考

```dart
// 注册
getIt.registerSingleton<T>(instance);
getIt.registerLazySingleton<T>(() => T());
getIt.registerFactory<T>(() => T());

// 获取
final service = getIt<T>();
final service = getIt<T>(instanceName: 'name');

// 检查
bool isRegistered = getIt.isRegistered<T>();

// 重置
getIt.reset();
```

---

## 相关资源

- [GetIt 官方文档](https://pub.dev/packages/get_it)
- [示例代码](../lib/examples/10_get_it.dart)
- [Flutter 依赖注入最佳实践](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options#dependency-injection)

---

**最后更新**: 2024年

