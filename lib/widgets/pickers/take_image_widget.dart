import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakeImageWidget extends StatefulWidget {
  const TakeImageWidget(this.takeImageForParent, {Key? key}) : super(key: key);

  final void Function(File image) takeImageForParent;

  @override
  State<TakeImageWidget> createState() => _TakeImageWidgetState();
}

class _TakeImageWidgetState extends State<TakeImageWidget> {
  File? _image;

  void _takeImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (image != null) {
      final File imageFile = File(image.path);
      setState(() {
        _image = imageFile;
      });
      widget.takeImageForParent(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image as File) : null,
        ),
        TextButton.icon(
          onPressed: _takeImage,
          icon: const Icon(Icons.image),
          label: const Text('Add image'),
        ),
      ],
    );
  }
}
