import 'package:flutter/material.dart';

import '../widgets/custom_appbar_widget.dart';
import '../widgets/custom_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBarWidget(title: 'Home'),
      drawer: CustomDrawerWidget(),
    );
  }
}
