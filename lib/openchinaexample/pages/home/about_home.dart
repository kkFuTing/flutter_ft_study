import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ft_study/openchinaexample/common/event_bus.dart';
import 'package:flutter_ft_study/openchinaexample/constants/app_colors.dart';
import 'package:flutter_ft_study/openchinaexample/constants/constants.dart'
    hide AppColors;
import 'package:flutter_ft_study/openchinaexample/pages/Login_web_page.dart';
import 'package:flutter_ft_study/openchinaexample/utils/data_utils.dart';
import 'package:flutter_ft_study/openchinaexample/utils/net_utils.dart';

class AboutHomePage extends StatefulWidget {
  const AboutHomePage({super.key});

  @override
  State<AboutHomePage> createState() => AboutHomePageState();
}

class AboutHomePageState extends State<AboutHomePage> {
  List menuTitles = ['我的消息', '阅读记录', '我的博客', '我的问答', '我的活动', '我的团队', '我的好友'];
  List menuIcons = [
    Icons.message,
    Icons.library_books,
    Icons.book,
    Icons.question_answer,
    Icons.event,
    Icons.group,
    Icons.person,
  ];
  String useAvatar = 'https://www.oschina.net/favicon.ico';
  String userName = '点击头像登录';

  @override
  void initState() {
    super.initState();

    eventBus.on<LoginEvent>().listen((event) {
      _getUserInfo();
    });
    eventBus.on<LogoutEvent>().listen((event) {
      setState(() {
        //刷新token信息界面
      });
    });
    // NetUtils.get('https://www.oschina.net/action/openapi/user_detail', {}).then((value) {
    //   print('NetUtils: get response: $value');
    // });
  }

  _showUserInfo() {
    DataUtils.getUserInfo().then((user) {
      if (user != null && mounted) {
        setState(() {
          useAvatar = user.avatar;
          userName = user.name;
        });
      } else {
        useAvatar = '';
        userName = '';
      }
    });
  }

  _getUserInfo() {
    DataUtils.getAccessToken().then((accessToken) {
      if (accessToken.isEmpty) {
        return;
      }
      Map<String, dynamic> params = {
        'access_token': accessToken,
        'data_type': 'json',
      };
      NetUtils.get(AppUrls.OPENAPI_USER, params).then((value) {
        print('AboutHomePage: getUserInfo: $value');
        if (value.isNotEmpty) {
          Map<String, dynamic> dataMap = json.decode(value);
          if (dataMap != null && dataMap.isNotEmpty) {
            if (mounted) {
              setState(() {
                useAvatar = dataMap['avatar'];
                userName = dataMap['name'];
              });
              DataUtils.saveUserInfo(dataMap);
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: menuTitles.length,
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildAvaterWidget();
        }

        return ListTile(
          title: Text(menuTitles[index]),
          leading: Icon(menuIcons[index]),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }

  Container _buildAvaterWidget() {
    return Container(
      height: 150,
      color: AppColors.APP_THEME,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //头像
            GestureDetector(
              onTap: () {
                DataUtils.isLogin().then((value) {
                  if(value) {
                  //跳转至个人中心
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalCenterPage()));
                  } else {
                    _lougin();
                  }
                });
              },
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image:
                        useAvatar.isNotEmpty
                            ? NetworkImage(useAvatar)
                            : AssetImage('assets/images/ic_avatar_default.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //用户名
            Text(
              userName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _lougin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginWPage()),
    ).then((value) {
      if (value == "Refresh") {
        //登录成功
        //刷新token信息界面
        eventBus.fire(LoginEvent());
      }
    });
  }
}
