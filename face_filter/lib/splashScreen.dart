import 'package:face_filter/cameraWithMaskFilterScreen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      loaderColor: Colors.red,
      navigateAfterSeconds: CameraWithMaskFilter() ,
      seconds: 3,
      title: Text(
        "AR face filter",
        style: TextStyle(
          color: Colors.deepPurpleAccent,
          fontSize: 55,
          fontFamily: "Signatra",
        ),
      ),
      backgroundColor: Colors.deepPurple,
      loadingText: Text(
        "namancOder",
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontFamily: "Brand Bold"),
      ),
    );
  }
}
