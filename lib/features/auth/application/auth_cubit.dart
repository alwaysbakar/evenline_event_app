import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/app_store.dart';

enum AuthStatus { idle, loading, success, failure }

class AuthState {
  const AuthState({this.status = AuthStatus.idle, this.message});
  final AuthStatus status;
  final String? message;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.store) : super(const AuthState());
  final AppStore store;

  Future<void> signIn(String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final success = await store.signIn(email, password);
      emit(success ? const AuthState(status: AuthStatus.success) : const AuthState(status: AuthStatus.failure, message: 'Check your email and password.'));
    } catch (_) {
      emit(const AuthState(status: AuthStatus.failure, message: 'Unable to sign in. Please try again.'));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final success = await store.signUp(name, email, password);
      emit(success ? const AuthState(status: AuthStatus.success) : const AuthState(status: AuthStatus.failure, message: 'Complete all fields and use a valid password.'));
    } catch (_) {
      emit(const AuthState(status: AuthStatus.failure, message: 'Unable to create your account.'));
    }
  }
}