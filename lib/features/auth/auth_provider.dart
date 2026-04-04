import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final String? phoneNumber;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.phoneNumber,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    String? phoneNumber,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 1500));
    state = state.copyWith(isLoading: false, phoneNumber: phone);
    return true; // Simulate success
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 1500));
    state = state.copyWith(isLoading: false);
    return true; // Simulate authentication success
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
