import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  static const routeName = '/requests';

  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('requests')),
    );
  }
}
