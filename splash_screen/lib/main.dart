import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange, accentColor: Colors.greenAccent),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double age = 0.0;
  var selectedYear;

  Animation animation;
  AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1500));
    animation = animationController;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  void _showPicker() {
    showDatePicker(
            context: context,
            initialDate: new DateTime(2010),
            firstDate: new DateTime(1900),
            lastDate: DateTime.now())
        .then((DateTime dt) {
      setState(() {
        selectedYear = dt.year;
        calculateAge();
      });
    });
  }

  void calculateAge() {
    setState(() {
      age = (2020 - selectedYear).toDouble();
      animation = new Tween<double>(begin: animation.value, end: age).animate(
          new CurvedAnimation(
              curve: Curves.fastOutSlowIn, parent: animationController));
      animation.addListener(() {
        setState(() {});
      });
      animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Age Calculator"),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new OutlineButton(
              child: new Text(selectedYear != null
                  ? selectedYear.toString()
                  : "Enter your Year of Birth"),
              borderSide:
                  new BorderSide(color: Colors.tealAccent[400], width: 4.0),
              color: Colors.blue,
              onPressed: _showPicker,
            ),
            new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            new Text(
              "Your age is ${animation.value.toStringAsFixed(0)}",
              style: new TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.deepOrange[300]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40,
                                color: Colors.white,
                                spreadRadius: 5)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.military_tech_sharp,
                            size: 50.0,
                            color: Colors.blue[500],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Text(
                        "CALCULATOR",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text("Lets know your Age 😉",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
