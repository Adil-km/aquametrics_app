import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

enum ViewState { loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  ViewState state = ViewState.loading;
  String errorMessage = '';

  // Data fields
  int tankLevel = 0;
  int remainingLiters = 0;
  int todayUsage = 0;
  bool isPumpOn = false;
  DateTime lastSync = DateTime.now();

  final int tankId = 1;
  final int tankCapacity = 1000;
  
  Timer? _pollingTimer;

  HomeProvider() {
    fetchDashboardData();
  }

  // Bulletproof parser to handle any data type the API might return for the pump state
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
      // Fetch all three endpoints on initial load to ensure perfect sync
      final results = await Future.wait([
        _api.getTankLevel(tankId),
        _api.getTodayUsage(tankId),
        _api.getPumpStatus(tankId), 
      ]);

      final levelData = results[0];
      final usageData = results[1];
      final pumpData = results[2];

      final num rawLevel = levelData['water_level_percent'] ?? 0.0;
      tankLevel = rawLevel.round();
      remainingLiters = ((rawLevel / 100) * tankCapacity).round();

      // Ensure we parse the dedicated pump data using the helper
      isPumpOn = _checkIfPumpIsOn(pumpData['pump']);

      todayUsage = usageData['total_consumption'] ?? 0; 
      lastSync = DateTime.now();

      state = ViewState.loaded;
      notifyListeners();

      _startPolling();

    } on DioException catch (e) {
      state = ViewState.error;
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network and try again.';
      } else {
        errorMessage = 'Failed to load dashboard data. Server responded with an error.';
      }
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
        // Poll both endpoints to keep everything perfectly synced
        final results = await Future.wait([
          _api.getTankLevel(tankId),
          _api.getPumpStatus(tankId),
        ]);
        
        final levelData = results[0];
        final pumpData = results[1];
        
        final num rawLevel = levelData['water_level_percent'] ?? 0.0;
        
        tankLevel = rawLevel.round();
        remainingLiters = ((rawLevel / 100) * tankCapacity).round();
        
        // Instantly updates the UI if the backend changes
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
    
    // Optimistic UI update
    isPumpOn = !isPumpOn;
    notifyListeners();

    try {
      await _api.togglePump(tankId, command);
      
      // Force a sync to confirm the backend accepted the command
      final pumpData = await _api.getPumpStatus(tankId);
      isPumpOn = _checkIfPumpIsOn(pumpData['pump']);
      notifyListeners();
    } catch (e) {
      // Revert if API fails
      isPumpOn = !isPumpOn;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}