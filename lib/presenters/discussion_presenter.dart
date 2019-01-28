import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/repos/message_repo.dart';

abstract class DiscussionViewContract {
  void onGetLatestMessagesComplete(List<Message> messages);
}

class DiscussionPresenter {

  DiscussionViewContract _view;
  MessageRepo _repo;

  DiscussionPresenter(this._view) {
    _repo = MessageRepo();
  }

  void getLatestMessages() {
    _repo.getDiscussionMessages()
      .then(_view.onGetLatestMessagesComplete);
  }

}


