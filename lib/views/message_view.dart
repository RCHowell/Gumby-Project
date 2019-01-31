import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gumby_project/components/image_upload.dart';
import 'package:gumby_project/models/message.dart';
import 'package:gumby_project/whois.dart' as Whois;
import 'package:gumby_project/presenters/message_presenter.dart';

class MessageView extends StatefulWidget {

  final String routeId;

  MessageView({
    this.routeId,
  });

  @override
  State<StatefulWidget> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView>
    implements MessageViewContract {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MessagePresenter _presenter;
  String _messageContent;
  String _imageUrl;
  File _image;
  bool _imageUploaded;
  bool _loading;

  @override
  void initState() {
    _presenter = MessagePresenter(this);
    _imageUploaded = false;
    _loading = false;
    super.initState();
  }

  @override
  void onSaveMessageError(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Image is still uploading'),
    ));
  }

  @override
  void onSavedMessageComplete(String reply) {
    Navigator.of(context).pop();
  }

  void _saveMessage() {
    if (_image != null && _imageUploaded == false) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Image is still uploading'),
      ));
    } else {
      Message message = Message(
        content: _messageContent,
        createdAt: DateTime.now(),
        author: Whois.whois,
        imageUrl: _imageUrl,
      );
      if (widget.routeId != null) {
        // If there is a threadId, then this message should go for a route
        _presenter.saveRouteMessage(widget.routeId, message);
      } else {
        _presenter.saveDiscussionMessage(message);
      }
      setState(() {
        _loading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Message'),
      ),
      body: (_loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                _textInput(),
                Divider(height: 2.0),
                Expanded(
                  child: ImageUpload(
                    onComplete: (String imageUrl) {
                      _imageUploaded = true;
                      _imageUrl = imageUrl;
                    },
                    onError: (String message) {},
                  ),
                ),
              ],
            ),
      floatingActionButton: (_loading)
          ? null
          : FloatingActionButton(
              child: Icon(Icons.send),
              onPressed: _saveMessage,
            ),
    );
  }

  Widget _textInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 8.0,
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Hot takes only...',
          labelText: 'Content',
        ),
        onChanged: (String content) {
          _messageContent = content;
        },
        maxLength: 250,
      ),
    );
  }
}
