import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static final List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowBlack,
      blurRadius: 2,
      offset: const Offset(0, 2),
    ),
  ];
}