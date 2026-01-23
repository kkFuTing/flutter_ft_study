https://pan.baidu.com/pfile/docview?path=%2F%E5%88%98%E6%B3%BD%E5%88%86%E4%BA%AB%2FAndroid_20250827_204610%2F2024%E5%B9%B4Android%E5%BC%80%E5%8F%91VIP%E8%B5%84%E6%96%99%2FAndroid%E5%AE%89%E5%8D%93%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%B6%E6%9E%84%E5%BC%80%E5%8F%91%E8%AF%BE%E7%A8%8B%2FFlutter%E5%BC%80%E5%8F%91%2FLsn5_Dart%E8%AF%AD%E8%A8%80%E8%AF%A6%E8%A7%A3%E4%B8%89_2020-3-22(Damon)%2F%E8%B5%84%E6%96%99%2FDart%E8%AF%AD%E8%A8%80%E8%AF%A6%E8%A7%A3.pptx&fsid=454167426066720&size=795484&view_from=personal_file&md5=1e6b418134a8641daacd5a8fdc303ac9&share=0&client=web&scene=main

# dart 基础

## 变量

## 函数

### 函数-定义
- 可在函数内定义
- 定义函数时可省略类型
- 支持缩写语法 =>

```dart
返回值类型 函数名(参数类型 参数名){
   函数体;
}


int add(int x, int y){
    return x+y;
}

```

Dart是面向对象的语言，即便函数也是对象，其类型为Function。这就意味着，函数可以和普通的对象（变量数据）一样使用，可以被赋值、可以作为函数参数。

### 函数-可选参数
- 可选命名参数
- 可可选位置参数
- 默认参数值
  
### 函数-匿名函数
- 可赋值给变量,通过变量调用
- 可在其他函数中直接调用或传递给其他函数

### 函数-闭包
```dart
Function makeAddFunc(int x) {
    x++;
    return (int y) => x + y;
  }

  var addFunc = makeAddFunc(2);
  print(addFunc(3));
```

### 函数-别名
```dart
  // 函数别名
  MyFunc myFunc;
  //可以指向任何同签名的函数
  myFunc = subtsract;
  myFunc(4, 2);
  myFunc = divide;
  myFunc(4, 2);
  //typedef 作为参数传递给函数
  calculator(4, 2, subtsract);
}

//函数别名
typedef MyFunc(int a, int b);
//根据MyFunc相同的函数签名定义两个函数
subtsract(int a, int b) {
  print('subtsract: ${a - b}');
}

divide(int a, int b) {
  print('divide: ${a / b}');
}
//typedef 也可以作为参数传递给函数
calculator(int a, int b, MyFunc func) {
  func(a, b);
}

```


## 异常类型
```dart
try{


}catch(e,s){//异常对象，stackTrace 对象
    print('')
}
```

## 类
### 类-命名构造函数

### 类-抽象类
dart 里面没有 interface，所以所有的类都可以当作接口。
#### 工厂模式
两者写法
写法一:
```dart

  //工厂模式两种方式
  //创建顶级函数
  var footMassage = massageFactory('foot');
  footMassage.doMassage();



class SpecialMassage extends Massage {
  @override
  void doMassage() {
    print('特殊按摩');
  }
}
Massage massageFactory(String type){
  switch (type) {
    case 'foot':
      return new FootMassage();
    case 'body':
      return new BodyMassage();
    default:
      return new SpecialMassage();
  }
}
```
方法二：
```dart

  //创建工厂构造函数
//  var footMassage = new Massage('foot');
//  footMassage.doMassage();
abstract class Massage {
 factory Massage(String type) {
   switch (type) {
     case 'foot':
       return new FootMassage();
     case 'body':
       return new BodyMassage();
     default:
       return new SpecialMassage();
   }
 }
```

## mixin


## 泛型


## 库载入

## 重载操作符

## 异步
### 异步-async和await
dart 单线程模型

输出结果  getStr1、getName2、getName3、getStr2、getName1
```dart
void main{
//  getName1();
//  getName2();
//  getName3();
}

/ async wait
Future<void> getName1() async {
//  getStr1();//可以不用await打断点看下await后的区别
  await getStr1(); //遇到第一个await表达式执行暂停，返回future对象，await表达式执行完成后继续执行
  await getStr2(); //await表达式可以使用多次
  print('getName1');
}

getStr1() {
  print('getStr1');
}

getStr2() {
  print('getStr2');
}

getName2() {
  print('getName2');
}

getName3() {
  print('getName3');
}
```
原因：
Main  依次执行，遇到await会进入事件队列，会返回Future，等主线程跑完，再继续调用Future里的内容

### 异步-then，catchError,whenComplete
```dart
打印结果
aa：0
whenComplete1

void main{
  new Future(() => futureTask()) //  异步任务的函数
      .then((m) => "a:$m") //   任务执行完后的子任务
      .then((m) => print('a$m')) //  其中m为上个任务执行完后的返回的结果
      .then((_) => new Future.error('error'))//_ 相当于一个变量
      .then((m) => print('damon'))
      .whenComplete(() => print('whenComplete1')) //不是最后执行whenComplete，通常放到最后回调

//      .catchError((e) => print(e))//如果不写test默认实现一个返回true的test方法
      .catchError((e) => print('catchError:' + e), test: (Object o) {
        print('test:' + o);
        return true; //返回true，会被catchError捕获
//        return false; //返回false，继续抛出错误，会被下一个catchError捕获
      })
      .catchError((e) => print('catchError2:' + e))
//      .then((m) => print('dongnao'))
//      .whenComplete(() => print('finish'))
 ;
 
}


 //then catchError whenComplete
int futureTask() {
//  throw 'error';
  return 0;
}


```

