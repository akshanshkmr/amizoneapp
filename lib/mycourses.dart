import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:dio/dio.dart';

String _username;
String _password;
var result=null;

class Courses extends StatefulWidget {
  Courses(String username, String password){
    _username=username;
    _password=password;
  }

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  Future<String> getdata()async{
    var r;
//    SharedPreferences.getInstance().then((prefValue) => {
//      _username=prefValue.getString("username"),
//      _password=prefValue.getString("password"),
//    });
    var map = new Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    r=await http.post("https://amizone-api.herokuapp.com/courses", body: map);
    setState((){
      result=r.body;
    });
    return r;
  }
@override
  void initState() {
//    result=null;
    setState(() {
      getdata();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
      if(result==null){
        setState(() {
          getdata();
        });
      }
    return Scaffold(
        appBar: AppBar(
          title: Text('My Courses'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh),
            onPressed: (){
              setState(() {
                result=null;
                Toast.show('Please Wait', context,duration: Toast.LENGTH_LONG);
//                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Courses(_username,_password)));
              });
            },)
          ],
        ),
        drawer: Drawers(),
        body: result==null?Center(child: CircularProgressIndicator(),):
            ListView.builder(
                itemCount: jsonDecode(result)['CourseCode'].length,
                itemBuilder: (BuildContext ctext,int index){
                  return ListTile(
                    title: Text(jsonDecode(result)['CourseName'][index].toString()+' ['+jsonDecode(result)['CourseCode'][index].toString()+']'),
                    subtitle: Text(jsonDecode(result)['Attendance'][index].toString(),style: TextStyle(
                      color: double.parse(jsonDecode(result)['Percentage'][index].toString())>95?Colors.green:double.parse(jsonDecode(result)['Percentage'][index].toString())>75?Colors.yellow:Colors.red
                    ),),
                    trailing: IconButton(icon: Icon(Icons.file_download,color: Colors.blue,),
                      onPressed: ()async{
                        var dir= await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                        await Dio().download(jsonDecode(result)['Syllabus'][index].toString(), dir+'/'+jsonDecode(result)['CourseName'][index].toString()+'.pdf');
                        Toast.show('File Downloaded', context,duration: Toast.LENGTH_LONG);
                    },)
                  );
                },
            )
    );
  }
}
