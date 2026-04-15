import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Current Balance',
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text('KES 2,450.00',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: AppColors.primary)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/payment');
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text('Top Up'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text('Withdraw',
                          style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                _TransactionTile(
                    title: 'Toll Payment - Syokimau',
                    date: 'Oct 24, 14:30',
                    amount: '- KES 120',
                    isTopUp: false),
                _TransactionTile(
                    title: 'M-Pesa Top Up',
                    date: 'Oct 23, 09:15',
                    amount: '+ KES 1000',
                    isTopUp: true),
                _TransactionTile(
                    title: 'Toll Payment - Museum Hill',
                    date: 'Oct 22, 18:45',
                    amount: '- KES 400',
                    isTopUp: false),
                _TransactionTile(
                    title: 'M-Pesa Top Up',
                    date: 'Oct 20, 11:00',
                    amount: '+ KES 1500',
                    isTopUp: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title, date, amount;
  final bool isTopUp;

  const _TransactionTile(
      {required this.title,
      required this.date,
      required this.amount,
      required this.isTopUp});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: isTopUp
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.error.withOpacity(0.2),
        child: Icon(
          isTopUp ? Icons.arrow_downward : Icons.arrow_upward,
          color: isTopUp ? AppColors.primary : AppColors.error,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle:
          Text(date, style: const TextStyle(color: AppColors.textSecondary)),
      trailing: Text(
        amount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isTopUp ? AppColors.primary : AppColors.error,
        ),
      ),
    );
  }
}
