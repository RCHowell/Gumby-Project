import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/repos/message_repo.dart';
import 'package:gumby_project/repos/route_repo.dart';
import 'package:gumby_project/models/route.dart';

abstract class RouteViewContract {
  void onGetCommentsComplete(List<Message> comments);
  void onGetMessagesError(error);

  void onRouteDeleted(String message);
}

class RoutePresenter {

  final RouteViewContract _view;
  MessageRepo _messageRepo;
  RouteRepo _routeRepo;

  RoutePresenter(this._view) {
    _routeRepo = RouteRepo();
    _messageRepo = MessageRepo();
  }

  void getCommentsForRoute(String id) {
    _messageRepo.getMessagesForRoute(id)
        .then(_view.onGetCommentsComplete)
        .catchError(_view.onGetMessagesError);
  }

  void deleteRoute(String routeId) {
    _routeRepo.deleteRoute(routeId)
        .then(_view.onRouteDeleted)
        .catchError((e) {
      print(e);
    });
  }

  void rateRoute(Route route, int val, Function success, Function error) {
    _routeRepo.rateRoute(route, val)
        .then((String message) => success(message))
        .catchError((e) => error(e.toString()));
  }

}