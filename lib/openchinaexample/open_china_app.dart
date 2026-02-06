import 'package:flutter/material.dart';
import 'package:flutter_ft_study/openchinaexample/pages/home/about_home.dart';
import 'package:flutter_ft_study/openchinaexample/pages/home/discovey_home.dart';
import 'package:flutter_ft_study/openchinaexample/pages/home/new_list_home.dart';
import 'package:flutter_ft_study/openchinaexample/pages/home/tweet_home.dart';
import 'package:flutter_ft_study/openchinaexample/widget/my_drawer.dart';
import 'package:flutter_ft_study/openchinaexample/widget/navigation_view.dart';
//接口地址
// https://www.oschina.net/openapi/docs/project_detail 
//只写了整体框架，没有写具体内容（意义不大）从Lsn13_中间开始就看不下去了，没有怎么跟写

class OpenChinaApp extends StatefulWidget {
  const OpenChinaApp({super.key});

  @override
  State<OpenChinaApp> createState() => _OpenChinaAppState();
}

class _OpenChinaAppState extends State<OpenChinaApp> {
  final List<String> pageTitles = ['资讯', '动弹', '发现', '我的'];
  late List<NavigationView> _navigationViews;
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _navigationViews = [
      NavigationView(
        title: '资讯',
        iconPath: 'assets/images/ic_nav_news_normal.png',
        selectedIconPath: 'assets/images/ic_nav_news_actived.png',
        isSelected: true,
      ),
      NavigationView(
        title: '动弹',
        iconPath: 'assets/images/ic_nav_discover_normal.png',
        selectedIconPath: 'assets/images/ic_nav_discover_actived.png',
        isSelected: false,
      ),
      NavigationView(
        title: '发现',
        iconPath: 'assets/images/ic_nav_discover_normal.png',
        selectedIconPath: 'assets/images/ic_nav_discover_actived.png',
        isSelected: false,
      ),
      NavigationView(
        title: '我的',
        iconPath: 'assets/images/ic_nav_my_normal.png',
        selectedIconPath: 'assets/images/ic_nav_my_pressed.png',
        isSelected: false,
      ),
    ];
    _pages = [
      NewListHomePage(),
      TweetHomePage(),
      DiscoveyHomePage(),
      AboutHomePage(),
    ];
    PageController _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    //safeArea 可适配刘海屏等形屏
    return Scaffold(
      appBar: AppBar(title: Text(_navigationViews[_currentIndex].title)),
      // body: _pages[_currentIndex],
      body: PageView.builder(
        // physics: NeverScrollableScrollPhysics(),//禁止滑动
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) => _pages[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navigationViews.map((view) => view.item).toList(),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      drawer: MyDrawer(
        headImagePath: 'assets/images/cover_img.jpg',
        menuTitles: ['发布动弹', '动弹小黑屋', '关于', '设置'],
        menuIcons: [Icons.send, Icons.home, Icons.error, Icons.settings],
      ),
    );
  }
}
