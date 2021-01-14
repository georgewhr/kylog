
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/post.dart';

class PostTile extends StatelessWidget {

  final Post post;
  PostTile({ this.post });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(post.title),
          subtitle: Text(post.phrases.toString()),
        ),
      ),
    );
  }
}