import 'dart:io';

import 'package:gumby_project/models/route.dart';
import 'package:gumby_project/repos/route_repo.dart';
import 'package:gumby_project/whois.dart' as User;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class RecentRouteViewContract {
  void onGetLatestRoutesComplete(List<Route> routes);

  void promptForWhoIs();

  void onWriteWhoIsComplete();
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

  void checkWhoIs() {
    if (User.whois == null) {
      _view.promptForWhoIs();
    }
  }

  void setWhoIs(String name) async {
    final docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, "whois");
    File(path).writeAsStringSync(name);
    User.whois = name;
    _view.onWriteWhoIsComplete();
  }
}
