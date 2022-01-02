import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flip_card/flip_card.dart';
import '../utils/remote_services.dart' as api;

var result;
var sgpa;
var cgpa;

class Grade {
  final double sem;
  final double grade;
  Grade(this.sem, this.grade);
}

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  PointsLineChart(this.seriesList);
  factory PointsLineChart.withSampleData() {
    return PointsLineChart(
      _createSampleData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
        seriesList,
        animate: false,
        defaultRenderer: charts.LineRendererConfig(
            includePoints: true,
        )
    );
  }

  static List<charts.Series<Grade, double>> _createSampleData() {
    sgpa = [new Grade(1, jsonDecode(result)['combined']['sgpa'][0])];
    cgpa = [new Grade(1, jsonDecode(result)['combined']['cgpa'][0])];
    for(var i=0;i<jsonDecode(result)['combined']['sgpa'].length;i++){
      sgpa.add(new Grade((i+1).toDouble(), jsonDecode(result)['combined']['sgpa'][i]));
      cgpa.add(new Grade((i+1).toDouble(), jsonDecode(result)['combined']['cgpa'][i]));
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

class ResultGraph extends StatefulWidget {
  @override
  _ResultGraphState createState() => _ResultGraphState();
}

class _ResultGraphState extends State<ResultGraph> {
  Future<String> getdata() async{
    http.Response res = await api.result();
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FlipCard(
        front: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: result==null?Center(child: CircularProgressIndicator()):
            jsonDecode(result)['combined']['sgpa'].length==0?Center(child: Text('Result Not Published yet')):
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PointsLineChart(PointsLineChart._createSampleData()),
            ),
          ),
        back: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child:result==null?CircularProgressIndicator():
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemCount: jsonDecode(result)['combined']['cgpa'].length,
                     itemBuilder: (BuildContext context,int index){
                       return Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Table(
                           children: [
                             TableRow(children: [
                               Text("Sem "+(index+1).toString()),
                               Text("SGPA: "+jsonDecode(result)['combined']['sgpa'][index].toString(),style: TextStyle(color: Colors.blue)),
                               Text("CGPA: "+jsonDecode(result)['combined']['cgpa'][index].toString(),style: TextStyle(color: Colors.green))
                             ])
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
