import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/db_helper.dart';
import 'utils/theme.dart';
import 'views/splash/splash_view.dart';

void main() async {
  // Ensure that Flutter widget binding is initialized before calling database APIs
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-initialize Database
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TaskFlow Todo',
      debugShowCheckedModeBanner: false,
      
      // Theme settings
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to Dark Mode for premium aesthetics
      
      // Start with SplashView
      home: const SplashView(),
    );
  }
}
