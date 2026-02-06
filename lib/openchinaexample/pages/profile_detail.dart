import 'package:flutter/material.dart';

class ProfileDetailWidget extends StatefulWidget {
  const ProfileDetailWidget({super.key});

  @override
  State<ProfileDetailWidget> createState() => _ProfileDetailWidgetState();
}

class _ProfileDetailWidgetState extends State<ProfileDetailWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人信息'),
      ),
      body: Column(
        children: [
          InkWell(//墨水印效果
            onTap: () {
              print('墨水印效果');
            },
            child: Container(
              child: Row(
                children: [
                  Text('个人信息'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}