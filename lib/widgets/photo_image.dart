import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Menampilkan foto dari path hasil kamera (Android/iOS maupun web).
class PhotoImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const PhotoImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(path, width: width, height: height, fit: fit);
    }
    return Image.file(File(path), width: width, height: height, fit: fit);
  }
}
