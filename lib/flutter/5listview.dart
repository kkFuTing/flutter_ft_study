import 'package:flutter/material.dart';

class ListViewExample extends StatelessWidget {
  const ListViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListViewExample')),
      // 选中ListView 右键-refactor-extract-widget (-to-new-file)
      // body: NormalListWidget(),
      // 2、水平滚动 ，generate会直接加载100个好像
      // body: ListView(
      //   scrollDirection: Axis.horizontal,
      //   children: List.generate(100,(index) => Text('Item $index',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
      // ),
      // 3、builder方式，懒加载，不会直接加载100个
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          print('Item $index');
          if(index.isOdd){ //奇数行添加分割线
            return Divider();
          }
          return ListTile(
            title: Text('Item $index'),
            subtitle: Text('subtitle $index'),
            leading: Icon(Icons.home),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}

class NormalListWidget extends StatelessWidget {
  const NormalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Item 1'),
          leading: Icon(Icons.home),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('Item 2'),
          leading: Icon(Icons.search),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('Item 3'),
          leading: Icon(Icons.settings),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
      ],
    );
  }
}
