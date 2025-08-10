import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/employer.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_repository.dart';

class EmployerSignIn implements IUsecase<Employer, EmployerSignInParams> {
  final IEmployerRepository repository;

  EmployerSignIn(this.repository);

  @override
  Future<Either<Failure, Employer>> call(EmployerSignInParams params) async {
    return await repository.signIn(params.email, params.password);
  }
}

class EmployerSignInParams extends Equatable {
  final String email;
  final String password;

  const EmployerSignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
