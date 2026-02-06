
import 'package:flutter/material.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TableWidget')),
      body: Center(child: Table(
        columnWidths: {0: FlexColumnWidth(650), 1: FlexColumnWidth(50), 2: FlexColumnWidth(50),3: FlexColumnWidth(50)},
        border: TableBorder.all(color: Colors.red, width: 1),
        children: [
          TableRow(children: [Text('头像'), Text('2'), Text('3')]),
          TableRow(children: [Icon(Icons.person), Text('5'), Text('6')]),
          TableRow(children: [Icon(Icons.person), Text('5'), Text('6')]),
          TableRow(children: [Icon(Icons.person), Text('5'), Text('6')]),
        ],
      )),
    );
  }
}