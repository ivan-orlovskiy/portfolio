import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_application_repository.dart';

class LoadOwnApplication implements IUsecase<Application, LoadOwnApplicationParams> {
  final IApplicationRepository repository;

  LoadOwnApplication(this.repository);

  @override
  Future<Either<Failure, Application>> call(LoadOwnApplicationParams params) async {
    return await repository.loadOwnApplication(params.employeeId, params.vacancyId);
  }
}

class LoadOwnApplicationParams extends Equatable {
  final String employeeId;
  final String vacancyId;

  const LoadOwnApplicationParams({
    required this.employeeId,
    required this.vacancyId,
  });

  @override
  List<Object> get props => [employeeId, vacancyId];
}
