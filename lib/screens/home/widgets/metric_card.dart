import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String mainText;
  final String subText;
  final String suffix;
  final Color? subTextColor;

  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.mainText,
    required this.subText,
    this.suffix = '',
    this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  mainText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (suffix.isNotEmpty) ...[
                  const SizedBox(width: 2),
                  Text(
                    suffix,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subText,
              style: TextStyle(
                fontSize: 12,
                color: subTextColor ?? AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}