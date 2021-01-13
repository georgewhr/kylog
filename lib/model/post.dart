import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post {
  String title;
  List<String> phrase;
  final DateTime date;

  Post({
    @required this.date,
  });

}