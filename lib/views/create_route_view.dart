import 'package:flutter/material.dart';
import 'package:gumby_project/components/image_upload.dart';
import 'package:gumby_project/models/route.dart' as GP;
import 'package:gumby_project/repos/route_repo.dart';
import 'package:gumby_project/whois.dart' as Whois;

class CreateRouteView extends StatefulWidget {
  final String sector;

  CreateRouteView(this.sector);

  @override
  State<StatefulWidget> createState() => _CreateRouteViewState();
}

class _CreateRouteViewState extends State<CreateRouteView> {
  final EdgeInsets textInputMargin = const EdgeInsets.all(12.0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RouteRepo _repo;
  bool _loading;

  // state variables for route information
  String routeName;
  String routeGrade;
  String routeDescription;
  String routeImageUrl;

  // state variables for input validation
  bool _imageUploaded;

  @override
  void initState() {
    _imageUploaded = false;
    _repo = RouteRepo();
    _loading = false;
    super.initState();
  }

  void onSavedRouteError(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(error.toString()),
    ));
  }

  void onSavedRouteComplete(String reply) {
    Navigator.of(context).pop();
  }

  bool _invalid() {
    return (_imageUploaded == false ||
        routeName == null ||
        routeGrade == null ||
        routeDescription == null);
  }

  void _saveRoute() {
    if (_invalid()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill out all fields'),
      ));
    } else {
      GP.Route route = GP.Route(
        name: routeName,
        setter: Whois.whois,
        createdAt: DateTime.now(),
        grade: routeGrade,
        rating: [0],
        description: routeDescription,
        imageUrl: routeImageUrl,
        sector: widget.sector,
      );
      _repo
          .saveRoute(route)
          .then(onSavedRouteComplete)
          .catchError(onSavedRouteError);
      setState(() {
        _loading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Route'),
      ),
      body: (_loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: textInputMargin,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Route Name',
                            hintText: 'Zen and the Art of Masturbation',
                          ),
                          maxLength: 50,
                          onChanged: (String name) => routeName = name,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        margin: textInputMargin,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Grade',
                            hintText: 'V4',
                          ),
                          maxLength: 5,
                          onChanged: (String grade) => routeGrade = grade,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Container(
                  margin: textInputMargin,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'V9 in your gym.',
                    ),
                    maxLength: 500,
                    onChanged: (String description) =>
                        routeDescription = description,
                  ),
                ),
                Expanded(
                  child: ImageUpload(
                    onComplete: (String imageUrl) {
                      _imageUploaded = true;
                      routeImageUrl = imageUrl;
                    },
                    onError: (String message) {},
                  ),
                ),
              ],
            ),
      floatingActionButton: (!_loading)
          ? FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: _saveRoute,
            )
          : null,
    );
  }
}
