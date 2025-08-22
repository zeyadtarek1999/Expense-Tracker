import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../shared_widgets/buttons/elevated_btn_widget.dart';
import '../../../../shared_widgets/custom_app_bar.dart';
import '../../../../shared_widgets/custom_text_form_field.dart';
 import '../manager/add_expenses_bloc.dart';
import '../widgets/category_drop_down_widget.dart';
import '../widgets/expenses_form_widget.dart';
import '../widgets/type_selector_widget.dart';
import '../../../../generated/locale_keys.g.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<AddExpensesBloc>();
        return bloc;
      },
      child: BlocConsumer<AddExpensesBloc, AddExpensesState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
          if (state is ExpenseSavedState) {
            final isIncome = context.read<AddExpensesBloc>().state.entryType == EntryType.income;
            final message = isIncome
                ? LocaleKeys.income_saved_successfully.tr()
                : LocaleKeys.expense_saved_successfully.tr();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                    SizedBox(width: 10.w),
                    Expanded(child: Text(message)),
                  ],
                ),
                backgroundColor: AppColors.primaryBlue,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(milliseconds: 1200),
              ),
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context, {
                'category': state.category,
                'amount': state.amount,
                'date': state.date,
                'receipt': state.receipt,
              });
            });
          }
        },
        builder: (context, state) {
          final bloc = context.read<AddExpensesBloc>();

          final categories = bloc.categories;
          bloc.dateController.text = state.dateText;
          bloc.receiptController.text = state.receiptText;

          final isIncome = state.entryType == EntryType.income;

          return Scaffold(
            backgroundColor: AppColors.pageBackground,
            appBar: CustomAppBar(title: LocaleKeys.add_entry.tr()),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: bloc.formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 6.h),

                      TypeSelectorWidget(
                        entryType: state.entryType,
                        onChanged: (type) => bloc.add(SelectEntryTypeEvent(type)),
                      ),

                      SizedBox(height: 16.h),
                      CustomFormWidgets.fieldLabel(
                          isIncome ? LocaleKeys.category_source.tr() : LocaleKeys.category.tr()),
                      SizedBox(height: 8.h),
                      CategoryDropdown(
                        categories: categories,
                        value: state.selectedCategory,
                        onChanged: (category) => bloc.add(SelectCategoryEvent(category)),
                      ),

                      SizedBox(height: 16.h),
                      CustomFormWidgets.fieldLabel(LocaleKeys.amount.tr()),
                      SizedBox(height: 8.h),
                      CustomTextFormFieldWidget(
                        hint: isIncome
                            ? '\$ 0.00 (${LocaleKeys.save_income.tr()})'
                            : '\$ 0.00 (${LocaleKeys.save_expense.tr()})',
                        controller: bloc.amountController,
                        textInputType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          final text = (value ?? '').trim();
                          final number = double.tryParse(text);
                          if (text.isEmpty) return LocaleKeys.enter_amount.tr();
                          if (number == null || number <= 0) return LocaleKeys.valid_amount.tr();
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),
                      CustomFormWidgets.fieldLabel(LocaleKeys.date.tr()),
                      SizedBox(height: 8.h),
                      CustomTextFormFieldWidget(
                        hint: 'MM/DD/YY',
                        controller: bloc.dateController,
                        readOnly: true,
                        onTap: () => bloc.add(PickDatePressed(context, state.selectedDate)),
                        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                        validator: (value) =>
                        (value == null || value.isEmpty) ? LocaleKeys.pick_a_date.tr() : null,
                      ),

                      SizedBox(height: 16.h),
                      CustomFormWidgets.fieldLabel(LocaleKeys.attach_receipt.tr()),
                      SizedBox(height: 8.h),
                      CustomTextFormFieldWidget(
                        hint: LocaleKeys.upload_image.tr(),
                        controller: bloc.receiptController,
                        readOnly: true,
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            bloc.add(SelectReceiptEvent(picked.name, picked.path));
                          }
                        },
                        suffixIcon: const Icon(Icons.camera_alt_rounded, size: 18),
                      ),

                      SizedBox(height: 17.h),
                      CustomFormWidgets.fieldLabel(LocaleKeys.categories.tr()),
                      SizedBox(height: 12.h),
                      Wrap(
                        runSpacing: 18.h,
                        spacing: 18.w,
                        children: categories
                            .map(
                              (category) => CustomFormWidgets.categoryChip(
                            category: category,
                            selected: state.selectedCategory?.name == category.name,
                            onTap: () => bloc.add(SelectCategoryEvent(category)),
                          ),
                        )
                            .toList(),
                      ),

                      SizedBox(height: 28.h),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 22.h),
              child: CustomElevatedButtonWidget(
                text: state.saving
                    ? LocaleKeys.saving.tr()
                    : (isIncome ? LocaleKeys.save_income.tr() : LocaleKeys.save_expense.tr()),
                height: 52.h,
                onPressed: () {
                  if (state.saving) return;
                  bloc.add(const SaveExpenseEvent());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
