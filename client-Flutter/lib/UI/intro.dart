import 'dart:async';
import 'dart:convert';

import 'package:deneme/UI/debug_home.dart';
import 'package:deneme/datas.dart';
import 'package:deneme/myapp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IntroScreen extends StatefulWidget {
  static const name = ADatas.introRoute;
  IntroScreen() {
    //MyApp.channels[name].sink.add({'action': 'AUTHORIZATION','userName': 2});
  }
  createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  StreamSubscription streamSubscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _test(context));
  }

  void _test(BuildContext ctx) {
    debugPrint("true");
  }

  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
    MyApp.channels[IntroScreen.name].stream.listen((data) {
      if (data) {
        debugPrint(data.toString());
        /*var data = json.decode(snapshot.data);
                debugPrint(data.toString());
                if (data['action'] == 'AUTHORIZATION') {
                  var userId = data['userId'];
                  MyApp.userId = userId;
                  // Navigator.pushNamed(context, DebugHome.name);
                  //Navigator.popAndPushNamed(context, DebugHome.name);
                  debugPrint('its authorized');
                }*/
      }
    });
    return Scaffold(
        body: Container(
      color: Colors.red,
      child: Center(
          child: Stack(
        children: <Widget>[
          Icon(Icons.access_time),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: textEditingController,
                ),
              ),
              FlatButton(
                child: Text("Login"),
                onPressed: () {
                  var text = textEditingController.text;
                  if (text.length >= 3) {
                    var authorizationRequest = {
                      'action': 'AUTHORIZATION',
                      'userName': text
                    };
                    MyApp.channels[IntroScreen.name].sink
                        .add(json.encode(authorizationRequest));
                    debugPrint('Authorization request sent as $text');
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please enter minimum 3 characters.');
                  }
                },
              )
            ],
          ),
          /*StreamBuilder(
            stream: MyApp.channels[IntroScreen.name].stream,
            builder: (ctx, snapshot) {
              
              return Text('yaay');
            },
          )*/
        ],
      )),
    ));
  }
}
