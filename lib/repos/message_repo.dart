import 'package:gumby_project/models/message.dart';

class MessageRepo {

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

}