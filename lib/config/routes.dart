import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/tree_detail_screen.dart';
import '../screens/add_care_log_screen.dart';
import '../screens/add_tree_screen.dart';
import '../screens/educational_content_screen.dart';
import '../screens/content_detail_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String treeDetail = '/tree-detail';
  static const String addCareLog = '/add-care-log';
  static const String addTree = '/add-tree';
  static const String educationalContent = '/educational-content';
  static const String contentDetail = '/content-detail';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    dashboard: (context) => const DashboardScreen(),
    addTree: (context) => const AddTreeScreen(),
    educationalContent: (context) => const EducationalContentScreen(),
    profile: (context) => const ProfileScreen(),
  };
}