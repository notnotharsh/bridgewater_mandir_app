import 'package:flutter/material.dart';

class Instructions extends StatefulWidget {
  Instructions({Key key}) : super(key: key);
  @override
  InstructionsState createState() => InstructionsState();
}

class InstructionsState extends State<Instructions> {
  static final List<String> instructions = [
    'Counting Items',
    'On the Counter screen, there are a few fields that need to be filled out. First, put the ID of the item in the top box. Then, the dropdown below should contain a list of titles for said item. Select the right one.',
    'If there isn\'t a right one, you can select the plus icon next to it to create an empty text field in which the item title actually goes. If this was a mistake and you want to go back to the dropdown, select the X to the right of the text field.',
    'Once you have decided the title of the item from either the dropdown menu or the text field, please enter the correct quantity of items in the quantity box.',
    'Once you are done with the above steps, please press the submit button. This action will save the item you just counted to the local inventory.',
    'Note that you can choose to reset the inventory at any time you want by going to the Settings screen.',
    'Uploading',
    'If you have a valid internet connection (Wi-Fi or mobile data should you allow it in the Settings screen), you should be able to access the Upload screen.',
    'Please duplicate the Template sheet on the Google spreadsheet associated with the app (at bit.ly/mandirgiftshopsheet) prior to uploading data.',
    'After doing this, you can choose the sheet you just created, and the data from your local inventory should upload to that sheet.'
  ];
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