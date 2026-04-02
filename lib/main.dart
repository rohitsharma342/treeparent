import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/tree_controller.dart';
import 'controllers/content_controller.dart';
import 'controllers/user_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TreeController()),
        ChangeNotifierProvider(create: (_) => ContentController()),
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: const TreeParentApp(),
    ),
  );
}