part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthAutoSignIn extends AuthEvent {
  const AuthAutoSignIn();

  @override
  List<Object> get props => [];
}

class AuthSignOut extends AuthEvent {
  const AuthSignOut();

  @override
  List<Object> get props => [];
}

class AuthSignIn extends AuthEvent {
  final bool isEmployee;
  final String email;
  final String password;

  const AuthSignIn(
    this.isEmployee,
    this.email,
    this.password,
  );

  @override
  List<Object?> get props => [isEmployee, email, password];
}

class AuthSignUp extends AuthEvent {
  final bool isEmployee;
  final String email;
  final String password;
  final String companyName;

  const AuthSignUp(
    this.isEmployee,
    this.email,
    this.password,
    this.companyName,
  );

  @override
  List<Object> get props => [isEmployee, email, password, companyName];
}
