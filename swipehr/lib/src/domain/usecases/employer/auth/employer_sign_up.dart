import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/employer.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_repository.dart';

class EmployerSignUp implements IUsecase<Employer, EmployerSignUpParams> {
  final IEmployerRepository repository;

  EmployerSignUp(this.repository);

  @override
  Future<Either<Failure, Employer>> call(EmployerSignUpParams params) async {
    return await repository.signUp(params.email, params.password, params.companyName, params.photo);
  }
}

class EmployerSignUpParams extends Equatable {
  final String email;
  final String password;
  final String companyName;
  final File photo;

  const EmployerSignUpParams({
    required this.email,
    required this.password,
    required this.companyName,
    required this.photo,
  });

  @override
  List<Object> get props => [email, password, companyName, photo];
}
