import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../payment/payment_provider.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() async {
    // Simulate auto-fetching entry/exit from toll portal systems
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isFetching = false);
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(paymentProvider);

    ref.listen<PaymentStatus>(paymentProvider, (previous, next) {
      if (next == PaymentStatus.success) {
        // Pushing to Pass Screen with emergency override flag
        context.push('/pass', extra: true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency ETC Bridge'),
        backgroundColor: AppColors.error.withOpacity(0.1),
      ),
      body: _isFetching
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.error))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                          size: 64, color: AppColors.error)
                      .animate()
                      .shake(hz: 4, duration: 800.ms),
                  const SizedBox(height: 16),
                  Text(
                    'OBU Detection Failed',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      border: Border.all(color: AppColors.error),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Detected Entry: JKIA',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Current Exit: Westlands',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Divider(color: AppColors.error),
                        Text('Max Default Fee Applied',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'KES 500.00',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const Spacer(),
                  if (status == PaymentStatus.pending)
                    const Column(
                      children: [
                        CircularProgressIndicator(color: AppColors.error),
                        SizedBox(height: 16),
                        Text('Waiting for M-Pesa PIN...',
                            style: TextStyle(color: AppColors.error))
                      ],
                    ).animate().fade()
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(paymentProvider.notifier)
                            .initiateMpesaStk("+254 7XX XXX XXX", 500);
                      },
                      icon: const Icon(Icons.payment, color: Colors.white),
                      label: const Text('Pay Emergency Fee',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    )
                        .animate()
                        .scale(curve: Curves.easeOutBack, duration: 400.ms),
                ],
              ),
            ),
    );
  }
}
