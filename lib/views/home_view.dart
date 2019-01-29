import 'package:flutter/material.dart';
import 'package:gumby_project/components/my_title.dart';
import 'package:gumby_project/components/sector_tile.dart';
import 'package:gumby_project/components/vote_chart.dart';
import 'package:gumby_project/models/sector.dart';
import 'package:gumby_project/presenters/home_presenter.dart';
import 'package:gumby_project/repos/vote_repo.dart';
import 'package:gumby_project/views/discussion_view.dart';
import 'package:gumby_project/views/settings_view.dart';
import 'package:after_layout/after_layout.dart';

class HomeView extends StatefulWidget {
  final String title = "Gumby Project".toUpperCase();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AfterLayoutMixin<HomeView>
    implements HomeViewContract {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  HomePresenter _presenter;
  VoteRepo _voteRepo;
  List<Sector> _sectors;

  @override
  void initState() {
    _sectors = List();
    _presenter = HomePresenter(this);
    _voteRepo = VoteRepo();
    _presenter.initialize();
    super.initState();
  }

  @override
  void updateSectors(List<Sector> sectors) {
    setState(() {
      _sectors = sectors;
    });
  }

  @override
  void onVoteCastComplete(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void onWriteWhoIsComplete() {
    Navigator.of(context).pop();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    _presenter.checkWhoIs();
  }

  @override
  void promptForWhoIs() {
    showDialog(
      context: context,
      builder: (_) => whoIsDialog(),
    );
  }

  // ---------
  //   BUILD
  // ---------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _presenter.initialize,
        child: ListView(
          children: _listChildren(),
        ),
      ),
    );
  }

  // -------------------
  //   WIDGET BUILDING
  // -------------------

  Widget _appBar() => AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            _goToSettings(context);
          },
        ),
        title: Text(
          'Gumby Project',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: () {
              print('New Route');
            },
          )
        ],
      );

  Widget whoIsDialog() {
    String whoInput;

    // to be shown when writing text
    bool loading = false;
    if (loading)
      return AlertDialog(
        content: CircularProgressIndicator(),
      );

    return AlertDialog(
      title: Text('New phone. Who dis?'),
      content: TextField(
        onChanged: (String input) {
          whoInput = input;
        },
        maxLength: 30,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            loading = true;
            _presenter.setWhoIs(whoInput);
          },
          child: Text('Save'),
          textColor: Theme
              .of(context)
              .highlightColor,
        ),
      ],
    );
  }

  List<Widget> _listChildren() {
    List<Widget> children = [
      MyTitle('Sector Votes'),
      Divider(height: 2.0),
      VoteChart(_voteRepo.getVotes()),
      Divider(height: 2.0),
      MyTitle('General'),
      Divider(height: 2.0),
      Material(
        color: Colors.white,
        child: ListTile(
          onTap: () {
            _goToDiscussion(context);
          },
          title: Text('Chalk Talk'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      Divider(height: 2.0),
      Material(
        color: Colors.white,
        child: ListTile(
          onTap: () {
            print('Recent Routes');
          },
          title: Text('Recent Routes'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      Divider(height: 2.0),
      MyTitle('Sectors'),
      Divider(height: 2.0),
    ];
    // Add sectors to the end of the children list
    _sectors.forEach((Sector s) {
      children.add(SectorTile(s, _presenter.castVote));
      children.add(Divider(height: 2.0));
    });
    return children;
  }

  void _goToDiscussion(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DiscussionView(),
    ));
  }

  void _goToSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => SettingsView(),
    ));
  }
}
