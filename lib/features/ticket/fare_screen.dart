import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import 'ticket_provider.dart';

class FareScreen extends ConsumerStatefulWidget {
  const FareScreen({super.key});

  @override
  ConsumerState<FareScreen> createState() => _FareScreenState();
}

class _FareScreenState extends ConsumerState<FareScreen> {
  final Map<String, int> _exitRates = {
    'Syokimau': 120,
    'SGR': 170,
    'JKIA': 250,
    'Eastern Bypass': 300,
    'Capital Centre': 360,
    'Museum Hill': 400,
    'Westlands': 500,
  };

  String? _selectedExit;

  @override
  Widget build(BuildContext context) {
    final ticketState = ref.watch(ticketProvider);
    final fare = _selectedExit != null ? _exitRates[_selectedExit] : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Fare Calculation')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Entry Point', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(ticketState.entryPoint ?? 'Unknown', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Expected Exit',
                border: OutlineInputBorder(),
              ),
              value: _selectedExit,
              items: _exitRates.keys.map((exit) {
                return DropdownMenuItem(
                  value: exit,
                  child: Text(exit),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedExit = val;
                });
              },
            ),
            const Spacer(),
            if (_selectedExit != null)
              Center(
                child: Column(
                  children: [
                    Text('Total Fare', style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      'KES $fare',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectedExit == null ? null : () {
                context.push('/payment');
              },
              child: const Text('Proceed to Pay'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
