import 'dart:io';

import 'package:gumby_project/models/sector.dart';
import 'package:gumby_project/repos/sector_repo.dart';
import 'package:gumby_project/repos/vote_repo.dart';
import 'package:gumby_project/whois.dart' as User;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class HomeViewContract {
  void updateSectors(List<Sector> sectors);

  void onVoteCastComplete(String message);

  void promptForWhoIs();

  void onWriteWhoIsComplete();
}

class HomePresenter {

  final HomeViewContract _view;
  SectorRepo _sectorRepo;
  VoteRepo voteRepo;

  HomePresenter(this._view) {
    _sectorRepo = SectorRepo();
    voteRepo = VoteRepo();
  }

  /// To be used with a [RefreshIndicator]
  Future<Null> initialize() async {
//    _view.onInitializeChange(false);
    _view.updateSectors([]);
    try {
      List<Sector> sectors = await _sectorRepo.getSectors();
      _view.updateSectors(sectors);
      return Future.value(null);
    } catch (e) {
      print(e.toString());
    }
  }

  void castVote(String key, int val) {
    voteRepo.castVote(key, val).then(_view.onVoteCastComplete);
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
