import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

enum UsageViewState { loading, loaded, error }

class UsageProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  UsageViewState state = UsageViewState.loading;
  String errorMessage = '';

  final int tankId = 1;
  bool isWeekSelected = true;

  // Summary Metrics
  int todayUsage = 0;
  int periodTotal = 0;
  int periodAverage = 0;

  // Caching and Chart Data
  List<dynamic> _cachedDataArray = [];
  int _selectedIndex = -1;
  double _maxConsumption = 0.1;
  
  List<Map<String, dynamic>> chartBars = [];
  String activeTooltipValue = '';
  String activePeriodLabel = '';
  Alignment tooltipAlignment = Alignment.center;

  UsageProvider() {
    fetchUsageData();
  }

  void togglePeriod(bool isWeek) {
    if (isWeekSelected == isWeek) return;
    isWeekSelected = isWeek;
    fetchUsageData();
  }

  Future<void> fetchUsageData() async {
    state = UsageViewState.loading;
    notifyListeners();

    try {
      final String periodParam = isWeekSelected ? 'daily' : 'weekly';

      final results = await Future.wait([
        _api.getTodayUsage(tankId),
        _api.getUsageHistory(tankId, periodParam),
      ]);

      final todayData = results[0];
      final historyData = results[1];

      // Parse Today's Usage
      final num rawToday = todayData['total_consumed_liters'] ?? 0.0;
      todayUsage = rawToday.round();

      // Parse Period Totals
      final num rawTotal = historyData['total_consumed_liters'] ?? 0.0;
      final num rawAvg = historyData['average_consumption_per_period_liters'] ?? 0.0;
      periodTotal = rawTotal.round();
      periodAverage = rawAvg.round();

      // Cache the array for instant interactive scrubbing
      _cachedDataArray = historyData['data'] ?? [];
      _selectedIndex = _cachedDataArray.length - 1; // Default to the latest day

      // Calculate the maximum value once
      _maxConsumption = 0.1;
      for (var item in _cachedDataArray) {
        final double consumed = (item['consumed_liters'] ?? 0.0).toDouble();
        if (consumed > _maxConsumption) {
          _maxConsumption = consumed;
        }
      }

      // Process the visual bars
      _updateChartBars();

      state = UsageViewState.loaded;
    } on DioException catch (e) {
      state = UsageViewState.error;
      errorMessage = 'Failed to load usage data. Please check your network.';
    } catch (e) {
      state = UsageViewState.error;
      errorMessage = 'An unexpected error occurred.';
    }

    notifyListeners();
  }

  // Iterates through the cached array to build the visual bars based on the current _selectedIndex
  void _updateChartBars() {
    chartBars.clear();
    for (int i = 0; i < _cachedDataArray.length; i++) {
      final item = _cachedDataArray[i];
      final double consumed = (item['consumed_liters'] ?? 0.0).toDouble();
      
      String rawLabel = item['short_label'] ?? '';
      String chartLabel = isWeekSelected ? rawLabel.split(' ').first : rawLabel;

      final bool isActive = (i == _selectedIndex);

      chartBars.add({
        'label': chartLabel,
        'height': (consumed / _maxConsumption).clamp(0.0, 1.0),
        'active': isActive,
      });

      if (isActive) {
        activeTooltipValue = '${formatNumber(consumed.round())} L';
        activePeriodLabel = item['short_label'] ?? chartLabel; 
        
        // Dynamically calculate tooltip alignment (-1.0 is left edge, 1.0 is right edge)
        if (_cachedDataArray.length > 1) {
          double xPos = -1.0 + (2.0 * i / (_cachedDataArray.length - 1));
          tooltipAlignment = Alignment(xPos, 0);
        } else {
          tooltipAlignment = Alignment.center;
        }
      }
    }
  }

  // --- Interaction Methods ---
  
  void selectBarIndex(int index) {
    if (_cachedDataArray.isEmpty) return;
    if (index < 0 || index >= _cachedDataArray.length) return; // Prevent out of bounds
    if (_selectedIndex == index) return; // Ignore if already selected
    
    _selectedIndex = index;
    _updateChartBars();
    notifyListeners();
  }

  void previousBar() {
    selectBarIndex(_selectedIndex - 1);
  }

  void nextBar() {
    selectBarIndex(_selectedIndex + 1);
  }

  // Helper
  String formatNumber(int number) {
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}