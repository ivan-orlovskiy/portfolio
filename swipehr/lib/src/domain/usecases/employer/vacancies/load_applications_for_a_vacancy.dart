import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_application_repository.dart';

class LoadApplicationsForAVacancy
    implements IUsecase<List<Application>, LoadApplicationsForAVacancyParams> {
  final IApplicationRepository repository;

  LoadApplicationsForAVacancy(this.repository);

  @override
  Future<Either<Failure, List<Application>>> call(LoadApplicationsForAVacancyParams params) async {
    return await repository.loadApplicationsForAVacancy(params.vacancyId);
  }
}

class LoadApplicationsForAVacancyParams extends Equatable {
  final String vacancyId;

  const LoadApplicationsForAVacancyParams({
    required this.vacancyId,
  });

  @override
  List<Object> get props => [vacancyId];
}
