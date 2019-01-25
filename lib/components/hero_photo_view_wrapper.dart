import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper(
      {this.imageProvider,
        this.loadingChild,
        this.backgroundDecoration,
        this.minScale,
        this.maxScale,
        this.tag,
      });

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingChild: loadingChild,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          heroTag: tag,
        ));
  }
}