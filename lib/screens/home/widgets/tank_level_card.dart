import 'package:aquametrics/app/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class TankLevelCard extends StatelessWidget {
  final int levelPercent;
  final int remainingLiters;
  final int totalCapacity;

  const TankLevelCard({
    super.key,
    required this.levelPercent,
    required this.remainingLiters,
    this.totalCapacity = 1000,
  });

  @override
  Widget build(BuildContext context) {
    final double levelFactor = (levelPercent / 100.0).clamp(0.0, 1.0);
    final bool isLow = levelPercent <= 20;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLow
                      ? const Color(0xFFFFF3E0) // Light orange tint
                      : const Color(0xFFE6F7ED), // Light green tint
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isLow ? const Color(0xFFE65100) : const Color(0xFF00C853),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLow ? 'Water level is low' : 'Water level is healthy',
                      style: TextStyle(
                        color: isLow ? const Color(0xFFE65100) : const Color(0xFF00796B),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Total ${totalCapacity.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} L',
                style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Tank Graphic and Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: levelFactor,
                      widthFactor: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primaryBlue,
                              AppColors.primaryBlue.withValues(alpha: 0.5),
                              AppColors.primaryBlue.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              // Percentage Text wrapped in a fixed-width box to prevent layout shifting
              SizedBox(
                width: 140, // Keeps the layout rigid regardless of text length
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Level',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$levelPercent',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '$remainingLiters',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          ' L remaining',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}