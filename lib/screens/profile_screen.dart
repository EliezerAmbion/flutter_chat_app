import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/helper_widgets.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_appbar_widget.dart';
import '../widgets/drawer/custom_drawer_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UploadTask? task;
  File? file;
  bool isUploadBtnShow = false;

  @override
  void initState() {
    isUploadBtnShow = false;
    super.initState();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) {
      setState(() {
        isUploadBtnShow = false;
      });
      return;
    }

    final path = result.files.single.path!;

    setState(() {
      isUploadBtnShow = true;
      file = File(path);
    });
  }

  Future uploadFile(BuildContext context) async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = DatabaseService.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {
      setState(() {
        isUploadBtnShow = false;
      });

      HelperWidget.showSnackBar(
        context: context,
        message: 'Image successfully uploaded',
        backgroundColor: Colors.green,
      );
    });

    // imageUrlDownload = await snapshot.ref.getDownloadURL();
    // print('Download-Link =====> $imageUrlDownload');
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = Provider.of<AuthProvider>(context).currentUser;
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Profile'),
      drawer: const CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // IMAGE
            file == null
                ? const Icon(
                    Icons.account_circle,
                    size: 150,
                  )
                : CircleAvatar(
                    radius: 80,
                    backgroundImage: file != null ? FileImage(file!) : null,
                  ),
            const SizedBox(height: 10),
            Text(
              fileName,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            isUploadBtnShow
                ? ElevatedButton(
                    onPressed: () => uploadFile(context),
                    child: Text(
                      'Upload',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 25),
            TextButton.icon(
              onPressed: selectFile,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Select an image'),
            ),
            const SizedBox(height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Username:',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  currentUser!.displayName!,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email:',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  currentUser.email!,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
