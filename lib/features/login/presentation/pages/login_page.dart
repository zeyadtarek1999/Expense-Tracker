import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../injection_container.dart';
import '../widgets/login_form_widget.dart';
import '../widgets/login_info_dialog.dart';
import '../widgets/social_button_widget.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hasShownInfoDialog = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasShownInfoDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (ctx) => const InfoDialogWidget(),
        );
      });
      _hasShownInfoDialog = true;
    }

    return BlocProvider(
      create: (_) => getIt<LoginBloc>()..add(InitLoginEvent()),
      child: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) =>
        previous.success != current.success || previous.error != current.error,
        listener: (context, state) {
          if (state.success) {
            context.go(AppRoutes.homeLayout);
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 420.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      12.verticalSpace,
                      Text(
                        LocaleKeys.app_name.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      28.verticalSpace,
                      Text(
                        LocaleKeys.login.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      28.verticalSpace,
                      const LoginForm(),
                      20.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.black.withOpacity(.1),
                              thickness: 1.h,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              LocaleKeys.or_login_with.tr(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black.withOpacity(.1),
                              thickness: 1.h,
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      SocialButton(
                        label: LocaleKeys.continue_with_google.tr(),
                        icon: Assets.icons.googleIcon.svg(
                          width: 22.r,
                          height: 22.r,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Feature coming soon')),
                          );
                        },
                      ),
                      12.verticalSpace,
                      SocialButton(
                        label: LocaleKeys.continue_with_apple.tr(),
                        icon: Assets.icons.appleIcon.svg(
                          width: 22.r,
                          height: 22.r,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Feature coming soon')),
                          );
                        },
                      ),
                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

