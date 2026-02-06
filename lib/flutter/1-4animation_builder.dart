import 'package:flutter/material.dart';

//动画构建器 实现动画效果，从左边移动到右边，再从右边移动到左边，玄幻
class AnimationBuilderWidget extends StatefulWidget {
  const AnimationBuilderWidget({super.key});

  @override
  State<AnimationBuilderWidget> createState() => _AnimationBuilderWidgetState();
}


class _AnimationBuilderWidgetState extends State<AnimationBuilderWidget> with TickerProviderStateMixin {

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
  Widget build(BuildContext context) {
     double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('AnimationBuilder')),
      body: AnimatedBuilder(animation: animation, builder: (BuildContext context, Widget? child) {
        return Transform(
         transform: Matrix4.translationValues(animation.value*_screenWidth,0.0,0.0),
         child: Container(
          width: 200  ,
          height: 200,
          color: Colors.red,
          child: FlutterLogo(),
         ),
        );
      }),
    );
  }
}