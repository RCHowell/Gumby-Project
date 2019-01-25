import 'package:gumby_project/repos/route_repo.dart';
import 'package:gumby_project/models/sector.dart';
import 'package:gumby_project/models/route.dart';

abstract class SectorViewContract {
  void onGetRoutesComplete(List<Route> routes);
  void onGetRoutesError(error);
}

class SectorPresenter {

  SectorViewContract _view;
  RouteRepo _routeRepo;

  SectorPresenter(this._view) {
    _routeRepo = RouteRepo();
  }

  void getRoutesForSector(String key) {
    _routeRepo.getRoutesForSector(key)
        .then(_view.onGetRoutesComplete)
        .catchError(_view.onGetRoutesError);
  }

}
