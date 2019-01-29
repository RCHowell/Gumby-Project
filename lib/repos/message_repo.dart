import 'dart:io';
import 'package:gumby_project/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepo {

  final CollectionReference discussion = Firestore.instance.collection(
      'discussion');

  Future<List<Message>> getMessagesForRoute(String id) {
    return Future.delayed(Duration(seconds: 2), () {
      return [
        Message(
          author: 'DPP',
          content: 'This whole gym is soft',
        ),
        Message(
          author: 'Conner',
          content: 'Downgrade them all',
        ),
        Message(
          author: 'Patty',
          content: 'Check out the latest proj',
          imageUrl: 'https://i.ytimg.com/vi/CHE5ssb2aBs/maxresdefault.jpg',
        ),
      ];
    });
  }

  Future<List<Message>> getDiscussionMessages() async {
    Query query = discussion
        .limit(25)
        .orderBy('createdAt', descending: true);
    QuerySnapshot snapshot = await query.getDocuments();
    return snapshot.documents.map(Message.fromDoc).toList();
  }

  Future<String> saveDiscussionMessage(Message message) async {
    return discussion.add(message.toMap())
        .then((_) => 'Message Posted!')
        .catchError(() => 'Error posting message');
  }

  Future<String> saveRouteMessage(String routeId, Message message) async {
    return Future.delayed(Duration(seconds: 1), () {
      print(message.toString());
      return 'Message posted!';
    });
  }
}
