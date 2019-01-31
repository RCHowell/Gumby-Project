import 'dart:io';
import 'package:gumby_project/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepo {
  final CollectionReference discussion =
  Firestore.instance.collection('discussion');

  Future<List<Message>> getMessagesForRoute(String routeId) async {
    CollectionReference routeMessages =
    Firestore.instance.collection('routes/$routeId/messages');
    Query query = routeMessages.limit(25).orderBy(
        'createdAt', descending: true);
    QuerySnapshot snapshot = await query.getDocuments();
    return snapshot.documents.map(Message.fromDoc).toList();
  }

  Future<List<Message>> getDiscussionMessages() async {
    Query query = discussion.limit(25).orderBy('createdAt', descending: true);
    QuerySnapshot snapshot = await query.getDocuments();
    return snapshot.documents.map(Message.fromDoc).toList();
  }

  Future<String> saveDiscussionMessage(Message message) async {
    return discussion
        .add(message.toMap())
        .then((_) => 'Message Posted!')
        .catchError(() => 'Error posting message');
  }

  Future<String> saveRouteMessage(String routeId, Message message) async {
    CollectionReference routeMessages =
    Firestore.instance.collection('routes/$routeId/messages');
    return routeMessages
        .add(message.toMap())
        .then((_) => 'Message Posted!')
        .catchError(() => 'Error posting message');
  }
}
