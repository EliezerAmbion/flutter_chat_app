import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helper_widgets.dart';
import '../providers/auth_provider.dart';
import '../services/database_service.dart';
import 'custom_field_widget.dart';

class CreateGroupWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController groupController;

  const CreateGroupWidget({
    super.key,
    required this.formKey,
    required this.groupController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a Group'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFieldWidget(
              labelText: null,
              controller: groupController,
              obscureText: false,
              horizontalPadding: 0,
              suffixIcon: Icons.group,
              autoFill: AutofillHints.name,
              validator: (value) {
                const max = 15;

                if (value!.isEmpty) {
                  return 'Group Name can\'t be empty';
                }
                if (value.length > max) {
                  return 'Must not exceed $max characters.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        // cancel btn
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            groupController.clear();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text('CANCEL'),
        ),

        // create btn
        ElevatedButton(
          onPressed: () async {
            final bool isValid = formKey.currentState!.validate();
            if (!isValid) return;

            final currentUser =
                Provider.of<AuthProvider>(context, listen: false).currentUser;

            // TODO: Create a provider for groups
            DatabaseService().addGroupCollection(
              groupName: groupController.text,
              uid: currentUser!.uid,
              displayName: currentUser.displayName!,
            );

            // pop the alert dialog
            Navigator.pop(context);

            HelperWidget.showSnackBar(
              context: context,
              message: 'Group created successfully.',
              backgroundColor: Colors.green,
            );

            groupController.clear();
          },
          style: ElevatedButton.styleFrom(),
          child: const Text('CREATE'),
        )
      ],
    );
  }
}
