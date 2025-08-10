import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_vacancy_repository.dart';

class DeleteVacancy implements IUsecase<Success, DeleteVacancyParams> {
  final IVacancyRepository repository;

  DeleteVacancy(this.repository);

  @override
  Future<Either<Failure, Success>> call(DeleteVacancyParams params) async {
    return await repository.deleteVacancy(params.vacancyId);
  }
}

class DeleteVacancyParams extends Equatable {
  final String vacancyId;

  const DeleteVacancyParams({
    required this.vacancyId,
  });

  @override
  List<Object> get props => [vacancyId];
}
