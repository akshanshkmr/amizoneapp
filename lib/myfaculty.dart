import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';

String _username;
String _password;
var result=null;

class Faculty extends StatefulWidget {
  Faculty(String username, String password){
    _username=username;
    _password=password;
  }

  @override
  _FacultyState createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  Future<String> getdata()async{
    var r;
//    SharedPreferences.getInstance().then((prefValue) => {
//      _username=prefValue.getString("username"),
//      _password=prefValue.getString("password"),
//    });
    var map = new Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    r=await http.post("https://amizone-api.herokuapp.com/faculty", body: map);
    setState((){
      result=r.body;
    });
    print(result);
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
//                  Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Faculty(_username,_password)));
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
              trailing: CircleAvatar(backgroundImage:NetworkImage(jsonDecode(result)['images'][index].toString()),radius: 20,),
              title: Text(jsonDecode(result)['faculties'][index].toString()),
              subtitle: Text(jsonDecode(result)['subjects'][index].toString()),
            );
          },
        )
    );
  }
}
