
import 'package:flutter/material.dart';
import 'package:flutter_ft_study/flutter/1-1animation_color.dart';
import 'package:flutter_ft_study/flutter/1-1animation_double.dart';
import 'package:flutter_ft_study/flutter/1-3animated_widget.dart';
import 'package:flutter_ft_study/flutter/1-4animation_builder.dart';
import 'package:flutter_ft_study/flutter/1animation.dart';
import 'package:flutter_ft_study/flutter/2dialog.dart';
import 'package:flutter_ft_study/flutter/3card.dart';
import 'package:flutter_ft_study/flutter/4icon_button.dart';
import 'package:flutter_ft_study/flutter/5listview.dart';
import 'package:flutter_ft_study/flutter/6gridview.dart';
import 'package:flutter_ft_study/flutter/7form.dart';
import 'package:flutter_ft_study/flutter/dismissble.dart';
import 'package:flutter_ft_study/flutter/gesture.dart';
import 'package:flutter_ft_study/flutter/second_my_app.dart';
import 'package:flutter_ft_study/flutter/table.dart';

class DnHomeApp extends StatelessWidget {
  const DnHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DnHomeApp')),
      body:SingleChildScrollView(child: Center(
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
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GridViewExample()));
            }, child: Text('GridViewExample')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FormExample()));
            }, child: Text('FormExample')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DialogWidget()));
            }, child: Text('DialogWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CardWidget()));
            }, child: Text('CardWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TableWidget()));
            }, child: Text('TableWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GestureDetectorWidget()));
            }, child: Text('GestureDetectorWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DismissbleWidget()));
            }, child: Text('DismissbleWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AnimationWidget()));
            }, child: Text('AnimationWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AnimationDoubleWidget()));
            }, child: Text('AnimationDoubleWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AnimationColorWidget()));
            }, child: Text('AnimationColorWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyAnimatedWidget()));
            }, child: Text('MyAnimatedWidget')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AnimationBuilderWidget()));
            }, child: Text('AnimationBuilderWidget')),
          ],
        ),),
      ),
    );
  }
}