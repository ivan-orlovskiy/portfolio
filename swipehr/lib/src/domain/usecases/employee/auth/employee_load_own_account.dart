import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/employee.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_repository.dart';

class EmployeeLoadOwnAccount implements IUsecase<Employee, EmployeeLoadOwnAccountParams> {
  final IEmployeeRepository repository;

  EmployeeLoadOwnAccount(this.repository);

  @override
  Future<Either<Failure, Employee>> call(EmployeeLoadOwnAccountParams params) async {
    return await repository.loadOwnAccount(params.employeeId);
  }
}

class EmployeeLoadOwnAccountParams extends Equatable {
  final String employeeId;

  const EmployeeLoadOwnAccountParams({
    required this.employeeId,
  });

  @override
  List<Object> get props => [employeeId];
}
