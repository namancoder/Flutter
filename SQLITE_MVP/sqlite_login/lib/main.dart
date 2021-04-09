import 'package:flutter/material.dart';
import 'package:sqlite_login/pages/home_page.dart';

import 'pages/login/login_page.dart';


void main() => runApp(new MyApp());


final routes = {
  '/login': (BuildContext context)=> new LoginPage(),
  '/home': (BuildContext context)=> new HomePage(),
   '/': (BuildContext context)=> new LoginPage(),
};
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : "SQFLITE APP",
      theme: ThemeData(primarySwatch: Colors.lime),
      routes: routes,

    );
  }
}
