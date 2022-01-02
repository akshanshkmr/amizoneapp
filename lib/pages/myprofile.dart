import 'dart:convert';
import 'drawer.dart';
import '../graphs/attendancegraph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';
import '../utils/remote_services.dart' as api;

var result;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Future<String> getdata() async{
    http.Response res = await api.profile();
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
          title: Text('Profile'),
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
        body: Center(
          child: result==null?CircularProgressIndicator():
          ListView(
            children: [
              ListTile(title: Text('Name'), subtitle: Text(jsonDecode(result)['name'])),
              ListTile(title: Text('Enrollment Number'), subtitle: Text(jsonDecode(result)['enrollment'])),
              ListTile(title: Text('Programme Name'), subtitle: Text(jsonDecode(result)['programme'])),
              ListTile(title: Text('Current Semester'), subtitle: Text(jsonDecode(result)['sem'])),
              ListTile(title: Text('Pass-out Year'), subtitle: Text(jsonDecode(result)['passyear'])),
            ],
          ),
        )
    );
  }
}
