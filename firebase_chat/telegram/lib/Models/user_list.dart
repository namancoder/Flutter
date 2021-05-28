import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telegramchatapp/Models/chat_model.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Pages/ChattingPage.dart';


class UserResult extends StatelessWidget {
  final User eachUser;
  //UserResult(@required , {User eachUser}this.eachUser);
  UserResult({ @required this.eachUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        //decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
        color: Colors.white,
        child: Column(children: <Widget>[
          GestureDetector(
            onTap: () => sendUserToChatPage(context),
            child: ListTile(
              tileColor: Colors.yellow,
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.teal,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(eachUser.photoUrl),
              ),
              title: Text(
                eachUser.nickname,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "joined " +
                    DateFormat("dd MMMM, yyyy - hh:mm:aa").format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(eachUser.createdAt),
                      ),
                    ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  sendUserToChatPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
            receiverId: eachUser.id,
            receiverAvatar: eachUser.photoUrl,
            receiverName: eachUser.nickname),
      ),
    );
  }
}
