import 'package:flutter/material.dart';
import 'package:gumby_project/components/message_tile.dart';
import 'package:gumby_project/components/my_title.dart';
import 'package:gumby_project/presenters/discussion_presenter.dart';
import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/views/message_view.dart';

class DiscussionView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DiscussionViewState();
}

class _DiscussionViewState extends State<DiscussionView>
    implements DiscussionViewContract {
  DiscussionPresenter _presenter;
  List<Message> _messages;
  bool _loading;

  @override
  void initState() {
    _loading = true;
    _messages = List();
    _presenter = DiscussionPresenter(this);
    _presenter.getLatestMessages();
    super.initState();
  }

  @override
  void onGetLatestMessagesComplete(List<Message> messages) {
    setState(() {
      _loading = false;
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      _newMessageButton(context),
      Divider(height: 2.0),
      MyTitle('Recent Messages'),
      Divider(height: 2.0),
    ];

    _messages.forEach((Message m) {
      _children.add(MessageTile(m));
      _children.add(Divider(height: 2.0));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Message Board'),
      ),
      body: (_loading)
          ? _loadingWidget()
          : ListView(
              children: _children,
            ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _newMessageButton(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: RaisedButton(
        child: Text('New Message'),
        color: theme.primaryColor,
        textColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => MessageView(),
          )).then((_) => _presenter.getLatestMessages());
        },
      ),
    );
  }
}
