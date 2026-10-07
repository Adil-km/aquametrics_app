import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'widgets/tank_level_card.dart';
import 'widgets/metric_card.dart';
import 'widgets/pump_control_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Main Water Tank',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            const TankLevelCard(),
            
            const SizedBox(height: 16),
            
            // Metrics Row
            const Row(
              children: [
                MetricCard(
                  icon: Icons.power_settings_new,
                  title: 'Pump',
                  mainText: 'OFF',
                  subText: 'Resting',
                ),
                SizedBox(width: 12),
                MetricCard(
                  icon: Icons.water_drop_outlined,
                  title: 'Today',
                  mainText: '340',
                  suffix: 'L',
                  subText: 'Used so far',
                ),
                SizedBox(width: 12),
                MetricCard(
                  icon: Icons.sync,
                  title: 'Updated',
                  mainText: '12s',
                  suffix: 'ago',
                  subText: 'Live sync',
                  subTextColor: AppColors.primaryBlue,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            const PumpControlCard(),
            
            // Extra padding at the bottom for scroll clearance
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}