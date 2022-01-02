import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void setCookie (cookie){
  SharedPreferences.getInstance().then((prefValue) => {
    prefValue.setString("session_cookie", cookie)
  });
}

Future<Map> getCookie () async {
  var sp =  await SharedPreferences.getInstance();
  String cookieString = sp.getString("session_cookie");
  Map cookieJson = await jsonDecode(cookieString);
  Map<String, String> sessionCookie = {"session-cookie":json.encode(cookieJson['session_cookie'])};
  return sessionCookie;
}

void resetCookie (){
  SharedPreferences.getInstance().then((prefValue) => {
    prefValue.remove("session_cookie")
  });
}