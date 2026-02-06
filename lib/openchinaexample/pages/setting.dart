import 'package:flutter/material.dart';
import 'package:flutter_ft_study/openchinaexample/common/event_bus.dart';
import 'package:flutter_ft_study/openchinaexample/utils/data_utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置', style: TextStyle(color: Colors.white))),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            DataUtils.clearLoginInfo().then((value) {
              eventBus.fire(LogoutEvent());
              Navigator.pop(context);
            });
          },
          child: Text('退出登录'),
        ),
      ),
    );
  }
}
