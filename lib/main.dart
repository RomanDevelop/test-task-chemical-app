import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/lsi_calculator_screen.dart';
import 'views/splash_screen.dart';
import 'services/lsi_api_service.dart';
import 'services/token_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TokenStorageService.initializeDefaultToken();
  LSIApiService.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LSI Calculator',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const _Root(),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(next: const LSICalculatorScreen());
  }
}
