import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_colors.dart';

class AlertCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final String date;
  final String mainIconPath;
  final String footerIconPath;
  final String footerText;
  final String badgeText;
  
  // Dynamic theming properties
  final Color iconColor;
  final Color iconBgColor;
  final Color badgeTextColor;
  final Color badgeBgColor;
  final Color? badgeDotColor;
  final Color footerIconColor;

  const AlertCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.date,
    required this.mainIconPath,
    required this.footerIconPath,
    required this.footerText,
    required this.badgeText,
    required this.iconColor,
    required this.iconBgColor,
    required this.badgeTextColor,
    required this.badgeBgColor,
    this.badgeDotColor,
    required this.footerIconColor,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Main Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgPicture.asset(
                  mainIconPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  errorBuilder: (context, error, stackTrace) => 
                      Icon(Icons.warning_amber_rounded, color: iconColor),
                ),
              ),
              const SizedBox(width: 16),
              
              // Right Content Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Time Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              date,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.dividerGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (badgeDotColor != null) ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: badgeDotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Body Text
                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Footer Message Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: SvgPicture.asset(
                    footerIconPath,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(footerIconColor, BlendMode.srcIn),
                    errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.info_outline, size: 16, color: footerIconColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    footerText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}