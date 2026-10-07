import 'package:flutter/material.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_bottom_nav.dart';

import '../home/home_screen.dart';
import '../usage/usage_screen.dart';
import '../alerts/alerts_screen.dart';
import '../settings/settings_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  // The screens that will be swapped into the body
  final List<Widget> _screens = const [
    HomeScreen(),
    UsageScreen(),
    AlertsScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}