import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'screens/splash_screen.dart';

class TreeParentApp extends StatelessWidget {
  const TreeParentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreeParent',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: AppRoutes.routes,
    );
  }
}