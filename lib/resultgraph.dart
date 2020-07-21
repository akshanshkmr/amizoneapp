import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flip_card/flip_card.dart';

String _username;
String _password;
var result=null;
var sgpa;
var cgpa;

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  PointsLineChart(this.seriesList, {this.animate});
  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData() {
    return new PointsLineChart(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Grade, double>> _createSampleData() {
    sgpa = [new Grade(1, jsonDecode(result)['Combined']['sgpa'][0]),];
    cgpa = [new Grade(1, jsonDecode(result)['Combined']['cgpa'][0]),];
    for(var i=0;i<jsonDecode(result)['Combined']['sgpa'].length;i++){
      sgpa.add(new Grade((i+1).toDouble(), jsonDecode(result)['Combined']['sgpa'][i]));
      cgpa.add(new Grade((i+1).toDouble(), jsonDecode(result)['Combined']['cgpa'][i]));
    }
    return [
      new charts.Series<Grade, double>(
        id: "sgpa",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Grade g, _) => g.sem,
        measureFn: (Grade g, _) => g.grade,
        data: sgpa,
      ),
      new charts.Series<Grade, double>(
        id:"cgpa",
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Grade g, _) => g.sem,
        measureFn: (Grade g, _) => g.grade,
        data: cgpa,
      )
    ];
  }
}
class Grade {
  final double sem;
  final double grade;
  Grade(this.sem, this.grade);
}



class ResultGraph extends StatefulWidget {
  ResultGraph(String username, String password){
    _username=username;
    _password=password;
  }
  @override
  _ResultGraphState createState() => _ResultGraphState();
}

class _ResultGraphState extends State<ResultGraph> {
  Future<String> getdata()async{
    var r;
    var map = new Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    r=await http.post("https://amizone-api.herokuapp.com/results", body: map);
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FlipCard(
        front: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: result==null?Center(child: CircularProgressIndicator()):
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PointsLineChart(PointsLineChart._createSampleData()),
          ),
        ),
          back: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//            elevation: 10,
            child: Center(
              child:result==null?CircularProgressIndicator():
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemCount: jsonDecode(result)['Combined']['cgpa'].length,
                     itemBuilder: (BuildContext context,int index){
                       return Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Table(
                           children: [
                             TableRow(children: [
                               Text("Sem "+(index+1).toString()),
                               Text("SGPA: "+jsonDecode(result)['Combined']['sgpa'][index].toString(),style: TextStyle(color: Colors.blue)),
                               Text("CGPA: "+jsonDecode(result)['Combined']['cgpa'][index].toString(),style: TextStyle(color: Colors.green))
                             ]
                             )
                           ],
                         ),
                       );
                     },
                )
              ),
            ),
          ),
      )
    );
  }
}
