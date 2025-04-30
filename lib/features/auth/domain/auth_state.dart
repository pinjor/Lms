// lib/features/auth/domain/auth_state.dart
import 'package:bjp_app/features/auth/domain/login_response_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final bool isLoading;
  final LoginResponseModel? user;
  final String? error;
  final AuthStatus status;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    required this.status,
  });

  // Boolean to check if the user is logged in
  bool get isLoggedIn => status == AuthStatus.authenticated;

  // Getter to check if the user is admin
  bool get isAdmin => user?.user?.isAdmin == 1;
}
