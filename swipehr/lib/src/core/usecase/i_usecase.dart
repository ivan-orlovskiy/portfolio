import 'package:dartz/dartz.dart';

import '../failures/failure.dart';

abstract class IUsecase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}
