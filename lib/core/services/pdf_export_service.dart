import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import 'package:intl/intl.dart';

class PdfExportService {
  static Future<void> exportSubscriptionsToPdf(
    List<SubscriptionDataModel> subscriptions,
  ) async {
    final pdf = pw.Document();

    final now = DateTime.now();
    final formattedDate = DateFormat('MMM d, yyyy').format(now);

    double totalMonthly = subscriptions.fold(
      0,
      (sum, sub) => sum + sub.monthlyEquivalent,
    );
    double totalYearly = subscriptions.fold(
      0,
      (sum, sub) => sum + sub.yearlyEquivalent,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(formattedDate),
            pw.SizedBox(height: 20),
            _buildSummaryContent(totalMonthly, totalYearly),
            pw.SizedBox(height: 30),
            _buildSubscriptionsTable(subscriptions),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'SubTrack_Pro_Report_${DateFormat('yyyyMMdd').format(now)}.pdf',
    );
  }

  static pw.Widget _buildHeader(String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SubTrack Pro',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Subscription Report',
          style: pw.TextStyle(fontSize: 20, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Generated on: \$date',
          style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
        ),
        pw.Divider(color: PdfColors.grey300),
      ],
    );
  }

  static pw.Widget _buildSummaryContent(
    double totalMonthly,
    double totalYearly,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'Total Monthly',
            '\$${totalMonthly.toStringAsFixed(2)}',
          ),
          _buildSummaryItem(
            'Total Yearly',
            '\$${totalYearly.toStringAsFixed(2)}',
          ),
          _buildSummaryItem('Active Subs', '\${subscriptions.length}'),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey600,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSubscriptionsTable(
    List<SubscriptionDataModel> subscriptions,
  ) {
    return pw.TableHelper.fromTextArray(
      context: null,
      headers: ['Name', 'Category', 'Cycle', 'Cost', 'Next Bill'],
      data: subscriptions.map((sub) {
        return [
          sub.name,
          sub.category,
          sub.billingCycle.toUpperCase(),
          '\$${sub.price.toStringAsFixed(2)}',
          DateFormat('MMM d, yyyy').format(sub.nextBillingDate),
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey50),
    );
  }
}
