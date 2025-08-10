import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/employee.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_repository.dart';

class EmployeeSignUp implements IUsecase<Employee, EmployeeSignUpParams> {
  final IEmployeeRepository repository;

  EmployeeSignUp(this.repository);

  @override
  Future<Either<Failure, Employee>> call(EmployeeSignUpParams params) async {
    return await repository.signUp(params.email, params.password, params.photo);
  }
}

class EmployeeSignUpParams extends Equatable {
  final String email;
  final String password;
  final File photo;

  const EmployeeSignUpParams({
    required this.email,
    required this.password,
    required this.photo,
  });

  @override
  List<Object> get props => [email, password, photo];
}
