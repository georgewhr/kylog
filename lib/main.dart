import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      title: "baby logger",
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}