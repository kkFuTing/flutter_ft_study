import 'package:flutter/material.dart';

//列表项可左滑，向右删除
class DismissbleWidget extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DismissbleWidget')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Dismissible(
          //向右向下滑删除的颜色
          background: Container(
            color: Colors.red,
          ),
          //向左向上滑删除的颜色
          secondaryBackground: Container(
            color: Colors.blue,
          ),
          onDismissed: (direction) {
            items.removeAt(index);
          },
          key: Key(items[index]),
          child: ListTile(
            title: Text(items[index]),
            leading: Icon(Icons.home),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
       
        ),
      ),
    );
  }
}