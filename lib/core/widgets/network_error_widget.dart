import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const NetworkErrorWidget({
    super.key,
    required this.onRetry,
    this.message = 'Unable to connect to the system. Please check your network.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            const Text(
              'Connection Error',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.surfaceWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}