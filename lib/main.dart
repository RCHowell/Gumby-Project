import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gumby_project/views/home_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  // Configure Firebase
  if (FirebaseApp.instance == null) {
    await FirebaseApp.configure(
      name: 'gumby-project',
      options: FirebaseOptions(
        googleAppID: Platform.isIOS
            ? '1:279870594027:ios:ddef786c77d9cb08'
            : '1:279870594027:android:ddef786c77d9cb08',
        gcmSenderID: '279870594027',
        apiKey: 'AIzaSyCkzzRouaRRXBO1am8uNt-jRcDLB14oTCY',
        projectID: 'gumby-project',
      ),
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Gumby Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.blue,
        primaryColor: Colors.lightBlue[900],
        primaryColorDark: Colors.lightBlue[600],
        accentColor: Colors.redAccent,
        highlightColor: Colors.lightBlue,
      ),
      home: HomeView(),
    );
}
