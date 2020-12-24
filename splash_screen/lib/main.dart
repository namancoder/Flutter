import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.amber),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Center(
            child: Text("Drawer App",
                style: TextStyle(shadows: <Shadow>[
                  Shadow(
                    offset: Offset(10.0, 10.0),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                ], fontWeight: FontWeight.w500))),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : .0,
      ),
    );
  }
}
