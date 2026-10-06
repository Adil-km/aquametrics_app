import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class UsageScreen extends StatelessWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Usage Screen', style: TextStyle(color: AppColors.textPrimary)),
    );
  }
}