import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';
import '../providers/report_provider.dart';
import '../utils/app_theme.dart';
import 'report_viewer_screen.dart';

class GeneratingReportScreen extends StatefulWidget {
  const GeneratingReportScreen({super.key});

  @override
  State<GeneratingReportScreen> createState() => _GeneratingReportScreenState();
}

class _GeneratingReportScreenState extends State<GeneratingReportScreen> {
  bool _isGenerating = true;
  String _currentStep = 'جاري الاتصال بقاعدة البيانات...';
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _generateReport();
  }
  
  Future<void> _generateReport() async {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    
    try {
      // Reset report data
      reportProvider.resetReport();
      
      // Step 1: Ensure database connection
      if (!databaseProvider.isConnected) {
        setState(() {
          _currentStep = 'جاري الاتصال بقاعدة البيانات...';
        });
        
        final success = await databaseProvider.connect();
        if (!success) {
          throw Exception('فشل الاتصال بقاعدة البيانات: ${databaseProvider.errorMessage}');
        }
      }
      
      // Step 2: Fetch payment data
      setState(() {
        _currentStep = 'جاري استرجاع بيانات المدفوعات...';
      });
      final paymentData = await databaseProvider.getPaymentData(
        reportProvider.startDate, 
        reportProvider.endDate,
      );
      reportProvider.processPaymentData(paymentData);
      
      // Step 3: Fetch sale data for clinic report and sales/profit report
      setState(() {
        _currentStep = 'جاري استرجاع بيانات المبيعات...';
      });
      final saleData = await databaseProvider.getSaleData(
        reportProvider.startDate, 
        reportProvider.endDate,
      );
      reportProvider.processClinicData(saleData);
      reportProvider.processSalesProfitData(saleData);
      
      // Step 4: Process expenses data (using payment data)
      setState(() {
        _currentStep = 'جاري معالجة بيانات المصروفات...';
      });
      reportProvider.processExpensesData(paymentData);
      
      // Step 5: Generate PDF report
      setState(() {
        _currentStep = 'جاري إنشاء ملف التقرير...';
      });
      final success = await reportProvider.generatePdfReport(databaseProvider.selectedDatabase);
      
      if (!success) {
        throw Exception('فشل إنشاء التقرير: ${reportProvider.errorMessage}');
      }
      
      // Step 6: Show the report
      setState(() {
        _isGenerating = false;
      });
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              const ReportViewerScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
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
      }
      
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _errorMessage = e.toString();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isGenerating) ...[
                  // Loading animation
                  Animate(
                    effects: [
                      ScaleEffect(
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                      ),
                    ],
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLightColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Current step
                  Animate(
                    effects: [
                      SlideEffect(
                        duration: 600.ms,
                        delay: 300.ms,
                        begin: const Offset(0, 30),
                        end: const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                        delay: 300.ms,
                      ),
                    ],
                    child: Text(
                      _currentStep,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Info text
                  Animate(
                    effects: [
                      SlideEffect(
                        duration: 600.ms,
                        delay: 400.ms,
                        begin: const Offset(0, 30),
                        end: const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                        delay: 400.ms,
                      ),
                    ],
                    child: Text(
                      'يرجى الانتظار بينما يتم تجهيز التقرير الخاص بك',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ] else if (_errorMessage.isNotEmpty) ...[
                  // Error icon
                  Animate(
                    effects: [
                      ScaleEffect(
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                      ),
                    ],
                    child: const Icon(
                      Icons.error_outline,
                      size: 100,
                      color: Colors.red,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Error message
                  Animate(
                    effects: [
                      SlideEffect(
                        duration: 600.ms,
                        delay: 300.ms,
                        begin: const Offset(0, 30),
                        end: const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                        delay: 300.ms,
                      ),
                    ],
                    child: Text(
                      'حدث خطأ أثناء إنشاء التقرير',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Error details
                  Animate(
                    effects: [
                      SlideEffect(
                        duration: 600.ms,
                        delay: 400.ms,
                        begin: const Offset(0, 30),
                        end: const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                        delay: 400.ms,
                      ),
                    ],
                    child: Text(
                      _errorMessage,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Retry button
                  Animate(
                    effects: [
                      SlideEffect(
                        duration: 600.ms,
                        delay: 500.ms,
                        begin: const Offset(0, 30),
                        end: const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                      ),
                      FadeEffect(
                        duration: 600.ms,
                        delay: 500.ms,
                      ),
                    ],
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isGenerating = true;
                          _errorMessage = '';
                        });
                        _generateReport();
                      },
                      style: AppTheme.primaryButtonStyle,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}