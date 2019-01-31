import 'package:flutter/material.dart';
import 'package:gumby_project/components/route_list_tile.dart';
import 'package:gumby_project/presenters/recent_routes_view_presenter.dart';
import 'package:gumby_project/models/route.dart' as GP;
import 'package:gumby_project/views/route_view.dart';

class RecentRoutesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecentRoutesViewState();
}

class _RecentRoutesViewState extends State<RecentRoutesView>
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Latest Routes'),
      ),
      body: (_loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemBuilder: (_, i) {
                if (i == _routes.length) return Container();
                return RouteListTile(_routes[i], () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RouteView(_routes[i])));
                });
              },
              separatorBuilder: (_, i) => Divider(height: 2.0),
              itemCount: _routes.length + 1,
            ),
    );
  }
}
