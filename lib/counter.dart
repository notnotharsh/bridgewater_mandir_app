import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';

import 'useful.dart';

class Counter extends StatefulWidget {
  Counter({Key key}) : super(key: key);
  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<Counter> {
  GlobalKey scaffold = GlobalKey();
  Map<String, dynamic> localIDs;
  Future<void> downloadIfAble() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    bool wifi = connectivity == ConnectivityResult.wifi;
    String localJSONString = await readText('ids', 'titles.json');
    var localJSON = jsonDecode(localJSONString);
    if (wifi) {
      String globalJSONString = await makeGetRequest('https://api.myjson.com/bins/iobco');
      var globalJSON = jsonDecode(globalJSONString);
      var mergedJSON;
      if (localJSON == null) {
        writeText('ids', 'titles.json', globalJSONString, false);
        localIDs = globalJSON;
      } else {
        mergedJSON = mergeMaps(localJSON, globalJSON);
        localIDs = mergedJSON;
        String mergedJSONString = jsonEncode(mergedJSON);
        writeText('ids', 'titles.json', mergedJSONString, false);
        makePutRequest('https://api.myjson.com/bins/iobco', mergedJSONString);
      }
      Flushbar(
          title:  'Connected to Wi-Fi',
          message:  'Updating ID map',
          duration:  Duration(seconds: 2),
          icon: IconTheme(data: IconThemeData(color: Color(0xFF209020)), child: Icon(Icons.check_circle))
      ).show(scaffold.currentContext);
    } else {
      if (localJSON == null) {
        String localJSONBackupString = await rootBundle.loadString('assets/backup_base.json');
        var localJSONBackup = jsonDecode(localJSONBackupString);
        localIDs = localJSONBackup;
        writeText('ids', 'titles.json', localJSONBackupString, false);
      } else {
        writeText('ids', 'titles.json', localJSONString, false);
        localIDs = localJSON;
      }
      Flushbar(
          title:  'Not connected to Wi-Fi',
          message:  'Will update ID map later',
          duration:  Duration(seconds: 2),
          icon: IconTheme(data: IconThemeData(color: Color(0xFF902020)), child: Icon(Icons.error))
      ).show(scaffold.currentContext);
    }
  }
  void initState() {
    downloadIfAble();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      backgroundColor: Colors.transparent,
    );
  }}