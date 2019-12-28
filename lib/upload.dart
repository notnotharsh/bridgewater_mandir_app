import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';

import 'useful.dart';

class Upload extends StatefulWidget {
  Upload({Key key}) : super(key: key);
  @override
  UploadState createState() => UploadState();
}

class UploadState extends State<Upload> {
  GlobalKey scaffold = GlobalKey();
  static List<dynamic> sheets = <dynamic>['Spare'];
  bool wifi = false;
  void determineConnection() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    bool allowMobile = (await readText('logs', 'mobile.txt')) == 'true';
    if (allowMobile == null) {
      allowMobile = false;
    }
    setState(() {
      wifi = ((connectivity == ConnectivityResult.wifi) || ((connectivity == ConnectivityResult.mobile) && (allowMobile)));
    });
  }
  Widget build(BuildContext context) {
    if (wifi) {
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
    } else {
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
                children: <Widget>[
                  Expanded(child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0), child: Center(child: Text('Sorry, but you cannot upload data at this time, as you are either connected to a mobile network and haven\'t allowed operations on this app over mobile data (you can do this in Settings) or you are just not connected to the internet.', textAlign: TextAlign.center))))
                ],
              ),
            ],
          ),
        ),
      );
    }

  }
}