import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      //primaryColor: Colors.blue,
      primarySwatch: Colors.blue,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String todoTitle = "";
  //List todos = List();

  createTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);
    Map<String, String> todos = {"todoTitle": todoTitle};
    documentReference.set(todos).whenComplete(() {
      print("$todoTitle printed");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);

    documentReference.delete();
  }

  @override
  // void initState() {
  //   super.initState();
  //   todos.add("Item1");
  //   todos.add("Item2");
  //   todos.add("Item3");
  //   todos.add("Item4");
  // }

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
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
        backgroundColor: Colors.white,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Aaj ka kaam?"),
                  content: TextField(onChanged: (String value) {
                    todoTitle = value;
                  }),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        createTodos();
                        Navigator.of(context).pop();
                      },
                      child: Text("add"),
                    ),
                  ],
                );
              });
        },
        child: Icon(
          Icons.plus_one,
          color: Colors.black38,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshots) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data.documents[index];
                  return Dismissible(
                    onDismissed: (direction) {
                      deleteTodos(documentSnapshot["todoTitle"]);
                    },
                    key: Key(documentSnapshot["todoTitle"]),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(documentSnapshot["todoTitle"]),
                        trailing: IconButton(
                          onPressed: () {
                            // setState(() {
                            //   todos.removeAt(index);
                            // });
                            deleteTodos(documentSnapshot["todoTitle"]);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
