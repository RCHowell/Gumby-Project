import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/repos/message_repo.dart';

abstract class RouteViewContract {
  void onGetCommentsComplete(List<Message> comments);
  void onGetMessagesError(error);
}

class RoutePresenter {

  final RouteViewContract _view;
  MessageRepo _messageRepo;

  RoutePresenter(this._view) {
    _messageRepo = MessageRepo();
  }

  void getCommentsForRoute(String id) {
    _messageRepo.getMessagesForRoute(id)
        .then(_view.onGetCommentsComplete)
        .catchError(_view.onGetMessagesError);
  }

}