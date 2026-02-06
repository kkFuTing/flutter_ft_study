import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationWidget extends StatefulWidget {
  const AnimationWidget({super.key});

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double>? _animation;
  late AnimationController _animationController;
  double _animationValue = 0.0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {
              _animationValue = _animation?.value ?? 0.0;
            });
            print(_animation?.value);
          })
          ..addStatusListener((status) {
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
      appBar: AppBar(title: Text('AnimationWidget')),
      body: Center(child: Text('$_animationValue')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _animationController.forward(from: 0.0);
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
