import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class UserImagePickerWidget extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  const UserImagePickerWidget({
    super.key,
    required this.imagePickFn,
  });

  @override
  State<UserImagePickerWidget> createState() => _UserImagePickerWidgetState();
}

class _UserImagePickerWidgetState extends State<UserImagePickerWidget> {
  File? image;

  Future pickImage(ImageSource source) async {
    Navigator.of(context).pop(source);

    try {
      final imageFile = await ImagePicker().pickImage(source: source);

      if (imageFile == null) {
        return;
      }

      final imageTemporary = File(imageFile.path);
      // final imagePermanent = await saveImagePermanently(imageFile.path);

      setState(() {
        image = imageTemporary;
      });

      // pass the image to SignupScreen
      widget.imagePickFn(imageTemporary);
    } on PlatformException catch (error) {
      print('Failed to pick an image $error');
    }
  }

  // Future<File> saveImagePermanently(String imagePath) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = Path.basename(imagePath);
  //   final image = File('${directory.path}/$name');

  //   return File(imagePath).copy(image.path);
  // }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    // IOS
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => pickImage(ImageSource.camera),
              child: const Text('Camera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () => pickImage(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );
    }

    // ANDROID
    return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Gallery'),
            onTap: () => pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    const placeHolderImage = AssetImage('assets/images/no-image.jpg');

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image != null
              ? FileImage(image!)
              : placeHolderImage as ImageProvider,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          child: InkWell(
            onTap: () => showImageSource(context),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) {
    return buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 15,
        ),
        all: 6,
        color: color,
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }
}
