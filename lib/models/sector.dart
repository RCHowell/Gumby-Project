import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sector {

  String id;
  String name;
  String imageUrl;
  String thumbnailUrl;

  Sector({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.thumbnailUrl,
  });

  static Sector fromDoc(DocumentSnapshot doc) {
    if (doc == null) return null;
    return Sector(
      id: doc.data['key'],
      name: doc.data['name'],
      imageUrl: doc.data['image_url'],
      thumbnailUrl: doc.data['thumbnail_url'],
    );
  }

}
