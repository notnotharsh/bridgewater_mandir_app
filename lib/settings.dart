import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

import 'useful.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  GlobalKey scaffold = GlobalKey();
  Future<void> resetInventoryDialog() async {
    return showDialog<void>(
      context: scaffold.currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset inventory?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('All data not uploaded will be erased. Are you sure you want to do this?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(scaffold.currentContext).pop();
                resetInventory();
              },
            ),
            // This is just the "no" option.
            // Leave it unchanged.
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(scaffold.currentContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void resetInventory() {
    writeText('docs', 'local_inv.json', '', false);
  }
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
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      child: Text('Reset local inventory?'),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    FlatButton(
                      child: Text('Reset'),
                      color: Color(0xFF202030),
                      onPressed: resetInventoryDialog,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}