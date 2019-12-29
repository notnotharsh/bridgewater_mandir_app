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
  var localIDs;
  static List<dynamic> titles = <dynamic>['NOT FOUND'];
  Icon switcher = Icon(Icons.add);
  bool dropdownVisible = true;
  bool textFieldVisible = false;
  String ID;
  String title = titles[0];
  String altTitle;
  String qty;
  TextEditingController IDController = TextEditingController();
  TextEditingController altTitleController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) is int;
  }
  bool isIntegral(num x) => x is int || x.truncateToDouble() == x;
  Future<void> downloadIfAble() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    bool allowMobile = (await readText('logs', 'mobile.txt')) == 'true';
    if (allowMobile == null) {
      allowMobile = false;
    }
    bool wifi = ((connectivity == ConnectivityResult.wifi) || ((connectivity == ConnectivityResult.mobile) && (allowMobile)));
    String localJSONString = await readText('docs', 'titles.json');
    if (localJSONString == '') {
      localJSONString = '{}';
    }
    var localJSON = jsonDecode(localJSONString);
    if (wifi) {
      String globalJSONString = await makeGetRequest('https://api.myjson.com/bins/iobco');
      var globalJSON = jsonDecode(globalJSONString);
      if (localJSON == null) {
        writeText('docs', 'titles.json', globalJSONString, false);
        localIDs = globalJSON;
      } else {
        localIDs = mergeMaps(localJSON, globalJSON);
        String localIDString = jsonEncode(localIDs);
        writeText('docs', 'titles.json', localIDString, false);
        makePutRequest('https://api.myjson.com/bins/iobco', localIDString);
      }
      Flushbar(
          title:  'Acceptable connection confirmed',
          message:  'Updating ID map',
          duration:  Duration(seconds: 2),
          icon: IconTheme(data: IconThemeData(color: Color(0xFF209020)), child: Icon(Icons.check_circle))
      ).show(scaffold.currentContext);
    } else {
      if ((localJSON == null) || (localJSON.length == 0)) {
        String localJSONBackupString = await rootBundle.loadString('assets/backup_base.json');
        var localJSONBackup = jsonDecode(localJSONBackupString);
        localIDs = localJSONBackup;
        writeText('docs', 'titles.json', localJSONBackupString, false);
      } else {
        localIDs = localJSON;
      }
      Flushbar(
          title:  'No acceptable connection confirmed',
          message:  'Will update ID map later',
          duration:  Duration(seconds: 2),
          icon: IconTheme(data: IconThemeData(color: Color(0xFF902020)), child: Icon(Icons.error))
      ).show(scaffold.currentContext);
    }
  }
  void reset() {
    setState(() {
      IDController.clear();
      altTitleController.clear();
      qtyController.clear();
      ID = '';
      altTitle = '';
      qty = '';
      titles = ['NOT FOUND'];
      title = titles[0];
    });
  }
  Future<void> submitDialog() async {
    return showDialog<void>(
      context: scaffold.currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit data?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This information will be entered into the local inventory file. Are you sure it is correct?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(scaffold.currentContext).pop();
                if ((((ID == null) || (ID == '')) || ((qty == null) || (qty == ''))) || (((title == 'NOT FOUND') && (dropdownVisible)) || ((((altTitle == null) || (altTitle.replaceAll(new RegExp(r' '), '').length == 0)) || (altTitle == '')) && (textFieldVisible)))) {
                  Flushbar(
                      title:  'Submit unsuccessful',
                      message:  'Please fill out all required fields before submitting',
                      duration:  Duration(seconds: 2),
                      icon: IconTheme(data: IconThemeData(color: Color(0xFF902020)), child: Icon(Icons.error))
                  ).show(scaffold.currentContext);
                } else if ((isNumeric(qty)) && (int.parse(qty) > 0)) {
                  submit();
                } else {
                  Flushbar(
                      title:  'Submit unsuccessful',
                      message:  'Please enter a valid quantity',
                      duration:  Duration(seconds: 2),
                      icon: IconTheme(data: IconThemeData(color: Color(0xFF902020)), child: Icon(Icons.error))
                  ).show(scaffold.currentContext);
                }
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
  void submit() async {
    String titleToRecord;
    if (textFieldVisible) {
      titleToRecord = altTitle;
      print(localIDs[ID]);
      if ((localIDs.containsKey(ID)) && !(localIDs[ID].contains(titleToRecord))) {
        localIDs[ID].add(titleToRecord);
      } else if (!(localIDs.containsKey(ID))) {
        localIDs.addAll({ID: [titleToRecord]});
      }
      String localIDString = json.encode(localIDs);
      writeText('docs', 'titles.json', localIDString, false);
    } else {
      titleToRecord = title;
    }
    String localINVString = await readText('docs', 'local_inv.json');
    if (localINVString == '') {
      localINVString = '{}';
    }
    var localINV = jsonDecode(localINVString);
    if ((localINV == null) || (localINV.length == 0)) {
      localINV = {ID: {titleToRecord: qty}};
    } else {
      if (localINV.containsKey(ID)) {
        if (localINV[ID].containsKey(titleToRecord)) {
          String already = localINV[ID][titleToRecord];
          String newQTY = (int.parse(qty) + int.parse(already)).toString();
          localINV[ID][titleToRecord] = newQTY;
        } else {
          localINV[ID].addAll({titleToRecord: qty});
        }
      } else {
        localINV.addAll({ID: {titleToRecord: qty}});
      }
    }
    String newLocalINVString = jsonEncode(localINV);
    writeText('docs', 'local_inv.json', newLocalINVString, false);
    Flushbar(
        title:  'Submit successful',
        message:  'Information saved to local inventory',
        duration:  Duration(seconds: 2),
        icon: IconTheme(data: IconThemeData(color: Color(0xFF209020)), child: Icon(Icons.check_circle))
    ).show(scaffold.currentContext);
    reset();
  }
  void initState() {
    ID = '';
    titles = ['NOT FOUND'];
    title = 'NOT FOUND';
    downloadIfAble();
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
                TextField(
                    controller: IDController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ID'
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        ID = newValue;
                        titles = localIDs[ID];
                        if (titles == null) {
                          titles = ['NOT FOUND'];
                        }
                        title = titles[0];
                      });
                    },
                    keyboardType: TextInputType.number
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Visibility(
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: title,
                                onChanged: (String newValue) {
                                  setState(() {
                                    title = newValue;
                                  });
                                },
                                items: titles.cast<String>().toList().map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          ),
                          visible: dropdownVisible,
                        ),
                        Container(
                          child: Visibility(
                            child: TextField(
                                controller: altTitleController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Title'
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    altTitle = newValue;
                                  });
                                },
                            ),
                            visible: textFieldVisible,
                          ),
                          width: 100,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: switcher,
                      onPressed: () {
                        setState(() {
                          if (switcher.icon == Icons.add) {
                            switcher = Icon(Icons.close);
                            dropdownVisible = false;
                            textFieldVisible = true;
                          } else {
                            switcher = Icon(Icons.add);
                            dropdownVisible = true;
                            textFieldVisible = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                    textAlign: TextAlign.center,
                    controller: qtyController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Quantity'
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        qty = newValue;
                      });
                    },
                    keyboardType: TextInputType.number
                ),
                Container(
                  width: 100,
                  child: FlatButton(
                    child: Text('Submit'),
                    color: Color(0xFF202030),
                    onPressed: submitDialog,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}