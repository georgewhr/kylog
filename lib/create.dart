import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'dart:async';
import 'dart:math';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';




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
  final String intro_disp_msg = "What do you want me to do?";
  List<LocaleName> _localeNames = [];
  final TextEditingController eCtrl = new TextEditingController();
  final SpeechToText speech = SpeechToText();


  @override
  void initState() {
    if (!_hasSpeech) {
      initSpeechState().then((value) {
        print('Speech  initialization complete');
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
      body: new Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).selectedRowColor,
                      child: Center(
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.green
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
//          new TextField(
//            controller: eCtrl,
//            onSubmitted: (text) {
//              var utc_time = DateTime.now().millisecondsSinceEpoch;
////              day_time_key = utc_time - (utc_time % (86400 * 1000));
////              myMap[day_time_key].add(text);
//              myList.add(text);
//              eCtrl.clear();
//              setState(() {});
//              widget?._callback();
//            },
//          ),
//          new Expanded(
//              child: new ListView.builder
//                (
//                  itemCount: myList.length,
//                  itemBuilder: (BuildContext ctxt, int Index) {
//                    return new Text(myList[Index]);
//                  }
//              )
//          )
        ],
      ),
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
                      fontSize: 30.0, color: Colors.white24)
                      : TextStyle(
                      fontSize: 30.0, color: Colors.white)),
              onPressed: onTalkButtonPress
          ),
          FlatButton(
            child: Text('Stop',
              style: TextStyle(
                  fontSize: 30.0, color: Colors.white),
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
    myList.add(lastWords);
    widget?._callback();
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