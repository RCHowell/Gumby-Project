import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gumby_project/components/hero_photo_view_wrapper.dart';
import 'package:gumby_project/components/my_title.dart';
import 'package:gumby_project/components/route_list_tile.dart';
import 'package:gumby_project/models/sector.dart';
import 'package:gumby_project/models/route.dart' as gp_route;
import 'package:gumby_project/presenters/sector_presenter.dart';
import 'package:gumby_project/views/route_view.dart';

class SectorView extends StatefulWidget {

  final Sector _sector;

  SectorView(this._sector);

  @override
  State createState() => _SectorViewState();

}

class _SectorViewState extends State<SectorView> implements SectorViewContract {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SectorPresenter _presenter;
  List<gp_route.Route> _routes;

  @override
  void initState() {
    _presenter = SectorPresenter(this);
    _routes = List();
    _presenter.getRoutesForSector(widget._sector.id);
    super.initState();
  }


  @override
  void onGetRoutesComplete(List<gp_route.Route> routes) {
    setState(() {
      _routes = routes;
    });
  }

  @override
  void onGetRoutesError(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(error.toString()),
    ));
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> children = [
      LargeSectorImage(widget._sector.imageUrl),
      MyTitle('Routes (By Most Recent)'),
      Divider(height: 2.0),
    ];

    if (_routes.length == 0) {
      children.add(Container(
        height: 200.0,
        child: Center(
          child: Text('No routes yet'),
        ),
      ));
    } else {
      _routes.forEach((gp_route.Route r) {
        children.add(RouteListTile(r, () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => RouteView(r),
          ));
        }));
        children.add(Divider(height: 2.0));
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget._sector.name,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: children,
      ),
    );
  }


}

class LargeSectorImage extends StatelessWidget {

  final String url;
  final double height = 140.0;

  LargeSectorImage(this.url);

  @override
  Widget build(BuildContext context) {

    CachedNetworkImage img = CachedNetworkImage(
      imageUrl: url,
      placeholder: Container(
        height: height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: Icon(Icons.error),
      fit: BoxFit.cover,
      height: height,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeroPhotoViewWrapper(
                imageProvider: CachedNetworkImageProvider(url),
                tag: url,
              ),
            ));
      },
      child: Container(
        height: 150.0,
        child: Hero(
          tag: url,
          child: img,
        ),
      ),
    );
  }


}