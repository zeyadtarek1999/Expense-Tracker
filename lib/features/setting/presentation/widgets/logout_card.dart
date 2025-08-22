import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../manager/setting_bloc.dart';
import '../../../../generated/locale_keys.g.dart';

class LogoutCard extends StatelessWidget {
  const LogoutCard({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          LocaleKeys.settings_logout_title.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          LocaleKeys.settings_logout_desc.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              LocaleKeys.common_cancel.tr(),
              style: const TextStyle(color: AppColors.textMedium),
            ),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlue.withOpacity(0.12),
              foregroundColor: AppColors.primaryBlue,
            ),
            child: Text(LocaleKeys.settings_logout.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<SettingBloc>().add(const SettingLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: AppColors.white,
      shadowColor: AppColors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(14.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: _iconCircle(Icons.logout, background: AppColors.error),
        title: Text(
          LocaleKeys.settings_logout.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.error,
          ),
        ),
        onTap: () => _confirmLogout(context),
      ),
    );
  }

  Widget _iconCircle(IconData icon, {Color? background}) {
    final bg = background ?? AppColors.primaryBlue;
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: bg.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: bg, size: 20.sp),
    );
  }
}
