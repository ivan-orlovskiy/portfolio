import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_subscription_repository.dart';

class EmployerBuySubscription implements IUsecase<Success, EmployerBuySubscriptionParams> {
  final IEmployerSubscriptionRepository repository;

  EmployerBuySubscription(this.repository);

  @override
  Future<Either<Failure, Success>> call(EmployerBuySubscriptionParams params) async {
    return await repository.subscribe(params.employerId);
  }
}

class EmployerBuySubscriptionParams extends Equatable {
  final String employerId;

  const EmployerBuySubscriptionParams({
    required this.employerId,
  });

  @override
  List<Object> get props => [employerId];
}
