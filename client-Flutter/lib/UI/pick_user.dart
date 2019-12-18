import 'dart:convert';

import 'package:deneme/datas.dart';
import 'package:deneme/myapp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_socket_channel/io.dart';

class PickUserScreen extends StatefulWidget {
  var arguments;
  static const name = ADatas.pickUser;
  PickUserScreen(this.arguments);

  PickUserState createState() => PickUserState();
}

class PickUserState extends State<PickUserScreen> {
  String action;
  @override
  void initState() {
    action = widget.arguments["action"];
    initChannel();
    super.initState();
  }

  void initChannel() {
  }

  void sendToServer(String action, var data) {
    data['action'] = action;
    MyApp.channels[PickUserScreen.name].sink.add(json.encode(data));
  }

  var addedUserIds = [];

  @override
  Widget build(BuildContext context) {
    var content = null;
    switch (action) {
      case PickUserActions.NEW_CHAT:
        {
          var textEditingController = TextEditingController();
          content = Scaffold(
            appBar: AppBar(
              title: Text('Chat: ' + widget.arguments['chatName']),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    sendToServer('NEW_CHAT', {
                      'chatName': widget.arguments['chatName'],
                    });
                  },
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(8),
              child: Stack(children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration:
                                InputDecoration(hintText: "Enter a username"),
                          ),
                        ),
                        FlatButton(
                          child: Text("Ara"),
                          onPressed: () {
                            if (textEditingController.text.length >= 3) {
                              sendToServer("GET_USERS",
                                  {"userName": textEditingController.text});
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please enter minimum 3 characters.');
                            }
                          },
                        )
                      ],
                    ),
                    StreamBuilder(
                      stream: MyApp.channels[PickUserScreen.name].stream,
                      builder: (ctx, AsyncSnapshot<Object> snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          var jsonData = json.decode(data);
                          debugPrint(jsonData.toString());
                          var users = List<dynamic>();
                          users = jsonData['users'];
                          var addedUsersText = "";
                          for (var userId in addedUserIds) {
                            var _user = users.firstWhere((a) {
                              return a['id'] == userId;
                            });
                            debugPrint('@@@ ' +
                                addedUserIds.last.runtimeType.toString() +
                                " aaaa " +
                                userId.runtimeType.toString());
                            addedUsersText += _user['name'] +
                                (addedUserIds.last == userId ? "" : ", ");
                          }
                          if (jsonData['action'].toString() == 'GET_USERS') {
                            debugPrint(users.toString());
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Current users: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            addedUsersText,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withAlpha(100),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey.withAlpha(100),
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: users.length,
                                  itemBuilder: (ctx, index) {
                                    debugPrint('rell');
                                    var user = users[index];
                                    var userAdded =
                                        addedUserIds.contains(user['id']);
                                    return Container(
                                      color: userAdded
                                          ? Colors.grey.withAlpha(50)
                                          : null,
                                      child: FlatButton(
                                        child: Align(
                                            child: Row(
                                              children: <Widget>[
                                                Text('User: ' + user['name']),
                                                Icon(userAdded
                                                    ? Icons.cancel
                                                    : Icons.chevron_right)
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            ),
                                            alignment: Alignment.centerLeft),
                                        onPressed: () {
                                          setState(() {
                                            var id = user['id'];
                                            if (addedUserIds.contains(id))
                                              addedUserIds.remove(id);
                                            else
                                              addedUserIds.add(id);
                                          });
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder: (ctx, index) {
                                    return Container(
                                      height: 1,
                                      color: Colors.black.withAlpha(50),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        }
                        return Text('NOPE');
                      },
                    )
                  ],
                )
              ]),
            ),
          );
        }
    }
    return content;
  }

@override
  void dispose() {
    MyApp.delChannel(PickUserScreen.name);
    super.dispose();
  }
}

class PickUserActions {
  static const NEW_CHAT = "newChat";
}
