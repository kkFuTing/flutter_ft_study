import 'package:flutter/material.dart';

class TweetBackPage extends StatefulWidget {
  const TweetBackPage({super.key});

  @override
  State<TweetBackPage> createState() => _TweetBackPageState();
}

class _TweetBackPageState extends State<TweetBackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('动弹小黑屋')),
      body: Center(child: Text('动弹小黑屋')),
    );
  }
}