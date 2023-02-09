import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerWidget extends StatefulWidget {
  const UserImagePickerWidget({super.key});

  @override
  State<UserImagePickerWidget> createState() => _UserImagePickerWidgetState();
}

class _UserImagePickerWidgetState extends State<UserImagePickerWidget> {
  File? _pickedImage;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final pickedImageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
      preferredCameraDevice: CameraDevice.rear,
    );

    // if no image was taken
    if (pickedImageFile == null) {
      return;
    }

    setState(() {
      _pickedImage = File((pickedImageFile as XFile).path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
