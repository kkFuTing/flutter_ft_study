import 'package:flutter/material.dart';

class GridViewExample extends StatefulWidget {
  const GridViewExample({super.key});

  @override
  State<GridViewExample> createState() => _GridViewExampleState();
}

class _GridViewExampleState extends State<GridViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GridViewExample')),
      // 1、count方式
      // body: GridView.count(
      //   crossAxisCount: 2, //交叉轴
      //   scrollDirection: Axis.horizontal, //滚动方向
      //   childAspectRatio: 2 / 3, //子元素宽高比
      //   children: List.generate(
      //     100,
      //     (index) => Container(
      //       color: Colors.red,
      //       margin: EdgeInsets.all(10),
      //       child: Center(
      //         child: Text(
      //           'Item $index',
      //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // 2、builder方式
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
        ),
        itemBuilder:
            (context, index) => Container(
              color: Colors.red,
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  'Item $index',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
      ),
    );
  }
}
