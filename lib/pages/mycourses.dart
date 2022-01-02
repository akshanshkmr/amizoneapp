import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';
import '../utils/remote_services.dart' as api;

var result;
var semCount;
var selectedSem;

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  Future<String> getdata()async{
    final response = await Future.wait([
      api.courses(),
      api.semCount()
    ]);
    setState(() {
      result = response[0].body;
      semCount = jsonDecode(response[1].body)['sem_count'].toDouble();
      selectedSem = semCount;
    });
  }
  Future<String> getdataBySem(sem)async{
    http.Response res = await api.courseBySem(sem.toInt());
    setState((){
      result=res.body;
    });
  }
  Future<String> resetState()async{
    setState((){
      result=null;
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
          getdataBySem(selectedSem);
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
              });
            },)
          ],
        ),
        drawer: Drawers(),
        body: result==null?Center(child: CircularProgressIndicator(),):
            Column(
              children: [
                SpinBox(
                  min: 1,
                  max: semCount,
                  value: selectedSem,
                  onChanged: (value) => {
                    selectedSem = value,
                    resetState()
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: jsonDecode(result)['course_code'].length,
                      itemBuilder: (BuildContext ctext,int index){
                        return ListTile(
                          title: Text(jsonDecode(result)['course_name'][index].toString()+' ['+jsonDecode(result)['course_code'][index].toString()+']'),
                          subtitle: Text(jsonDecode(result)['attendance'][index].toString()),
                          trailing:CircleAvatar(
                              radius: 25,
                              child:Text(double.parse(jsonDecode(result)['attendance_pct'][index].toString()).truncate().toString()),
                              backgroundColor: double.parse(jsonDecode(result)['attendance_pct'][index].toString())>95?Colors.green:double.parse(jsonDecode(result)['attendance_pct'][index].toString())>75?Colors.yellow:Colors.red)
                        );
                      },
                  ),
                ),
              ],
            )
    );
  }
}
