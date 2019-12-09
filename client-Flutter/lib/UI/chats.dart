import 'dart:convert';

import 'package:deneme/UI/chatting.dart';
import 'package:deneme/UI/pick_user.dart';
import 'package:deneme/datas.dart';
import 'package:deneme/myapp.dart';
import 'package:deneme/stream_helper.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ChatsScreen extends StatefulWidget {
  var arguments;
  static const name = ADatas.chats;

  ChatsScreen(this.arguments);

  createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> with RouteHelper{
  String userName = "";

  var textEditingController = TextEditingController();

  @override
  void initState() {
    getRouteName();
    userName = widget.arguments['userName'];
    initChannel();
    super.initState();
  }

  void initChannel() {
    sendToServer("CONNECT", {"userName": userName});
  }

  void sendToServer(String action, var data) {
    data['action'] = action;
    MyApp.channels[ChatsScreen.name].sink.add(json.encode(data));
  }

  @override
  Widget build(BuildContext context) {
    if(widget is ChatsScreen){
      (widget.runtimeType.name);
    }
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            StreamBuilder<Object>(
                stream: MyApp.channels[ChatsScreen.name].stream,
                builder: (context, AsyncSnapshot snapshot) {
                  var data = snapshot.data;
                  if (snapshot.hasData) {
                    handleStreamRespond(json.decode(data));
                  }
                  
                  return Column(
                    children: [
                      Text("Displaying $userName's chats"),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              decoration:
                                  InputDecoration(hintText: "New chat's name"),
                            ),
                          ),
                          FlatButton(
                            child: Text("Create"),
                            onPressed: () {
                              if (textEditingController.text.length > 0) {
                                /*sendToServer("NEW_CHAT",
                                    {"chatName": textEditingController.text});*/
                              }
                              Navigator.pop(context);
                              Navigator.pushNamed(context, ADatas.pickUser,
                                  arguments: {
                                    "action": PickUserActions.NEW_CHAT,
                                    "chatName" : textEditingController.text
                                  });
                            },
                          )
                        ],
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }

  void handleStreamRespond(Map respond) {
    switch (respond['action']) {
      case 'CONNECTED':
        sendToServer("GET_CHATS", {"userName": userName});
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    MyApp.delChannel(ChatsScreen.name);
    super.dispose();
  }
}
