import 'package:http/http.dart' as http;
import 'cookies.dart';

Future<http.Response> login(String username, String password) async{
  var loginMap = new Map<String, dynamic>();
  loginMap['username'] = username;
  loginMap['password'] = password;
  String loginUrl = 'https://amizone-apiv2.herokuapp.com/login';
  http.Response loginResponse = await http.post(Uri.parse(loginUrl), body:loginMap);
  if(loginResponse.statusCode==200){
    setCookie(loginResponse.body);
    setCookieCreds(username, password);
  }
  return loginResponse;
}

Future<http.Response> semCount() async{
  String semCountUrl = 'https://amizone-apiv2.herokuapp.com/sem_count';
  Map sessionCookie = await getCookie();
  http.Response semCountResponse = await http.get(Uri.parse(semCountUrl), headers: sessionCookie);
  return semCountResponse;
}

Future<http.Response> profile() async{
  String profileUrl = 'https://amizone-apiv2.herokuapp.com/profile';
  Map sessionCookie = await getCookie();
  http.Response profileResponse = await http.get(Uri.parse(profileUrl), headers: sessionCookie);
  return profileResponse;
}

Future<http.Response> courses() async{
  String coursesUrl = 'https://amizone-apiv2.herokuapp.com/courses';
  Map sessionCookie = await getCookie();
  http.Response coursesResponse = await http.get(Uri.parse(coursesUrl), headers: sessionCookie);
  return coursesResponse;
}

Future<http.Response> courseBySem(int sem) async{
  String coursesUrl = 'https://amizone-apiv2.herokuapp.com/courses?sem=${sem}';
  Map sessionCookie = await getCookie();
  http.Response coursesResponse = await http.get(Uri.parse(coursesUrl), headers: sessionCookie);
  return coursesResponse;
}

Future<http.Response> result() async{
  String resultUrl = 'https://amizone-apiv2.herokuapp.com/result';
  Map sessionCookie = await getCookie();
  http.Response resultResponse = await http.get(Uri.parse(resultUrl), headers: sessionCookie);
  return resultResponse;
}

Future<http.Response> resultBySem(int sem) async{
  String resultUrl = 'https://amizone-apiv2.herokuapp.com/result?sem=${sem}';
  Map sessionCookie = await getCookie();
  http.Response resultResponse = await http.get(Uri.parse(resultUrl), headers: sessionCookie);
  return resultResponse;
}

Future<http.Response> faculty() async{
  String facultyUrl = 'https://amizone-apiv2.herokuapp.com/faculty';
  Map sessionCookie = await getCookie();
  http.Response facultyResponse = await http.get(Uri.parse(facultyUrl), headers: sessionCookie);
  return facultyResponse;
}

Future<http.Response> examSchedule() async{
  String examScheduleUrl = 'https://amizone-apiv2.herokuapp.com/exam_schedule';
  Map sessionCookie = await getCookie();
  http.Response examScheduleResponse = await http.get(Uri.parse(examScheduleUrl), headers: sessionCookie);
  return examScheduleResponse;
}

Future<http.Response> timetable() async{
  String timetableUrl = 'https://amizone-apiv2.herokuapp.com/timetable';
  Map sessionCookie = await getCookie();
  http.Response timetableResponse = await http.get(Uri.parse(timetableUrl), headers: sessionCookie);
  return timetableResponse;
}