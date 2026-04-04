import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentStatus { idle, pending, success, failed }

class PaymentNotifier extends StateNotifier<PaymentStatus> {
  PaymentNotifier() : super(PaymentStatus.idle);

  Future<void> initiateMpesaStk(String phone, int amount) async {
    state = PaymentStatus.pending;
    
    // Simulate network delay and user STK PIN typing time
    await Future.delayed(const Duration(seconds: 4));
    
    state = PaymentStatus.success;
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentStatus>((ref) {
  return PaymentNotifier();
});
