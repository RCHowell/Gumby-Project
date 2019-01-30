import 'package:flutter/material.dart';
import 'package:gumby_project/components/fullscreen_photo_view.dart';
import 'package:gumby_project/models/message.dart';

final List months = [
  "",
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "June",
  "July",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

class MessageTile extends StatelessWidget {
  final Message message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (message.imageUrl != null) {
      trailing = IconButton(
        icon: Icon(Icons.image),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return FullscreenPhotoView(message.imageUrl);
          }));
        },
      );
    }

    String month = months[message.createdAt.month];
    int day = message.createdAt.day;
    String hour = (message.createdAt.hour == 12) ? "12" : (message.createdAt
        .hour % 12).toString();
    String minute = message.createdAt.minute.toString();
    String dayPart = (message.createdAt.hour >= 12) ? "pm" : "am";
    String date = '$month, $day $hour:$minute$dayPart';

    return Container(
      color: Colors.white,
      child: ListTile(
        title: Row(
          children: <Widget>[
            Text(message.author),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 8.0),
              child: Text(date,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.0,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(message.content),
        trailing: trailing,
      ),
    );
  }
}
