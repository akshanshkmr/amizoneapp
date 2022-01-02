import 'dart:convert';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';
import '../utils/remote_services.dart' as api;

var result;

class Faculty extends StatefulWidget {
  @override
  _FacultyState createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  Future<String> getdata()async{
    http.Response res = await api.faculty();
    setState((){
      result=res.body;
    });
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
    if (result==null){
      setState(() {
        getdata();
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('My Faculties'),
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
        ListView.builder(
          itemCount: jsonDecode(result)['faculties'].length,
          itemBuilder: (BuildContext ctext,int index){
            return ListTile(
              trailing: CircleAvatar(backgroundImage:NetworkImage(jsonDecode(result)['images'][index].toString()),radius: 25,),
              title: Text(jsonDecode(result)['faculties'][index].toString()),
              subtitle: Text(jsonDecode(result)['subjects'][index].toString()),
            );
          },
        )
    );
  }
}
