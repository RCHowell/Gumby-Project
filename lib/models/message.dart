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

  @override
  String toString() {
    return '''Message {
  author: $author,
  content: $content,
  time: ${createdAt.millisecondsSinceEpoch ~/ 1000},
  imageUrl: $imageUrl
}''';
  }


}