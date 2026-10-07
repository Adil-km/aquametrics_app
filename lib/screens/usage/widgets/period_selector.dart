import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class PeriodSelector extends StatelessWidget {
  final String label;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  const PeriodSelector({
    super.key,
    required this.label,
    this.onLeftTap,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Hugs the content
        children: [
          _buildNavButton(
            icon: Icons.chevron_left,
            onTap: () {
              print('Left arrow clicked!'); // Console verification
              if (onLeftTap != null) onLeftTap!();
            },
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          _buildNavButton(
            icon: Icons.chevron_right,
            onTap: () {
              print('Right arrow clicked!'); // Console verification
              if (onRightTap != null) onRightTap!();
            },
          ),
        ],
      ),
    );
  }

  // Helper widget to make the arrows look like distinct, clickable buttons
  Widget _buildNavButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensures the entire padded area catches the tap
      child: Container(
        padding: const EdgeInsets.all(6), // Increases the physical touch target area
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite, // Creates visual distinction from the gray bubble
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: AppColors.textSecondary),
      ),
    );
  }
}