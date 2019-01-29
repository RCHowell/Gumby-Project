import 'package:flutter/material.dart';
import 'package:gumby_project/components/fullscreen_photo_view.dart';
import 'package:gumby_project/models/message.dart';

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

    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(message.author),
        subtitle: Text(message.content),
        trailing: trailing,
      ),
    );
  }
}
