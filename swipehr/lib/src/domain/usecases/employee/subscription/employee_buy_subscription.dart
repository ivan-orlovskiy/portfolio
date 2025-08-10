import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_subscription_repository.dart';

class EmployeeBuySubscription implements IUsecase<Success, EmployeeBuySubscriptionParams> {
  final IEmployeeSubscriptionRepository repository;

  EmployeeBuySubscription(this.repository);

  @override
  Future<Either<Failure, Success>> call(EmployeeBuySubscriptionParams params) async {
    return await repository.subscribe(params.employeeId);
  }
}

class EmployeeBuySubscriptionParams extends Equatable {
  final String employeeId;

  const EmployeeBuySubscriptionParams({
    required this.employeeId,
  });

  @override
  List<Object> get props => [employeeId];
}
