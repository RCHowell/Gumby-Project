import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gumby_project/components/hero_photo_view_wrapper.dart';
import 'package:gumby_project/models/sector.dart';
import 'package:gumby_project/views/sector_view.dart';

class SectorTile extends StatelessWidget {
  final Sector _sector;
  final Function _voteMethod;
  final double _imgHeight = 100.0;
  final double _imgWidth = 100.0;
  SectorTile(this._sector, this._voteMethod);

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);


    return Container(
      height: 120.0,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image(context),
          Expanded(
            child: ListTile(
              title: Text(
                _sector.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  height: 1.4,
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('KEEP'),
                    onPressed: () {
                      _voteMethod(_sector.id, 1);
                    },
                    color: theme.primaryColor,
                    textColor: Colors.white,
                  ),
                  RaisedButton(
                    child: Text('RESET'),
                    onPressed: () {
                      _voteMethod(_sector.id, -1);
                    },
                    color: theme.accentColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {


    CachedNetworkImage img = CachedNetworkImage(
      imageUrl: _sector.thumbnailUrl,
      placeholder: (BuildContext ctx, String url) => Container(
        height: _imgHeight,
        width: _imgWidth,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (ctx, url, error) => Icon(Icons.error),
      fit: BoxFit.cover,
      height: _imgHeight,
      width: _imgWidth,
    );


    return Container(
      height: _imgHeight,
      margin: const EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          Hero(
            tag: _sector.imageUrl,
            child: img,
          ),
          InkWell(
            child: Container(
              height: _imgHeight,
              width: _imgWidth,
              decoration: BoxDecoration(
                color: Color(0x2F000000),
              ),
              child: Center(
                child: Text(
                  _sector.id,
                  style: TextStyle(
                    fontSize: _imgHeight / 3,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SectorView(_sector)
                  ));
            },
          ),
        ],
      ),
    );
  }
}

