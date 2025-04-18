import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'date_range_screen.dart';
import '../widgets/database_card.dart';

class DatabaseSelectionScreen extends StatelessWidget {
  const DatabaseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    
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
                      Constants.selectDatabase,
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
                    child: Text(
                      'اختر قاعدة البيانات التي تريد استخراج التقارير منها',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            // Database options
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: Constants.databases.asMap().entries.map((entry) {
                    final index = entry.key;
                    final database = entry.value;
                    
                    return Animate(
                      effects: [
                        SlideEffect(
                          duration: 600.ms,
                          delay: Duration(milliseconds: 300 + (index * 100)),
                          begin: const Offset(30, 0),
                          end: const Offset(0, 0),
                          curve: Curves.easeOutCubic,
                        ),
                        FadeEffect(
                          duration: 600.ms,
                          delay: Duration(milliseconds: 300 + (index * 100)),
                        ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DatabaseCard(
                          name: database,
                          isSelected: databaseProvider.selectedDatabase == database,
                          onTap: () {
                            databaseProvider.selectDatabase(database);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Connect button
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
                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text('جاري الاتصال بقاعدة البيانات ${databaseProvider.selectedDatabase}...'),
                            ],
                          ),
                        );
                      },
                    );
                    
                    // Connect to database
                    final success = await databaseProvider.connect();
                    
                    // Close loading dialog
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      
                      if (success) {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => 
                              const DateRangeScreen(),
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('حدث خطأ: ${databaseProvider.errorMessage}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'اتصال',
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