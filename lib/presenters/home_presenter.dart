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
  VoteRepo _voteRepo;

  HomePresenter(this._view) {
    _sectorRepo = SectorRepo();
    _voteRepo = VoteRepo();
  }

  /// To be used with a [RefreshIndicator]
  Future<Null> initialize() async {
//    _view.onInitializeChange(false);
    _view.updateSectors([]);
    return Future.delayed(Duration(milliseconds: 250), () {
//      _view.onInitializeChange(true);
      _view.updateSectors(_sectorRepo.getSectors());
      return Future.value(null);
    });
  }

  void castVote(String key, int val) {
    _voteRepo.castVote(key, val).then(_view.onVoteCastComplete);
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
