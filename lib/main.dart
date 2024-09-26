import 'package:flutter/material.dart';
import 'pages/gallery.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gallery',
      home: GalleryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
