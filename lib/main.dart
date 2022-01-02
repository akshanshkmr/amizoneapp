import 'package:flutter/material.dart';
import 'pages/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amizone',
      theme: ThemeData.light(),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
