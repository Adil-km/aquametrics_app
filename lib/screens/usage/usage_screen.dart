import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'widgets/usage_summary_card.dart';
import 'widgets/breakdown_card.dart';
import 'widgets/usage_tip_card.dart';

class UsageScreen extends StatefulWidget {
  const UsageScreen({super.key});

  @override
  State<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  bool isWeekSelected = true;

  @override
  Widget build(BuildContext context) {
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
                      onTap: () => setState(() => isWeekSelected = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isWeekSelected ? AppColors.textPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Week',
                          style: TextStyle(
                            color: isWeekSelected ? AppColors.surfaceWhite : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isWeekSelected = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isWeekSelected ? AppColors.textPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Month',
                          style: TextStyle(
                            color: !isWeekSelected ? AppColors.surfaceWhite : AppColors.textSecondary,
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
            
            if (isWeekSelected) ...[
              const UsageSummaryCard(
                mainTitle: 'Today',
                mainValue: '340',
                subTitle1: 'This week',
                subValue1: '2,140',
                subTitle2: 'Average',
                subValue2: '305',
                subUnit2: 'L / day',
              ),
              const SizedBox(height: 16),
              BreakdownCard(
                title: 'Daily\nBreakdown',
                periodLabel: 'Friday',
                tooltipValue: '340 L',
                tooltipAlignment: const Alignment(0.25, 0), // Roughly aligns over Friday
                bars: const [
                  {'label': 'Mon', 'height': 0.4, 'active': false},
                  {'label': 'Tue', 'height': 0.5, 'active': false},
                  {'label': 'Wed', 'height': 0.7, 'active': false},
                  {'label': 'Thu', 'height': 0.45, 'active': false},
                  {'label': 'Fri', 'height': 0.9, 'active': true},
                  {'label': 'Sat', 'height': 0.6, 'active': false},
                  {'label': 'Sun', 'height': 0.35, 'active': false},
                ],
              ),
              const SizedBox(height: 16),
              const UsageTipCard(
                tipText: 'Typical household usage is steady. You have plenty of water reserved, and consumption is well within...',
              ),
            ] else ...[
              const UsageSummaryCard(
                mainTitle: 'This Month',
                mainValue: '9,420',
                subTitle1: 'Weekly Average',
                subValue1: '2,210',
                subTitle2: 'Daily Average',
                subValue2: '304',
                subUnit2: 'L / day',
              ),
              const SizedBox(height: 16),
              BreakdownCard(
                title: 'Monthly\nBreakdown',
                periodLabel: 'October',
                tooltipValue: '2,430 L',
                tooltipAlignment: const Alignment(0.85, 0), // Roughly aligns over Week 4
                bars: const [
                  {'label': 'Week 1', 'height': 0.5, 'active': false},
                  {'label': 'Week 2', 'height': 0.7, 'active': false},
                  {'label': 'Week 3', 'height': 0.6, 'active': false},
                  {'label': 'Week 4', 'height': 0.95, 'active': true},
                ],
              ),
              const SizedBox(height: 16),
              const UsageTipCard(
                tipText: 'Your monthly consumption is 4% lower than last month. Household water efficiency remains in the...',
              ),
            ],
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}