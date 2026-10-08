import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // <-- Added import
import 'app/app.dart';
import 'providers/home_provider.dart';
import 'providers/usage_provider.dart';
import 'providers/alerts_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  // 1. Ensure Flutter bindings are ready before interacting with native splash
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Preserve the splash screen while the app boots up
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UsageProvider()),
        ChangeNotifierProvider(create: (_) => AlertsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const AquaMetricsApp(),
    ),
  );

  // 3. Remove the splash screen. 
  // We use a small 1-second delay so the UI and providers have time to load their initial data.
  // (For a perfectly seamless experience, you can move this remove() call into your 
  // HomeProvider's fetchDashboardData method right after state = ViewState.loaded)
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
}