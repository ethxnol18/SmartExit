import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AttendantLoginScreen extends StatefulWidget {
  const AttendantLoginScreen({super.key});

  @override
  State<AttendantLoginScreen> createState() => _AttendantLoginScreenState();
}

class _AttendantLoginScreenState extends State<AttendantLoginScreen> {
  final _pinController = TextEditingController();

  void _login() {
    if (_pinController.text.isNotEmpty) {
      context.push('/attendant/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings, size: 80, color: Colors.black87),
                const SizedBox(height: 16),
                const Text(
                  'Operator Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Operator PIN',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800], // distinct action color
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _login,
                    child: const Text('Access Portal', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
