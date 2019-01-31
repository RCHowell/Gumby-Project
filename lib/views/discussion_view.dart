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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Message Board'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => MessageView(),
              ))
                  .then((_) => _presenter.getLatestMessages());
            },
          ),
        ],
      ),
      body: (_loading)
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyTitle('Recent Messages'),
          Divider(height: 2.0),
          Expanded(
            child: RefreshIndicator(
              child: ListView.separated(
                itemBuilder: (_, i) {
                  if (i == _messages.length) return Container();
                  return MessageTile(_messages[i]);
                },
                separatorBuilder: (_, i) => Divider(height: 2.0),
                itemCount: _messages.length + 1,
              ),
              onRefresh: () {
                _presenter.getLatestMessages();
                return Future.value(null);
              },
            ),
          ),
        ],
      ),
    );
  }
}
