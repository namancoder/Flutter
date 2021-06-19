import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:telegramchatapp/Models/Emoji.dart';
import 'package:telegramchatapp/Widgets/FullImageWidget.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/helper/emoji.dart';

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
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  bool isDisplaySticker;
  bool isLoading;

  File imageFile;
  String imageUrl;

  String chatId;
  SharedPreferences preferences;
  String id;
  var listMessage;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);
    isDisplaySticker = false;
    isLoading = false;
    chatId = "";
    readLocal();
  }

  readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id") ?? "";
    if (id.hashCode <= receiverId.hashCode) {
      chatId = "$id-$receiverId";
    } else {
      chatId = "$receiverId-$id";
    }

    Firestore.instance
        .collection("users")
        .document(id)
        .updateData({'chattingWith': receiverId});
    setState(() {});
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

              (isDisplaySticker ? createStickers() : Container()),
              //INput Controller
              createInput(),
            ],
          ),
          //createLoading(),
        ],
      ),
      // onWillPop: onBackPress,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => onSendMessage("mimi1", 2),
                child: Emoji(num: "1"),
              ),
              TextButton(
                onPressed: () => onSendMessage("mimi2", 2),
                child: Emoji(num: '2'),
              ),
              TextButton(
                onPressed: () => onSendMessage("mimi3", 2),
                child: Emoji(num: '3'),
              ),
            ],
          ),
          //2ND ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => onSendMessage("mimi4", 2),
                child: Emoji(num: '4'),
              ),
              TextButton(
                onPressed: () => onSendMessage("mimi5", 2),
                child: Emoji(num: '5'),
              ),
              TextButton(
                onPressed: () => onSendMessage("mimi6", 2),
                child: Emoji(num: '6'),
              ),
            ],
          ),
          //3RD ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              TextButton(
                onPressed: () => onSendMessage("mimi7", 2),
                child: Emoji(num: "7"),
              ),
              TextButton(
                onPressed: () => onSendMessage("mimi8", 2),
                child: Emoji(num: '8'),
              ),
              TextButton(
                onPressed: () => onSendMessage("mimi9", 2),
                child: Emoji(num: '9'),
              ),
            ],
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.orange,
          Colors.black,
          Colors.purple,
          Colors.black,
          Colors.purple,
          Colors.orange
        ]),
      ),
    );
  }

  createListMessages() {
    return Flexible(
      child: chatId == ""
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection("messages")
                  .document(chatId)
                  .collection(chatId)
                  .orderBy("timestamp", descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                    ),
                  );
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        createItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] == id) ||
        index == 0) {
      return true;
    } else
      return false;
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] != id) ||
        index == 0) {
      return true;
    } else
      return false;
  }

  Widget createItem(int index, DocumentSnapshot document) {
    //right side // sender's msgs
    if (document["idFrom"] == id) {
      return Row(
        children: <Widget>[
          document["type"] == 0
              ? Container(
                  child: Text(
                    document["content"],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
                )
              : document["type"] == 1
                  ? Container(
                      child: TextButton(
                        child: Material(
                          child: CachedNetworkImage(
                            imageUrl: document['content'],
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lightBlueAccent),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset(
                                "images/img_not_available.jpeg",
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            //imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullPhoto(url: document["content"]),
                            ),
                          );
                        },
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  : Container(
                      child: Image.asset(
                        "images/${document['content']}.gif",
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
    // left side // receiver msgs
    else {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                isLastMsgLeft(index)
                    //display RECEIVER AVATAR
                    ? Material(
                        child: CachedNetworkImage(
                          imageUrl: receiverAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightBlueAccent),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(
                        width: 35.0,
                      ),
                //display msgs
                document["type"] == 0
                    ? Container(
                        child: Text(
                          document["content"],
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: EdgeInsets.only(
                          left: 10.0,
                        ),
                      )
                    : document["type"] == 1
                        ? Container(
                            child: TextButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  imageUrl: document['content'],
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.lightBlueAccent),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.asset(
                                      "images/img_not_available.jpeg",
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  //imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                clipBehavior: Clip.hardEdge,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullPhoto(url: document["content"]),
                                  ),
                                );
                              },
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: Image.asset(
                              "images/${document['content']}.gif",
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
              ],
            ),
            isLastMsgLeft(index)
                ? Container(
                    child: Text(
                      DateFormat("dd MMMM yyyy - hh:mm:aa").format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document["timestamp"]),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
                  )
                : Container(),

            //Message Time
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
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
                onPressed: getImage,
              ),
            ),
            color: Colors.transparent,
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
            color: Colors.transparent,
          ),

          Flexible(
            child: Container(
              child: TextField(
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration(
                  //isDense: true,
                  labelStyle: TextStyle(color: Colors.red),
       
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.transparent)),

                  fillColor: Colors.transparent,
                  filled: true,
                ),
                autofocus: true,
                focusNode: focusNode,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
              //color: Colors.transparent,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                color: Colors.purple,
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
        color: Colors.transparent,
      ),
    );
  }

  void onSendMessage(String contentMsg, int type) {
//if(type==0)
    if (contentMsg != "") {
      textEditingController.clear();
      var docRef = Firestore.instance
          .collection("messages")
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(docRef, {
          "idFrom": id,
          "idTo": receiverId,
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "type": type,
          "content": contentMsg,
        });
      });
      listScrollController.animateTo(
          listScrollController.position.minScrollExtent,
          duration: Duration(microseconds: 400),
          curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Empty message cannot be send");
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) isLoading = true;
    uploadImageFile();
  }

  Future uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;

      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: " + error);
    });
  }
}
