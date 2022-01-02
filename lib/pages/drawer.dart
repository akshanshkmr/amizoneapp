import 'package:flutter/material.dart';
import 'mycourses.dart';
import 'homeScreen.dart';
import 'myfaculty.dart';
import 'loginScreen.dart';
import 'examschedule.dart';
import 'examresults.dart';
import 'myprofile.dart';
import '../utils/cookies.dart';

class Drawers extends StatefulWidget {
  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).primaryColor),
            title: Text('Home'),
            onTap:(){
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Home()));
            }
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
              title: Text('My Profile'),
              onTap:(){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Profile()));
              }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.school, color: Theme.of(context).primaryColor),
            title: Text('My Courses'),
            onTap:(){
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Courses()));
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.supervisor_account, color: Theme.of(context).primaryColor),
            title: Text('My Faculty'),
              onTap:(){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Faculty()));
              }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.schedule, color: Theme.of(context).primaryColor),
            title: Text('Exam Schedule'),
              onTap:(){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Schedule()));
              }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assessment, color: Theme.of(context).primaryColor),
            title: Text('Exam Results'),
              onTap:(){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Result()));
              }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: (){
              resetCookie();
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
