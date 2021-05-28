import 'package:flutter/material.dart';

class Emoji extends StatelessWidget {
  final String num;

  Emoji({@required this.num});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "images/mimi$num.gif",
      width: 50.0,
      height: 50.0,
      fit: BoxFit.cover,
    );
  }
}
