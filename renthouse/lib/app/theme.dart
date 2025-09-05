import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const seed = Color(0xFF2E6A9E);
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
  return ThemeData(colorScheme: scheme, useMaterial3: true);
}

ThemeData buildDarkTheme() {
  const seed = Color(0xFF2E6A9E);
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
  return ThemeData(colorScheme: scheme, useMaterial3: true);
}
