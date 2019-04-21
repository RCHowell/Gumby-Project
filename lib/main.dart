import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gumby_project/views/recent_routes_view.dart';
import 'package:gumby_project/whois.dart' as Whois;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  Firestore(app: FirebaseApp.instance);

  await setWhoIs();

  runApp(MyApp());
}

Future<void> setWhoIs() async {
  final docDir = await getApplicationDocumentsDirectory();
  String path = join(docDir.path, "whois");
  // Only copy if the database doesn't exist
  if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
    Whois.whois = await File(path).readAsStringSync();
  }
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
    home: RecentRoutesView(),
    );
}
