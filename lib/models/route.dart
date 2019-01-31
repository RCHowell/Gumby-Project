import 'package:cloud_firestore/cloud_firestore.dart';

class Route {

  final String id;
  final String name;
  final String grade;
  final String description;
  final String imageUrl;
  final String setter;
  final List rating;
  final DateTime createdAt;
  final String sector;

  Route({
    this.id,
    this.name,
    this.grade,
    this.description,
    this.imageUrl,
    this.setter,
    this.rating,
    this.createdAt,
    this.sector,
  });

  static Route fromDoc(DocumentSnapshot doc) {
    if (doc == null) return null;
    return Route(
      id: doc.documentID,
      name: doc.data['name'],
      grade: doc.data['grade'],
      description: doc.data['description'],
      imageUrl: doc.data['imageUrl'],
      setter: doc.data['setter'],
      rating: doc.data['rating'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(doc.data['createdAt']),
      sector: doc.data['sector'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'grade': this.grade,
      'description': this.description,
      'imageUrl': this.imageUrl,
      'setter': this.setter,
      'rating': this.rating,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'sector': this.sector,
    };
  }


}
