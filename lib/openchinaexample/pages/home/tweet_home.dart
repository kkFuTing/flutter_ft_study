
import 'package:flutter/material.dart';

class TweetHomePage extends StatefulWidget {
  const TweetHomePage({super.key});

  @override
  State<TweetHomePage> createState() => _TweetHomePageState();
}

class _TweetHomePageState extends State<TweetHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TweetHome')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(title: Text('Item $index'));
        },
      ),
    );
  }
}