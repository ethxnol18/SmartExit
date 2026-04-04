import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/auth');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.toll, // Placeholder for actual logo
              size: 100,
              color: AppColors.primary,
            )
            .animate()
            .fade(duration: 800.ms)
            .scale(duration: 800.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(
              'SmartExit',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primary,
                  ),
            )
            .animate()
            .fade(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
