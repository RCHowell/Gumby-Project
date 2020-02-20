import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageUpload extends StatefulWidget {
  final Function onComplete;
  final Function onError;

  ImageUpload({
    this.onComplete,
    this.onError,
  });

  @override
  State<StatefulWidget> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File _image;
  bool complete;
  String imageUrl;
  StorageUploadTask task;
  FirebaseStorage storage;

  @override
  void initState() {
    storage = FirebaseStorage(
      app: FirebaseApp.instance,
      storageBucket: 'gs://gumby-project-images',
    );
    complete = false;
    super.initState();
  }

  Future<void> _uploadFile(File imageFile) async {
    // Create a filename
    this.imageUrl = 'image-${Uuid().v1()}.jpg';
    // Parse and compress image
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.Image tinyImage = Im.copyResize(image, height: 600);
    // Create a temp file and write tinyImage to it
    Directory tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/$imageUrl').create();
    file.writeAsBytesSync(Im.encodeJpg(tinyImage, quality: 80));
    StorageReference ref = storage.ref().child(imageUrl);
    // Begin uploading
    setState(() {
      task = ref.putFile(file);
    });

    task.onComplete.then((_) {
      widget.onComplete(imageUrl);
    });
  }

  Future _selectImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _uploadFile(_image);
  }

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return FlatButton(
        child: Text('Add Image'),
        onPressed: _selectImage,
        textColor: Colors.lightBlue,
      );
    }

    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget child;
        if (task.isInProgress) {
          child = Center(
            child: CircularProgressIndicator(),
          );
        } else if (task.isSuccessful) {
          child = Image.file(
            _image,
            fit: BoxFit.cover,
          );
        } else {
          child = Center(
            child: Text('Upload Error'),
          );
        }

        return Container(
          padding: const EdgeInsets.all(50.0),
          child: child,
        );
      },
    );
  }
}
