import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DnMyApp extends StatelessWidget {
  const DnMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DnMyApp')),
      body: Center(
        child: Column(
          children: <Widget>[
            //网络图片
            Image.network(
              'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png',
              width: 150,
              height: 100,
            ),
            //本地图片
            Image.asset('assets/images/up.jpg', width: 150, height: 100),
            //内存图片
            MemoryImageWidget(),
            FileImageWidget(),
          ],
        ),

        // child: Container(
        //   width: 200,
        //   height: 200,
        //   transform: Matrix4.rotationZ(0.1),

        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.red, width: 2)
        //     ,borderRadius: BorderRadius.circular(10)
        //     ,
        //   ),
        //   padding: EdgeInsets.all(10),
        //   child: Text('Hello, World!')
        // ),
      ),
    );
  }
}

class FileImageWidget extends StatefulWidget {
  const FileImageWidget({super.key});

  @override
  State<FileImageWidget> createState() => _FileImageWidgetState();
}

class _FileImageWidgetState extends State<FileImageWidget> {
  File? _image;

  Future getImage() async {
    print('getImage22');
    final XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print('getImag22: imagefile: $xFile');
    setState(() {
      _image = xFile != null ? File(xFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child:
              _image != null ? Image.file(_image!,width: 150, height: 200,) : Text('No image selected',style: TextStyle(fontSize: 20, color: Colors.red),),
        ),
        ElevatedButton(onPressed: getImage, child: Text('Select Image')),
      ],
    );
  }
}

class MemoryImageWidget extends StatefulWidget {
  const MemoryImageWidget({super.key});

  @override
  State<MemoryImageWidget> createState() => _MemoryImageWidgetState();
}

class _MemoryImageWidgetState extends State<MemoryImageWidget> {
  Uint8List? imageData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.load('assets/images/up.jpg').then((value) {
      if (mounted) {
        setState(() {
          imageData = value.buffer.asUint8List();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      image:
          imageData != null
              ? DecorationImage(image: MemoryImage(imageData!))
              : null,
    );
    return Container(width: 200, height: 200, decoration: decoration);
  }
}
