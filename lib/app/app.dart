import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import '../screens/base/base_screen.dart';

class AquaMetricsApp extends StatelessWidget {
  const AquaMetricsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaMetrics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.backgroundMain,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          background: AppColors.backgroundMain,
          surface: AppColors.surfaceWhite,
        ),
      ),
      home: const BaseScreen(),
    );
  }
}