import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_vacancy_repository.dart';

class LoadOwnVacancies implements IUsecase<List<Vacancy>, LoadOwnVacanciesParams> {
  final IVacancyRepository repository;

  LoadOwnVacancies(this.repository);

  @override
  Future<Either<Failure, List<Vacancy>>> call(LoadOwnVacanciesParams params) async {
    return await repository.loadOwnVacancies(params.employerId);
  }
}

class LoadOwnVacanciesParams extends Equatable {
  final String employerId;

  const LoadOwnVacanciesParams({
    required this.employerId,
  });

  @override
  List<Object> get props => [employerId];
}
