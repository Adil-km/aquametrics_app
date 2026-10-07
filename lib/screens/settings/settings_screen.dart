import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'widgets/settings_section.dart';
import 'widgets/custom_toggle.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for the toggles
  bool isAutoModeOn = true;
  bool isLowAlertsOn = true;
  bool isHighAlertsOn = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your household water preferences.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Tank Section
            SettingsSection(
              title: 'TANK',
              children: [
                SettingsRow(
                  title: 'Tank capacity',
                  subtitle: 'Household water storage',
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '1,000 L',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                  onTap: () {
                    // Navigate or open modal
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pump Section
            SettingsSection(
              title: 'PUMP',
              children: [
                SettingsRow(
                  title: 'Automatic mode',
                  subtitle: 'Automatically refills when water is low',
                  trailing: CustomToggle(
                    value: isAutoModeOn,
                    onChanged: (val) {
                      setState(() => isAutoModeOn = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notifications Section
            SettingsSection(
              title: 'NOTIFICATIONS',
              children: [
                SettingsRow(
                  title: 'Low water alerts',
                  subtitle: 'Notify when water drops low',
                  trailing: CustomToggle(
                    value: isLowAlertsOn,
                    onChanged: (val) {
                      setState(() => isLowAlertsOn = val);
                    },
                  ),
                ),
                SettingsRow(
                  title: 'High water alerts',
                  subtitle: 'Notify when tank is nearly full',
                  trailing: CustomToggle(
                    value: isHighAlertsOn,
                    onChanged: (val) {
                      setState(() => isHighAlertsOn = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // System Section
            SettingsSection(
              title: 'SYSTEM',
              children: [
                SettingsRow(
                  title: 'App version',
                  subtitle: 'Up to date',
                  trailing: const Text(
                    'v1.4.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onTap: () {}, // Might tap to check for updates
                ),
                SettingsRow(
                  title: 'Support & Help',
                  subtitle: 'FAQs and customer contact',
                  trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Advanced Technical Settings Footer
            Center(
              child: GestureDetector(
                onTap: () {
                  print('Advanced settings tapped');
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.settings_outlined, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text(
                      'ADVANCED TECHNICAL SETTINGS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}