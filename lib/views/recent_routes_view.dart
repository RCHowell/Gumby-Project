import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:gumby_project/components/route_list_tile.dart';
import 'package:gumby_project/models/route.dart' as GP;
import 'package:gumby_project/presenters/recent_routes_view_presenter.dart';
import 'package:gumby_project/views/create_route_view.dart';
import 'package:gumby_project/views/route_view.dart';
import 'package:gumby_project/views/settings_view.dart';

class RecentRoutesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecentRoutesViewState();
}

class _RecentRoutesViewState extends State<RecentRoutesView>
    with AfterLayoutMixin<RecentRoutesView>
    implements RecentRouteViewContract {

  RecentRouteViewPresenter _presenter;
  List<GP.Route> _routes;
  bool _loading;

  @override
  void initState() {
    _loading = true;
    _routes = List();
    _presenter = RecentRouteViewPresenter(this);
    _presenter.getLatestRoutes();
    super.initState();
  }

  @override
  void onGetLatestRoutesComplete(List<GP.Route> routes) {
    setState(() {
      _loading = false;
      _routes = routes;
    });
  }

  @override
  void onWriteWhoIsComplete() {
    Navigator.of(context).pop();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    _presenter.checkWhoIs();
  }

  @override
  void promptForWhoIs() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => whoIsDialog(),
    );
  }

  void _goToSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => SettingsView(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gumby Project'),
        leading: IconButton(
          icon: Icon(Icons.perm_identity, color: Colors.white),
          onPressed: () {
            _goToSettings(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (_) => CreateRouteView('A'),
                fullscreenDialog: true,
              ))
                  .then(
                      (_) => _presenter.getLatestRoutes());
            },
          ),
        ],

      ),
      body: RefreshIndicator(
        child: (_loading)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.separated(
          itemBuilder: (_, i) {
            if (i == _routes.length) return Container();
            return RouteListTile(_routes[i], () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                  builder: (_) => RouteView(_routes[i])))
                  .then((_) => _presenter.getLatestRoutes());
            });
          },
          separatorBuilder: (_, i) => Divider(height: 2.0),
          itemCount: _routes.length + 1,
        ),
        onRefresh: () {
          setState(() {
            _loading = true;
          });
          _presenter.getLatestRoutes();
          return Future.value(null);
        },
      ),
    );
  }

  Widget whoIsDialog() {
    String whoInput;

    // to be shown when writing text
    bool loading = false;
    if (loading)
      return AlertDialog(
        content: CircularProgressIndicator(),
      );

    return AlertDialog(
      title: Text('New phone. Who dis?'),
      content: TextField(
        onChanged: (String input) {
          whoInput = input;
        },
        maxLength: 30,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            loading = true;
            _presenter.setWhoIs(whoInput);
          },
          child: Text('Save'),
          textColor: Theme
              .of(context)
              .highlightColor,
        ),
      ],
    );
  }
}
