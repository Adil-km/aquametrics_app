import 'package:aquametrics/app/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class PumpControlCard extends StatelessWidget {
  final bool isPumpOn;
  final VoidCallback onToggle;

  const PumpControlCard({
    super.key,
    required this.isPumpOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Water Pump',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPumpOn
                      ? AppColors.primaryBlueLight.withOpacity(0.4)
                      : AppColors.backgroundSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isPumpOn ? 'Pump ON' : 'Pump OFF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isPumpOn ? AppColors.primaryBlue : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPumpOn ? const Color(0xFFC62828) : AppColors.primaryBlue,
                foregroundColor: AppColors.surfaceWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.power_settings_new),
                  const SizedBox(width: 8),
                  Text(
                    isPumpOn ? 'Turn Pump OFF' : 'Turn Pump ON',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPumpOn ? Icons.sync : Icons.check_circle_outline,
                size: 16,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 6),
              Text(
                isPumpOn
                    ? 'Pump is actively running refills'
                    : 'Automatic mode is taking care of refills',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}