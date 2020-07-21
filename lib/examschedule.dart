import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';

String _username;
String _password;
var result=null;

class Schedule extends StatefulWidget {
  Schedule(String username, String password){
    _username=username;
    _password=password;
  }

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Future<String> getdata()async{
    var r;
    var map = new Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    r=await http.post("https://amizone-api.herokuapp.com/schedule", body: map);
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
          title: Text('Exam Schedule'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh),
              onPressed: (){
                setState(() {
                  result=null;
                  Toast.show('Please Wait', context,duration: Toast.LENGTH_LONG);
//                  Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Schedule(_username,_password)));
                });
              },)
          ],
        ),
        drawer: Drawers(),
        body: result==null?Center(child: CircularProgressIndicator(),):
        jsonDecode(result)['courseCode'].length==0?Center(child: Text('Exam Schedule Not Available yet')):
        ListView.builder(
          itemCount: jsonDecode(result)['courseCode'].length,
          itemBuilder: (BuildContext ctext,int index){
            return ListTile(
                title: Text(jsonDecode(result)['ExamDate'][index].toString()),
                subtitle: Text(jsonDecode(result)['courseTitle'][index].toString()+' ['+jsonDecode(result)['courseCode'][index].toString()+']'),
                trailing: Text(jsonDecode(result)['Time'][index].toString())
            );
          },
        )
    );
  }
}
