import 'package:gumby_project/repos/message_repo.dart';
import 'package:gumby_project/models/message.dart';

abstract class MessageViewContract {
  void onSavedMessageComplete(String reply);
  void onSaveMessageError(error);
}

class MessagePresenter {

  final MessageViewContract _view;
  MessageRepo _repo;

  MessagePresenter(this._view) {
    _repo = MessageRepo();
  }

  void saveDiscussionMessage(Message message) {
    _repo.saveDiscussionMessage(message)
        .then(_view.onSavedMessageComplete)
        .catchError(_view.onSaveMessageError);
  }

  void saveRouteMessage(String routeId, Message message) {
    _repo.saveRouteMessage(routeId, message)
        .then(_view.onSavedMessageComplete)
        .catchError(_view.onSaveMessageError);
  }

}
