import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../injection_container.dart';
import '../manager/setting_bloc.dart';
import '../../../../shared_widgets/custom_app_bar.dart';
import '../widgets/language_card.dart';
import '../widgets/logout_card.dart';
import '../../../../generated/locale_keys.g.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
      create: (_) => getIt<SettingBloc>()..add(SettingInit(context.locale.languageCode)),
      child: BlocConsumer<SettingBloc, SettingState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          if (state.status == SettingStatus.languageChanged) {
            await context.setLocale(Locale(state.languageCode));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(LocaleKeys.settings_language_changed.tr())),
              );
            }
          } else if (state.status == SettingStatus.logoutSuccess) {
            if (context.mounted) context.go(AppRoutes.login);
          } else if (state.status == SettingStatus.error && state.errorMessage != null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          }
        },
        builder: (context, state) {
          final isArabic = state.languageCode == 'ar';
          final loading = state.status == SettingStatus.loading;

          return Scaffold(
            backgroundColor: AppColors.pageBackground,
            appBar: CustomAppBar(
              title: LocaleKeys.settings_title.tr(),
              showBack: false,
              onBack: () => context.pop(),
            ),
            body: AbsorbPointer(
              absorbing: loading,
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                    children: [
                      Text(
                        LocaleKeys.settings_general.tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                          color: AppColors.textDark,
                        ),
                      ),
                      LanguageCard(
                        isArabic: isArabic,
                        languageCode: state.languageCode,
                      ),
                      20.h.verticalSpace,
                      Text(
                        LocaleKeys.settings_account.tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                          color: AppColors.textDark,
                        ),
                      ),
                      const LogoutCard(),
                    ],
                  ),
                  if (loading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.04),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
