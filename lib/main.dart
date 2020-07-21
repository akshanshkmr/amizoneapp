import 'package:amizoneapp/homeScreen.dart';
import 'package:amizoneapp/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splashscreen.dart';

void main() => runApp(MyApp());

String u,p;

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefValue) => {
      this.setState(() {
        u=prefValue.getString("username");
        p=prefValue.getString("password");
      }),
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Splash(),
//      home: (u==null && p==null) ?LoginScreen():Home(u,p),
    );
  }
}
