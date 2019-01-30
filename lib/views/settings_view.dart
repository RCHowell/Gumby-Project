import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gumby_project/whois.dart' as User;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SettingsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsViewState();

}

class _SettingsViewState extends State<SettingsView> {

  String _name;

  @override
  void initState() {
    _name = User.whois;
    super.initState();
  }


  void _saveName(BuildContext context) async {
    final docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, "whois");
    File(path).writeAsStringSync(_name);
    User.whois = _name;
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Username'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Don't abuse this..."),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Current name is "$_name"',
              ),
              maxLength: 30,
              onChanged: (String name) {
                _name = name;
              },
            ),
          ),
          FlatButton(
            child: Text('Save'),
            color: Theme
                .of(context)
                .primaryColor,
            textColor: Colors.white,
            onPressed: () => _saveName(context),
          ),
        ],
      ),
    );
  }

}