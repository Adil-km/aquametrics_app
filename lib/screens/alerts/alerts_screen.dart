import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Alerts Screen', style: TextStyle(color: AppColors.textPrimary)),
    );
  }
}