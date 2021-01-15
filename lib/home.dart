import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'model/post.dart';
import 'services/database.dart';
import 'package:kyle/post_tile.dart';
import 'package:kyle/post_list.dart';
import 'create.dart';
import 'model/user.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

//    void _showSettingsPanel() {
//      showModalBottomSheet(context: context, builder: (context) {
//        return Container(
//          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
//          child: SettingsForm(),
//        );
//      });
//    }
    User user = Provider.of<User>(context);

    return StreamProvider<List<Post>>.value(
      value: DatabaseService(uid: user.uid).posts,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Kyle Logger'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('/Users/wgeorge/borathon/baby_logger/assets/coffee_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: PostList()
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
//List<String> myList = new List<String>();
//Map<String, List<String>> myMap = new Map();
//var day_time_key = 0;

//class HomePage extends StatefulWidget {
//
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage>{
//
//  toggleCoin() {
//    setState(() {});
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      appBar: AppBar(
//        title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//          Text("Kyle", style: TextStyle(
//            fontSize: 22
//          ),),
//          Text("Blog", style: TextStyle(
//            fontSize: 22, color: Colors.yellow
//          ),),
//
//        ],
//        ),
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//      ),
//        body: new Column(
//          children: <Widget>[
//            new Expanded(
//                child: new ListView.builder
//                  (
//                    itemCount: myList.length,
//                    itemBuilder: (BuildContext ctxt, int Index) {
//                      return new Text(myList[Index]);
//                    }
//                )
//            )
//          ],
//        ),
//      floatingActionButton: Container(
//        padding: EdgeInsets.symmetric(vertical: 20),
//        child:Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          FloatingActionButton(
//            onPressed: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog(toggleCoinCallback: toggleCoin,)));
//            },
//            child: Icon(Icons.add),
//          )
//        ],
//      ),
//    ),
//    );
//  }
//}