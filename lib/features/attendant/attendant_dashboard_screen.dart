import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class AttendantDashboardScreen extends StatefulWidget {
  const AttendantDashboardScreen({super.key});

  @override
  State<AttendantDashboardScreen> createState() => _AttendantDashboardScreenState();
}

enum VerificationState { idle, valid, invalid }

class _AttendantDashboardScreenState extends State<AttendantDashboardScreen> {
  final _manualController = TextEditingController();
  VerificationState _state = VerificationState.idle;

  void _verifyCode(String code) {
    if (code.trim().toUpperCase() == 'X9A-BV2') {
      setState(() => _state = VerificationState.valid);
    } else {
      setState(() => _state = VerificationState.invalid);
    }
  }

  void _reset() {
    setState(() {
      _state = VerificationState.idle;
      _manualController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _state == VerificationState.idle 
            ? AppBar(
                title: const Text('Attendant Portal', style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => context.pop(), // back to login
                  ),
                ],
              ) 
            : null,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case VerificationState.valid:
        return _buildResultScreen(true);
      case VerificationState.invalid:
        return _buildResultScreen(false);
      case VerificationState.idle:
      default:
        return _buildScanner();
    }
  }

  Widget _buildScanner() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: MobileScanner(
             onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  _verifyCode(barcodes.first.rawValue!);
                }
             },
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Or Enter Code Manually:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _manualController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g. X9A-BV2',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                      onPressed: () {
                         if(_manualController.text.isNotEmpty) {
                           _verifyCode(_manualController.text);
                         }
                      },
                      child: const Text('Verify', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen(bool isValid) {
    return Container(
      width: double.infinity,
      color: isValid ? Colors.green[600] : Colors.red[600],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isValid ? Icons.check_circle : Icons.cancel, size: 120, color: Colors.white),
          const SizedBox(height: 24),
          Text(
            isValid ? 'PAID' : 'INVALID',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            isValid ? 'Open Gate' : 'Deny Entry',
            style: const TextStyle(fontSize: 24, color: Colors.white70),
          ),
          const SizedBox(height: 64),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: isValid ? Colors.green[800] : Colors.red[800],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            label: const Text('Scan Next Ticket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
