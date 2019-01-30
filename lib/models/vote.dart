import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Vote {

  final String sector;
  final DateTime createdAt;
  final int value;

  Vote({
    @required this.sector,
    @required this.createdAt,
    @required this.value,
  });

  static Vote fromDoc(DocumentSnapshot doc) {
    if (doc == null) return null;
    return Vote(
      sector: doc.data['sector'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(doc.data['createdAt']),
      value: doc.data['value'],
    );
  }

}
