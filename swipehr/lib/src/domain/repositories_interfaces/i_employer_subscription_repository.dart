import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';

abstract class IEmployerSubscriptionRepository {
  Future<Either<Failure, Success>> subscribe(String employerId);
}
