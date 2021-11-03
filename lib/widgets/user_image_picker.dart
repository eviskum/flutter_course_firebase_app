import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  const UserImagePicker(this.imagePickFn, {Key? key}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _takeImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 150, maxHeight: 150);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
      widget.imagePickFn(_pickedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 45,
        backgroundImage: _pickedImage == null ? null : FileImage(_pickedImage!),
      ),
      TextButton.icon(onPressed: _takeImage, icon: Icon(Icons.camera), label: Text('Take picture')),
    ]);
  }
}
