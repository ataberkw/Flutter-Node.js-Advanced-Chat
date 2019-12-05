import 'dart:convert';
import 'package:flutter/material.dart';

class ChatController {
  ChatController();
}

class Chat {
  int id;
  Function updateClientChat;
  List<Message> history = List();
  Chat(this.updateClientChat);

  //call when you update chat history
  updateChat(Map chat) {
    List history = chat['history'];
    this.history = List();
    history.reversed.forEach((v) {
      addMessage(id, v['messageId'], v['sender'], v['content']);
    });
  }

  addMessage(var chatId, var messageId, var sender, var content) {
    if (chatId is String) {
      chatId = int.parse(chatId);
    }
    if (messageId is String) {
      messageId = int.parse(messageId);
    }

    var _msg = Message.single(chatId, messageId, sender, content);
    this.history.add(_msg);
  }

  List<Message> getHistory() {
    if (history.length > 0) {
      return this.history;
    }
    List<Message> _history = List();
    _history.add(Message.noMessage());
    return _history;
  }
}

class Message {
  int messageId;
  String content;
  String sender;
  int chatId;

  Message.single(this.chatId, this.messageId, this.sender, this.content);
  static Object toSend(chatId, sender, content) {
    return {"chatId": chatId, "sender": sender, "content": content};
  }

  Message.noMessage() {
    this.messageId = -1;
    this.content = "No message in this chat";
  }
}
