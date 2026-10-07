import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/home_provider.dart';
import '../../core/widgets/network_error_widget.dart';
import 'widgets/tank_level_card.dart';
import 'widgets/metric_card.dart';
import 'widgets/pump_control_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.state == ViewState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (provider.state == ViewState.error) {
          return NetworkErrorWidget(
            message: provider.errorMessage,
            onRetry: provider.fetchDashboardData,
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                // UPDATED: Now displays the dynamic tank name
                Text(
                  provider.tankName, 
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                TankLevelCard(
                  levelPercent: provider.tankLevel,
                  remainingLiters: provider.remainingLiters,
                  totalCapacity: provider.tankCapacity, // UPDATED: Passed dynamic capacity
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    MetricCard(
                      icon: Icons.power_settings_new,
                      title: 'Pump',
                      mainText: provider.isPumpOn ? 'ON' : 'OFF',
                      subText: provider.isPumpOn ? 'Running' : 'Resting',
                    ),
                    const SizedBox(width: 12),
                    MetricCard(
                      icon: Icons.water_drop_outlined,
                      title: 'Today',
                      mainText: provider.todayUsage.toString(),
                      suffix: 'L',
                      subText: 'Used so far',
                    ),
                    const SizedBox(width: 12),
                    MetricCard(
                      icon: Icons.sync,
                      title: 'Updated',
                      mainText: '${DateTime.now().difference(provider.lastSync).inSeconds}s',
                      suffix: 'ago',
                      subText: 'Live sync',
                      subTextColor: AppColors.primaryBlue,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                PumpControlCard(
                  isPumpOn: provider.isPumpOn,
                  isAutoModeOn: provider.isAutoModeOn,
                  onToggle: provider.togglePump,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}