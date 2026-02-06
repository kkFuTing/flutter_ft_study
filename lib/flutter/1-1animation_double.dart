
import 'package:flutter/material.dart';

class AnimationDoubleWidget extends StatefulWidget {
  const AnimationDoubleWidget({super.key});

  @override
  State<AnimationDoubleWidget> createState() => _AnimationDoubleWidgetState();
}
// 动画四种状态：
//1. forward：正向动画，从头到尾播放状态
//2. reverse：反向动画，从尾到头播放状态
//3. completed：动画完成，动画完成状态
//4. dismissed：动画取消，动画取消状态/初始状态
class _AnimationDoubleWidgetState extends State<AnimationDoubleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _animationValue = 0.0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 20.0, end: 200.0).animate(_animationController)..addListener(() {
      setState(() {
        _animationValue = _animation.value;
        print(_animation.value);
      });
    })..addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        _animationController.reverse();
      }if(status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
      print(status);
    });
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimationDoubleWidget')),
      body: Center(child: Container(width: _animationValue, height: _animationValue, color: Colors.red)),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _animationController.forward();
      }, child: Icon(Icons.play_arrow)),
    );
  }
}