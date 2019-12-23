import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'home.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MandirApp());
}

class MandirApp extends StatefulWidget {
  MandirApp({Key key}) : super(key: key);
  @override
  MandirAppState createState() => MandirAppState();
}

class MandirAppState extends State<MandirApp> {
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sri Venkateswara Mandir: Gift Shop Volunteer App',
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Color(0xFF202040),
            accentColor: Color(0xFFFFFFFF),
            backgroundColor: Colors.transparent,
            fontFamily: 'Raleway'
        ),
        home: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/ganesh.jpg'),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Home()
              )
            ]
        )
    );
  }
}