### 异步-Event-Looper

用于分析消息循环及任务队列

```dart
void mian{
  testFuture()//打印结果：7、1、6、3、5、2、4
}
//Future
void testFuture() {
  Future f = new Future(() => print("f1"));
  Future f1 = new Future(() => null); //7163524
//  Future f1 = new Future.delayed(Duration(seconds: 1) ,() => null);//7132465
  Future f2 = new Future(() => null);
  Future f3 = new Future(() => null);

  f3.then((_) => print("f2"));
  f2.then((_) {
    print("f3");
    new Future(() => print("f4"));
    f1.then((_) {
      print("f5");
    });
  });

  f1.then((m) {
    print("f6");
  });
  print("f7");
}

/*
执行顺序分析（Dart Event Loop 机制）：

1. 同步执行阶段：
   - 创建 Future f, f1, f2, f3（调度到事件队列）
   - 注册 f3.then → 等待 f3 完成
   - 注册 f2.then → 等待 f2 完成
   - 注册 f1.then（第253行）→ 等待 f1 完成
   - print("f7") → 打印 7 ✓

2. 事件队列执行（Future 回调）：
   - Future f 执行 → print("f1") → 打印 1 ✓
   - Future f1 执行（返回 null）→ f1 完成，将已注册的 then 回调加入微任务队列
   - Future f2 执行（返回 null）→ f2 完成，将 f2.then 回调加入微任务队列
   - Future f3 执行（返回 null）→ f3 完成，将 f3.then 回调加入微任务队列

3. 微任务队列执行（按注册顺序，优先于事件队列）：
   - 执行 f1.then（第253行，先注册）→ print("f6") → 打印 6 ✓
   - 执行 f2.then（第245行）→ print("f3") → 打印 3 ✓
     - 在 f2.then 中创建新 Future（第247行）→ 调度到事件队列
     - 在 f2.then 中注册 f1.then（第248行）→ f1 已完成，立即加入微任务队列
   - 执行 f1.then（第248行，在 f2.then 中注册）→ print("f5") → 打印 5 ✓
   - 执行 f3.then（第244行）→ print("f2") → 打印 2 ✓

4. 事件队列继续执行：
   - 执行新创建的 Future（第247行）→ print("f4") → 打印 4 ✓

最终打印顺序：7、1、6、3、5、2、4

关键点：
- 同步代码最先执行（7）
- Future 构造函数立即调度到事件队列
- 微任务队列优先于事件队列执行
- **then 回调按注册顺序加入微任务队列**（不是事件队列！）
  - 证据：打印顺序 7、1、6、3、5、2、4 中，所有 then 回调（6、3、5、2）都在新创建的 Future（4）之前执行
  - 如果 then 在事件队列，它们应该和 Future（4）一起排队，但实际 then 优先执行，证明它们在微任务队列
- 已完成 Future 的 then 回调会立即加入微任务队列
*/

```
### 异步-scheduleMicrotask()
```dart
void main{
  testScheduleMicrotask()  //：9，1，8，3，4，6，5，10，7，11，12，2
}

//scheduleMicrotask
void testScheduleMicrotask() {
  scheduleMicrotask(() => print('s1'));//微任务

  //delay 延迟
  new Future.delayed(new Duration(seconds: 1), () => print('s2'));

  new Future(() => print('s3')).then((_) {
    print('s4');
    scheduleMicrotask(() => print('s5'));
  }).then((_) => print('s6'));

  new Future(() => print('s10'))
      .then((_) => new Future(() => print('s11')))
      .then((_) => print('s12'));

  new Future(() => print('s7'));

  scheduleMicrotask(() => print('s8'));

  print('s9');
}

```

## 生成器
### 生成器 -同步生成器

```dart
  //同步生成器
  //调用getSyncGenerator立即返回Iterable
  var it = getSyncGenerator(5).iterator;
//  调用moveNext方法时getSyncGenerator才开始执行
  while (it.moveNext()) {   //z执行结果 5\n 4\n 3\n 2 \n 1\n
    print(it.current);
  }

//同步生成器： 使用sync*，返回的是Iterable对象
Iterable<int> getSyncGenerator(int n) sync* {
  print('start');
  int k = n;
  while (k > 0) {
    //yield会返回moveNext为true,并等待 moveNext 指令
    yield k--;
  }
  print('end');
}

```

### 生成器 -异步生成器
```dart

  //异步生成器
  //调用getAsyncGenerator立即返回Stream,只有执行了listen，函数才会开始执行


 getAsyncGenerator(5).listen((value) => print(value));
 StreamSubscription subscription = getAsyncGenerator(5).listen(null);
 subscription.onData((value) {
   print(value);
   if (value >= 2) {
     subscription.pause(); //可以使用StreamSubscription对象对数据流进行控制
   }
 });

//异步生成器： 使用async*，返回的是Stream对象
Stream<int> getAsyncGenerator(int n) async* {
  print('start');
  int k = 0;
  while (k < n) {
    //yield不用暂停，数据以流的方式一次性推送,通过StreamSubscription进行控制
    yield k++;
  }
  print('end');
}

```


### 生成器 -递归生成器
知道概念就性了


## 隔离-ISolate


## 元数据（注解）

### 元数据（注解）-@depressed

### 元数据（注解）-@override

### 自定义注解

## 注释



