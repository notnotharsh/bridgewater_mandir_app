import 'package:flutter/material.dart';

import 'useful.dart';

class Upload extends StatefulWidget {
  Upload({Key key}) : super(key: key);
  @override
  UploadState createState() => UploadState();
}

class UploadState extends State<Upload> {
  GlobalKey scaffold = GlobalKey();
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      backgroundColor: Colors.transparent,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[],
            ),
          ],
        ),
      ),
    );
  }
}