import 'package:flutter/material.dart';
import 'package:kyle/model/user.dart';
import 'package:kyle/services/auth.dart';
import 'package:kyle/wrapper.dart';
import 'package:provider/provider.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
//    return MaterialApp (
//      title: "baby logger",
//      theme: ThemeData.dark(),
//      home: HomePage(),
//    );

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: "baby logger",
        theme: ThemeData.dark(),
        home: Wrapper(),
      ),
    );
  }
}