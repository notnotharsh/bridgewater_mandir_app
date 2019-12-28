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
  bool allowMobileData = false;
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
    Flushbar(
        title:  'Reset successful',
        message:  'Local inventory is now blank',
        duration:  Duration(seconds: 2),
        icon: IconTheme(data: IconThemeData(color: Color(0xFF209020)), child: Icon(Icons.check_circle))
    ).show(scaffold.currentContext);
  }
  void updateMobile() async {
    String result = await readText('logs', 'mobile.txt');
    setState(() {
      allowMobileData = result == 'true';
      if (allowMobileData == null) {
        allowMobileData = false;
      }
    });
    writeText('logs', 'mobile.txt', allowMobileData.toString(), false);
  }
  void initState() {
    updateMobile();
    super.initState();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      child: Text('Allow connections over mobile data?'),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Switch(
                      value: allowMobileData,
                      activeColor: Color(0xFFFFFFFF),
                      onChanged: (bool newValue) {
                        setState(() {
                          allowMobileData = newValue;
                          writeText('logs', 'mobile.txt', allowMobileData.toString(), false);
                        });
                      },
                    )
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