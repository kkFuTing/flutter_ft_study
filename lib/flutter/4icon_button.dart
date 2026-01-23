import 'package:flutter/material.dart';

class IconButtonExample extends StatelessWidget {
  const IconButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IconButtonExample')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 40, color: Colors.blue),//不支持交互
            SizedBox(height: 10),
            IconButton(onPressed: () {}, icon: Icon(Icons.search),onLongPress: () {


            },),//支持交互
            SizedBox(height: 10),
            // RaisedButton(onPressed: () {}, child: Text('RaisedButton')),//已弃用,被移除了
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: Text('ElevatedButton')),//推荐使用
            SizedBox(height: 10),
            OutlinedButton(onPressed: () {}, child: Text('OutlinedButton')),//推荐使用
            SizedBox(height: 10),
            TextButton(onPressed: () {}, child: Text('TextButton')),//推荐使用
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}