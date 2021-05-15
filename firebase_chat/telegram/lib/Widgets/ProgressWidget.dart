import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    // child:CircularProgressIndicator.adaptive(),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.redAccent),
    ),
  );
}

linearProgress() {return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    // child:CircularProgressIndicator.adaptive(),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.redAccent),
    ),
  );}
