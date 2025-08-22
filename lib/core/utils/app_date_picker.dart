import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';

class AppDatePicker {
  const AppDatePicker._();

  static Future<DateTime?> show(
      BuildContext context, {
        DateTime? initial,
        DateTime? firstDate,
        DateTime? lastDate,
        String helpText = 'Select date',
        String confirmText = 'Done',
        String cancelText = 'Cancel',
      }) async {
    final now = DateTime.now();

    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: helpText,
      confirmText: confirmText,
      cancelText: cancelText,
      fieldHintText: 'MM/DD/YY',
      builder: (ctx, child) {
        final theme = Theme.of(ctx);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primaryBlue,
              surface: Colors.white,
              onSurface: AppColors.textDark,
              onPrimary: Colors.white,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              headerBackgroundColor: AppColors.primaryBlue,
              headerForegroundColor: Colors.white,
              headerHeadlineStyle: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: .2,
              ),
              headerHelpStyle: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                return AppColors.textDark;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryBlue;
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.primaryBlue.withOpacity(0.08);
                }
                return Colors.transparent;
              }),
              dayOverlayColor: WidgetStateProperty.all(
                AppColors.primaryBlue.withOpacity(0.10),
              ),
              todayForegroundColor: WidgetStateProperty.all(
                AppColors.primaryBlue,
              ),
              todayBackgroundColor: WidgetStateProperty.all(
                AppColors.primaryBlue.withOpacity(0.10),
              ),
              yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryBlue;
                }
                return AppColors.textDark;
              }),
              yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryBlue.withOpacity(0.12);
                }
                return Colors.transparent;
              }),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static String formatMdy(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final yy = (d.year % 100).toString().padLeft(2, '0');
    return '$mm/$dd/$yy';
  }
}
