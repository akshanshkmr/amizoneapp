import 'dart:convert';
import 'package:amizoneapp/attendancegraph.dart';
import 'package:amizoneapp/resultgraph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';

String _username;
String _password;
var result=null;

class Home extends StatefulWidget {
  Home(String u, String p){
    _username=u;
    _password=p;
  }

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  Future<String> getdata()async{
    var r;
//    SharedPreferences.getInstance().then((prefValue) => {
//      _username=prefValue.getString("username"),
//      _password=prefValue.getString("password"),
//    });
    var map = new Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    r=await http.post("https://amizone-api.herokuapp.com/timetable", body: map);
    setState((){
      result=r.body;
    });
    print(result);
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
        title: Text('Home'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
            onPressed: (){
              setState(() {
                result=null;
                Toast.show('Please Wait', context,duration: Toast.LENGTH_LONG);
//                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Home(_username,_password)));
              });
            },)
        ],
      ),
      drawer: Drawers(),
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Attendance(_username,_password),
                ResultGraph(_username,_password),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height-300,
            child: Center(child: result==null?CircularProgressIndicator():
            jsonDecode(result)['Time'].length==0?Text('No classes today, Enjoy!'):
            ListView.builder(
              itemCount: jsonDecode(result)['Time'].length,
              itemBuilder: (BuildContext ctext,int index){
                return ListTile(
                  title: Text('['+jsonDecode(result)['courseCode'][index].toString()+'] '+jsonDecode(result)['Time'][index].toString()),
                  subtitle: Text(jsonDecode(result)['courseTeacher'][index].toString()),
                  trailing: Text(jsonDecode(result)['classLocation'][index].toString()),
                );
              },
            )
            ),
          )
        ],
      )
    );
  }
}
