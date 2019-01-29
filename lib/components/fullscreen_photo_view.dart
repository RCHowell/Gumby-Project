import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullscreenPhotoView extends StatelessWidget {
  final String imageUrl;

  FullscreenPhotoView(this.imageUrl);

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
    return Scaffold(
      body: FutureBuilder(
          future: getFullImageUrl(),
          builder: (_, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('${snapshot.error}');
                else
                  return Container(
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(snapshot.data),
                    ),
                  );
                break;
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
            }
          }),
    );
  }
}
