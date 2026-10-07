import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../core/widgets/network_error_widget.dart';
import 'widgets/settings_section.dart';
import 'widgets/custom_toggle.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {

        if (provider.state == SettingsViewState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (provider.state == SettingsViewState.error) {
          return NetworkErrorWidget(
            message: provider.errorMessage,
            onRetry: provider.fetchSettings,
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
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
                      title: 'Tank name',
                      subtitle: 'Display name for this tank',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // FIXED: Replaced Expanded with a constrained Container
                          Container(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              provider.tankName,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                      onTap: () => _showStringInputDialog(
                        context: context,
                        title: 'Tank Name',
                        initialValue: provider.tankName,
                        onSave: (val) => provider.updateTankName(val),
                      ),
                    ),
                    SettingsRow(
                      title: 'Tank height',
                      subtitle: 'Physical depth (cm)',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${provider.formatNumber(provider.tankHeight)} cm',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                      onTap: () => _showNumericInputDialog(
                        context: context,
                        title: 'Tank Height (cm)',
                        initialValue: provider.tankHeight.toString(),
                        onSave: (val) => provider.updateTankHeight(val),
                      ),
                    ),
                    SettingsRow(
                      title: 'Tank capacity',
                      subtitle: 'Household water storage',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${provider.formatNumber(provider.tankCapacity)} L',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                      onTap: () => _showNumericInputDialog(
                        context: context,
                        title: 'Tank Capacity (Liters)',
                        initialValue: provider.tankCapacity.toString(),
                        onSave: (val) => provider.updateCapacity(val),
                      ),
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
                        value: provider.isAutoModeOn,
                        onChanged: (val) => provider.updatePumpConfig(autoMode: val),
                      ),
                    ),
                    SettingsRow(
                      title: 'Low Threshold',
                      subtitle: 'Start pump when level drops below',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${provider.lowThreshold}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                      onTap: () => _showNumericInputDialog(
                        context: context,
                        title: 'Low Threshold',
                        initialValue: provider.lowThreshold.toString(),
                        onSave: (val) => provider.updatePumpConfig(low: val),
                      ),
                    ),
                    SettingsRow(
                      title: 'High Threshold',
                      subtitle: 'Stop pump when level reaches',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${provider.highThreshold}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                      onTap: () => _showNumericInputDialog(
                        context: context,
                        title: 'High Threshold',
                        initialValue: provider.highThreshold.toString(),
                        onSave: (val) => provider.updatePumpConfig(high: val),
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
                        value: provider.isLowAlertsOn,
                        onChanged: provider.toggleLowAlerts,
                      ),
                    ),
                    SettingsRow(
                      title: 'High water alerts',
                      subtitle: 'Notify when tank is nearly full',
                      trailing: CustomToggle(
                        value: provider.isHighAlertsOn,
                        onChanged: provider.toggleHighAlerts,
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
                      onTap: () {},
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
      },
    );
  }

  // A reusable popup dialog with a numeric text field
  void _showNumericInputDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(int) onSave,
  }) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundSoft,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final int? newValue = int.tryParse(controller.text);
                if (newValue != null) {
                  onSave(newValue);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save', style: TextStyle(color: AppColors.surfaceWhite)),
            ),
          ],
        );
      },
    );
  }

  // A reusable popup dialog with a standard text field
  void _showStringInputDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundSoft,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save', style: TextStyle(color: AppColors.surfaceWhite)),
            ),
          ],
        );
      },
    );
  }
}