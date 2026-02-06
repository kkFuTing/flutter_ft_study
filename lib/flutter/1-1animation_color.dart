
import 'package:flutter/material.dart';

class AnimationColorWidget extends StatefulWidget {
  const AnimationColorWidget({super.key});

  @override
  State<AnimationColorWidget> createState() => _AnimationColorWidgetState();
}
// 动画四种状态：
//1. forward：正向动画，从头到尾播放状态
//2. reverse：反向动画，从尾到头播放状态
//3. completed：动画完成，动画完成状态
//4. dismissed：动画取消，动画取消状态/初始状态
class _AnimationColorWidgetState extends State<AnimationColorWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color> _animation;
  Color _animationValue = Colors.red;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: Colors.red, end: Colors.white).animate(_animationController)..addListener(() {
      setState(() {
        _animationValue = _animation.value;
      });
      print(_animation.value);
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
      body: Center(child: Container(width: 100, height: 100, color: _animationValue,child: FlutterLogo(),)),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _animationController.forward();
      }, child: Icon(Icons.play_arrow)),
    );
  }
}