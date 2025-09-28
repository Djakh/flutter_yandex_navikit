import 'package:flutter/material.dart';
import 'package:navikit_flutter_demo/app.dart';
import 'package:navikit_flutter_demo/core/resources/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: NavikitFlutterTheme.lightTheme,
      darkTheme: NavikitFlutterTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const NavikitFlutterApp(),
    ),
  );
}
