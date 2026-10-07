import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/alerts_provider.dart';
import '../../core/widgets/network_error_widget.dart';
import 'widgets/alert_card.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertsProvider>(
      builder: (context, provider, child) {
        
        if (provider.state == AlertsViewState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (provider.state == AlertsViewState.error) {
          return NetworkErrorWidget(
            message: provider.errorMessage,
            onRetry: provider.fetchAlerts,
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alerts',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
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

                if (provider.filteredAlerts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text('No alerts at this time.', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),

                // Map through the filtered alerts dynamically
                ...provider.filteredAlerts.map((alert) {
                  final String type = alert['type'] ?? '';
                  final config = _getAlertConfig(type);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: AlertCard(
                      title: config['title'],
                      time: provider.formatTime(alert['timestamp']),
                      date: provider.formatDate(alert['timestamp']),
                      body: alert['message'] ?? '',
                      badgeText: config['badgeText'],
                      mainIconPath: config['mainIconPath'],
                      footerIconPath: config['footerIconPath'],
                      footerText: config['footerText'],
                      iconColor: config['iconColor'],
                      iconBgColor: config['iconBgColor'],
                      badgeTextColor: config['badgeTextColor'],
                      badgeBgColor: config['badgeBgColor'],
                      badgeDotColor: config['badgeDotColor'],
                      footerIconColor: config['footerIconColor'],
                    ),
                  );
                }),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to assign themes and icons based on the API alert type
  Map<String, dynamic> _getAlertConfig(String type) {
    if (type == 'LOW_WATER') {
      return {
        'title': 'Water is running low',
        'badgeText': 'Warning',
        'mainIconPath': 'assets/icons/tank_low.svg',
        'footerIconPath': 'assets/icons/info_outline.svg',
        'footerText': 'Check if the pump is scheduled to run.',
        'iconColor': const Color(0xFFE65100), // Orange
        'iconBgColor': const Color(0xFFFFF3E0),
        'badgeTextColor': const Color(0xFFE65100),
        'badgeBgColor': const Color(0xFFFFF3E0),
        'badgeDotColor': const Color(0xFFE65100),
        'footerIconColor': AppColors.primaryBlue,
      };
    } else if (type == 'HIGH_WATER') {
      return {
        'title': 'Tank is almost full',
        'badgeText': 'Optimal',
        'mainIconPath': 'assets/icons/success_circle.svg',
        'footerIconPath': 'assets/icons/thumbs_up.svg',
        'footerText': 'Tank level is optimal. Everything is running smoothly.',
        'iconColor': const Color(0xFF2E7D32), // Green
        'iconBgColor': const Color(0xFFE8F5E9),
        'badgeTextColor': AppColors.textSecondary,
        'badgeBgColor': AppColors.dividerGray.withOpacity(0.3),
        'badgeDotColor': null,
        'footerIconColor': const Color(0xFF2E7D32),
      };
    } else if (type == 'PUMP_OFF_LOW_LEVEL') {
      return {
        'title': 'Pump is OFF',
        'badgeText': 'Advisory',
        'mainIconPath': 'assets/icons/pump_active.svg',
        'footerIconPath': 'assets/icons/info_outline.svg',
        'footerText': 'Water is low. Consider turning the pump ON manually.',
        'iconColor': AppColors.primaryBlue,
        'iconBgColor': AppColors.primaryBlueLight.withOpacity(0.4),
        'badgeTextColor': AppColors.primaryBlue,
        'badgeBgColor': AppColors.primaryBlueLight.withOpacity(0.4),
        'badgeDotColor': AppColors.primaryBlue,
        'footerIconColor': AppColors.primaryBlue,
      };
    } else if (type == 'PUMP_RUNNING_HIGH_LEVEL') {
      return {
        'title': 'Overflow Risk',
        'badgeText': 'Critical',
        'mainIconPath': 'assets/icons/tank_low.svg',
        'footerIconPath': 'assets/icons/info_outline.svg',
        'footerText': 'Turn OFF the pump immediately to prevent overflow.',
        'iconColor': const Color(0xFFD32F2F), // Red
        'iconBgColor': const Color(0xFFFFEBEE),
        'badgeTextColor': const Color(0xFFD32F2F),
        'badgeBgColor': const Color(0xFFFFEBEE),
        'badgeDotColor': const Color(0xFFD32F2F),
        'footerIconColor': const Color(0xFFD32F2F),
      };
    }
    
    // Default fallback for unknown types
    return {
        'title': 'System Notification',
        'badgeText': 'Info',
        'mainIconPath': 'assets/icons/info_outline.svg',
        'footerIconPath': 'assets/icons/info_outline.svg',
        'footerText': 'General system update.',
        'iconColor': AppColors.textSecondary,
        'iconBgColor': AppColors.backgroundSoft,
        'badgeTextColor': AppColors.textSecondary,
        'badgeBgColor': AppColors.backgroundSoft,
        'badgeDotColor': null,
        'footerIconColor': AppColors.textSecondary,
    };
  }
}