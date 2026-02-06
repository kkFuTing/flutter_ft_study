import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DialogWidget')),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          SimpleDialog(title: Text('对话框标题'), children: [
          SimpleDialogOption(child: Text('对话框选项1'), onPressed: () {}),
          SimpleDialogOption(child: Text('对话框选项2'), onPressed: () {}),
          SimpleDialogOption(child: Text('对话框选项3'), onPressed: () {}),
          ]),
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) => AlertDialog(title: Text('AlertDialog'), content: Text('AlertDialog内容'), actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('确定')),
            ]));
          }, child: Text('AlertDialog')),
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) => AlertDialog(title: Text('AlertDialog'), content: SingleChildScrollView(child: Column(children: [
              Text('AlertDialog内容1'),
              Text('AlertDialog内容2'),
       
            ],)), actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('取消')),
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('确定')),
            ]));
          }, child: Text('删除')), 
        ],
      ),
    );
  }
}