import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  
  // Updated to use your computer's tethered IP address
  final String baseUrl = 'http://192.168.13.80:8000';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  // Gets the current tank level
  Future<Map<String, dynamic>> getTankLevel(int tankId) async {
    final response = await _dio.get('/tanks/$tankId/level');
    return response.data;
  }

  // Gets today's consumption history
  Future<Map<String, dynamic>> getTodayUsage(int tankId) async {
    final response = await _dio.get('/tanks/$tankId/history/today');
    return response.data;
  }

  // Gets the current pump status
  Future<Map<String, dynamic>> getPumpStatus(int tankId) async {
    final response = await _dio.get('/tanks/$tankId/pump');
    return response.data;
  }

  // Toggles the pump ON or OFF
  Future<void> togglePump(int tankId, String command) async {
    await _dio.post('/tanks/$tankId/pump', data: {'command': command});
  }

  Future<Map<String, dynamic>> getUsageHistory(int tankId, String period) async {
    final response = await _dio.get(
      '/tanks/$tankId/history/usage',
      queryParameters: {'period': period},
    );
    return response.data;
  }

  Future<List<dynamic>> getAlerts(int tankId) async {
    final response = await _dio.get('/tanks/$tankId/alerts');
    return response.data;
  }

  // Gets current tank information (capacity, height)
  Future<Map<String, dynamic>> getTankInfo(int tankId) async {
    final response = await _dio.get('/tanks/$tankId');
    return response.data;
  }

  // Updates tank information
  Future<void> updateTankInfo(int tankId, Map<String, dynamic> data) async {
    await _dio.put('/tanks/$tankId', data: data);
  }

  // Gets current pump configuration thresholds
  Future<Map<String, dynamic>> getPumpConfig(int tankId) async {
    final response = await _dio.get('/tanks/$tankId/pump/config');
    return response.data;
  }

  // Updates pump configuration thresholds
  Future<void> updatePumpConfig(int tankId, Map<String, dynamic> data) async {
    await _dio.post('/tanks/$tankId/pump/config', data: data);
  }
}