import 'package:flutter/material.dart';
import 'dart:convert' show jsonDecode;

void main() => runApp(new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JSON PARSING LOCAL"),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
              future: DefaultAssetBundle.of(context)
                  .loadString('load_json/person.json'),
              builder: (context, snapshot) {
                //For Decoding Local Json
                var mydata = jsonDecode(snapshot.data.toString());
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Text("Name :" + mydata[index]['name']),
                          new Text("Age :" + mydata[index]['age']),
                          new Text("Gender :" + mydata[index]['gender']),
                          new Text("Skill :" + mydata[index]['skill']),
                        ],
                      ),
                    );
                  },
                  itemCount: mydata == null ? 0 : mydata.length,
                );
              }),
        ),
      ),
    );
  }
}
