import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import 'vehicle_provider.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _plateController = TextEditingController();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _dobController = TextEditingController();
  
  bool _isPlateValid = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _plateController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _validatePlate(String value) {
    // Regex: Example 'KDC 123A'
    final regex = RegExp(r'^[K][A-Z]{2}\s\d{3}[A-Z]$');
    setState(() {
      _isPlateValid = regex.hasMatch(value.toUpperCase());
    });
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate() && _isPlateValid) {
      ref.read(vehicleProvider.notifier).addVehicle(_plateController.text.toUpperCase());
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Vehicle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Vehicle Details', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                textCapitalization: TextCapitalization.characters,
                onChanged: _validatePlate,
                decoration: InputDecoration(
                  labelText: 'Registration Number (e.g. KDC 123A)',
                  border: const OutlineInputBorder(),
                  suffixIcon: _isPlateValid
                      ? const Icon(Icons.check_circle, color: AppColors.primary).animate().scale()
                      : null,
                ),
              ),
              const SizedBox(height: 32),
              
              Text('KYC Verification', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'National ID', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isPlateValid ? _saveVehicle : null,
                child: const Text('Save Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
