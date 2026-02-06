import 'package:flutter/material.dart';

class PublishTweetPage extends StatefulWidget {
  const PublishTweetPage({super.key});

  @override
  State<PublishTweetPage> createState() => _PublishTweetPageState();
}

class _PublishTweetPageState extends State<PublishTweetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('发布动弹')),
      body: Column(children: [Text('发布动弹')]),
    );
  }
}
