import 'package:gumby_project/models/route.dart';
import 'package:gumby_project/repos/route_repo.dart';

abstract class RecentRouteViewContract {
  void onGetLatestRoutesComplete(List<Route> routes);
}

class RecentRouteViewPresenter {
  RecentRouteViewContract _view;
  RouteRepo _repo;

  RecentRouteViewPresenter(this._view) {
    _repo = RouteRepo();
  }

  void getLatestRoutes() {
    _repo.getLatestRoutes().then(_view.onGetLatestRoutesComplete);
  }
}
