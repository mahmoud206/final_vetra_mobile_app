import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/clinic_report.dart';
import '../models/payment_report.dart';
import '../models/sales_profit_report.dart';
import '../models/expenses_report.dart';
import '../utils/constants.dart';

class ReportProvider extends ChangeNotifier {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isGenerating = false;
  String _pdfPath = '';
  String _errorMessage = '';
  
  // Data models
  PaymentReport? _paymentReport;
  ClinicReport? _clinicReport;
  SalesProfitReport? _salesProfitReport;
  ExpensesReport? _expensesReport;
  
  // Getters
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  bool get isGenerating => _isGenerating;
  String get pdfPath => _pdfPath;
  String get errorMessage => _errorMessage;
  bool get hasReport => _pdfPath.isNotEmpty;
  
  // Set date range
  void setDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }
  
  // Process payment data
  void processPaymentData(List<Map<String, dynamic>> data) {
    _paymentReport = PaymentReport.fromData(data);
    notifyListeners();
  }
  
  // Process sale data for clinic report
  void processClinicData(List<Map<String, dynamic>> data) {
    _clinicReport = ClinicReport.fromData(data);
    notifyListeners();
  }
  
  // Process sale data for sales and profit report
  void processSalesProfitData(List<Map<String, dynamic>> data) {
    _salesProfitReport = SalesProfitReport.fromData(data);
    notifyListeners();
  }
  
  // Process expenses data
  void processExpensesData(List<Map<String, dynamic>> data) {
    _expensesReport = ExpensesReport.fromData(data);
    notifyListeners();
  }
  
  // Generate PDF report
  Future<bool> generatePdfReport(String databaseName) async {
    if (_paymentReport == null || 
        _clinicReport == null || 
        _salesProfitReport == null ||
        _expensesReport == null) {
      _errorMessage = 'بيانات التقرير غير مكتملة';
      notifyListeners();
      return false;
    }
    
    _isGenerating = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      final pdf = pw.Document();
      
      // Load the Arabic font
      final arabicFont = await PdfGoogleFonts.tajawalRegular();
      final arabicFontBold = await PdfGoogleFonts.tajawalBold();
      
      // Format dates for display
      final dateFormatter = DateFormat('yyyy-MM-dd', 'ar');
      final formattedStartDate = dateFormatter.format(_startDate);
      final formattedEndDate = dateFormatter.format(_endDate);
      
      // Add title page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'تقرير مالي',
                    style: pw.TextStyle(
                      font: arabicFontBold,
                      fontSize: 28,
                      color: PdfColors.green800,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    databaseName,
                    style: pw.TextStyle(
                      font: arabicFontBold,
                      fontSize: 24,
                      color: PdfColors.green600,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    'الفترة من $formattedStartDate إلى $formattedEndDate',
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 18,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 100),
                  pw.Text(
                    'تم إنشاء هذا التقرير في ${dateFormatter.format(DateTime.now())}',
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ],
              ),
            );
          },
        ),
      );
      
      // Add payment report page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildPaymentReportPage(arabicFont, arabicFontBold);
          },
        ),
      );
      
      // Add clinic report page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildClinicReportPage(arabicFont, arabicFontBold);
          },
        ),
      );
      
      // Add sales and profit report page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildSalesProfitReportPage(arabicFont, arabicFontBold);
          },
        ),
      );
      
      // Add expenses report page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildExpensesReportPage(arabicFont, arabicFontBold);
          },
        ),
      );
      
      // Save the PDF
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      _pdfPath = file.path;
      _isGenerating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isGenerating = false;
      notifyListeners();
      return false;
    }
  }
  
  // Build payment report page
  pw.Widget _buildPaymentReportPage(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            Constants.paymentReport,
            style: pw.TextStyle(
              font: arabicFontBold,
              fontSize: 24,
              color: PdfColors.green800,
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColors.green300),
          pw.SizedBox(height: 20),
          
          // Incoming vs Outgoing summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'ملخص المدفوعات',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildPaymentSummaryTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Payment methods summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'تفاصيل طرق الدفع',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildPaymentMethodsTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build payment summary table
  pw.Widget _buildPaymentSummaryTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green200),
          children: [
            _buildTableCell(Constants.total, arabicFontBold, isHeader: true),
            _buildTableCell(Constants.outgoing, arabicFontBold, isHeader: true),
            _buildTableCell(Constants.incoming, arabicFontBold, isHeader: true),
          ],
        ),
        // Data row
        pw.TableRow(
          children: [
            _buildTableCell(_formatCurrency(_paymentReport!.totalAmount), arabicFont),
            _buildTableCell(_formatCurrency(_paymentReport!.outgoingAmount), arabicFont),
            _buildTableCell(_formatCurrency(_paymentReport!.incomingAmount), arabicFont),
          ],
        ),
      ],
    );
  }
  
  // Build payment methods table
  pw.Widget _buildPaymentMethodsTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green200),
          children: [
            _buildTableCell(Constants.total, arabicFontBold, isHeader: true),
            _buildTableCell(Constants.outgoing, arabicFontBold, isHeader: true),
            _buildTableCell(Constants.incoming, arabicFontBold, isHeader: true),
            _buildTableCell('طريقة الدفع', arabicFontBold, isHeader: true),
          ],
        ),
        // Cash row
        pw.TableRow(
          children: [
            _buildTableCell(_formatCurrency(_paymentReport!.cashTotal), arabicFont),
            _buildTableCell(_formatCurrency(_paymentReport!.cashOutgoing), arabicFont),
            _buildTableCell(_formatCurrency(_paymentReport!.cashIncoming), arabicFont),
            _buildTableCell(Constants.cashMethod, arabicFont),
          ],
        ),
        // Network row
        pw.TableRow(
          children: [
            _buildTableCell(_formatCurrency(_paymentReport!.networkTotal), arabicFont),
            _buildTableCell(_formatCurrency(_paymentReport!.networkOutgoing), arabicFont),
            _buildTableCell(_formatCurrency(_paymentReport!.networkIncoming), arabicFont),
            _buildTableCell(Constants.networkMethod, arabicFont),
          ],
        ),
      ],
    );
  }
  
  // Build clinic report page
  pw.Widget _buildClinicReportPage(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            Constants.clinicReport,
            style: pw.TextStyle(
              font: arabicFontBold,
              fontSize: 24,
              color: PdfColors.green800,
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColors.green300),
          pw.SizedBox(height: 20),
          
          // Clinic Services Summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'ملخص خدمات العيادة',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildClinicServicesSummaryTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Regular Services
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  Constants.regularServices,
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildRegularServicesTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Large Services
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  Constants.largeServices,
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildLargeServicesTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build clinic services summary table
  pw.Widget _buildClinicServicesSummaryTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green200),
          children: [
            _buildTableCell(Constants.amount, arabicFontBold, isHeader: true),
            _buildTableCell(Constants.service, arabicFontBold, isHeader: true),
          ],
        ),
        // Regular Services Total
        pw.TableRow(
          children: [
            _buildTableCell(_formatCurrency(_clinicReport!.regularServicesTotal), arabicFont),
            _buildTableCell(Constants.regularServices, arabicFont),
          ],
        ),
        // Large Services Total
        pw.TableRow(
          children: [
            _buildTableCell(_formatCurrency(_clinicReport!.largeServicesTotal), arabicFont),
            _buildTableCell(Constants.largeServices, arabicFont),
          ],
        ),
        // Total
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green100),
          children: [
            _buildTableCell(_formatCurrency(_clinicReport!.totalServicesAmount), arabicFontBold),
            _buildTableCell('الإجمالي', arabicFontBold),
          ],
        ),
      ],
    );
  }
  
  // Build regular services table
  pw.Widget _buildRegularServicesTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    final rows = <pw.TableRow>[];
    
    // Header row
    rows.add(pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.green200),
      children: [
        _buildTableCell(Constants.amount, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.price, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.quantity, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.service, arabicFontBold, isHeader: true),
      ],
    ));
    
    // Data rows
    for (final service in _clinicReport!.regularServices) {
      rows.add(pw.TableRow(
        children: [
          _buildTableCell(_formatCurrency(service.amount), arabicFont),
          _buildTableCell(_formatCurrency(service.price), arabicFont),
          _buildTableCell(service.quantity.toString(), arabicFont),
          _buildTableCell(service.name, arabicFont),
        ],
      ));
    }
    
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: rows,
    );
  }
  
  // Build large services table
  pw.Widget _buildLargeServicesTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    final rows = <pw.TableRow>[];
    
    // Header row
    rows.add(pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.green200),
      children: [
        _buildTableCell(Constants.amount, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.price, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.quantity, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.service, arabicFontBold, isHeader: true),
      ],
    ));
    
    // Data rows
    for (final service in _clinicReport!.largeServices) {
      rows.add(pw.TableRow(
        children: [
          _buildTableCell(_formatCurrency(service.amount), arabicFont),
          _buildTableCell(_formatCurrency(service.price), arabicFont),
          _buildTableCell(service.quantity.toString(), arabicFont),
          _buildTableCell(service.name, arabicFont),
        ],
      ));
    }
    
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: rows,
    );
  }
  
  // Build sales and profit report page
  pw.Widget _buildSalesProfitReportPage(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            Constants.salesProfitReport,
            style: pw.TextStyle(
              font: arabicFontBold,
              fontSize: 24,
              color: PdfColors.green800,
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColors.green300),
          pw.SizedBox(height: 20),
          
          // Sales and Profit Summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'ملخص المبيعات والأرباح',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildSalesProfitSummaryTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Daily Sales and Profit
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'المبيعات والأرباح اليومية',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildDailySalesProfitTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build sales and profit summary table
  pw.Widget _buildSalesProfitSummaryTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green200),
          children: [
            _buildTableCell('القيمة', arabicFontBold, isHeader: true),
            _buildTableCell('البند', arabicFontBold, isHeader: true),
          ],
        ),
        // Revenue
        pw.TableRow(
          children: [
            _buildTableCell(_formatCurrency(_salesProfitReport!.totalRevenue), arabicFont),
            _buildTableCell(Constants.revenue, arabicFont),
          ],
        ),
        // Profit
        pw.TableRow(
          children: [
            _buildTableCell(_formatCurrency(_salesProfitReport!.totalProfit), arabicFont),
            _buildTableCell(Constants.profit, arabicFont),
          ],
        ),
        // Profit Margin
        pw.TableRow(
          children: [
            _buildTableCell('${(_salesProfitReport!.profitMargin * 100).toStringAsFixed(2)}%', arabicFont),
            _buildTableCell('نسبة الربح', arabicFont),
          ],
        ),
      ],
    );
  }
  
  // Build daily sales and profit table
  pw.Widget _buildDailySalesProfitTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    final rows = <pw.TableRow>[];
    
    // Header row
    rows.add(pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.green200),
      children: [
        _buildTableCell('نسبة الربح', arabicFontBold, isHeader: true),
        _buildTableCell(Constants.profit, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.revenue, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.date, arabicFontBold, isHeader: true),
      ],
    ));
    
    // Data rows
    final dateFormatter = DateFormat('yyyy-MM-dd', 'ar');
    
    for (final dailyData in _salesProfitReport!.dailyData) {
      final profitMargin = dailyData.revenue > 0 
          ? (dailyData.profit / dailyData.revenue * 100).toStringAsFixed(2) + '%'
          : '0%';
      
      rows.add(pw.TableRow(
        children: [
          _buildTableCell(profitMargin, arabicFont),
          _buildTableCell(_formatCurrency(dailyData.profit), arabicFont),
          _buildTableCell(_formatCurrency(dailyData.revenue), arabicFont),
          _buildTableCell(dateFormatter.format(dailyData.date), arabicFont),
        ],
      ));
    }
    
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: rows,
    );
  }
  
  // Build expenses report page
  pw.Widget _buildExpensesReportPage(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            Constants.expensesReport,
            style: pw.TextStyle(
              font: arabicFontBold,
              fontSize: 24,
              color: PdfColors.green800,
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColors.green300),
          pw.SizedBox(height: 20),
          
          // Expenses Summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'ملخص المصروفات',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildExpensesSummaryTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Detailed Expenses
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'تفاصيل المصروفات',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                _buildDetailedExpensesTable(arabicFont, arabicFontBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build expenses summary table
  pw.Widget _buildExpensesSummaryTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green200),
          children: [
            _buildTableCell(Constants.amount, arabicFontBold, isHeader: true),
            _buildTableCell('نوع المصروف', arabicFontBold, isHeader: true),
          ],
        ),
        // Total Expenses
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green100),
          children: [
            _buildTableCell(_formatCurrency(_expensesReport!.totalExpenses), arabicFontBold),
            _buildTableCell('إجمالي المصروفات', arabicFontBold),
          ],
        ),
      ],
    );
  }
  
  // Build detailed expenses table
  pw.Widget _buildDetailedExpensesTable(pw.Font arabicFont, pw.Font arabicFontBold) {
    final rows = <pw.TableRow>[];
    
    // Header row
    rows.add(pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.green200),
      children: [
        _buildTableCell(Constants.date, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.amount, arabicFontBold, isHeader: true),
        _buildTableCell(Constants.expenseType, arabicFontBold, isHeader: true),
      ],
    ));
    
    // Data rows
    final dateFormatter = DateFormat('yyyy-MM-dd', 'ar');
    
    for (final expense in _expensesReport!.expenses) {
      rows.add(pw.TableRow(
        children: [
          _buildTableCell(dateFormatter.format(expense.date), arabicFont),
          _buildTableCell(_formatCurrency(expense.amount), arabicFont),
          _buildTableCell(expense.type, arabicFont),
        ],
      ));
    }
    
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: rows,
    );
  }
  
  // Helper to build table cell
  pw.Widget _buildTableCell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: isHeader ? font : font,
          fontSize: isHeader ? 14 : 12,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.center,
      ),
    );
  }
  
  // Format currency
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00 ر.س', 'ar');
    return formatter.format(amount);
  }
  
  // Share the PDF report
  Future<bool> sharePdfReport() async {
    if (_pdfPath.isEmpty) {
      _errorMessage = 'لم يتم إنشاء تقرير بعد';
      notifyListeners();
      return false;
    }
    
    try {
      await Share.shareXFiles(
        [XFile(_pdfPath)], 
        text: 'تقرير مالي من تطبيق الإنعام',
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Reset the report data
  void resetReport() {
    _pdfPath = '';
    _errorMessage = '';
    _paymentReport = null;
    _clinicReport = null;
    _salesProfitReport = null;
    _expensesReport = null;
    notifyListeners();
  }
}