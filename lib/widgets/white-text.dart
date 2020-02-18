import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {

  final String text;
  final double size;

  const WhiteText({Key key, this.text, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size
      ),



    );
  }
}