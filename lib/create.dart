import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'dart:async';
import 'dart:math';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'services/database.dart';
import 'model/user.dart';
import 'package:provider/provider.dart';




class CreateBlog extends StatefulWidget {
  final _callback;
  CreateBlog( {@required void toggleCoinCallback() } ) :
      _callback = toggleCoinCallback;
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  bool _talkPressed = false;
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";

  final String intro_disp_msg = "What do you want to log?";
  List<LocaleName> _localeNames = [];
  final TextEditingController eCtrl = new TextEditingController();
  final SpeechToText speech = SpeechToText();


  @override
  void initState() {
    if (!_hasSpeech) {
      initSpeechState().then((value) {
        print('Speech initialization complete');
      });
    }
    lastWords = intro_disp_msg;
    super.initState();
  }


  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body:
      Column(children: [
        Expanded(
          flex: 4,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Recognized Words',
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
//                      color: Theme.of(context).selectedRowColor,
                      color: Colors.yellow,
                      child: Center(
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
//      new Column(
//        children: <Widget>[
//          Container(
//            child: Column(
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    Container(
//                      color: Theme.of(context).selectedRowColor,
//                      child: Center(
//                        child: Text(
//                          lastWords,
//                          textAlign: TextAlign.center,
//                          style: TextStyle(
//                            fontSize: 14.0, color: Colors.green
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
      floatingActionButton: Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text('Talk',
                  style: _talkPressed
                      ? TextStyle(
                      fontSize: 30.0, color: Colors.black26)
                      : TextStyle(
                      fontSize: 30.0, color: Colors.black)),
              onPressed: onTalkButtonPress
          ),
          FlatButton(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text('Stop',
              style: TextStyle(
                  fontSize: 30.0, color: Colors.black),
            ),
            onPressed: speech.isListening ? stopListening : null,
          ),
        ],
      ),
    ),
//      body: Container(
//        child: Column(
//          children: <Widget>[
//            SizedBox(height: 8,),
//            TextField(
//              decoration: InputDecoration(hintText: "thought"),
//              onChanged: (val) {
//                myText = val;
//                myList.add(myText);
//                var utc_time = DateTime.now().millisecondsSinceEpoch;
//                var day_time_key = utc_time - (utc_time % (86400 * 1000));
//              }
//
//            )
//          ],
//        ),
//      ),
    );
  }

  void onTalkButtonPress() {
    _talkPressed = true;
    if (!_hasSpeech || speech.isListening) {
      return;
    }
    startListening();
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 120),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
    String myLast = lastWords;
    User user = Provider.of<User>(context);
    DatabaseService(uid: user.uid).updateUserPostData(myLast);
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    _talkPressed = false;
    setState(() {
      lastWords = '${result.recognizedWords}';
      }
    );

//    setState(() {
//      lastWords = "${result.recognizedWords} - ${result.finalResult}";
//    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

}