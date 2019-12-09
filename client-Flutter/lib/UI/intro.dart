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
  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
        return Scaffold(body: Container(
          color: Colors.red,
          child: Center(
              child: Stack(
            children: <Widget>[
              Icon(Icons.access_time),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(controller: textEditingController,),
              ),
              FlatButton(
                child: Text("Login"),
                onPressed: () {
                  var text = textEditingController.text;
                  if(text.length >= 3){
                    MyApp.channels[IntroScreen.name].sink.add({'action':''});
                  }else{
                    Fluttertoast.showToast(msg: 'Please enter minimum 3 characters.');
                  }
                },
              )
            ],
          ),
          StreamBuilder(
            stream: MyApp.channels[IntroScreen.name].stream,
            builder: (ctx, snapshot) {
              var data = snapshot.data;
              if (data != null) {
                if(data['action'] == ''){

                }
              }
              return Text('yaay');
            },
          )
        ],
      )),
    ));
  }
}
