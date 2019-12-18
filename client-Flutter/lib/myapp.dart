import 'package:deneme/UI/chats.dart';
import 'package:deneme/UI/chatting.dart';
import 'package:deneme/UI/debug_home.dart';
import 'package:deneme/UI/intro.dart';
import 'package:deneme/UI/pick_user.dart';
import 'package:deneme/datas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

/* 
dart(todo)
Implement a socket connection interface for chats chatting screens. Cause: avoiding of code repeat
 */

class MyApp extends StatelessWidget {
  static Map<String, IOWebSocketChannel> channels = Map();
  static var authorizedUser = {'token': "blahblah", 'id': 4};
  static int userId = 0;

  MyApp() {
    addChannel(IntroScreen.name); //TODO improve it
  }

  static authorizeUser(userId) {
    addChannel('authorization').sink.add({'action': 'LOGIN', 'userId': userId});
  }

  static isUserAuthorized() {
    return userId != 0;
  }

  final ui = MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case DebugHome.name:
            {
              return MaterialPageRoute(builder: (_) => DebugHomeScreen());
            }
          case ChattingScreen.name:
            {
              addChannel(settings.name);
              return MaterialPageRoute(
                  builder: (_) => ChattingScreen(settings.arguments));
            }
          case ChatsScreen.name:
            {
              addChannel(settings.name);
              return MaterialPageRoute(
                  builder: (_) => ChatsScreen(settings.arguments));
            }
          case PickUserScreen.name:
            {
              addChannel(settings.name);
              return MaterialPageRoute(
                  builder: (_) => PickUserScreen(settings.arguments));
            }
          default:
            {
              addChannel(settings.name);
              return MaterialPageRoute(builder: (_) => IntroScreen());
            }
        }
      },
      home: IntroScreen());

  static IOWebSocketChannel addChannel(routeName) {
    return channels[routeName] =
        IOWebSocketChannel.connect('ws://172.28.16.224:1337');
  }

  static delChannel(routeName) {
    channels[routeName].sink.close(0, "Closed by the client");
    channels.removeWhere((name, channel) => name == routeName);
  }

  @override
  Widget build(BuildContext context) {
    return ui;
  }
}
