import 'package:amizoneapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import '../utils/remote_services.dart' as api;

String _username;
String _password;
var result;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isloading;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text('Amizone',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        labelText: 'User Name',
                      ),
                      onChanged: (value){
                        _username=value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        labelText: 'Password',
                      ),
                      onChanged: (value){
                        _password=value;
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      height: 70,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: isloading==true?CircularProgressIndicator(backgroundColor: Colors.white,):Text('Login'),
                        onPressed: ()async {
                          setState(() {
                            isloading=true;
                          });
                          if(_username==null || _username=='' || _password==null || _password==''){
                            setState(() {
                              isloading=false;
                            });
                          showDialog(
                              context: context,
                              builder: (_)=>AlertDialog(
                                title: Text('Error!'),
                                content: Text('Incomplete credentials'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )
                          );
                          }
                          else{
                            await api.login(_username, _password).then((res)=>result=res);
                            if(result.statusCode == 401){
                              setState(() {
                                isloading=false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (_)=>AlertDialog(
                                    title: Text('Error!'),
                                    content: Text('Invalid Username or Password'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  )
                              );
                            }
                            else {
                              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Home()));
                            }
                          }
                        },
                      )
                  ),
                ],
              ),
            )
        )
    );
  }
}
