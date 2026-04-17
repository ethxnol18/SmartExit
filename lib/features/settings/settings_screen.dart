import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _handleLogout() async {
    // Clear session and return to auth
    await _secureStorage.deleteAll();
    if (!mounted) return;
    context.go('/auth');
  }

  Future<void> _handleDeleteAccount() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('DELETE ACCOUNT', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        content: const Text(
          'This action is completely irreversible. All your wallet balance, vehicles, and trip history will be permanently deleted out of our system.\n\nAre you sure you want to proceed?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('DELETE ACCOUNT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _secureStorage.deleteAll();
      if (!mounted) return;
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _buildSectionHeader('Preferences'),
          _buildSettingsTile(
            title: 'Edit Profile',
            subtitle: 'Update your personal details',
            icon: Icons.person_outline,
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Use the core Profile tab to edit details')));
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: AppColors.surface,
            title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Receive toll alerts and receipts', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
            activeColor: AppColors.primary,
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn(),

          const SizedBox(height: 32),
          _buildSectionHeader('Session Controls'),
          
          _buildSettingsTile(
            title: 'Sign Out',
            subtitle: 'Securely completely end your session',
            icon: Icons.logout,
            color: Colors.white,
            onTap: _handleLogout,
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            title: 'Delete Account',
            subtitle: 'Permanently remove your data',
            icon: Icons.delete_forever,
            color: AppColors.error,
            onTap: _handleDeleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color color = AppColors.primary,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: AppColors.surface,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color == AppColors.error ? color : Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn();
  }
}
