import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFFFF7043);
  static const background = Color(0xFFFFFFFF);
  static const field = Color(0xFFF5F7FA);
  static const surfaceTint = Color(0xFFFFEEE9);
  static const textPrimary = Color(0xFF171717);
  static const textSecondary = Color(0xFF8D93A3);
  static const divider = Color(0xFFE6E8ED);
  static const success = Color(0xFF20B965);
}

abstract final class AppSpacing {
  static const screen = 16.0;
  static const section = 22.0;
  static const compact = 8.0;
  static const control = 12.0;
}

abstract final class AppRadii {
  static const card = 11.0;
  static const field = 12.0;
  static const button = 12.0;
  static const thumbnail = 8.0;
}

abstract final class AppDimensions {
  static const referenceWidth = 375.0;
  static const referenceHeight = 812.0;
  static const searchHeight = 50.0;
  static const bottomNavigationHeight = 70.0;
  static const compactThumbnail = 58.0;
  static const popularCardWidth = 188.0;
}

abstract final class AppTextStyles {
  static const heading = TextStyle(fontSize: 22, height: 1.2, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const section = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const cardTitle = TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const body = TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary);
  static const caption = TextStyle(fontSize: 10, color: AppColors.textSecondary);
}

class ReferenceCanvas extends StatelessWidget {
  const ReferenceCanvas({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final canvasWidth = width < AppDimensions.referenceWidth ? width : AppDimensions.referenceWidth;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(width: canvasWidth, child: child),
    );
  }
}