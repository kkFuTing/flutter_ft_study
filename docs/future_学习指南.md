# Future 异步编程学习指南

## 📚 目录

- [什么是 Future](#什么是-future)
- [为什么使用 Future](#为什么使用-future)
- [基础 Future](#基础-future)
  - [创建 Future](#1-创建-future)
  - [async/await 语法](#2-asyncawait-语法)
  - [链式调用](#3-链式调用)
- [错误处理](#错误处理)
  - [错误处理方式](#4-错误处理方式)
  - [超时处理](#5-超时处理)
- [Future 组合](#future-组合)
  - [Future.wait](#6-futurewait)
  - [Future.any](#7-futureany)
  - [Future.delayed](#8-futuredelayed)
- [实际应用场景](#实际应用场景)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## 什么是 Future

`Future` 是 Dart 中表示**异步操作结果**的类型。它代表一个可能在未来某个时刻完成（或失败）的计算。

### 核心概念

- **异步操作**：不会立即返回结果的操作
- **非阻塞**：不会阻塞当前线程
- **单次结果**：一个 Future 只能产生一个结果（或错误）

---

## 为什么使用 Future

### 1. **避免阻塞 UI**

```dart
// ❌ 不推荐：同步操作会阻塞 UI
String fetchData() {
  // 耗时操作
  return '数据';
}

// ✅ 推荐：异步操作不阻塞 UI
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return '数据';
}
```

### 2. **处理网络请求**

网络请求是典型的异步操作：

```dart
Future<Response> fetchUser() async {
  return await http.get(Uri.parse('https://api.example.com/user'));
}
```

### 3. **处理文件 I/O**

文件读写也是异步操作：

```dart
Future<String> readFile() async {
  return await File('data.txt').readAsString();
}
```

---

## 基础 Future

### 1. 创建 Future

#### 方式1：使用 `Future.value`

```dart
Future<String> getValue() {
  return Future.value('立即返回的值');
}
```

#### 方式2：使用 `Future.delayed`

```dart
Future<String> getDelayedValue() {
  return Future.delayed(
    Duration(seconds: 2),
    () => '延迟返回的值',
  );
}
```

#### 方式3：使用 `async` 函数

```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return '数据';
}
```

#### 方式4：使用 `Future` 构造函数

```dart
Future<String> computeValue() {
  return Future(() {
    // 在下一个事件循环中执行
    return '计算的值';
  });
}
```

---

### 2. async/await 语法

`async/await` 是 Dart 提供的语法糖，让异步代码看起来像同步代码。

#### 使用 async/await（推荐）

```dart
Future<String> fetchUser() async {
  await Future.delayed(Duration(seconds: 1));
  return '用户数据';
}

Future<String> fetchProfile(String userId) async {
  await Future.delayed(Duration(seconds: 1));
  return '用户资料: $userId';
}

// 使用 async/await
Future<void> loadData() async {
  final user = await fetchUser();
  final profile = await fetchProfile(user);
  print(profile);
}
```

#### 使用 then（对比）

```dart
// 使用 then（不推荐，但可以对比）
void loadData() {
  fetchUser().then((user) {
    return fetchProfile(user);
  }).then((profile) {
    print(profile);
  });
}
```

#### 并行执行

```dart
// 并行执行多个异步操作
Future<void> loadData() async {
  final results = await Future.wait([
    fetchUser(),
    fetchSettings(),
    fetchNotifications(),
  ]);
  
  // 所有操作完成后，results 包含所有结果
  print(results);
}
```

---

### 3. 链式调用

可以使用 `then` 进行链式调用：

```dart
Future<int> step1(int input) async {
  return input * 2;
}

Future<String> step2(int input) async {
  return '结果: $input';
}

// 链式调用
step1(10)
    .then((value) => step2(value))
    .then((value) => print(value))
    .catchError((error) => print('错误: $error'));

// 使用 async/await（更清晰）
Future<void> process() async {
  try {
    final step1Result = await step1(10);
    final step2Result = await step2(step1Result);
    print(step2Result);
  } catch (e) {
    print('错误: $e');
  }
}
```

---

## 错误处理

### 4. 错误处理方式

#### 使用 try-catch（推荐）

```dart
Future<void> fetchData() async {
  try {
    final data = await riskyOperation();
    print('成功: $data');
  } catch (e) {
    print('错误: $e');
  }
}
```

#### 使用 catchError

```dart
riskyOperation()
    .then((value) => print('成功: $value'))
    .catchError((error) => print('错误: $error'));
```

#### 捕获特定错误

```dart
Future<void> fetchData() async {
  try {
    final data = await riskyOperation();
    print('成功: $data');
  } on NetworkException catch (e) {
    print('网络错误: $e');
  } on TimeoutException catch (e) {
    print('超时错误: $e');
  } catch (e, stackTrace) {
    print('未知错误: $e');
    print('堆栈: $stackTrace');
  }
}
```

---

### 5. 超时处理

#### 使用 timeout

```dart
// 方式1：返回默认值
Future<String> fetchData() async {
  return await slowOperation().timeout(
    Duration(seconds: 2),
    onTimeout: () => '超时，返回默认值',
  );
}

// 方式2：抛出异常
Future<String> fetchData() async {
  try {
    return await slowOperation().timeout(
      Duration(seconds: 2),
    );
  } on TimeoutException catch (e) {
    print('超时: $e');
    return '超时处理';
  }
}
```

---

## Future 组合

### 6. Future.wait

等待多个 Future 全部完成：

```dart
Future<String> task1() async {
  await Future.delayed(Duration(seconds: 1));
  return '任务1完成';
}

Future<String> task2() async {
  await Future.delayed(Duration(seconds: 2));
  return '任务2完成';
}

// 并行执行，等待所有完成
Future<void> executeAll() async {
  final results = await Future.wait([
    task1(),
    task2(),
  ]);
  
  // results = ['任务1完成', '任务2完成']
  // 总耗时 = max(1秒, 2秒) = 2秒
}
```

#### 特点

- ✅ **并行执行**：所有任务同时开始
- ✅ **等待全部**：所有任务完成后才返回
- ✅ **性能优化**：总时间 = 最长的任务时间

---

### 7. Future.any

等待任意一个 Future 完成：

```dart
Future<String> dataSource1() async {
  await Future.delayed(Duration(seconds: 3));
  return '数据源1';
}

Future<String> dataSource2() async {
  await Future.delayed(Duration(seconds: 1));
  return '数据源2';
}

// 等待任意一个完成
Future<void> fetchFromAny() async {
  final result = await Future.any([
    dataSource1(),
    dataSource2(),
  ]);
  
  // result = '数据源2'（最快完成的）
  // 总耗时 = min(3秒, 1秒) = 1秒
}
```

#### 适用场景

- 从多个数据源获取数据，使用最快的
- 实现超时机制
- 竞态条件处理

---

### 8. Future.delayed

延迟执行操作：

```dart
// 延迟执行
Future<void> delayedExecution() async {
  await Future.delayed(Duration(seconds: 2));
  print('2秒后执行');
}

// 延迟回调
void delayedCallback() {
  Future.delayed(Duration(seconds: 2), () {
    print('延迟回调');
  });
}

// 倒计时
Future<void> countdown() async {
  for (int i = 5; i > 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    print('$i');
  }
  print('倒计时结束');
}
```

---

## 实际应用场景

### 网络请求

```dart
Future<User> fetchUser(String userId) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/user/$userId'),
    );
    
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('请求失败: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('网络错误: $e');
  }
}
```

### 文件操作

```dart
Future<String> readFile(String path) async {
  try {
    final file = File(path);
    return await file.readAsString();
  } catch (e) {
    throw Exception('读取文件失败: $e');
  }
}

Future<void> writeFile(String path, String content) async {
  try {
    final file = File(path);
    await file.writeAsString(content);
  } catch (e) {
    throw Exception('写入文件失败: $e');
  }
}
```

### 数据库操作

```dart
Future<List<User>> getUsers() async {
  final db = await database;
  return await db.query('users');
}

Future<void> insertUser(User user) async {
  final db = await database;
  await db.insert('users', user.toMap());
}
```

### 顺序执行多个任务

```dart
Future<void> processData() async {
  // 1. 获取数据
  final rawData = await fetchData();
  
  // 2. 处理数据
  final processedData = await process(rawData);
  
  // 3. 保存数据
  await saveData(processedData);
  
  // 4. 显示结果
  showResult(processedData);
}
```

---

## 最佳实践

### 1. **优先使用 async/await**

```dart
// ✅ 推荐
Future<String> fetchData() async {
  final data = await api.getData();
  return data;
}

// ❌ 不推荐（除非必要）
Future<String> fetchData() {
  return api.getData().then((data) => data);
}
```

### 2. **正确处理错误**

```dart
// ✅ 推荐
Future<void> fetchData() async {
  try {
    final data = await api.getData();
    processData(data);
  } catch (e) {
    handleError(e);
  }
}
```

### 3. **使用 Future.wait 并行执行**

```dart
// ✅ 推荐：并行执行
final results = await Future.wait([
  fetchUser(),
  fetchSettings(),
  fetchNotifications(),
]);

// ❌ 不推荐：顺序执行（慢）
final user = await fetchUser();
final settings = await fetchSettings();
final notifications = await fetchNotifications();
```

### 4. **设置超时**

```dart
// ✅ 推荐
final data = await fetchData().timeout(
  Duration(seconds: 5),
  onTimeout: () => throw TimeoutException('请求超时'),
);
```

### 5. **避免 Future 嵌套**

```dart
// ❌ 不推荐
Future<Future<String>> nestedFuture() async {
  return Future.value('数据');
}

// ✅ 推荐
Future<String> flatFuture() async {
  return '数据';
}
```

### 6. **使用 Future.delayed 而非 sleep**

```dart
// ✅ 推荐：不阻塞
await Future.delayed(Duration(seconds: 1));

// ❌ 不推荐：阻塞线程
sleep(Duration(seconds: 1));
```

---

## 常见问题

### Q1: Future 和 async/await 的关系？

**A**: 
- `Future` 是类型，表示异步操作的结果
- `async/await` 是语法糖，简化 Future 的使用
- `async` 函数自动返回 `Future`
- `await` 等待 Future 完成

### Q2: 什么时候使用 then，什么时候使用 await？

**A**: 
- **优先使用 await**：代码更清晰，错误处理更容易
- **使用 then**：需要链式调用或处理多个 Future 时

### Q3: Future.wait 和顺序执行的区别？

**A**: 
- **Future.wait**：并行执行，总时间 = 最长的任务时间
- **顺序执行**：串行执行，总时间 = 所有任务时间之和

```dart
// 并行执行（快）
final results = await Future.wait([task1(), task2()]); // 总时间 = max(1s, 2s) = 2s

// 顺序执行（慢）
final r1 = await task1(); // 1s
final r2 = await task2(); // 2s
// 总时间 = 1s + 2s = 3s
```

### Q4: 如何取消 Future？

**A**: 使用 `CancelToken` 或 `Completer`：

```dart
final completer = Completer<String>();
final cancelToken = CancelToken();

// 取消操作
cancelToken.cancel();

// 检查是否取消
if (cancelToken.isCancelled) {
  completer.completeError('已取消');
}
```

### Q5: Future 和 Stream 的区别？

**A**: 
- **Future**：单次结果，一个值或错误
- **Stream**：多次结果，可以产生多个值

```dart
// Future：返回一个值
Future<String> fetchUser() async {
  return '用户数据';
}

// Stream：可以产生多个值
Stream<String> fetchUsers() async* {
  yield '用户1';
  yield '用户2';
  yield '用户3';
}
```

### Q6: 如何等待多个 Future，但只关心第一个完成的？

**A**: 使用 `Future.any`：

```dart
final result = await Future.any([
  dataSource1(),
  dataSource2(),
  dataSource3(),
]);
// 返回第一个完成的结果
```

### Q7: async 函数必须返回 Future 吗？

**A**: 是的，`async` 函数自动返回 `Future`：

```dart
// 这两个函数等价
Future<String> func1() async {
  return '数据';
}

Future<String> func2() {
  return Future.value('数据');
}
```

### Q8: 可以在非 async 函数中使用 await 吗？

**A**: 不可以。`await` 只能在 `async` 函数中使用：

```dart
// ❌ 错误
String fetchData() {
  final data = await api.getData(); // 错误！
  return data;
}

// ✅ 正确
Future<String> fetchData() async {
  final data = await api.getData();
  return data;
}
```

---

## 总结

Future 是 Dart 异步编程的核心，通过合理使用可以：

- ✅ 避免阻塞 UI 线程
- ✅ 处理异步操作（网络、文件、数据库）
- ✅ 提高代码可读性（async/await）
- ✅ 优化性能（并行执行）

### 快速参考

```dart
// 创建 Future
Future.value(value)
Future.delayed(duration, callback)
Future(() => value)

// 使用 async/await
Future<T> func() async {
  final result = await asyncOperation();
  return result;
}

// 错误处理
try {
  final result = await operation();
} catch (e) {
  handleError(e);
}

// 组合 Future
Future.wait([future1, future2])
Future.any([future1, future2])
```

---

## 相关资源

- [Dart Future 官方文档](https://dart.dev/guides/libraries/library-tour#future)
- [异步编程指南](https://dart.dev/guides/language/language-tour#asynchrony-support)
- [示例代码](../lib/examples/13_future.dart)

---

**最后更新**: 2024年

