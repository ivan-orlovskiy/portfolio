import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_vacancy_repository.dart';

class CreateVacancy implements IUsecase<Success, CreateVacancyParams> {
  final IVacancyRepository repository;

  CreateVacancy(this.repository);

  @override
  Future<Either<Failure, Success>> call(CreateVacancyParams params) async {
    return await repository.createVacancy(params.newVacancy);
  }
}

class CreateVacancyParams extends Equatable {
  final Vacancy newVacancy;

  const CreateVacancyParams({
    required this.newVacancy,
  });

  @override
  List<Object> get props => [newVacancy];
}
