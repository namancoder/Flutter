import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Pages/ChattingPage.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  Chat(
      {Key key,
      @required this.receiverId,
      @required this.receiverAvatar,
      @required this.receiverName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(receiverAvatar),
              ))
        ],
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          receiverName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
      ),
    );
  }
}