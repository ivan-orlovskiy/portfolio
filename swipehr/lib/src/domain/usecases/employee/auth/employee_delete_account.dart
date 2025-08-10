import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_repository.dart';

class EmployeeDeleteAccount implements IUsecase<Success, EmployeeDeleteAccountParams> {
  final IEmployeeRepository repository;

  EmployeeDeleteAccount(this.repository);

  @override
  Future<Either<Failure, Success>> call(EmployeeDeleteAccountParams params) async {
    return await repository.deleteAccount(params.employeeId);
  }
}

class EmployeeDeleteAccountParams extends Equatable {
  final String employeeId;

  const EmployeeDeleteAccountParams({
    required this.employeeId,
  });

  @override
  List<Object> get props => [employeeId];
}
