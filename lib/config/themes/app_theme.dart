import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/app_colors.dart';

ThemeData appTheme() {
  final baseText = GoogleFonts.poppinsTextTheme();
  final textTheme = baseText.copyWith(
    displayLarge: baseText.displayLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textDark),
    displayMedium: baseText.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
    displaySmall: baseText.displaySmall?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textDark),
    headlineLarge: baseText.headlineLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textDark),
    headlineMedium: baseText.headlineMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
    headlineSmall: baseText.headlineSmall?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textDark),
    titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
    titleMedium: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
    titleSmall: baseText.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textDark),
    bodyLarge: baseText.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textMedium),
    bodyMedium: baseText.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textMedium),
    bodySmall: baseText.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textMedium),
    labelLarge: baseText.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
    labelMedium: baseText.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
    labelSmall: baseText.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
  );

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryBlue,
    onPrimary: AppColors.white,
    secondary: AppColors.secondaryBlue,
    onSecondary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    background: AppColors.pageBackground,
    onBackground: AppColors.textDark,
    surface: AppColors.white,
    onSurface: AppColors.textDark,
  );

  return ThemeData(
    colorScheme: colorScheme,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.pageBackground,
    useMaterial3: true,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.pageBackground,
      foregroundColor: AppColors.textDark,
      titleTextStyle: textTheme.titleLarge,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackground,
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.hint),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.error, width: 1.2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size.fromHeight(52.h)),
        backgroundColor: WidgetStateProperty.all(AppColors.primaryBlue),
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.titleMedium?.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size.fromHeight(52.h)),
        side: WidgetStateProperty.all(BorderSide(color: AppColors.border)),
        foregroundColor: WidgetStateProperty.all(AppColors.textDark),
        backgroundColor: WidgetStateProperty.all(AppColors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.primaryBlue),
        textStyle: WidgetStateProperty.all(
          textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 24.h,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedColor: AppColors.primaryBlue.withOpacity(.1),
      labelStyle: textTheme.bodyMedium!,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryBlue,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) => AppColors.primaryBlue),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      side: BorderSide(color: AppColors.border),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primaryBlue),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((s) => AppColors.primaryBlue.withOpacity(.3)),
      thumbColor: WidgetStateProperty.all(AppColors.primaryBlue),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
