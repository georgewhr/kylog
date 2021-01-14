import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kyle/model/user.dart';
import 'package:kyle/screens/authenticate.dart';
import 'home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }

  }
}