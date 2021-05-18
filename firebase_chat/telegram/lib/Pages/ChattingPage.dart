import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Widgets/FullImageWidget.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;

  ChatScreen(
      {Key key, @required this.receiverId, @required this.receiverAvatar})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
      );
}

class ChatScreenState extends State<ChatScreen> {
  final String receiverId;
  final String receiverAvatar;

  ChatScreenState(
      {Key key, @required this.receiverId, @required this.receiverAvatar});

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool isDisplaySticker;
  bool isLoading;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);
    isDisplaySticker = false;
    isLoading = false;
  }

  onFocusChange() {
    //diasppear the emoji keyboard
    if (focusNode.hasFocus) {
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              //createListMessages
              createListMessages(),

              //(isDisplaySticker ? createStickers() : Container()),
              //INput Controller
              createInput(),
            ],
          ),
        ],
      ),
      //onWillPop: onWillPop,
    );
  }

  Future<bool> onBackPress() {
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else
      Navigator.pop(context);

    return Future.value(false);
  }

  createStickers() {
    return Container(
      child: Column(
        children: <Widget>[
          //1ST ROW
          Row(
            children: <Widget>[
              FlatButton(
                //onPressed:onSendMessage("mimi1",2 ),
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed:onSendMessage("mimi1",2 ),

                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed:onSendMessage("mimi3",2 ),

                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          //2ND ROW
          Row(
            children: <Widget>[
              FlatButton(
                //onPressed:onSendMessage("mimi4",2 ),
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed:onSendMessage("mimi5",2 ),

                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed:onSendMessage("mimi6",2 ),

                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          //3RD ROW
          Row(
            children: <Widget>[
              FlatButton(
                //onPressed:onSendMessage("mimi7",2 ),
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed:onSendMessage("mimi8",2 ),

                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed:onSendMessage("mimi9",2 ),

                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(),
    );
  }

  createListMessages() {
    return Flexible(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
        ),
      ),
    );
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  createInput() {
    return Container(
      child: Row(
        children: <Widget>[
          //SEND IMAGES
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: () => print("Dvvfvfbbdgdbb"),
              ),
            ),
            color: Colors.white,
          ),
          //SEND EMOJIS
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face_outlined),
                color: Colors.lightBlueAccent,
                onPressed: () => getSticker(),
              ),
            ),
            color: Colors.white,
          ),

          Flexible(
            child: Container(
              child: TextField(
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  hintText: "...",
                  hintStyle: TextStyle(fontSize: 40.0),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => print("ily"),
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.purple, width: 1.5),
          bottom: BorderSide(color: Colors.red, width: 1.5),
          right: BorderSide(color: Colors.orange, width: 1.5),
          left: BorderSide(color: Colors.yellow, width: 1.5),
        ),
        //color: Colors.grey[200],
      ),
    );
  }
}
