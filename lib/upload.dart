import 'dart:convert';
import 'dart:io';

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
  static List<dynamic> sheets = <dynamic>['App'];
  String sheet = sheets[0];
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
  void initState() {
    setTitles();
    super.initState();
  }
  void setTitles() async {
    String sheetsString = await makeGetRequest('https://jsonbin.org/notnotharsh/sheets', 'a57f6f6c-08aa-4ca1-ba65-17c19015734f');
    var sheetsMap = jsonDecode(sheetsString);
    sheets = sheetsMap['sheets'];
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
                Text('You will be uploading and emptying the local inventory file. Are you sure it is correct?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(scaffold.currentContext).pop();
                submit();
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
    try {
      String data = await readText('docs', 'local_inv.json');
      String url = 'https://docs.google.com/forms/d/e/1FAIpQLScgUpCf6tYYjwyrvUV_aCWjz78exmaLE_OSnpFbKpkuT3s12g/formResponse?usp=pp_url&entry.958111828=$sheet&entry.2127219464=$data&submit=Submit';
      makeGetRequest(url, 'a57f6f6c-08aa-4ca1-ba65-17c19015734f');
      writeText('docs', 'local_inv.json', '', false);
      Flushbar(
          title:  'Submit successful',
          message:  'Local inventory sent to spreadsheet',
          duration:  Duration(seconds: 2),
          icon: IconTheme(data: IconThemeData(color: Color(0xFF209020)), child: Icon(Icons.check_circle))
      ).show(scaffold.currentContext);
    } on Exception {
      Flushbar(
          title:  'Submit unsuccessful',
          message:  'Invalid request',
          duration:  Duration(seconds: 2),
          icon: IconTheme(data: IconThemeData(color: Color(0xFF902020)), child: Icon(Icons.error))
      ).show(scaffold.currentContext);
    }
    sheet = sheets[0];
  }
  Widget build(BuildContext context) {
    determineConnection();
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
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        child: Text('Select sheet: '),
                        padding: EdgeInsets.only(left: 8, right: 8, top: 2),
                      ),
                      DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: sheet,
                            onChanged: (String newValue) {
                              setState(() {
                                sheet = newValue;
                              });
                            },
                            items: sheets.cast<String>().toList().map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                      ),
                    ],
                  ),
                  FlatButton(
                    child: Text('Submit'),
                    color: Color(0xFF202030),
                    onPressed: submitDialog,
                  ),
                ],
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
                  Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0), child: Center(child: Text('Sorry, but you cannot upload data at this time, as you are either connected to a mobile network and haven\'t allowed operations on this app over mobile data (you can do this in Settings) or you are just not connected to the internet.', textAlign: TextAlign.center)))
                ],
              ),
            ],
          ),
        ),
      );
    }

  }
}