part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object> get props => [];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();

  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthLoggedIn extends AuthState {
  final bool isEmployee;

  const AuthLoggedIn(
    this.isEmployee,
  );

  @override
  List<Object> get props => [isEmployee];
}
