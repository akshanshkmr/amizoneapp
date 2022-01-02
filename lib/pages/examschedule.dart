import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import '../utils/remote_services.dart' as api;
import 'package:toast/toast.dart';

var result;

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Future<String> getdata()async{
    http.Response res = await api.examSchedule();
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
          title: Text('Exam Schedule'),
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
        body: result==null?Center(child: CircularProgressIndicator(),):
        jsonDecode(result)['course_code'].length==0?Center(child: Text('Exam Schedule Not Available yet')):
        ListView.builder(
          itemCount: jsonDecode(result)['course_code'].length,
          itemBuilder: (BuildContext ctext,int index){
            return ListTile(
                title: Text(jsonDecode(result)['exam_date'][index].toString()),
                subtitle: Text(jsonDecode(result)['course_title'][index].toString()+' ['+jsonDecode(result)['course_code'][index].toString()+']'),
                trailing: Text(jsonDecode(result)['exam_time'][index].toString())
            );
          },
        )
    );
  }
}
