import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../core/cache/tank_cache.dart';

enum SettingsViewState { loading, loaded, error }

class SettingsProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  SettingsViewState state = SettingsViewState.loading;
  String errorMessage = '';
  final int tankId = 1;

  // Local state for UI
  String tankName = "Main Overhead Tank";
  int tankHeight = 200;
  int tankCapacity = 1000;
  
  bool isAutoModeOn = true;
  int lowThreshold = 160;
  int highThreshold = 30;
  
  bool isLowAlertsOn = true;
  bool isHighAlertsOn = false;

  SettingsProvider() {
    // Listen to cache changes to update UI instantly
    TankCache().addListener(_syncWithCache);
    fetchSettings();
  }

  void _syncWithCache() {
    if (TankCache().tankName != null) tankName = TankCache().tankName!;
    if (TankCache().tankHeight != null) tankHeight = TankCache().tankHeight!;
    if (TankCache().tankCapacity != null) tankCapacity = TankCache().tankCapacity!;
    notifyListeners();
  }

  Future<void> fetchSettings() async {
    state = SettingsViewState.loading;
    notifyListeners();

    try {
      // Always fetch pump config
      final futures = <Future<dynamic>>[_api.getPumpConfig(tankId)];
      
      // ONLY fetch tank info if it's not already cached
      final bool needsTankFetch = !TankCache().hasData;
      if (needsTankFetch) {
        futures.add(_api.getTankInfo(tankId));
      }

      final results = await Future.wait(futures);
      final configData = results[0];

      if (needsTankFetch) {
        final tankData = results[1];
        TankCache().update(
          name: tankData['name']?.toString(),
          height: (tankData['height'] as num?)?.round(),
          capacity: (tankData['capacity'] as num?)?.round(),
        );
      } else {
        // If we didn't fetch, load existing cache into local variables
        _syncWithCache();
      }

      // Parse Pump Config
      final autoModeRaw = configData['auto_mode'];
      isAutoModeOn = (autoModeRaw == true || autoModeRaw == 1 || autoModeRaw == 'true' || autoModeRaw == 'ON');
      lowThreshold = (configData['low_threshold'] as num?)?.round() ?? lowThreshold;
      highThreshold = (configData['high_threshold'] as num?)?.round() ?? highThreshold;

      state = SettingsViewState.loaded;
    } on DioException catch (e) {
      state = SettingsViewState.error;
      errorMessage = 'Failed to load settings. Please check your network.';
    } catch (e) {
      state = SettingsViewState.error;
      errorMessage = 'An unexpected error occurred.';
    }
    notifyListeners();
  }

  // --- Optimistic Updates with Cache ---

  Future<void> updateTankName(String newName) async {
    final cleanName = newName.trim();
    if (cleanName == tankName || cleanName.isEmpty) return;

    final oldName = tankName;
    TankCache().update(name: cleanName); // Updates cache & UI instantly

    try {
      await _api.updateTankInfo(tankId, {"name": cleanName, "height": tankHeight, "capacity": tankCapacity});
    } catch (e) {
      TankCache().update(name: oldName); // Revert on failure
    }
  }

  Future<void> updateTankHeight(int newHeight) async {
    if (newHeight == tankHeight) return;
    
    final oldHeight = tankHeight;
    TankCache().update(height: newHeight);

    try {
      await _api.updateTankInfo(tankId, {"name": tankName, "height": newHeight, "capacity": tankCapacity});
    } catch (e) {
      TankCache().update(height: oldHeight);
    }
  }

  Future<void> updateCapacity(int newCapacity) async {
    if (newCapacity == tankCapacity) return;

    final oldCapacity = tankCapacity;
    TankCache().update(capacity: newCapacity);

    try {
      await _api.updateTankInfo(tankId, {"name": tankName, "height": tankHeight, "capacity": newCapacity});
    } catch (e) {
      TankCache().update(capacity: oldCapacity);
    }
  }

  // Pump Config Update (Not cached globally as Home doesn't need thresholds)
  Future<void> updatePumpConfig({bool? autoMode, int? low, int? high}) async {
    final newAutoMode = autoMode ?? isAutoModeOn;
    final newLow = low ?? lowThreshold;
    final newHigh = high ?? highThreshold;

    if (newAutoMode == isAutoModeOn && newLow == lowThreshold && newHigh == highThreshold) return;

    final oldAutoMode = isAutoModeOn;
    final oldLow = lowThreshold;
    final oldHigh = highThreshold;

    isAutoModeOn = newAutoMode;
    lowThreshold = newLow;
    highThreshold = newHigh;
    
    TankCache().update(autoMode: newAutoMode); // <-- ADDED THIS LINE to sync with Home Screen
    notifyListeners();

    try {
      await _api.updatePumpConfig(tankId, {
        "auto_mode": newAutoMode,
        "low_threshold": newLow,
        "high_threshold": newHigh,
      });
      print('Pump config updated successfully');
    } catch (e) {
      isAutoModeOn = oldAutoMode;
      lowThreshold = oldLow;
      highThreshold = oldHigh;
      TankCache().update(autoMode: oldAutoMode); // <-- Revert cache on error
      notifyListeners();
    }
  }

  void toggleLowAlerts(bool val) { isLowAlertsOn = val; notifyListeners(); }
  void toggleHighAlerts(bool val) { isHighAlertsOn = val; notifyListeners(); }

  String formatNumber(int number) {
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  void dispose() {
    TankCache().removeListener(_syncWithCache);
    super.dispose();
  }
}