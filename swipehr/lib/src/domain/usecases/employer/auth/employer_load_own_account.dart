import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/employer.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_repository.dart';

class EmployerLoadOwnAccount implements IUsecase<Employer, EmployerLoadOwnAccountParams> {
  final IEmployerRepository repository;

  EmployerLoadOwnAccount(this.repository);

  @override
  Future<Either<Failure, Employer>> call(EmployerLoadOwnAccountParams params) async {
    return await repository.loadOwnAccount(params.employerId);
  }
}

class EmployerLoadOwnAccountParams extends Equatable {
  final String employerId;

  const EmployerLoadOwnAccountParams({
    required this.employerId,
  });

  @override
  List<Object> get props => [employerId];
}
