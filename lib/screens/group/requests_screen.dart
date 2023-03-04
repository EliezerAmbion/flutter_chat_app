import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_appbar_widget.dart';

class RequestScreen extends StatelessWidget {
  static const routeName = '/requests';

  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBarWidget(title: 'Requests'),
    );
  }
}
