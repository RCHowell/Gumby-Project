import 'package:gumby_project/models/sector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SectorRepo {

  final CollectionReference sectors = Firestore.instance.collection('sectors');

  Future<List<Sector>> getSectors() {
    return sectors.getDocuments().then((QuerySnapshot snapshot) {
      return snapshot.documents.map(Sector.fromDoc).toList();
    });
  }

}
