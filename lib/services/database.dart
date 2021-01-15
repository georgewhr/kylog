import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyle/model/post.dart';
import 'package:intl/intl.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference postCollection = Firestore.instance.collection('posts');

  Future<void> updateUserData(String title, List<String> phrases) async {
    var utc_time = DateTime.now().millisecondsSinceEpoch;
    String day_time_key = (utc_time - (utc_time % (86400 * 1000))).toString();
//    return await postCollection.document(uid).setData({
//      'title': title,
//      'phrases': phrases
//    });
//    return await postCollection.document(uid).updateData({day_time_key: {'title':title, 'phrases': phrases}});

    return await postCollection.document(uid).setData({
      day_time_key: {'title':title, 'phrases': phrases},
    });
  }
  
  Future<void> updateUserPostData(String phrase) async {
    var utc_time = DateTime.now().millisecondsSinceEpoch;
    String day_time_key = (utc_time - (utc_time % (86400 * 1000))).toString();
    DocumentSnapshot s = await postCollection.document(uid).get();
    List<String> myList;
    Map<String, dynamic> map = Map.from(s.data);
    if (! map.containsKey(day_time_key)) {
      updateUserData("Hello", ["first phrase"]);
    } else {
      myList = List.from(map[day_time_key]['phrases']);
    }
    print(myList);
    myList.add(phrase);
    postCollection.document(uid).updateData({
      day_time_key: {'title':"test title", 'phrases': myList},
    });
  }

  List<Post> _postListFromSnapshot(DocumentSnapshot snapshot) {
    List<Post> list = new List<Post>();
    var utc_time = DateTime.now().millisecondsSinceEpoch;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String day_time_key = (utc_time - (utc_time % (86400 * 1000))).toString();
    var p = snapshot.data ?? {};
    p.forEach((key, value) => list.add(Post(title:formatter.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(key))),
        phrases:value)));
    print(p);
    return list;
  }

  // get posts stream
  Stream<List<Post>> get posts {
    return postCollection.document(uid).snapshots().map(_postListFromSnapshot);
  }



//  // brew list from snapshot
//  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
//    return snapshot.documents.map((doc){
//      //print(doc.data);
//      return Brew(
//          name: doc.data['name'] ?? '',
//          strength: doc.data['strength'] ?? 0,
//          sugars: doc.data['sugars'] ?? '0'
//      );
//    }).toList();
//  }
//
//  // user data from snapshots
//  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//    return UserData(
//        uid: uid,
//        name: snapshot.data['name'],
//        sugars: snapshot.data['sugars'],
//        strength: snapshot.data['strength']
//    );
//  }
//
//  // get brews stream
//  Stream<List<Brew>> get brews {
//    return brewCollection.snapshots()
//        .map(_brewListFromSnapshot);
//  }
//
//  // get user doc stream
//  Stream<UserData> get userData {
//    return brewCollection.document(uid).snapshots()
//        .map(_userDataFromSnapshot);
//  }

}