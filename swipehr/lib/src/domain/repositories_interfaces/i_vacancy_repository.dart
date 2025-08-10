import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';

abstract class IVacancyRepository {
  Future<Either<Failure, List<Vacancy>>> loadOwnVacancies(String employerId);
  Future<Either<Failure, List<Vacancy>>> loadVacanciesForEmployer(String employerId);
  Future<Either<Failure, Success>> createVacancy(Vacancy newVacancy);
  Future<Either<Failure, Success>> deleteVacancy(String vacancyId);
}
