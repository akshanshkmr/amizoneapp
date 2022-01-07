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

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future<String> getdata()async{
    final response = await Future.wait([
      api.result(),
      api.semCount()
    ]);
    setState(() {
      result = response[0].body;
      semCount = jsonDecode(response[1].body)['sem_count'].toDouble();
      selectedSem = semCount;
    });
  }
  Future<String> getdataBySem(sem)async{
    http.Response res = await api.resultBySem(sem.toInt());
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
      if(result==null) {
        getdata();
      }
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
          title: Text('Exam Results'),
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
        body: result==null?Center(child: CircularProgressIndicator()):
        jsonDecode(result)['sem_result']['course_code'].length==0?Center(child: Text('Result Not Published yet')):
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
                itemCount: jsonDecode(result)['sem_result']['course_code'].length,
                itemBuilder: (BuildContext ctext,int index){
                  return ListTile(
                      title: Text(jsonDecode(result)['sem_result']['course_title'][index].toString()+' ['+jsonDecode(result)['sem_result']['course_code'][index].toString()+']'),
                      subtitle: Text(jsonDecode(result)['sem_result']['grade_point'][index].toString()),
                      trailing: CircleAvatar(
                        radius: 25,
                        child:Text(jsonDecode(result)['sem_result']['grade_obtained'][index].toString()),
                        backgroundColor: double.parse(jsonDecode(result)['sem_result']['grade_point'][index].toString())>=8?Colors.greenAccent:double.parse(jsonDecode(result)['sem_result']['grade_point'][index].toString())>=5?Colors.lightBlueAccent:Colors.redAccent)
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}
