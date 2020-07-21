import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';

String _username;
String _password;
var result=null;

class Result extends StatefulWidget {
  Result(String username, String password){
    _username=username;
    _password=password;
  }

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future<String> getdata()async{
    var r;
//    SharedPreferences.getInstance().then((prefValue) => {
//      _username=prefValue.getString("username"),
//      _password=prefValue.getString("password"),
//    });
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Exam Results'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh),
              onPressed: (){
                setState(() {
                  result=null;
                  Toast.show('Please Wait', context,duration: Toast.LENGTH_LONG);
//                  Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Result(_username,_password)));
                });
              },)
          ],
        ),
        drawer: Drawers(),
        body: result==null?Center(child: CircularProgressIndicator(),):
        jsonDecode(result)['Latest Result']['courseCode'].length==0?Center(child: Text('Not Published yet')):
        ListView.builder(
          itemCount: jsonDecode(result)['Latest Result']['courseCode'].length,
          itemBuilder: (BuildContext ctext,int index){
            return ListTile(
                title: Text(jsonDecode(result)['Latest Result']['courseTitle'][index].toString()+' ['+jsonDecode(result)['Latest Result']['courseCode'][index].toString()+']'),
                subtitle: Text(jsonDecode(result)['Latest Result']['GP'][index].toString()),
                trailing: CircleAvatar(child:Text(jsonDecode(result)['Latest Result']['Go'][index].toString()),)
            );
          },
        )
    );
  }
}
