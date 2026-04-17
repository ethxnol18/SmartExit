import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data based on requested categories
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Toll Payment Success',
        'body': 'KES 120.00 deducted for trip to JKIA.',
        'time': '2 mins ago',
        'icon': Icons.check_circle_outline,
        'color': AppColors.primary,
        'isUnread': true,
      },
      {
        'title': 'Trip Summary Generated',
        'body': 'Your trip from Westlands is complete. Distance: 15km.',
        'time': '1 hour ago',
        'icon': Icons.route,
        'color': Colors.blueAccent,
        'isUnread': true,
      },
      {
        'title': 'Wallet Top-up Alert',
        'body': 'Successfully topped up KES 1000.00 via M-Pesa.',
        'time': 'Yesterday',
        'icon': Icons.account_balance_wallet,
        'color': Colors.amber,
        'isUnread': false,
      },
      {
        'title': 'Driving Points Earned!',
        'body': 'You earned 45 points from your last trip. Keep driving smart!',
        'time': 'Yesterday',
        'icon': Icons.stars,
        'color': Colors.purpleAccent,
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return _buildNotificationCard(item, context)
              .animate()
              .fadeIn(duration: 400.ms, delay: (index * 100).ms)
              .slideX(begin: 0.1, curve: Curves.easeOut);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> data, BuildContext context) {
    final bool isUnread = data['isUnread'];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.surface.withOpacity(0.9) : AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? (data['color'] as Color).withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: (data['color'] as Color).withOpacity(0.2),
          child: Icon(data['icon'] as IconData, color: data['color'] as Color),
        ),
        title: Text(
          data['title'] as String,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['body'] as String,
                style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 8),
              Text(
                data['time'] as String,
                style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        trailing: isUnread
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}
