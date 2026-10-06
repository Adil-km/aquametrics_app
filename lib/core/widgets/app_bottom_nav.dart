import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Handles your vector graphics

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Helper method to build standard SVG icons with state-based color filters
  Widget _buildSvgIcon(String assetPath, bool isActive) {
    return SvgPicture.asset(
      assetPath,
      width: 24.0,
      height: 24.0,
      colorFilter: ColorFilter.mode(
        isActive ? AppColors.primaryBlue : AppColors.textTertiary,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.backgroundMainTranslucent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8.0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.backgroundMainTranslucent,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed, // Forces all 4 items to always show
        elevation: 0,
        items: [
          // HOME TAB
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/icons/home_outline.svg', currentIndex == 0),
            activeIcon: _buildSvgIcon('assets/icons/home_filled.svg', currentIndex == 0),
            label: 'Home',
          ),
          
          // USAGE TAB
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/icons/usage_outline.svg', currentIndex == 1),
            activeIcon: _buildSvgIcon('assets/icons/usage_filled.svg', currentIndex == 1),
            label: 'Usage',
          ),
          
          // ALERTS TAB
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/icons/alerts_outline.svg', currentIndex == 2),
            activeIcon: _buildSvgIcon('assets/icons/alerts_filled.svg', currentIndex == 2),
            label: 'Alerts',
          ),
          
          // SETTINGS TAB
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/icons/settings_outline.svg', currentIndex == 3),
            activeIcon: _buildSvgIcon('assets/icons/settings_filled.svg', currentIndex == 3),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
