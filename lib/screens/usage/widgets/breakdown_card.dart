import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import 'period_selector.dart';

class BreakdownCard extends StatelessWidget {
  final String title;
  final String periodLabel;
  final String tooltipValue;
  final Alignment tooltipAlignment;
  final List<Map<String, dynamic>> bars;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final Function(int) onBarTap;

  const BreakdownCard({
    super.key,
    required this.title,
    required this.periodLabel,
    required this.tooltipValue,
    required this.tooltipAlignment,
    required this.bars,
    required this.onLeftTap,
    required this.onRightTap,
    required this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.show_chart, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              PeriodSelector(
                label: periodLabel,
                onLeftTap: onLeftTap,
                onRightTap: onRightTap,
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Tooltip container - dynamically aligned
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: tooltipAlignment,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tooltipValue,
                style: const TextStyle(color: AppColors.surfaceWhite, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 140,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashedLine(),
                    _buildDashedLine(),
                    _buildDashedLine(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Convert map to asMap().entries to get the index for the onBarTap callback
                  children: bars.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final data = entry.value;
                    final isActive = data['active'] as bool;
                    
                    return GestureDetector(
                      onTap: () => onBarTap(index),
                      behavior: HitTestBehavior.opaque, // Ensures the tap registers even on empty space above the bar
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            width: bars.length == 4 ? 48 : 32,
                            height: 100 * (data['height'] as double),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primaryBlue : AppColors.backgroundMuted,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data['label'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? AppColors.primaryBlue : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
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
                  decoration: BoxDecoration(color: AppColors.dividerGray.withValues(alpha: 0.5)),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}