import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../shared_widgets/buttons/elevated_btn_widget.dart';
import '../../../../shared_widgets/custom_app_bar.dart';
import '../../../../shared_widgets/custom_text_form_field.dart';
import '../manager/currency_conversion_bloc.dart';
import '../widgets/currancy_drop_down.dart';
import '../../../../generated/locale_keys.g.dart';

class CurrencyConversionPage extends StatelessWidget {
  const CurrencyConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<CurrencyConversionBloc>();
        bloc.add(FetchLatestRates(baseCode: bloc.state.baseCode));
        return bloc;
      },
      child: Builder(
        builder: (context) {
          final formKey = GlobalKey<FormState>();
          final textTheme = Theme.of(context).textTheme;

          return Scaffold(
            backgroundColor: AppColors.pageBackground,
            appBar: CustomAppBar(title: LocaleKeys.currency_converter.tr(), showBack: false),
            body: BlocBuilder<CurrencyConversionBloc, CurrencyConversionState>(
              builder: (context, state) {
                final items = state.rates.isEmpty
                    ? {state.fromCurrency, state.toCurrency}.toList()
                    : (state.rates.keys.toList()..sort());

                final rateText = state.rates.containsKey(state.toCurrency)
                    ? '1 = ${state.rates[state.toCurrency]}'
                    : '1 = —';

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      if (state.loading)
                        Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: const LinearProgressIndicator(minHeight: 3),
                        ),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 18.w),
                        margin: EdgeInsets.only(bottom: 24.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.currency_exchange, color: AppColors.white, size: 20),
                                8.w.horizontalSpace,
                                Text(
                                  '${state.fromCurrency} → ${state.toCurrency}',
                                  style: textTheme.titleLarge?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        offset: const Offset(1, 1),
                                        color: AppColors.black.withOpacity(0.25),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            10.h.verticalSpace,
                            Divider(
                              color: AppColors.white.withOpacity(0.30),
                              thickness: 1,
                              indent: 40,
                              endIndent: 40,
                            ),
                            10.h.verticalSpace,
                            Text(
                              rateText,
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.white.withOpacity(0.90),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (state.error != null && state.error!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.error.withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error),
                              10.w.horizontalSpace,
                              Expanded(
                                child: Text(
                                  state.error!,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LocaleKeys.enter_amount.tr(),
                                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                            8.h.verticalSpace,
                            CustomTextFormFieldWidget(
                              hint: 'e.g. 100',
                              textInputType: TextInputType.number,
                              onChange: (v) =>
                                  context.read<CurrencyConversionBloc>().add(UpdateAmount(v ?? '')),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return LocaleKeys.please_enter_amount.tr();
                                }
                                final v = double.tryParse(value.trim());
                                if (v == null || v <= 0) {
                                  return LocaleKeys.enter_valid_number.tr();
                                }
                                return null;
                              },
                            ),

                            24.h.verticalSpace,

                            Row(
                              children: [
                                Expanded(
                                  child: CurrencyDropdown(
                                    label: LocaleKeys.from.tr(),
                                    value: state.fromCurrency,
                                    items: items,
                                    onChanged: (val) {
                                      if (val != null) {
                                        context.read<CurrencyConversionBloc>().add(UpdateFromCurrency(val));
                                      }
                                    },
                                  ),
                                ),
                                16.w.horizontalSpace,
                                GestureDetector(
                                  onTap: () =>
                                      context.read<CurrencyConversionBloc>().add(const SwapCurrencies()),
                                  child: const Icon(Icons.swap_horiz_rounded, size: 28, color: Colors.black54),
                                ),
                                16.w.horizontalSpace,
                                Expanded(
                                  child: CurrencyDropdown(
                                    label: LocaleKeys.to.tr(),
                                    value: state.toCurrency,
                                    items: items,
                                    onChanged: (val) {
                                      if (val != null) {
                                        context.read<CurrencyConversionBloc>().add(UpdateToCurrency(val));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            32.h.verticalSpace,

                            CustomElevatedButtonWidget(
                              text: LocaleKeys.convert.tr(),
                              height: 50.h,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<CurrencyConversionBloc>().add(const ConvertPressed());
                                }
                              },
                            ),

                            32.h.verticalSpace,

                            if (state.result.isNotEmpty)
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Container(
                                  key: ValueKey(state.result),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.currency_exchange_rounded, color: Colors.white, size: 30.sp),
                                      12.h.verticalSpace,
                                      Text(LocaleKeys.converted_amount.tr(),
                                          style: textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                      6.h.verticalSpace,
                                      Text(
                                        state.result,
                                        style: textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
