
import 'package:flutter/material.dart';
import 'package:flutter_ft_study/flutter/4icon_button.dart';
import 'package:flutter_ft_study/flutter/5listview.dart';
import 'package:flutter_ft_study/flutter/second_my_app.dart';

class DnHomeApp extends StatelessWidget {
  const DnHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DnHomeApp')),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SecondMyApp()));
            }, child: Text('SecondMyApp')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => IconButtonExample()));
            }, child: Text('IconButtonExample')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ListViewExample()));
            }, child: Text('ListViewExample')),
          ],
        ),
      ),
    );
  }
}