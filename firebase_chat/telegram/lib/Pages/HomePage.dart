import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telegramchatapp/Models/chat_model.dart';
import 'package:telegramchatapp/Pages/ChattingPage.dart';
import 'package:telegramchatapp/main.dart';
import 'package:telegramchatapp/models/user.dart';
import 'package:telegramchatapp/Pages/AccountSettingsPage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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
  //TabController tb ;
  //  void initState() {
  //   tb =
  //       TabController(length: 3, vsync: this, initialIndex: 0);
  //   super.initState();
  // }

  homePageHeader() {
    return AppBar(
      //toolbarHeight: 90.0,
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
            })
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
              borderSide: BorderSide(color: Colors.white),
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

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      //width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
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
      // appBar: buildFloatingSearchBar(),

      body: futureSearchResults == null ||
              searchTextEditingController.value == null
          ? displayNoSearchResultScreen()
          : displayUserFoundScreen(),

    
    );
  }

  displayNoSearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
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
                color: Colors.deepOrange[900],
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
          UserResult userResult = UserResult(eachUser);

          if (currentUserId != document["id"]) {
            searchUserResult.add(userResult);
          }
          //return ListView(children: searchUserResult);
        });
        return ListView(children: searchUserResult);
      },
    );
  }

  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // Future<Null> logoutUser() async {
  //   await FirebaseAuth.instance.signOut();
  //   await googleSignIn.disconnect();
  //   await googleSignIn.signOut();

  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  // }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);
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
