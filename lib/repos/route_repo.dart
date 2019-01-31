import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/models/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteRepo {
  final CollectionReference routes = Firestore.instance.collection('routes');

  Future<List<Route>> getRoutesForSector(String key) {
    Query query = routes
        .where('sector', isEqualTo: key)
        .orderBy('createdAt', descending: true)
        .limit(25);
    return query
        .getDocuments()
        .then((snapshot) => snapshot.documents.map(Route.fromDoc).toList());
  }

  Future<String> saveRoute(Route route) {
    return routes.add(route.toMap()).then((DocumentReference ref) {
      CollectionReference messages = ref.collection('messages');
      return messages.add(Message(
        author: route.setter,
        createdAt: DateTime.now(),
        content: 'Route created 🤙',
      ).toMap());
    }).then((_) => 'Route created!');
  }

  Future<List<Route>> getLatestRoutes() {
    Query query = routes.orderBy('createdAt', descending: true).limit(25);
    return query
        .getDocuments()
        .then((snapshot) => snapshot.documents.map(Route.fromDoc).toList());
  }

  Future<String> deleteRoute(String routeId) {
    return routes.document(routeId).delete().then((_) => 'Route deleted!');
  }

  Future<String> rateRoute(Route route, int val) {
    DocumentReference ref = routes.document(route.id);
    List rating = List.from(route.rating);
    rating.add(val);
    return ref.updateData({
      'rating': rating,
    }).then((_) => 'Rated route!');
  }
}
