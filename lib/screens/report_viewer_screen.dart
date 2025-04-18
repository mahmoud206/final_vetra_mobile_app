import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';
import '../providers/report_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'date_range_screen.dart';

class ReportViewerScreen extends StatelessWidget {
  const ReportViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    
    final dateFormatter = DateFormat('yyyy-MM-dd', 'ar');
    final startDateStr = dateFormatter.format(reportProvider.startDate);
    final endDateStr = dateFormatter.format(reportProvider.endDate);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          Constants.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تقرير جديد',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => 
                    const DateRangeScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutCubic;
                    
                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );
                    
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: AppTheme.mediumAnimationDuration,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Animate(
                    effects: [
                      SlideEffect(
                        duration: 600.ms,
                        begin: const Offset(0, -30),
                        end: const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                      ),
                    ],
                    child: Text(
                      'تم إنشاء التقرير بنجاح',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Animate(
                    effects: [
                      SlideEffect(
                        duration: 600.ms,
                        delay: 200.ms,
                        begin: const Offset(0, -20),
                        end: const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                        delay: 200.ms,
                      ),
                    ],
                    child: Column(
                      children: [
                        Text(
                          '${databaseProvider.selectedDatabase}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryDarkColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'من $startDateStr إلى $endDateStr',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textColor.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // PDF Preview
            Expanded(
              child: Animate(
                effects: [
                  FadeEffect(
                    duration: 800.ms,
                    delay: 400.ms,
                  ),
                ],
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadius,
                  ),
                  child: ClipRRect(
                    borderRadius: AppTheme.borderRadius,
                    child: PdfPreview(
                      pdfFileName: 'تقرير_${databaseProvider.selectedDatabase}.pdf',
                      build: (format) => File(reportProvider.pdfPath).readAsBytesSync(),
                      canChangePageFormat: false,
                      canChangeOrientation: false,
                      canDebug: false,
                      maxPageWidth: 700,
                      previewPageMargin: const EdgeInsets.all(8),
                      initialPageFormat: const PdfPageFormat(
                        21.0 * PdfPageFormat.cm,
                        29.7 * PdfPageFormat.cm,
                        marginAll: 2.0 * PdfPageFormat.cm,
                      ),
                      scrollViewDecoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      pdfPreviewPageDecoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: AppTheme.cardShadow,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Share button
            Animate(
              effects: [
                SlideEffect(
                  duration: 600.ms,
                  delay: 800.ms,
                  begin: const Offset(0, 30),
                  end: const Offset(0, 0),
                  curve: Curves.easeOutCubic,
                ),
                FadeEffect(
                  duration: 600.ms,
                  delay: 800.ms,
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () async {
                    // Share the PDF report
                    await reportProvider.sharePdfReport();
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.share),
                        const SizedBox(width: 8),
                        Text(
                          Constants.shareReport,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}