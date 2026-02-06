import 'package:flutter/material.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({super.key});

  @override
  State<MyAnimatedWidget> createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimatedWidget')),
      body: Center(child: Mylogo(key: UniqueKey(), animation: animation)),
    );
  }
}

class Mylogo extends AnimatedWidget {
  late Tween<double> _rotationAnimation = Tween<double>(begin: 0, end: 20);
  late Tween<double> _scaleAnimation = Tween<double>(begin: 0, end: 10);
  late Tween<Color> _colorAnimation = Tween<Color>(begin: Colors.red, end: Colors.blue);

  Mylogo({required Key key, required Animation<double> animation})
    : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final rotation = listenable as Animation<double>;
    return Transform.scale(
      scale: _scaleAnimation.evaluate(rotation),
      child: Transform.rotate(
        angle: _rotationAnimation.evaluate(rotation),
        child: Container(
          // color: _colorAnimation.evaluate(rotation), // 颜色渐变 没有跑成功
          // width:rotation.value, // 等同scale放大,rotation.value是0-200之间的值
          // height: rotation.value, // 等同scale放大,rotation.value是0-200之间的值
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
