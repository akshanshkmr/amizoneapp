import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'mycourses.dart';

String _username;
String _password;
var result=null;
Map<String, double> dataMap = new Map();

class Attendance extends StatefulWidget {
  Attendance(String username, String password){
    _username=username;
    _password=password;
  }
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  Future<String> getdata()async{
    var r;
    var map = new Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    r=await http.post("https://amizone-api.herokuapp.com/courses", body: map);
    setState((){
      result=r.body;
    });
    double low=0,med=0,high=0;
    var list=List<double>.from(jsonDecode(result)['Percentage']);
    print(list);
    for (int i=0; i<list.length; i++) {
      if(list[i]<75)
        low=low+1;
      else if(list[i]>=75 &&list[i]<85)
        med=med+1;
      else if(list[i]>=85)
        high=high+1;
    }
    dataMap.putIfAbsent('Below 75', () => low);
    dataMap.putIfAbsent('75 To 85', () => med);
    dataMap.putIfAbsent('Above 85', () => high);
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Center(
            child:result==null?CircularProgressIndicator():
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              showChartValuesInPercentage: false,
              showChartValuesOutside: true,
              ),
            ),
          ),
        ),
        onTap: (){
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Courses(_username,_password)));
        },
      ),
    );
  }
}
