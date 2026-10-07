import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/usage_provider.dart';
import '../../core/widgets/network_error_widget.dart';
import 'widgets/usage_summary_card.dart';
import 'widgets/breakdown_card.dart';
import 'widgets/usage_tip_card.dart';

class UsageScreen extends StatelessWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UsageProvider>(
      builder: (context, provider, child) {
        
        if (provider.state == UsageViewState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (provider.state == UsageViewState.error) {
          return NetworkErrorWidget(
            message: provider.errorMessage,
            onRetry: provider.fetchUsageData,
          );
        }

        final bool isWeek = provider.isWeekSelected;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Water Usage',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Custom Week/Month Toggle
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => provider.togglePeriod(true),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isWeek ? AppColors.textPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Week',
                              style: TextStyle(
                                color: isWeek ? AppColors.surfaceWhite : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => provider.togglePeriod(false),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isWeek ? AppColors.textPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Month',
                              style: TextStyle(
                                color: !isWeek ? AppColors.surfaceWhite : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Dynamic Summary Card
                UsageSummaryCard(
                  mainTitle: isWeek ? 'Today' : 'This Month',
                  mainValue: isWeek 
                      ? provider.formatNumber(provider.todayUsage) 
                      : provider.formatNumber(provider.periodTotal),
                  subTitle1: isWeek ? 'This week' : 'Weekly Average',
                  subValue1: isWeek 
                      ? provider.formatNumber(provider.periodTotal)
                      : provider.formatNumber((provider.periodTotal / 4).round()),
                  subTitle2: isWeek ? 'Average' : 'Daily Average',
                  subValue2: provider.formatNumber(provider.periodAverage),
                  subUnit2: 'L / day',
                ),
                
                const SizedBox(height: 16),
                
                // Interactive Breakdown Chart
                BreakdownCard(
                  title: isWeek ? 'Daily\nBreakdown' : 'Monthly\nBreakdown',
                  periodLabel: provider.activePeriodLabel,
                  tooltipValue: provider.activeTooltipValue,
                  tooltipAlignment: provider.tooltipAlignment, // Tracks the active bar
                  bars: provider.chartBars.isEmpty 
                      ? [{'label': 'N/A', 'height': 0.0, 'active': false}] 
                      : provider.chartBars,
                  onLeftTap: provider.previousBar,    // Connects left arrow
                  onRightTap: provider.nextBar,       // Connects right arrow
                  onBarTap: provider.selectBarIndex,  // Connects direct bar taps
                ),
                
                const SizedBox(height: 16),
                
                UsageTipCard(
                  tipText: isWeek 
                      ? 'Typical household usage is steady. You have plenty of water reserved, and consumption is well within normal limits.'
                      : 'Your monthly consumption looks great. Household water efficiency remains in the optimal range.',
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