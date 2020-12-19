import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'new_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData.dark(),
        home: new HomePage(),
        routes: <String, WidgetBuilder>{
          "/a": (BuildContext context) => NewPage("NEw Page 1"),
        });
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get color => null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            "Drawer App",
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Naman Gupta"),
              accountEmail: Text("12345@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1579635480803-b990e007f508?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80')),
            ),
            ListTile(
              title: Text("OnE"),
              trailing: Icon(Icons.dangerous),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/a");
              },
            ),
            ListTile(
                title: Text("Navigate With Animation"),
                trailing: Icon(Icons.dangerous),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        NewPage("Page 1 one ek")))),
            ListTile(
              title: Text("TwO"),
              trailing: Icon(Icons.alarm_off),
              onTap: () => exit(0),
            ),
            Divider(),
            ListTile(
              title: Text("CLOSE"),
              trailing: Icon(Icons.close_sharp),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: new Text("hi my name is naman"),
        ),
      ),
    );
  }
}
