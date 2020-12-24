import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List todos = List();
  String input = "";
  @override
  void initState() {
    super.initState();
    todos.add("Item1");
    todos.add("Item2");
    todos.add("Item3");
    todos.add("Item4");
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new PreferredSize(
        child: new Container(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: new Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
            child: new Text(
              'TODO APP',
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          decoration: new BoxDecoration(
              gradient: new LinearGradient(colors: [Colors.red, Colors.yellow]),
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey[500],
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                )
              ]),
        ),
        preferredSize: new Size(MediaQuery.of(context).size.width, 150.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Aaj ka kaam?"),
                  content: TextField(onChanged: (String value) {
                    input = value;
                  }),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          todos.add(input);
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("add"),
                    ),
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todos[index]),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                title: Text(todos[index]),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      todos.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
