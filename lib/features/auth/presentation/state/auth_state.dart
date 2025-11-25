
import 'package:rider_pay_driver/features/auth/data/model/auth_responce.dart';

class AuthState {
  final bool isLoading;
  final AuthResponse? response;
  final String? error;

  AuthState({
    required this.isLoading,
    this.response,
    this.error,
  });

  factory AuthState.initial() => AuthState(isLoading: false);

  AuthState copyWith({
    bool? isLoading,
    AuthResponse? response,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}
