import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/employee.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_repository.dart';

class EmployeeSignIn implements IUsecase<Employee, EmployeeSignInParams> {
  final IEmployeeRepository repository;

  EmployeeSignIn(this.repository);

  @override
  Future<Either<Failure, Employee>> call(EmployeeSignInParams params) async {
    return await repository.signIn(params.email, params.password);
  }
}

class EmployeeSignInParams extends Equatable {
  final String email;
  final String password;

  const EmployeeSignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
