import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Base font family
  static TextStyle get _baseTextStyle => GoogleFonts.inter();
  
  // Display Styles (Large headings)
  static TextStyle get displayLarge => _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get displayMedium => _baseTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get displaySmall => _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Headline Styles
  static TextStyle get headlineLarge => _baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get headlineMedium => _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get headlineSmall => _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Title Styles
  static TextStyle get titleLarge => _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get titleMedium => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get titleSmall => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  // Body Styles
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  static TextStyle get bodySmall => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.6,
  );
  
  // Label Styles (Buttons, chips, etc.)
  static TextStyle get labelLarge => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelMedium => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelSmall => _baseTextStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );
  
  // Special Styles
  static TextStyle get caption => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  static TextStyle get overline => _baseTextStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
    height: 1.4,
  );
  
  // Button Styles
  static TextStyle get button => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  
  static TextStyle get buttonLarge => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  
  static TextStyle get buttonSmall => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  
  // Link Style
  static TextStyle get link => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );
  
  // Error Style
  static TextStyle get error => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );
  
  // Helper Style
  static TextStyle get helper => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}