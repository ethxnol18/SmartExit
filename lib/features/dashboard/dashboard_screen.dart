import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _promoController = PageController();
  int _currentPromoPage = 0;
  Timer? _promoTimer;

  @override
  void initState() {
    super.initState();
    _startPromoTimer();
  }

  void _startPromoTimer() {
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_promoController.hasClients) {
        int nextPage = (_currentPromoPage + 1) % 3;
        _promoController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartExit Home'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().scale(curve: Curves.easeOutBack, delay: 500.ms),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLoyaltyBanner(context),
            const SizedBox(height: 24),
            _buildPromos(),
            const SizedBox(height: 24),
            _buildWalletCard(context),
            const SizedBox(height: 24),
            _buildCarSlider(context),
            const SizedBox(height: 32),
            _buildEmergencyButton(context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () => context.push('/trip'),
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: const Text('Start Active Trip Simulation', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.primary,
                   padding: const EdgeInsets.symmetric(vertical: 16)
                )
              ),
            ),
            const SizedBox(height: 80), // Fab space
          ].animate(interval: 100.ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
        ),
      ),
    );
  }

  Widget _buildLoyaltyBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loyalty Program', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('Level 2 • 3,450 pts', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Colors.black,
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromos() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _promoController,
            onPageChanged: (idx) => setState(() => _currentPromoPage = idx),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.6),
                      AppColors.surface,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                     'Exclusive Offer ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPromoPage == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPromoPage == index ? AppColors.primary : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wallet Balance', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text('KES 2,450.00', style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Top Up'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('My Vehicles', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: PageView(
            controller: PageController(viewportFraction: 0.85),
            padEnds: false,
            children: const [
              _CarCard(plate: 'KDC 123A', trips: 12, spend: '4,500', distance: '124'),
              _CarCard(plate: 'KDG 789B', trips: 4, spend: '1,200', distance: '45'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () { context.push('/emergency'); },
        icon: const Icon(Icons.warning, color: AppColors.error),
        label: const Text('Emergency Exit Pass', style: TextStyle(color: AppColors.error, fontSize: 16)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

class _CarCard extends StatelessWidget {
  final String plate, spend, distance;
  final int trips;

  const _CarCard({
    required this.plate,
    required this.trips,
    required this.spend,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plate, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
              const Icon(Icons.directions_car, color: AppColors.primary),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Trips', trips.toString(), context),
              _buildStat('Spend', 'KES $spend', context),
              _buildStat('Distance', '${distance}km', context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
