import 'package:flutter/material.dart';
import 'package:newsn/view/rss_feed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsN',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RssFeedScreen(),
    );
  }
}
