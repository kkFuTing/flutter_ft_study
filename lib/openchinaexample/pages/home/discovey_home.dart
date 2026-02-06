
import 'package:flutter/material.dart';

class DiscoveyHomePage extends StatefulWidget {
  const DiscoveyHomePage({super.key});

  @override
  State<DiscoveyHomePage> createState() =>  DiscoveyHomePageState();
}

class  DiscoveyHomePageState extends State<DiscoveyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DiscoveyHome')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(title: Text('Item $index'));
        },
      ),
    );
  }
}