import 'package:flutter/material.dart';
import 'package:gumby_project/models/route.dart' as gp_route;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RouteListTile extends StatelessWidget {
  final gp_route.Route route;
  final Function onTap;

  RouteListTile(this.route, this.onTap);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String title = route.name;
    List<Widget> subheadList = [
      Text(
        route.setter,
        style: TextStyle(
          color: Colors.blueGrey[700],
          fontSize: 14.0,
        ),
      ),
    ];

    int month = route.createdAt.month;
    int day = route.createdAt.day;
    int year = route.createdAt.year % 2000;
    String date = '$month/$day/$year';

    subheadList.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          date,
          style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Roboto',
              color: Theme
                  .of(context)
                  .primaryColor),
        )));
    subheadList.addAll(_getStars());

    return Material(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(children: subheadList),
        trailing: Chip(
          label: Text(
            route.grade,
            style: theme.textTheme.body1.copyWith(
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
          ),
          backgroundColor: theme.primaryColor,
        ),
      ),
    );
  }

  List<Widget> _getStars() {
    List<Widget> stars = List<Widget>();
    Color color = Colors.blueGrey[700];
    double size = 14.0;

    // Round count to nearest whole
    num avg = route.rating.reduce((acc, v) => acc + v) / route.rating.length;
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
