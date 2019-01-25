import 'package:flutter/material.dart';
import 'package:gumby_project/models/message.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageTile extends StatelessWidget {
  Message message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (message.imageUrl != null) {
      trailing = IconButton(
        icon: Icon(Icons.image),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return Scaffold(
              body: Container(
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(message.imageUrl),
                ),
              ),
            );
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
