import 'dart:io';
 import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
 import '../../features/add_expenses/domain/entities/expense_entity.dart';

class PdfExportService {
  static Future<File> generateReport({
    required List<ExpenseEntity> expenses,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Income & Expense Report',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Table.fromTextArray(
            headers: ['ID', 'Category', 'Date', 'Type', 'Amount'],
            data: expenses.map((e) {
              final type = e.amount >= 0 ? "Income" : "Expense";
              return [
                e.id?.toString() ?? "-",
                e.category,
                "${e.date.month}/${e.date.day}/${e.date.year}",
                type,
                e.amount.toStringAsFixed(2),
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/expense_report.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
