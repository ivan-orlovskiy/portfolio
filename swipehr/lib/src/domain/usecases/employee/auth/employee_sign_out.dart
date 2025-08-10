import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/core/usecase/no_params.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_repository.dart';

class EmployeeSignOut implements IUsecase<Success, NoParams> {
  final IEmployeeRepository repository;

  EmployeeSignOut(this.repository);

  @override
  Future<Either<Failure, Success>> call(NoParams params) async {
    return await repository.signOut();
  }
}
