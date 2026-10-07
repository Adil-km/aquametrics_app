import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'widgets/alert_card.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alerts',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Stay updated on your home water levels and pump activity.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Warning Alert
            AlertCard(
              title: 'Water is running low',
              time: '09:42 AM',
              date: 'Today',
              body: 'The tank dropped to 19%.\nAutomatic refill has started, so no action is needed.',
              badgeText: 'Refilling now',
              mainIconPath: 'assets/icons/tank_low.svg',
              footerIconPath: 'assets/icons/check_outline.svg',
              footerText: 'Water tank is currently refilling automatically. You can use water normally.',
              iconColor: const Color(0xFFE65100), // Orange
              iconBgColor: const Color(0xFFFFF3E0), // Light Orange
              badgeTextColor: const Color(0xFFE65100),
              badgeBgColor: const Color(0xFFFFF3E0),
              badgeDotColor: const Color(0xFFE65100),
              footerIconColor: AppColors.primaryBlue,
            ),
            
            const SizedBox(height: 16),

            // Info Alert
            AlertCard(
              title: 'Pump is running',
              time: '08:30 AM',
              date: 'Today',
              body: 'The water pump is actively filling the household lines.',
              badgeText: 'Active',
              mainIconPath: 'assets/icons/pump_active.svg',
              footerIconPath: 'assets/icons/info_outline.svg',
              footerText: 'No action needed. The pump will shut off as soon as water pressure is balanced.',
              iconColor: AppColors.primaryBlue,
              iconBgColor: AppColors.primaryBlueLight.withOpacity(0.4),
              badgeTextColor: AppColors.primaryBlue,
              badgeBgColor: AppColors.primaryBlueLight.withOpacity(0.4),
              badgeDotColor: AppColors.primaryBlue,
              footerIconColor: AppColors.primaryBlue,
            ),

            const SizedBox(height: 16),

            // Success Alert
            AlertCard(
              title: 'Tank is almost full',
              time: '06:21 PM',
              date: 'Yesterday',
              body: 'Water reached 95%. Pump automatically stopped.',
              badgeText: 'Completed',
              mainIconPath: 'assets/icons/success_circle.svg',
              footerIconPath: 'assets/icons/thumbs_up.svg',
              footerText: 'Tank level is optimal. Everything is running smoothly.',
              iconColor: const Color(0xFF2E7D32), // Green
              iconBgColor: const Color(0xFFE8F5E9), // Light Green
              badgeTextColor: AppColors.textSecondary,
              badgeBgColor: AppColors.dividerGray.withOpacity(0.3),
              badgeDotColor: null, // No dot for this status
              footerIconColor: const Color(0xFF2E7D32),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}