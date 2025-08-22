import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/validations/app_validation.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared_widgets/buttons/elevated_btn_widget.dart';
import '../../../../shared_widgets/custom_text_form_field.dart';
import '../bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();

    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
      previous.email != current.email ||
          previous.password != current.password ||
          previous.loading != current.loading ||
          previous.obscure != current.obscure,
      builder: (context, state) {
        final String? emailError =
        (state.email.isNotEmpty) ? AppValidator.email(state.email) : null;
        final String? passwordError =
        (state.password.isNotEmpty) ? AppValidator.password(state.password) : null;

        return Form(
          key: bloc.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.email.tr(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              8.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormFieldWidget(
                    hint: LocaleKeys.enter_your_email.tr(),
                    fillColor: AppColors.lightBackground,
                    textInputType: TextInputType.emailAddress,
                    onChange: (v) => bloc.add(EmailChanged(v)),
                  ),
                  if (emailError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h, left: 4.w),
                      child: Text(
                        emailError,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
              16.verticalSpace,
              Text(
                LocaleKeys.password.tr(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              8.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormFieldWidget(
                    hint: '****************',
                    obscureText: state.obscure,
                    fillColor: AppColors.lightBackground,
                    onChange: (v) => bloc.add(PasswordChanged(v)),
                    suffixIcon: GestureDetector(
                      onTap: () => bloc.add(TogglePasswordVisibility()),
                      child: Icon(
                        state.obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  if (passwordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h, left: 4.w),
                      child: Text(
                        passwordError,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
              14.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: state.loading
                      ? null
                      : () {
                    Fluttertoast.showToast(
                      msg: "Feature coming soon",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    LocaleKeys.forget_password.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              14.verticalSpace,
              CustomElevatedButtonWidget(
                height: 48.h,
                text: LocaleKeys.login.tr(),
                isLoading: state.loading,
                isDisabled: !state.canSubmit,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  bloc.add(SubmitPressed());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
