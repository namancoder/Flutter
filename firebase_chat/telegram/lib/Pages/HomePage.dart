import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:telegramchatapp/Models/user.dart';

import 'package:telegramchatapp/models/user_list.dart';
import 'package:telegramchatapp/Pages/AccountSettingsPage.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeScreenState({Key key, @required this.currentUserId});
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  final String currentUserId;

  homePageHeader() {
    return AppBar(
      toolbarHeight: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          
          bottom: Radius.circular(30),
        ),
      ),
      elevation: 5,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.settings,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            }),
      ],
      backgroundColor: Colors.deepPurple,
      title: Container(
        margin: new EdgeInsets.only(bottom: 4.0),
        child: TextFormField(
          // readOnly: true,
          cursorColor: Colors.white,
          showCursor: false,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "Search Here...",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
            prefixIcon: Icon(Icons.person_pin_outlined,
                color: Colors.white, size: 30.0),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  searchTextEditingController.clear();
                  displayNoSearchResultScreen();
                });
              },
            ),
          ),
          onFieldSubmitted: controlSearching,
        ),
      ),
    );
  }

  controlSearching(String userName) {
    Future<QuerySnapshot> allFoundUsers = Firestore.instance
        .collection("users")
        .where("nickname", isGreaterThanOrEqualTo: userName)
        .getDocuments();

    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageHeader(),

      body: futureSearchResults == null ||
              searchTextEditingController.value == null
          ? displayNoSearchResultScreen()
          : displayUserFoundScreen(),
    );
  }

  displayNoSearchResultScreen() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group, color: Colors.purple[900], size: 200.0),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.purple[900],
                fontSize: 50.0,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      //initialData: InitialData,
      builder: (context, dataSnapshot) {
        // if (!dataSnapshot.hasData) {
        //   return circularProgress();
        // }

        List<UserResult> searchUserResult = [];
        dataSnapshot.data.documents.forEach((document) {
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser: eachUser);

          if (currentUserId != document["id"]) {
            searchUserResult.add(userResult);
          }
          //return ListView(children: searchUserResult);
        });
        return ListView(children: searchUserResult);
      },
    );
  }
}

// class UserResult extends StatelessWidget {
//   final User eachUser;
//   UserResult(this.eachUser);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         //decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
//         color: Colors.white,
//         child: Column(children: <Widget>[
//           GestureDetector(
//             onTap: () => sendUserToChatPage(context),
//             child: ListTile(
//               tileColor: Colors.yellow,
//               trailing: Icon(
//                 Icons.arrow_forward_ios,
//                 color: Colors.teal,
//               ),
//               leading: CircleAvatar(
//                 backgroundColor: Colors.black,
//                 backgroundImage: CachedNetworkImageProvider(eachUser.photoUrl),
//               ),
//               title: Text(
//                 eachUser.nickname,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 "joined " +
//                     DateFormat("dd MMMM, yyyy - hh:mm:aa").format(
//                       DateTime.fromMillisecondsSinceEpoch(
//                         int.parse(eachUser.createdAt),
//                       ),
//                     ),
//               ),
//             ),
//           )
//         ]),
//       ),
//     );
//   }

//   sendUserToChatPage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Chat(
//             receiverId: eachUser.id,
//             receiverAvatar: eachUser.photoUrl,
//             receiverName: eachUser.nickname),
//       ),
//     );
//   }
// }
