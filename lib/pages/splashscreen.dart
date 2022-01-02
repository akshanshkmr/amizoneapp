import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'loginScreen.dart';
import 'homeScreen.dart';
import '../utils/cookies.dart';

Map sessionCookie;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  Future<String> getdata() async{
    var c = await getCookie();
    setState((){
      sessionCookie = c;
    });
  }

  @override
  void initState() {
    setState(() {
      getdata();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: (sessionCookie==null) ?LoginScreen():Home(),
      title: Text('Made with Flutter',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black,
        ),
      ),
      image: Image.asset('assets/images/flutter.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 80,
      useLoader: false,
      loadingText: Text('By Akshansh Kumar',
          style: TextStyle(
              fontWeight: FontWeight.bold)),
    );
  }
}
