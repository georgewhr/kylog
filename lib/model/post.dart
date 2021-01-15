import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post {
  DateTime createdAt;
  String title;
  dynamic phrases = List<String>();
//  Map<int, List<String>> sub_posts;
  Post({
    @required this.title,
    @required this.phrases,
//    @required this.sub_posts,
  });
}