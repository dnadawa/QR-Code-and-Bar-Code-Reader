import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappgo/screens/add-product.dart';
import 'package:snappgo/screens/home.dart';
import 'package:snappgo/screens/product.dart';
import 'package:snappgo/screens/sign-in.dart';
import 'package:snappgo/screens/sign-up.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
       textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
    ),
      ),
      home: SignIn(),
    );
  }
}
