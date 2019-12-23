import 'package:flutter/material.dart';

class Instructions extends StatefulWidget {
  Instructions({Key key}) : super(key: key);
  @override
  InstructionsState createState() => InstructionsState();
}

class InstructionsState extends State<Instructions> {
  static List<String> instructions = ['1', '2', '3'];
  String text = instructions[0];
  int a = 0;
  void nextPage() {
    setState(() {
      text = instructions[(a + 1) % instructions.length];
      a++;
    });
  }
  void prevPage() {
    setState(() {
      text = instructions[(a - 1) % instructions.length];
      a = (a - 1) % instructions.length;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0), child: Center(child: Text(text, textAlign: TextAlign.center))))
        ]
      ),
      floatingActionButton:
        FloatingActionButton(
            onPressed: nextPage,
            tooltip: 'Next Page',
            child: IconTheme(data: IconThemeData(color: Color(0xFF202040)), child: Icon(Icons.arrow_forward_ios))
        ),
    );
  }
}