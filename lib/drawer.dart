import 'package:amizoneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mycourses.dart';
import 'homeScreen.dart';
import 'myfaculty.dart';
import 'loginScreen.dart';
import 'examschedule.dart';
import 'examresults.dart';

String _username;
String _password;

class Drawers extends StatefulWidget {
  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((prefValue) => {
        this.setState(() {
          _username=prefValue.getString("username");
          _password=prefValue.getString("password");
        })
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context){
      SharedPreferences.getInstance().then((prefValue) => {
        _username=prefValue.getString("username"),
      });
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Center(child: _username==null?CircleAvatar(child: Icon(Icons.account_circle),radius: 50,):CircleAvatar(backgroundImage: NetworkImage("https://amizone.net/amizone/Images/Signatures/" + _username + "_P.png"),radius: 50,)),
                Center(child: Text(''),),
                Center(child: _username==null?Text('User Name'):Text(_username))
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap:(){
            Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Home(_username,_password)));
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('My Courses'),
            onTap:(){
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Courses(_username,_password)));
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('My Faculty'),
              onTap:(){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Faculty(_username,_password)));
              }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text('Exam Schedule'),
              onTap:(){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Schedule(_username,_password)));
              }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Exam Results'),
              onTap:(){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Result(_username,_password)));
              }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              SharedPreferences.getInstance().then((prefValue) => {
                prefValue.setString("username", null),
                prefValue.setString("password", null)
              });
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
