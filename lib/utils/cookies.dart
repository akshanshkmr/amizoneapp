import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'remote_services.dart' as api;

void setCookieCreds(username,password){
  SharedPreferences.getInstance().then((prefValue) => {
    prefValue.setString("username", username),
    prefValue.setString("password", password)
  });
}

void getCookieFromCreds () async {
  var sp =  await SharedPreferences.getInstance();
  String username = sp.getString("username");
  String password = sp.getString("password");
  var cookieString = await api.login(username, password);
  Map cookieJson = await jsonDecode(cookieString.body);
  Map<String, String> sessionCookie = {"session-cookie":json.encode(cookieJson['session_cookie'])};
  setCookie(sessionCookie);
}

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