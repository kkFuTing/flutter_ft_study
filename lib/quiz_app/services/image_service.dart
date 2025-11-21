import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// 图片处理服务
class ImageService {
  static final ImageService instance = ImageService._init();
  ImageService._init();

  /// 获取图片存储目录
  Future<Directory> getImageDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory(path.join(appDir.path, 'quiz_images'));
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }

  /// 从本地路径复制图片到应用目录
  /// 返回相对路径（相对于应用文档目录）
  Future<String?> copyImageFromPath(String sourcePath, String fileName) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        return null;
      }

      final imageDir = await getImageDirectory();
      final targetPath = path.join(imageDir.path, fileName);
      final targetFile = await sourceFile.copy(targetPath);

      // 返回相对路径
      final appDir = await getApplicationDocumentsDirectory();
      return path.relative(targetFile.path, from: appDir.path);
    } catch (e) {
      print('复制图片失败: $e');
      return null;
    }
  }

  /// 从URL下载图片到应用目录
  /// 返回相对路径
  Future<String?> downloadImageFromUrl(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return null;
      }

      final imageDir = await getImageDirectory();
      final targetPath = path.join(imageDir.path, fileName);
      final targetFile = File(targetPath);
      await targetFile.writeAsBytes(response.bodyBytes);

      // 返回相对路径
      final appDir = await getApplicationDocumentsDirectory();
      return path.relative(targetFile.path, from: appDir.path);
    } catch (e) {
      print('下载图片失败: $e');
      return null;
    }
  }

  /// 处理图片路径（支持本地路径和URL）
  /// 如果是本地路径，复制到应用目录
  /// 如果是URL，下载到应用目录
  /// 返回相对路径，如果处理失败返回null
  Future<String?> processImagePath(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    // 判断是URL还是本地路径
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // URL，下载图片
      final fileName = path.basename(imagePath);
      // 如果URL中没有文件名，使用时间戳
      final finalFileName = fileName.contains('.')
          ? fileName
          : '${DateTime.now().millisecondsSinceEpoch}.jpg';
      return await downloadImageFromUrl(imagePath, finalFileName);
    } else {
      // 本地路径，复制图片
      final fileName = path.basename(imagePath);
      // 如果源文件没有扩展名，尝试添加
      final finalFileName = fileName.contains('.')
          ? fileName
          : '${DateTime.now().millisecondsSinceEpoch}.jpg';
      return await copyImageFromPath(imagePath, finalFileName);
    }
  }

  /// 根据相对路径获取完整文件路径
  Future<String?> getImageFilePath(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      return null;
    }
    final appDir = await getApplicationDocumentsDirectory();
    return path.join(appDir.path, relativePath);
  }

  /// 检查图片文件是否存在
  Future<bool> imageExists(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      return false;
    }
    final filePath = await getImageFilePath(relativePath);
    if (filePath == null) return false;
    return await File(filePath).exists();
  }
}

