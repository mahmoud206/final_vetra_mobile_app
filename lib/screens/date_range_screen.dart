import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/database_provider.dart';
import '../providers/report_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'generating_report_screen.dart';

class DateRangeScreen extends StatefulWidget {
  const DateRangeScreen({super.key});

  @override
  State<DateRangeScreen> createState() => _DateRangeScreenState();
}

class _DateRangeScreenState extends State<DateRangeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  
  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    final reportProvider = Provider.of<ReportProvider>(context);
    
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
                      Constants.selectDateRange,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
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
                          'حدد نطاق التاريخ للبيانات المطلوبة',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textColor.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'قاعدة البيانات: ${databaseProvider.selectedDatabase}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Date range form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'startDate': reportProvider.startDate,
                    'endDate': reportProvider.endDate,
                  },
                  child: Column(
                    children: [
                      // Start Date
                      Animate(
                        effects: [
                          SlideEffect(
                            duration: 600.ms,
                            delay: 400.ms,
                            begin: const Offset(30, 0),
                            end: const Offset(0, 0),
                            curve: Curves.easeOutCubic,
                          ),
                          FadeEffect(
                            duration: 600.ms,
                            delay: 400.ms,
                          ),
                        ],
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.borderRadius,
                            side: BorderSide(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Constants.startDate,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FormBuilderDateTimePicker(
                                  name: 'startDate',
                                  inputType: InputType.date,
                                  decoration: InputDecoration(
                                    hintText: 'اختر تاريخ البدء',
                                    prefixIcon: const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                  locale: const Locale('ar', ''),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(errorText: 'يرجى اختيار تاريخ البدء'),
                                  ]),
                                  format: DateFormat('yyyy-MM-dd', 'ar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // End Date
                      Animate(
                        effects: [
                          SlideEffect(
                            duration: 600.ms,
                            delay: 500.ms,
                            begin: const Offset(30, 0),
                            end: const Offset(0, 0),
                            curve: Curves.easeOutCubic,
                          ),
                          FadeEffect(
                            duration: 600.ms,
                            delay: 500.ms,
                          ),
                        ],
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.borderRadius,
                            side: BorderSide(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Constants.endDate,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FormBuilderDateTimePicker(
                                  name: 'endDate',
                                  inputType: InputType.date,
                                  decoration: InputDecoration(
                                    hintText: 'اختر تاريخ الانتهاء',
                                    prefixIcon: const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                  locale: const Locale('ar', ''),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(errorText: 'يرجى اختيار تاريخ الانتهاء'),
                                  ]),
                                  format: DateFormat('yyyy-MM-dd', 'ar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Date range info
                      Animate(
                        effects: [
                          SlideEffect(
                            duration: 600.ms,
                            delay: 600.ms,
                            begin: const Offset(0, 20),
                            end: const Offset(0, 0),
                            curve: Curves.easeOutCubic,
                          ),
                          FadeEffect(
                            duration: 600.ms,
                            delay: 600.ms,
                          ),
                        ],
                        child: Card(
                          color: AppTheme.primaryLightColor.withOpacity(0.2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.borderRadius,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: AppTheme.primaryDarkColor,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'سيتم عرض البيانات في الفترة المحددة فقط، تأكد من اختيار الفترة الزمنية المناسبة',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.primaryDarkColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Generate report button
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
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      final startDate = formData['startDate'] as DateTime;
                      final endDate = formData['endDate'] as DateTime;
                      
                      // Validate date range
                      if (endDate.isBefore(startDate)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تاريخ الانتهاء يجب أن يكون بعد تاريخ البدء'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      // Set date range in provider
                      reportProvider.setDateRange(startDate, endDate);
                      
                      // Navigate to generating report screen
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => 
                            const GeneratingReportScreen(),
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
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      Constants.generateReport,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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