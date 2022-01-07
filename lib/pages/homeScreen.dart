import 'dart:convert';
import '../graphs/attendancegraph.dart';
import '../graphs/resultgraph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';
import '../utils/remote_services.dart' as api;

var result;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<String> getdata() async{
    http.Response res = await api.timetable();
    setState((){
      result=res.body;
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
                AttendanceGraph(),
                ResultGraph(),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height-300,
            child: Center(child: result==null?CircularProgressIndicator():
            jsonDecode(result)['class_time'].length==0?Text('No classes today, Enjoy!'):
            ListView.builder(
              itemCount: jsonDecode(result)['class_time'].length,
              itemBuilder: (BuildContext ctext,int index){
                return ListTile(
                  // isThreeLine: true,
                  title: Text('['+jsonDecode(result)['course_code'][index].toString()+'] ' + jsonDecode(result)['course_title'][index].toString()),
                  leading: Icon(Icons.circle, color:jsonDecode(result)['attendance'][index]<0?Colors.redAccent:
                  jsonDecode(result)['attendance'][index]>0?Colors.greenAccent:Colors.lightBlueAccent),
                  subtitle: Text(jsonDecode(result)['course_teacher'][index].toString()),
                  trailing: Text(jsonDecode(result)['class_location'][index].toString() + '\n' + jsonDecode(result)['class_time'][index].toString()),
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
