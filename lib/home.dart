import 'package:flutter/material.dart';

import 'instructions.dart';
import 'counter.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            tabs: [
              Tab(text: "Instructions"),
              Tab(text: "Counter"),
              Tab(text: "Settings")
            ],
          ),
          title: Text('Gift Shop Volunteer App'),
        ),
        body: TabBarView(
          children: [
            Instructions(),
            Counter(),
            Settings()
          ],
        ),
      ),
    );
  }
}