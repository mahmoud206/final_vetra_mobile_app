import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_theme.dart';
import 'database_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.forward().then((_) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            const DatabaseSelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOutCubic;
            
            var fadeAnimation = Tween(
              begin: begin,
              end: end,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
            );
            
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          transitionDuration: AppTheme.longAnimationDuration,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animation
            Animate(
              effects: [
                ScaleEffect(
                  duration: 800.ms,
                  delay: 300.ms,
                  curve: Curves.easeOutBack,
                ),
                FadeEffect(
                  duration: 600.ms,
                  delay: 300.ms,
                ),
              ],
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.cardShadow,
                ),
                child: const Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // App title
            Animate(
              effects: [
                SlideEffect(
                  duration: 800.ms,
                  delay: 600.ms,
                  begin: const Offset(0, 50),
                  end: const Offset(0, 0),
                  curve: Curves.easeOutCubic,
                ),
                FadeEffect(
                  duration: 800.ms,
                  delay: 600.ms,
                ),
              ],
              child: Text(
                'تقارير الإنعام',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tagline
            Animate(
              effects: [
                SlideEffect(
                  duration: 800.ms,
                  delay: 800.ms,
                  begin: const Offset(0, 50),
                  end: const Offset(0, 0),
                  curve: Curves.easeOutCubic,
                ),
                FadeEffect(
                  duration: 800.ms,
                  delay: 800.ms,
                ),
              ],
              child: Text(
                'نظام التقارير المالية',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.7),
                ),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Loading animation
            Animate(
              effects: [
                FadeEffect(
                  duration: 600.ms,
                  delay: 1200.ms,
                ),
              ],
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
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