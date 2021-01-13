import 'package:flutter/material.dart';
import 'create.dart';


List<String> myList = new List<String>();
//Map<String, List<String>> myMap = new Map();
//var day_time_key = 0;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

//  Widget WordList() {
//    return ListView.builder(
//          itemCount: entries.length,
//          itemBuilder: (context,index){
//            return Container(
//              height: 10,
//              color: Colors.amber[colorCodes[index]],
//              child: Center(child: Text('Entry ${entries[index]}')),
//            );
//          }
//    );
//  }
//



//  Widget WordList() {
//
//    // backing data
//    final europeanCountries = ['Albania', 'Andorra', 'Armenia', 'Austria',
//    'Azerbaijan', 'Belarus', 'Belgium', 'Bosnia and Herzegovina', 'Bulgaria',
//    'Croatia', 'Cyprus', 'Czech Republic', 'Denmark', 'Estonia'];
//    new Column(
//      children: <Widget>[
//        new Expanded(
//            child: new ListView.builder
//              (
//                itemCount: myMap[day_time_key].length,
//                itemBuilder: (BuildContext ctxt, int Index) {
//                  return new Text(myMap[day_time_key][Index]);
//                }
//            )
//        )
//      ],
//    );
//  }

  toggleCoin() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text("Kyle", style: TextStyle(
            fontSize: 22
          ),),
          Text("Blog", style: TextStyle(
            fontSize: 22, color: Colors.yellow
          ),)
        ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
        body: new Column(
          children: <Widget>[
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: myList.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return new Text(myList[Index]);
                    }
                )
            )
          ],
        ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog(toggleCoinCallback: toggleCoin,)));
            },
            child: Icon(Icons.add),
          )
        ],
      ),
    ),
    );
  }
}