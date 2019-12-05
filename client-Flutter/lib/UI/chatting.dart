import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:deneme/chat_controller.dart';
import 'package:deneme/myapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChattingScreen extends StatefulWidget {
  var arguments;
  IOWebSocketChannel channel;

  ChattingScreen(this.arguments, {this.channel});

  @override
  ChattingScreenState createState() => ChattingScreenState();
}

class ChattingScreenState extends State<ChattingScreen>
    with WidgetsBindingObserver, AfterLayoutMixin<ChattingScreen> {
  List<String> chatHistory = [
    "There is no message in this conversation.",
  ];
  Chat chat;
  String userName = "0";
  bool connected = false;

  GlobalKey listViewKey = GlobalKey<State>();
  TextEditingController sendMessageTextFieldController =
      TextEditingController();
  ScrollController chatListViewScrollController = ScrollController();

  void updateClientChat() {
    debugPrint("updaaaytd");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    userName = widget.arguments['userName'];
    chat = Chat(updateClientChat);
    initSocket("chat");
    //chat.initializeChat(updateClientChat);
    super.initState();
  }

  initSocket(String identifier) async {
    sendToServer("CONNECT", {"userName": userName});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: MyApp.channel.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var data = snapshot.data;
          if (data != null) {
            Map respond = json.decode(data);
            handleStreamRespond(respond);
          }
          return Scaffold(
              appBar: AppBar(
                title: Text("App Title"),
              ),
              body: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: chatListViewScrollController,
                      itemCount: chat.getHistory().length,
                      itemBuilder: (context, index) {
                        return getMessageItem(chat.getHistory()[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: sendMessageTextFieldController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter a message'),
                          ),
                        ),
                        FlatButton(
                          child: Image.asset(
                            "assets/images/right-arrow.png",
                            width: 16,
                            height: 16,
                          ),
                          onPressed: () {
                            if (sendMessageTextFieldController.text
                                    .toString()
                                    .length >
                                0) {
                              sendToServer(
                                  "SEND_MESSAGE",
                                  Message.toSend(
                                      22,
                                      this.userName,
                                      sendMessageTextFieldController.text
                                          .toString()));
                              sendMessageTextFieldController.text = "";
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  void sendToServer(String action, var data) {
    data['action'] = action;
    MyApp.channel.sink.add(json.encode(data));
  }

  Widget getMessageItem(Message msg) {
    return Padding(
      padding: EdgeInsets.only(left: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            msg.sender.toString(),
            style: TextStyle(
                color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, top: 2),
            child: Text(msg.content.toString()),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        {
        }
        break;
      case AppLifecycleState.resumed:
        {}
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void handleStreamRespond(Map respond) {
    switch (respond['action']) {
      case 'GET_CHAT':
        Map _chat = respond;
        chat.updateChat(_chat);
        break;
      case 'CONNECTED':
        connected = true; //TODO disconnect
        sendToServer("GET_CHAT", {"chatId": "22"});
        break;
      default:
        break;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    chatListViewScrollController
        .jumpTo(chatListViewScrollController.position.maxScrollExtent);
  }
}
