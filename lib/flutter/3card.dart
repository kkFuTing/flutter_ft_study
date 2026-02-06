import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('card 示例')),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('Card标题'),
              subtitle: Text('Card内容'),
              leading: Icon(Icons.home),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),

          buildcard(
            url:
                'https://fastly.picsum.photos/id/524/600/300.jpg?hmac=hmImj5gs86VM6BnoB_TWAFjgTzRiXcApGWoykYDlcvg',
          ),
          buildcard(url: 'https://picsum.photos/600/300?random=1'),
          buildcard(url: 'https://picsum.photos/600/300?random=2'),
        ],
      ),
    );
  }

  Card buildcard({required String url}) {
    return Card(
      shape: Border.all(color: Colors.red, width: 2,style: BorderStyle.solid),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Image.network(url, height: 200, fit: BoxFit.cover),
          ),

          Row(
            children: [
              Padding(padding: EdgeInsets.all(10), child: Icon(Icons.person)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card标题',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Card内容',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.favorite, color: Colors.red, size: 20),
                    Text(
                      '100',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
