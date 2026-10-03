import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../orders/domain/entities/order_entity.dart';
import '../domain/entities/expense_entity.dart';

/// Service to generate and export/download monthly workshop reports in PDF format.
class MonthlyReportPdfGenerator {
  /// Generates the PDF document bytes for a specific month and year
  static Future<Uint8List> generateMonthlyReportBytes({
    required int year,
    required int month,
    required List<OrderEntity> allOrders,
    required List<ExpenseEntity> allExpenses,
  }) async {
    final pdf = pw.Document();

    final monthName = DateFormat('MMMM yyyy').format(DateTime(year, month));

    // Filter orders and expenses belonging to this month
    final monthOrders = allOrders.where((o) {
      return o.bookingDate.year == year && o.bookingDate.month == month;
    }).toList();

    final monthExpenses = allExpenses.where((e) {
      return e.date.year == year && e.date.month == month;
    }).toList();

    final totalRevenue = monthOrders.fold(0.0, (sum, o) => sum + o.stitchingRate);
    final totalExpenses = monthExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final netProfit = totalRevenue - totalExpenses;

    // Group expenses by category
    final categoryTotals = <String, double>{};
    for (final e in monthExpenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0.0) + e.amount;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // 1. Header Banner
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('1E3A8A'),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'DARZI DAIRY TAILORS',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Monthly Workshop Ledger & Accounts Report',
                        style: const pw.TextStyle(
                          color: PdfColors.grey200,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        monthName,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Generated: ${DateFormatter.formatDate(DateTime.now())}',
                        style: const pw.TextStyle(
                          color: PdfColors.grey300,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 18),

            // 2. Financial Summary KPI Grid
            pw.Row(
              children: [
                _buildKpiCard(
                  title: 'Total Orders',
                  value: '${monthOrders.length}',
                  color: PdfColor.fromHex('1E3A8A'),
                ),
                pw.SizedBox(width: 10),
                _buildKpiCard(
                  title: 'Stitching Revenue',
                  value: CurrencyFormatter.format(totalRevenue),
                  color: PdfColor.fromHex('16A34A'),
                ),
                pw.SizedBox(width: 10),
                _buildKpiCard(
                  title: 'Total Expenses',
                  value: CurrencyFormatter.format(totalExpenses),
                  color: PdfColor.fromHex('DC2626'),
                ),
                pw.SizedBox(width: 10),
                _buildKpiCard(
                  title: 'Net Profit',
                  value: CurrencyFormatter.format(netProfit),
                  color: netProfit >= 0 ? PdfColor.fromHex('15803D') : PdfColor.fromHex('B91C1C'),
                ),
              ],
            ),
            pw.SizedBox(height: 22),

            // 3. Orders Table
            pw.Text(
              'Orders Booked in $monthName (${monthOrders.length})',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('1E3A8A'),
              ),
            ),
            pw.SizedBox(height: 8),

            if (monthOrders.isEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'No orders recorded for this month.',
                    style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 11),
                  ),
                ),
              )
            else
              pw.TableHelper.fromTextArray(
                headers: ['Token', 'Customer Name', 'Phone', 'Garment', 'Status', 'Rate'],
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('1E3A8A')),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                data: monthOrders.map((o) {
                  return [
                    o.orderToken,
                    o.customerName,
                    o.customerPhone,
                    _cleanTextForPdf(o.garmentType),
                    o.status.displayName,
                    CurrencyFormatter.format(o.stitchingRate),
                  ];
                }).toList(),
              ),

            pw.SizedBox(height: 22),

            // 4. Workshop Expenses Table
            pw.Text(
              'Daily Workshop Expenses in $monthName (${monthExpenses.length})',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('DC2626'),
              ),
            ),
            pw.SizedBox(height: 8),

            if (monthExpenses.isEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'No workshop expenses recorded for this month.',
                    style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 11),
                  ),
                ),
              )
            else
              pw.TableHelper.fromTextArray(
                headers: ['Date', 'Category', 'Expense Detail', 'Amount (Rs)'],
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('475569')),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                data: monthExpenses.map((e) {
                  return [
                    DateFormatter.formatDate(e.date),
                    _cleanTextForPdf(e.category),
                    _cleanTextForPdf(e.title.isNotEmpty ? e.title : e.category),
                    CurrencyFormatter.format(e.amount),
                  ];
                }).toList(),
              ),

            pw.SizedBox(height: 20),

            // 5. Expense Categories Breakdown
            if (categoryTotals.isNotEmpty) ...[
              pw.Text(
                'Expense Category Breakdown',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('334155'),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 8,
                runSpacing: 6,
                children: categoryTotals.entries.map((entry) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(4),
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.Text(
                      '${_cleanTextForPdf(entry.key)}: ${CurrencyFormatter.format(entry.value)}',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('1E293B'),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            pw.SizedBox(height: 25),

            // Footer
            pw.Divider(color: PdfColors.grey300),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'DarziDairy Tailors Ledger - 100% Offline Digital Khata',
                  style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 8),
                ),
                pw.Text(
                  'Official Workshop Report',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('1E3A8A'),
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// KPI Block Helper
  static pw.Widget _buildKpiCard({
    required String title,
    required String value,
    required PdfColor color,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey50,
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: color, width: 1.2),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 8),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Triggers the system print / download / save dialog for the generated PDF
  static Future<void> printOrDownloadReport({
    required int year,
    required int month,
    required List<OrderEntity> allOrders,
    required List<ExpenseEntity> allExpenses,
  }) async {
    final monthName = DateFormat('MMMM_yyyy').format(DateTime(year, month));
    final pdfBytes = await generateMonthlyReportBytes(
      year: year,
      month: month,
      allOrders: allOrders,
      allExpenses: allExpenses,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'DarziDairy_Report_$monthName.pdf',
    );
  }

  /// Shares the PDF file directly via share sheet
  static Future<void> shareReport({
    required int year,
    required int month,
    required List<OrderEntity> allOrders,
    required List<ExpenseEntity> allExpenses,
  }) async {
    final monthName = DateFormat('MMMM_yyyy').format(DateTime(year, month));
    final pdfBytes = await generateMonthlyReportBytes(
      year: year,
      month: month,
      allOrders: allOrders,
      allExpenses: allExpenses,
    );

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'DarziDairy_Report_$monthName.pdf',
    );
  }

  /// Cleans strings for standard PDF rendering (removes Urdu text in brackets and replaces bullet points)
  static String _cleanTextForPdf(String text) {
    final regex = RegExp(r'\s*\([^)]*[\u0600-\u06FF]+[^)]*\)');
    return text.replaceAll(regex, '').replaceAll('•', '-').trim();
  }
}
