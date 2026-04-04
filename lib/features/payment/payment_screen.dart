import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import 'payment_provider.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(paymentProvider);

    // Watcher logic to wait for success and navigate
    ref.listen<PaymentStatus>(paymentProvider, (previous, next) {
      if (next == PaymentStatus.success) {
        context.push('/pass');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Multi-Channel Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            // M-Pesa Primary Row
            InkWell(
              onTap: status == PaymentStatus.pending
                  ? null
                  : () {
                      ref.read(paymentProvider.notifier).initiateMpesaStk("+254 7XX XXX XXX", 100);
                    },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android, color: AppColors.primary, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('M-Pesa STK Push', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Direct to phone', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    if (status == PaymentStatus.pending)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1000.ms, color: AppColors.primary)
                    else
                      const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
                  ],
                ),
              ),
            ),
            if (status == PaymentStatus.pending)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: const Text('Waiting for PIN...', textAlign: TextAlign.center)
                    .animate()
                    .fade(duration: 500.ms)
                    .tint(color: AppColors.primary),
              ),
            
            const SizedBox(height: 24),
            // Airtel Money
            const _DisabledPaymentMethod(icon: Icons.cell_tower, title: 'Airtel Money'),
            const SizedBox(height: 12),
            // Card
            const _DisabledPaymentMethod(icon: Icons.credit_card, title: 'Bank Card'),
            const SizedBox(height: 12),
            // USSD
            const _DisabledPaymentMethod(icon: Icons.dialpad, title: 'USSD'),
          ],
        ),
      ),
    );
  }
}

class _DisabledPaymentMethod extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DisabledPaymentMethod({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('Coming Soon', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
