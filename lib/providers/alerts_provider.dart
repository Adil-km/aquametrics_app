import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

enum AlertsViewState { loading, loaded, error }

class AlertsProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  AlertsViewState state = AlertsViewState.loading;
  String errorMessage = '';

  final int tankId = 1;
  
  // This will store only the latest alert for each type
  List<Map<String, dynamic>> filteredAlerts = [];

  AlertsProvider() {
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    state = AlertsViewState.loading;
    notifyListeners();

    try {
      final List<dynamic> rawAlerts = await _api.getAlerts(tankId);
      
      // Filter logic: Keep only the latest alert for each 'type'
      // Assuming the API returns the newest alerts first, the first time we see 
      // a type is the most recent one.
      final Map<String, Map<String, dynamic>> latestAlertsMap = {};
      
      for (var item in rawAlerts) {
        final alert = item as Map<String, dynamic>;
        final String type = alert['type'];
        
        if (!latestAlertsMap.containsKey(type)) {
          latestAlertsMap[type] = alert;
        }
      }

      filteredAlerts = latestAlertsMap.values.toList();
      state = AlertsViewState.loaded;

    } on DioException catch (e) {
      state = AlertsViewState.error;
      errorMessage = 'Failed to load alerts. Please check your network.';
    } catch (e) {
      state = AlertsViewState.error;
      errorMessage = 'An unexpected error occurred.';
    }

    notifyListeners();
  }

  // --- Formatting Helpers ---

  String formatTime(String isoString) {
    final DateTime dt = DateTime.parse(isoString).toLocal();
    int h = dt.hour;
    int m = dt.minute;
    final String ampm = h >= 12 ? 'PM' : 'AM';
    
    h = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final String mm = m.toString().padLeft(2, '0');
    
    return '$h:$mm $ampm';
  }

  String formatDate(String isoString) {
    final DateTime dt = DateTime.parse(isoString).toLocal();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime alertDate = DateTime(dt.year, dt.month, dt.day);
    
    if (alertDate == today) return 'Today';
    if (alertDate == today.subtract(const Duration(days: 1))) return 'Yesterday';
    
    const List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}';
  }
}