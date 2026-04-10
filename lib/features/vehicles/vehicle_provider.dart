import 'package:flutter_riverpod/flutter_riverpod.dart';

class Vehicle {
  final String plate;
  final int trips;
  final int distance;
  final int spend;

  Vehicle({required this.plate, this.trips = 0, this.distance = 0, this.spend = 0});
}

class VehicleNotifier extends StateNotifier<List<Vehicle>> {
  VehicleNotifier() : super([
    Vehicle(plate: 'KDC 123A', trips: 12, spend: 4500, distance: 124),
    Vehicle(plate: 'KDG 789B', trips: 4, spend: 1200, distance: 45),
  ]);

  void addVehicle(String plate) {
    state = [...state, Vehicle(plate: plate)];
  }
}

final vehicleProvider = StateNotifierProvider<VehicleNotifier, List<Vehicle>>((ref) {
  return VehicleNotifier();
});
