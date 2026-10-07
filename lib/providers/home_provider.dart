import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../core/cache/tank_cache.dart';

enum ViewState { loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  ViewState state = ViewState.loading;
  String errorMessage = '';

  String tankName = 'Loading...'; 
  int tankCapacity = 1000;        
  int tankLevel = 0;
  int remainingLiters = 0;
  int todayUsage = 0;
  bool isPumpOn = false;
  bool isAutoModeOn = true; // <-- Added
  DateTime lastSync = DateTime.now();

  final int tankId = 1;
  Timer? _pollingTimer;

  HomeProvider() {
    TankCache().addListener(_syncWithCache);
    fetchDashboardData();
  }

  void _syncWithCache() {
    bool changed = false;
    if (TankCache().tankName != null && TankCache().tankName != tankName) {
      tankName = TankCache().tankName!;
      changed = true;
    }
    if (TankCache().tankCapacity != null && TankCache().tankCapacity != tankCapacity) {
      tankCapacity = TankCache().tankCapacity!;
      remainingLiters = ((tankLevel / 100) * tankCapacity).round();
      changed = true;
    }
    if (TankCache().isAutoModeOn != null && TankCache().isAutoModeOn != isAutoModeOn) {
      isAutoModeOn = TankCache().isAutoModeOn!; // <-- Added
      changed = true;
    }
    if (changed) notifyListeners();
  }

  bool _checkIfPumpIsOn(dynamic pumpValue) {
    if (pumpValue == null) return false;
    if (pumpValue == 1 || pumpValue == '1' || pumpValue == true || pumpValue.toString().toUpperCase() == 'ON') {
      return true;
    }
    return false;
  }

  Future<void> fetchDashboardData() async {
    state = ViewState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _api.getTankLevel(tankId),
        _api.getTodayUsage(tankId),
        _api.getPumpStatus(tankId), 
        _api.getPumpConfig(tankId), // <-- Fetch config on app start
      ]);

      final levelData = results[0];
      final usageData = results[1];
      final pumpData = results[2];
      final configData = results[3]; // <-- Added

      final autoModeRaw = configData['auto_mode'];
      isAutoModeOn = (autoModeRaw == true || autoModeRaw == 1 || autoModeRaw == 'true' || autoModeRaw == 'ON');

      if (!TankCache().hasData) {
        TankCache().update(
          name: usageData['tank_name']?.toString(),
          capacity: (usageData['capacity_liters'] as num?)?.round(),
          autoMode: isAutoModeOn,
        );
      } else {
        TankCache().update(autoMode: isAutoModeOn);
        _syncWithCache();
      }

      final num rawLevel = levelData['water_level_percent'] ?? 0.0;
      tankLevel = rawLevel.round();
      remainingLiters = ((rawLevel / 100) * tankCapacity).round();
      isPumpOn = _checkIfPumpIsOn(pumpData['pump']);
      final num rawUsage = usageData['total_consumed_liters'] ?? 0.0;
      todayUsage = rawUsage.round(); 
      lastSync = DateTime.now();

      state = ViewState.loaded;
      notifyListeners();

      _startPolling();

    } on DioException catch (e) {
      state = ViewState.error;
      errorMessage = 'No internet connection. Please check your network and try again.';
      notifyListeners();
    } catch (e) {
      state = ViewState.error;
      errorMessage = 'An unexpected error occurred.';
      notifyListeners();
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final results = await Future.wait([
          _api.getTankLevel(tankId),
          _api.getPumpStatus(tankId),
        ]);
        
        final levelData = results[0];
        final pumpData = results[1];
        
        final num rawLevel = levelData['water_level_percent'] ?? 0.0;
        tankLevel = rawLevel.round();
        remainingLiters = ((rawLevel / 100) * tankCapacity).round();
        isPumpOn = _checkIfPumpIsOn(pumpData['pump']); 
        
        lastSync = DateTime.now();
        notifyListeners();
      } catch (e) {
        print('Live sync failed: $e');
      }
    });
  }

  Future<void> togglePump() async {
    final command = isPumpOn ? 'OFF' : 'ON';
    isPumpOn = !isPumpOn;
    notifyListeners();

    try {
      await _api.togglePump(tankId, command);
      final pumpData = await _api.getPumpStatus(tankId);
      isPumpOn = _checkIfPumpIsOn(pumpData['pump']);
      notifyListeners();
    } catch (e) {
      isPumpOn = !isPumpOn;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    TankCache().removeListener(_syncWithCache);
    _pollingTimer?.cancel();
    super.dispose();
  }
}