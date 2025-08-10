import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehr/src/core/usecase/no_params.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_sign_in.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_sign_out.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_sign_up.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_sign_in.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_sign_out.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sp;
  final EmployeeSignOut employeeSignOut;
  final EmployerSignOut employerSignOut;
  final EmployeeSignUp employeeSignUp;
  final EmployerSignUp employerSignUp;
  final EmployeeSignIn employeeSignIn;
  final EmployerSignIn employerSignIn;

  // Shared preferences codes
  static const String loggedInKey = 'logged_in';
  static const String isEmployeeKey = 'is_employee';
  static const String userIdKey = 'user_id';

  AuthBloc({
    required this.sp,
    required this.employeeSignOut,
    required this.employerSignOut,
    required this.employeeSignUp,
    required this.employerSignUp,
    required this.employeeSignIn,
    required this.employerSignIn,
  }) : super(const AuthLoading()) {
    on<AuthAutoSignIn>((event, emit) => _onAutoSignIn(event, emit));
    on<AuthSignOut>((event, emit) => _onSignOut(event, emit));
    on<AuthSignUp>((event, emit) => _onSignUp(event, emit));
    on<AuthSignIn>((event, emit) => _onSignIn(event, emit));
  }

  void _onAutoSignIn(AuthAutoSignIn event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final loggedIn = sp.getBool(loggedInKey) ?? false;

    if (!loggedIn) {
      emit(const AuthLoggedOut());
      return;
    }

    final isEmployee = sp.getBool(isEmployeeKey) ?? false;
    emit(AuthLoggedIn(isEmployee));
  }

  void _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final isEmployee = sp.getBool(isEmployeeKey) ?? false;

    if (isEmployee) {
      await employeeSignOut(const NoParams());
    } else {
      await employerSignOut(const NoParams());
    }

    sp.remove(loggedInKey);
    sp.remove(userIdKey);
    emit(const AuthLoggedOut());
  }

  void _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    if (event.isEmployee) {
      final result = await employeeSignUp(
        EmployeeSignUpParams(
          email: event.email,
          password: event.password,
          photo: File(''),
        ),
      );

      await result.fold(
        (l) async => emit(AuthError(l.errorMessage)),
        (r) async {
          await sp.setString(userIdKey, r.id);
          await sp.setBool(isEmployeeKey, event.isEmployee);
          emit(AuthLoggedIn(event.isEmployee));
        },
      );
    } else {
      final result = await employerSignUp(
        EmployerSignUpParams(
          email: event.email,
          password: event.password,
          companyName: event.companyName,
          photo: File(''),
        ),
      );

      await result.fold(
        (l) async => emit(AuthError(l.errorMessage)),
        (r) async {
          await sp.setString(userIdKey, r.id);
          await sp.setBool(isEmployeeKey, event.isEmployee);
          emit(AuthLoggedIn(event.isEmployee));
        },
      );
    }

    await sp.setBool(loggedInKey, true);
  }

  void _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    if (event.isEmployee) {
      final result = await employeeSignIn(
        EmployeeSignInParams(
          email: event.email,
          password: event.password,
        ),
      );

      await result.fold(
        (l) async => emit(AuthError(l.errorMessage)),
        (r) async {
          await sp.setString(userIdKey, r.id);
          await sp.setBool(isEmployeeKey, event.isEmployee);
          emit(AuthLoggedIn(event.isEmployee));
        },
      );
    } else {
      final result = await employerSignIn(
        EmployerSignInParams(
          email: event.email,
          password: event.password,
        ),
      );

      await result.fold(
        (l) async => emit(AuthError(l.errorMessage)),
        (r) async {
          await sp.setString(userIdKey, r.id);
          await sp.setBool(isEmployeeKey, event.isEmployee);
          emit(AuthLoggedIn(event.isEmployee));
        },
      );
    }

    await sp.setBool(loggedInKey, true);
  }
}
