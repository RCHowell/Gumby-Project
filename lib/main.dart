import 'package:flutter/material.dart';
import 'package:gumby_project/views/home_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Project Gumby',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.purple,
        primaryColor: Colors.lightBlue[900],
        primaryColorDark: Colors.lightBlue[600],
        accentColor: Colors.redAccent,
        highlightColor: Colors.red[100],
//        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      home: HomeView(),
    );
}
