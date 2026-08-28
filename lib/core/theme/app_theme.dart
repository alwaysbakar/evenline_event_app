import 'package:flutter/material.dart';

import 'design_tokens.dart';

abstract final class AppTheme {
  static const ink = AppColors.textPrimary;
  static const canvas = AppColors.background;
  static const coral = AppColors.primary;
  static const muted = AppColors.textSecondary;
  static const field = AppColors.field;

  static ThemeData get light => ThemeData(
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: coral, brightness: Brightness.light),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(backgroundColor: canvas, foregroundColor: ink, elevation: 0, centerTitle: true),
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: field, border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.field), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.field), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.field), borderSide: BorderSide(color: coral)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), hintStyle: const TextStyle(color: muted, fontSize: 13)),
        navigationBarTheme: const NavigationBarThemeData(backgroundColor: canvas, elevation: 8, indicatorColor: Colors.transparent, labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 10, color: muted)), iconTheme: WidgetStatePropertyAll(IconThemeData(size: 20, color: muted))),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: ink, height: 1.2),
          headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
          titleMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ink),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
          bodyMedium: TextStyle(fontSize: 12, color: muted, height: 1.4),
        ),
        useMaterial3: true,
      );
}