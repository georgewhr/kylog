import 'package:flutter/material.dart';
import 'post.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  Map<String, Post> map;

  User({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
  });

}