import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginScreen.dart';
import 'homeScreen.dart';

String u,p;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
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
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: (u==null && p==null) ?LoginScreen():Home(u,p),
      title: new Text('Made with Flutter',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black,
        ),
      ),
      image: new Image.network('https://flutter.io/images/catalog-widget-placeholder.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.red,
      loadingText: Text('By Akshansh Kumar',style: TextStyle(color: Colors.black),),
    );
  }
}
