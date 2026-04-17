import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLocked = true;
  final TextEditingController _authController = TextEditingController();
  String? _authError;
  bool _shakeError = false;

  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _phoneController = TextEditingController(text: '+254 712 345 678');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');
  final TextEditingController _passwordController = TextEditingController(text: 'SmartExit2026!');

  void _verifyPassword() {
    // Strict validation: even one incorrect character prevents access
    if (_authController.text == 'SmartExit2026!') {
      setState(() {
        _isLocked = false;
        _authError = null;
      });
    } else {
      setState(() {
        _authError = 'ACCESS DENIED: Invalid Security Clearance';
        _shakeError = true;
      });
      // reset shake flag after animation completes
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _shakeError = false);
      });
    }
  }

  @override
  void dispose() {
    _authController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Driver Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!_isLocked) // Only show settings if unlocked
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        child: _isLocked ? _buildAuthenticationGate() : _buildProfileForm(),
      ),
    );
  }

  Widget _buildAuthenticationGate() {
    Widget authContainer = Container(
      key: const ValueKey('auth_gate'),
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _authError != null ? AppColors.error : AppColors.primary.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: _authError != null ? AppColors.error.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _authError != null ? Icons.lock_outline : Icons.lock,
            size: 64,
            color: _authError != null ? AppColors.error : AppColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'ENCRYPTED VAULT',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              letterSpacing: 4,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter master password to access profile details',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _authController,
            obscureText: true,
            style: const TextStyle(color: Colors.white, letterSpacing: 4),
            decoration: InputDecoration(
              hintText: 'PASSWORD',
              prefixIcon: const Icon(Icons.key, color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            onSubmitted: (_) => _verifyPassword(),
          ),
          if (_authError != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _authError!,
                style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ).animate().fade().slideY(),
            ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _verifyPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('DECRYPT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ),
          ),
        ],
      ),
    );

    if (_shakeError) {
      authContainer = authContainer.animate(key: UniqueKey()).shake(hz: 8, curve: Curves.easeInOut);
    } else {
      authContainer = authContainer.animate().fadeIn();
    }

    return Center(child: authContainer);
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      key: const ValueKey('profile_form'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.surface,
            child: Icon(Icons.person, size: 60, color: AppColors.primary),
          ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 32),
          
          _buildTextField('FULL NAME', _nameController, false),
          const SizedBox(height: 20),
          _buildTextField('PHONE NUMBER', _phoneController, false),
          const SizedBox(height: 20),
          _buildTextField('EMAIL ADDRESS', _emailController, false),
          const SizedBox(height: 20),
          _buildTextField('PASSWORD', _passwordController, true),
          
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Profile Updates Saved Securely'))
               );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('SAVE UPDATES', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn();
  }
}
