import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SecondMyApp extends StatelessWidget {
  const SecondMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SecondMyApp')),
      body: Center(
        child: Column(
          children: [
            Text(
              'MaterialApp代表使用Material Design风格的应用，里面包含了其他所需的基本控件。官方提供的示例demo就是从MaterialApp这个主组件开始的。',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true, //是否换行
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Hello, World!',
                style: TextStyle(color: Colors.red, fontSize: 20),
                children: [
                  TextSpan(
                    text: 'WELCOME!',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  TextSpan(
                    text: 'to the world!',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      String url = 'https://www.baidu.com';
                      // todo 没跑起来
                        // url_launcher: ^6.3.2
                      // if (await canLaunchUrl(Uri.parse(url))) {
                      //   await launchUrl(Uri.parse(url));
                      // } else {
                      //   throw 'Could not launch $url';
                      // }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
