import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class DailyBreakdownCard extends StatelessWidget {
  const DailyBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the bars: height percentages and labels
    final bars = [
      {'day': 'Mon', 'height': 0.4, 'active': false},
      {'day': 'Tue', 'height': 0.5, 'active': false},
      {'day': 'Wed', 'height': 0.7, 'active': false},
      {'day': 'Thu', 'height': 0.45, 'active': false},
      {'day': 'Fri', 'height': 0.9, 'active': true}, // Highlighted day
      {'day': 'Sat', 'height': 0.6, 'active': false},
      {'day': 'Sun', 'height': 0.35, 'active': false},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.show_chart, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  const Text(
                    'Daily\nBreakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_left, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text(
                      'Friday',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Tooltip mock for Friday
          Align(
            alignment: const Alignment(0.25, 0), // Roughly aligns over Friday
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '340 L',
                style: TextStyle(color: AppColors.surfaceWhite, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Custom Bar Chart
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                // Horizontal grid lines
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashedLine(),
                    _buildDashedLine(),
                    _buildDashedLine(),
                  ],
                ),
                // Bars
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: bars.map((data) {
                    final isActive = data['active'] as bool;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 32,
                          height: 100 * (data['height'] as double),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primaryBlue : AppColors.primaryBlueLight,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['day'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive ? AppColors.primaryBlue : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 4.0;
          const dashSpace = 4.0;
          final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
          return Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.dividerGray.withOpacity(0.5)),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}