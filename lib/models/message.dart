import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  final String author;
  final String content;
  final String imageUrl;
  final DateTime createdAt;

  Message({
    this.author,
    this.content,
    this.imageUrl,
    this.createdAt,
  });

  static Message fromDoc(DocumentSnapshot doc) {
    if (doc == null) return null;
    return Message(
      author: doc.data['author'],
      content: doc.data['content'],
      imageUrl: doc.data['imageUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(doc.data['createdAt']),
    );
  }

  @override
  String toString() {
    return '''Message {
  author: $author,
  content: $content,
  time: ${createdAt.millisecondsSinceEpoch ~/ 1000},
  imageUrl: $imageUrl
}''';
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }


}