import 'package:deneme/datas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DebugHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug Navigasyon"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: textEditingController,
            ),
            MaterialButton(
              onPressed: () => {
                if (textEditingController.text.toString().length > 0)
                  {
                    Navigator.pushNamed(context, ADatas.chatting,
                        arguments: {'userName': textEditingController.text})
                  }
              },
              child: Text("Chatting"),
            ),
            MaterialButton(
              onPressed: () => {
                if (textEditingController.text.toString().length > 0)
                  {
                    Navigator.pushNamed(context, ADatas.chats,
                        arguments: {'userName': textEditingController.text})
                  }
              },
              child: Text("Chats"),
            ),
            MaterialButton(
              onPressed: () =>
                  {Navigator.pushNamed(context, ADatas.publisherScreenRoute)},
              child: Text("Yayın Sayfası "),
            )
          ],
        ),
      ),
    );
  }
}
