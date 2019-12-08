import 'package:deneme/UI/chats.dart';
import 'package:deneme/UI/chatting.dart';
import 'package:deneme/UI/debug_home.dart';
import 'package:deneme/UI/debug_publisher_screen.dart';
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
  static IOWebSocketChannel channel =
      IOWebSocketChannel.connect('ws://172.28.19.38:1337'); //TODO IMPROVE IT
  static int userId = 0;

  MyApp() {
    channel.stream.asBroadcastStream();
    debugPrint("Stream is : " + channel.stream.isBroadcast.toString());
  }

  final ui = MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case ADatas.homeRoute:
            return MaterialPageRoute(builder: (_) => DebugPublisherScreen());
          case ADatas.chatting:
            return MaterialPageRoute(
                builder: (_) => ChattingScreen(settings.arguments));
          case ADatas.chats:
            return MaterialPageRoute(
                builder: (_) => ChatsScreen(settings.arguments));
          case ADatas.pickUser:
            return MaterialPageRoute(
                builder: (_) => PickUserScreen(settings.arguments));
          default:
            return MaterialPageRoute(builder: (_) => DebugPublisherScreen());
        }
      },
      home: DebugHome());

  @override
  Widget build(BuildContext context) {
    return ui;
  }
}
