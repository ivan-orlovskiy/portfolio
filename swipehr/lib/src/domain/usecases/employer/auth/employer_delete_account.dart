import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_repository.dart';

class EmployerDeleteAccount implements IUsecase<Success, EmployerDeleteAccountParams> {
  final IEmployerRepository repository;

  EmployerDeleteAccount(this.repository);

  @override
  Future<Either<Failure, Success>> call(EmployerDeleteAccountParams params) async {
    return await repository.deleteAccount(params.employerId);
  }
}

class EmployerDeleteAccountParams extends Equatable {
  final String employerId;

  const EmployerDeleteAccountParams({
    required this.employerId,
  });

  @override
  List<Object> get props => [employerId];
}
