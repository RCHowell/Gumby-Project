import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gumby_project/components/hero_photo_view_wrapper.dart';
import 'package:gumby_project/components/message_tile.dart';
import 'package:gumby_project/components/my_title.dart';
import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/presenters/route_presenter.dart';
import 'package:gumby_project/models/route.dart' as gp_route;

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

  @override
  void initState() {
    _presenter = RoutePresenter(this);
    _comments = List();
    _presenter.getCommentsForRoute(widget.route.id);
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
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);

    List<Widget> children = [
      LargeRouteImage(widget.route.imageUrl),
      MyTitle('About'),
      Divider(height: 2.0),
      _about(widget.route, theme),
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
      appBar: AppBar(
        title: Text(widget.route.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
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
                    onPressed: () {},
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
      child: FlatButton(
        child: Text('New Comment'),
        color: theme.primaryColor,
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  List<Widget> _getStars() {
    List<Widget> stars = List<Widget>();
    Color color = Colors.blueGrey[700];
    double size = 14.0;

    // Round count to nearest whole
    num abs = widget.route.rating.abs();
    int val = abs.round();
    IconData icon;
    if (widget.route.rating > 0) {
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
  final String url;
  final double height = 140.0;

  LargeRouteImage(this.url);

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
