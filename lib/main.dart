import 'package:flutter/material.dart';
import 'package:blankwallpaper/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpapers',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
