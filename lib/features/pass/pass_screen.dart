import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';

class PassScreen extends StatefulWidget {
  final bool isEmergency;
  const PassScreen({super.key, this.isEmergency = false});

  @override
  State<PassScreen> createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  int _timeRemaining = 15 * 60; // 15 mins
  Timer? _timer;
  final String _passCode = "X9A-BV2";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timeRemaining = 15 * 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() => _timeRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = (_timeRemaining / 60).floor();
    final seconds = _timeRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = _timeRemaining < 120; // Under 2 mins
    final timeColor = isCritical ? AppColors.error : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SmartExit Pass',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              )
              .animate()
              .shimmer(duration: 2.seconds),
              
              const SizedBox(height: 16),
              
              Text(
                'Expires in:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: timeColor,
                      fontWeight: FontWeight.bold,
                    ),
                child: Text(formattedTime),
              ),

              const SizedBox(height: 48),

              // Glowing Pass UI
              if (widget.isEmergency)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.error, width: 2),
                  ),
                  child: const Text('EMERGENCY OVERRIDE', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ).animate().flash(duration: 2.seconds),
                
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: QrImageView(
                        data: _passCode,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _passCode,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                letterSpacing: 4,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: AppColors.primary),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _passCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: const Text('Pass code copied')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .scale(curve: Curves.easeOutBack, duration: 800.ms),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.refresh, color: AppColors.primary),
                  label: const Text('Renew Pass', style: TextStyle(color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
