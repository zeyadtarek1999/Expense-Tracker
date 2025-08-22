import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:printing/printing.dart';
import '../../../../core/services/pdf_export_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../shared_widgets/custom_app_bar.dart';
import '../../../add_expenses/domain/entities/expense_entity.dart';
import '../widgets/glass_card.dart';
import '../widgets/info_row_details.dart';
import '../widgets/receipt_preview.dart';
import '../widgets/section_title.dart';
import '../../../../generated/locale_keys.g.dart';

class ExpenseDetailsPage extends StatelessWidget {
  final ExpenseEntity expense;
  final List<ExpenseEntity> allExpenses;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ExpenseDetailsPage({
    super.key,
    required this.expense,
    required this.allExpenses,
    this.onDelete,
    this.onEdit,
  });

  bool get isIncome => expense.amount >= 0;
  Color get accent => isIncome ? const Color(0xFF2ECC71) : const Color(0xFFEB5757);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = expense.amount.abs().toStringAsFixed(2);
    final dateText = TimeFormatter.formatDateShort(expense.date);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: CustomAppBar(
        title: LocaleKeys.entry_details.tr(),
        onPdfExport: () async {
          final file = await PdfExportService.generateReport(expenses: allExpenses);
          await Printing.sharePdf(
            bytes: await file.readAsBytes(),
            filename: "expense_report.pdf",
          );
        },
        showPdf: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          children: [
            GlassCard(
              padding: EdgeInsets.all(18.w),
              child: Row(
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withOpacity(.18),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      color: accent,
                      size: 24.r,
                    ),
                  ),
                  14.w.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIncome ? LocaleKeys.income.tr() : LocaleKeys.expense.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textDark.withOpacity(0.75),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        6.h.verticalSpace,
                        Text(
                          '\$ $amount',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 26.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            16.h.verticalSpace,
            GlassCard(
              padding: EdgeInsets.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(LocaleKeys.summary.tr()),
                  12.h.verticalSpace,
                  InfoRowDetails(icon: Icons.category_rounded, label: LocaleKeys.category.tr(), value: expense.category),
                  10.h.verticalSpace,
                  InfoRowDetails(icon: Icons.event_rounded, label: LocaleKeys.date.tr(), value: dateText),
                  10.h.verticalSpace,
                  InfoRowDetails(
                    icon: isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
                    label: LocaleKeys.type.tr(),
                    value: isIncome ? LocaleKeys.income.tr() : LocaleKeys.expense.tr(),
                    valueColor: accent,
                  ),
                  if (expense.id != null)
                    InfoRowDetails(icon: Icons.tag_rounded, label: LocaleKeys.id.tr(), value: "#${expense.id}"),
                ],
              ),
            ),
            16.h.verticalSpace,
            GlassCard(
              padding: EdgeInsets.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(LocaleKeys.receipt.tr()),
                  12.h.verticalSpace,
                  ReceiptPreview(
                    receiptPath: expense.receipt,
                    heroTag: 'receipt_${expense.id ?? expense.hashCode}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
