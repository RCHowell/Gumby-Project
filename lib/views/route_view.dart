import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gumby_project/components/hero_photo_view_wrapper.dart';
import 'package:gumby_project/components/message_tile.dart';
import 'package:gumby_project/components/my_title.dart';
import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/presenters/route_presenter.dart';
import 'package:gumby_project/models/route.dart' as gp_route;
import 'package:gumby_project/views/message_view.dart';

class RouteView extends StatefulWidget {
  final gp_route.Route route;

  RouteView(this.route);

  @override
  State<StatefulWidget> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> implements RouteViewContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RoutePresenter _presenter;
  List<Message> _comments;
  gp_route.Route _route;

  @override
  void initState() {
    _presenter = RoutePresenter(this);
    _comments = List();
    _presenter.getCommentsForRoute(widget.route.id);
    _route = widget.route;
    super.initState();
  }

  @override
  void onGetCommentsComplete(List<Message> comments) {
    setState(() {
      _comments = comments;
    });
  }

  @override
  void onGetMessagesError(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(error.toString()),
    ));
  }

  @override
  void onRouteDeleted(String message) {
    Navigator.of(_scaffoldKey.currentContext).pop();
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO!'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('ye boi'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _presenter.deleteRoute(_route.id);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<Widget> children = [
      LargeRouteImage(_route.imageUrl),
      MyTitle('About'),
      Divider(height: 2.0),
      _about(_route, theme),
      Divider(height: 2.0),
      MyTitle('Discussion'),
      Divider(height: 2.0),
    ];

    _comments.forEach((Message m) {
      children.add(MessageTile(m));
      children.add(Divider(height: 2.0));
    });

    children.add(_newCommentButton(context));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_route.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              _confirmDelete(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: children,
      ),
    );
  }

  Widget _about(gp_route.Route route, ThemeData theme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    route.grade,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Row(
                    children: _getStars(),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  FlatButton(
                    child: Text('RATE'),
                    textColor: Colors.white,
                    color: theme.primaryColor,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (_) => RateRouteView(route, _presenter),
                        fullscreenDialog: true,
                      ))
                          .then((val) {
                        List rating = List.from(route.rating);
                        rating.add(val);
                        setState(() {
                          _route = gp_route.Route(
                            id: route.id,
                            name: route.name,
                            grade: route.grade,
                            description: route.description,
                            imageUrl: route.imageUrl,
                            setter: route.setter,
                            sector: route.sector,
                            rating: rating,
                            createdAt: route.createdAt,
                          );
                        });
                      });
                    },
                  ),
                  Text(
                    'Set by ${route.setter}',
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Text(
              route.description,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newCommentButton(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: RaisedButton(
        child: Text('New Comment'),
        color: theme.primaryColor,
        textColor: Colors.white,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (_) => MessageView(routeId: widget.route.id),
            fullscreenDialog: true,
          ))
              .then((_) => _presenter.getCommentsForRoute(widget.route.id));
        },
      ),
    );
  }

  List<Widget> _getStars() {
    List<Widget> stars = List<Widget>();
    Color color = Colors.blueGrey[700];
    double size = 14.0;

    // Round count to nearest whole
    num avg = widget.route.rating.reduce((acc, v) => acc + v) /
        widget.route.rating.length;
    num abs = avg.abs();
    int val = abs.round();
    IconData icon;
    if (avg > 0) {
      icon = Icons.star;
    } else {
      icon = FontAwesomeIcons.bomb;
    }

    // 0 star routes get bombs
    if (val == 0) {
      return [
        Icon(
          FontAwesomeIcons.bomb,
          color: color,
          size: size,
        )
      ];
    }

    // Add whole stars
    for (int i = 0; i < abs; i += 1) {
      stars.add(Icon(
        icon,
        color: color,
        size: size,
      ));
    }

    return stars;
  }
}

class LargeRouteImage extends StatelessWidget {
  final String imageUrl;
  final double height = 140.0;

  LargeRouteImage(this.imageUrl);

  Future<String> getFullImageUrl() async {
    FirebaseStorage storage = FirebaseStorage(
      app: FirebaseApp.instance,
      storageBucket: 'gs://gumby-project-images',
    );
    StorageReference ref = storage.ref().child(imageUrl);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFullImageUrl(),
        builder: (_, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text('${snapshot.error}');
              else
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HeroPhotoViewWrapper(
                                imageProvider:
                                CachedNetworkImageProvider(snapshot.data),
                                tag: snapshot.data,
                              ),
                        ));
                  },
                  child: Container(
                    height: height,
                    child: Hero(
                      tag: snapshot.data,
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data,
                        placeholder: Container(
                          height: height,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: height,
                      ),
                    ),
                  ),
                );
              break;
            default:
              return Container(
                height: height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
          }
        });
  }
}

class RateRouteView extends StatefulWidget {
  final RoutePresenter presenter;
  final gp_route.Route route;

  RateRouteView(this.route, this.presenter);

  @override
  State<StatefulWidget> createState() => _RateRouteViewState();
}

class _RateRouteViewState extends State<RateRouteView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  void rateRoute(int val) {
    setState(() {
      _loading = true;
    });
    widget.presenter.rateRoute(widget.route, val, (String message) {
      Navigator.of(_scaffoldKey.currentContext).pop(val);
    }, (String errorMessage) {
      print(errorMessage);
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    });
  }

  List<Widget> _iconList(int val) {
    IconData icon = (val > 0) ? Icons.star : FontAwesomeIcons.bomb;
    int count = val.abs();
    return List.generate(count, (_) => Icon(icon, color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Rate "${widget.route.name}"'),
      ),
      body: (_loading)
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemBuilder: (_, i) {
          // 0,1,2,3,4,5 -> -3,-2,-1,1,2,3
          int val = (i >= 3) ? i - 2 : i - 3;
          return Container(
            margin: const EdgeInsets.symmetric(
                vertical: 2.0, horizontal: 12.0),
            child: FlatButton(
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () {
                rateRoute(val);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _iconList(val),
              ),
            ),
          );
        },
        itemCount: 6,
      ),
    );
  }
}
