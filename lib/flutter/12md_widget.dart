import 'package:flutter/material.dart';

class MdWidget extends StatelessWidget {
  const MdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MdWidget',
      routes: {'/other': (context) => OtherWidget()},
      home: MyHomeWidget(),
    );
  }
}

class MyHomeWidget extends StatefulWidget {
  const MyHomeWidget({super.key});

  @override
  State<MyHomeWidget> createState() => _MyHomeWidgetState();
}

class _MyHomeWidgetState extends State<MyHomeWidget> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Center(child: Text('Home')),
    Center(child: Text('Settings')),
    Center(child: Text('Person')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyHomeWidget'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        tooltip: "路由跳转",
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 10, //阴影
        onPressed: () {
          Navigator.pushNamed(context, '/other');
        },
        child: Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Person'),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/lego/7.jpg',
                ),
              ),
              otherAccountsPictures: [Icon(Icons.camera_alt)],
              accountName: Text('TING FU'),
              accountEmail: Text('447072785@qq.com'),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/up.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Person'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            AboutListTile(child: Text('about'), icon: Icon(Icons.info)
            ,aboutBoxChildren: [Text('about'), Text('about'), Text('about')],
            applicationName: 'MyApp',
            applicationVersion: '1.0.0',
            applicationIcon: Icon(Icons.info),
            applicationLegalese: 'Copyright 2026',
      
            ),
          ],
        ),
      ),
    );
  }
}

class OtherWidget extends StatelessWidget {
  const OtherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('otherWidget')),
      body: Center(child: Text('otherWidget')),
    );
  }
}
