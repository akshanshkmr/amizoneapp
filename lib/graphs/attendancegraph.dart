import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import '../pages/mycourses.dart';
import '../utils/remote_services.dart' as api;

var result;

Map<String, double> dataMap = new Map();

class AttendanceGraph extends StatefulWidget {
  @override
  _AttendanceGraphState createState() => _AttendanceGraphState();
}

class _AttendanceGraphState extends State<AttendanceGraph> {
  Future<String> getdata()async{
    http.Response res = await api.courses();
    setState((){
      result=res.body;
    });
    double low=0,med=0,high=0;
    var list=List<double>.from(jsonDecode(result)['attendance_pct']);
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
              chartValuesOptions: ChartValuesOptions(
                decimalPlaces: 0,
              ),
              ),
            ),
          ),
        ),
        onTap: (){
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Courses()));
        },
      ),
    );
  }
}
