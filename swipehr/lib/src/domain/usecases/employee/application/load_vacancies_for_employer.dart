import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_vacancy_repository.dart';

class LoadVacanciesForEmployer implements IUsecase<List<Vacancy>, LoadVacanciesForEmployerParams> {
  final IVacancyRepository repository;

  LoadVacanciesForEmployer(this.repository);

  @override
  Future<Either<Failure, List<Vacancy>>> call(LoadVacanciesForEmployerParams params) async {
    return await repository.loadVacanciesForEmployer(params.employerId);
  }
}

class LoadVacanciesForEmployerParams extends Equatable {
  final String employerId;

  const LoadVacanciesForEmployerParams({
    required this.employerId,
  });

  @override
  List<Object> get props => [employerId];
}
