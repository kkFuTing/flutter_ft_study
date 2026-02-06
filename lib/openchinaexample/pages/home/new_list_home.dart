import 'package:flutter/material.dart';
class NewListHomePage extends StatefulWidget {
  const NewListHomePage({super.key});

  @override
  State<NewListHomePage> createState() => _NewListHomePageState();
}

class _NewListHomePageState extends State<NewListHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NewListHome')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(title: Text('Item $index'));
        },
      ),
    );
  }
}