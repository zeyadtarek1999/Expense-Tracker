import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../manager/setting_bloc.dart';
import '../../../../generated/locale_keys.g.dart';

class LanguageCard extends StatelessWidget {
  final bool isArabic;
  final String languageCode;

  const LanguageCard({
    super.key,
    required this.isArabic,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      ListTile(
        leading: _iconCircle(Icons.language),
        title: Text(
          LocaleKeys.settings_change_language.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            isArabic ? LocaleKeys.settings_lang_arabic.tr() : LocaleKeys.settings_lang_english.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMedium,
            ),
          ),
        ),
        trailing: _pill(context, isArabic ? 'AR' : 'EN'),
        onTap: () => _showLanguageModal(context, languageCode),
      ),
    );
  }

  Widget _cardWrapper(Widget child) => Card(
    elevation: 0.5,
    color: AppColors.white,
    shadowColor: AppColors.black.withOpacity(0.06),
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.circular(14.r),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );

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

  Widget _pill(BuildContext context, String label) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.2,
    ) ??
        TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w800,
          fontSize: 12.sp,
          letterSpacing: 0.2,
        );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.22)),
      ),
      child: Text(label, style: style),
    );
  }

  Future<void> _showLanguageModal(BuildContext context, String currentCode) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h + MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHeader(context, LocaleKeys.settings_change_language.tr()),
              4.h.verticalSpace,
              _languageOption(
                context: context,
                label: LocaleKeys.settings_lang_english.tr(),
                value: 'en',
                groupValue: currentCode,
                onSelected: () {
                  context.read<SettingBloc>().add(const SettingChangeLanguageRequested('en'));
                  Navigator.pop(context);
                },
              ),
              _languageOption(
                context: context,
                label: LocaleKeys.settings_lang_arabic.tr(),
                value: 'ar',
                groupValue: currentCode,
                onSelected: () {
                  context.read<SettingBloc>().add(const SettingChangeLanguageRequested('ar'));
                  Navigator.pop(context);
                },
              ),
              8.h.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Widget _sheetHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.translate, color: AppColors.primaryBlue),
          ),
          10.w.horizontalSpace,
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageOption({
    required BuildContext context,
    required String label,
    required String value,
    required String groupValue,
    required VoidCallback onSelected,
  }) {
    final selected = value == groupValue;
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: selected ? AppColors.primaryBlue : AppColors.border,
        ),
        color: selected ? AppColors.primaryBlue.withOpacity(0.04) : AppColors.white,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        activeColor: AppColors.primaryBlue,
        controlAffinity: ListTileControlAffinity.trailing,
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        onChanged: (_) => onSelected(),
      ),
    );
  }
}
