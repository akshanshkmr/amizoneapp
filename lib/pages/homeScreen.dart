import 'dart:convert';
import 'package:intl/intl.dart';
import '../graphs/attendancegraph.dart';
import '../graphs/resultgraph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';
import '../utils/remote_services.dart' as api;
import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';
import 'loginScreen.dart';

var result;
var selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<String> getdataByDate(date)async{
    http.Response res = await api.timetableByDate(date.toString());
    try{
      var test = jsonDecode(res.body)['class_time'].length;
    }
    catch (e){
      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    setState((){
      result=res.body;
    });
  }
  Future<String> resetState()async{
    setState((){
      result=null;
      Toast.show('Please Wait', context,duration: Toast.LENGTH_LONG);
    });
  }
  @override
  void initState() {
    setState(() {
      getdataByDate(selectedDate);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(result==null){
      setState(() {
        getdataByDate(selectedDate);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
            onPressed: (){
              resetState();
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
          FlutterDatePickerTimeline(
            startDate: DateTime.now().subtract(Duration(days:7)),
            endDate: DateTime.now().add(Duration(days:7)),
            initialSelectedDate: DateFormat("yyyy-MM-dd").parse(selectedDate),
            selectedItemBackgroundColor: Theme.of(context).primaryColor,
              onSelectedDateChange: (DateTime dateTime) {
                selectedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                resetState();
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: MediaQuery.of(context).size.height-300,
              child: Center(child: result==null?CircularProgressIndicator():
              jsonDecode(result)['class_time'].length==0?Text('No classes today, Enjoy!'):
              ListView.builder(
                itemCount: jsonDecode(result)['class_time'].length,
                itemBuilder: (BuildContext ctext,int index){
                  return ListTile(
                    title: Text(jsonDecode(result)['course_title'][index].toString()),
                    leading: Icon(Icons.circle, color:jsonDecode(result)['attendance'][index]<0?Colors.redAccent:
                    jsonDecode(result)['attendance'][index]>0?Colors.greenAccent:Colors.blueGrey),
                    subtitle: Text(jsonDecode(result)['course_teacher'][index].toString()),
                    trailing: Text(jsonDecode(result)['class_location'][index].toString() + '\n' + jsonDecode(result)['class_time'][index].toString()),
                  );
                },
              )
              ),
            ),
          )
        ],
      )
    );
  }
}
