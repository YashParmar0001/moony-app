import 'package:flutter/material.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/theme/texts.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: AppColors.midSlateBlue,
      scaffoldBackgroundColor: AppColors.aliceBlue,
      textTheme: const TextTheme(
        displayLarge: AppTexts.displayLarge,
        displayMedium: AppTexts.displayMedium,
        displaySmall: AppTexts.displaySmall,
        headlineMedium: AppTexts.headlineMedium,
        headlineSmall: AppTexts.headlineSmall,
        titleLarge: AppTexts.titleLarge,
        titleMedium: AppTexts.titleMedium,
        bodySmall: AppTexts.bodySmall,
      ),
    );
  }
}