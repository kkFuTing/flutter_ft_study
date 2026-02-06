import 'package:flutter/material.dart';
import 'package:flutter_ft_study/openchinaexample/pages/about.dart';
import 'package:flutter_ft_study/openchinaexample/pages/publish_tweet.dart';
import 'package:flutter_ft_study/openchinaexample/pages/setting.dart';
import 'package:flutter_ft_study/openchinaexample/pages/tweet_back.dart';

class MyDrawer extends StatelessWidget {
  final String headImagePath;
  final List<String> menuTitles;
  final List<IconData> menuIcons;

  MyDrawer({
    Key? key,
    required this.headImagePath,
    required this.menuTitles,
    required this.menuIcons,
  }) : assert(headImagePath.isNotEmpty, 'headImagePath is required'),
       assert(menuTitles.isNotEmpty, 'menuTitles is required'),
       assert(menuIcons.isNotEmpty, 'menuIcons is required'),
       assert(
         menuTitles.length == menuIcons.length,
         'menuTitles and menuIcons must have the same length',
       );
  //assert 只在开发环境生效，发布时会被忽略

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        padding: EdgeInsets.zero,//去除内边距 (可以直接铺满状态栏)
        itemCount: menuTitles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Image.asset(headImagePath, fit: BoxFit.cover);
          }
          index -= 1;
          return ListTile(
            leading: Icon(menuIcons[index]),
            title: Text(menuTitles[index]),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              switch (index) {
                case 0:
                //这里可以统一封装成一个方法
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PublishTweetPage()));
                  break;
                case 1:
                //这里可以统一封装成一个方法
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TweetBackPage()));
                  break;
                case 2:
                //这里可以统一封装成一个方法
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                  break;
                case 3:
                //这里可以统一封装成一个方法
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
                  break;
              }
            },
          );
        },
        separatorBuilder: (context, index) {
          if (index == 0) {
            return SizedBox.shrink();
          }

          return Divider(height: 1, color: Colors.grey[300]);
        },
      ),
    );
  }
}

class MyDrawerItem extends StatelessWidget {
  const MyDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text('我的'));
  }
}
