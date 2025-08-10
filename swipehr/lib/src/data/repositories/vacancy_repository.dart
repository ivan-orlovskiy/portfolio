import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/exceptions/base_exception.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_vacancy_datasource.dart';
import 'package:swipehr/src/data/models/vacancy_model.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_vacancy_repository.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';

class VacancyRepository implements IVacancyRepository {
  final IVacancyDatasource datasource;

  VacancyRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Success>> createVacancy(Vacancy newVacancy) async {
    try {
      final model = VacancyModel.fromEntity(newVacancy);
      await datasource.createVacancy(model);
      return const Right(Success());
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteVacancy(String vacancyId) async {
    try {
      await datasource.deleteVacancy(vacancyId);
      return const Right(Success());
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, List<Vacancy>>> loadOwnVacancies(String employerId) async {
    try {
      final models = await datasource.loadOwnVacancies(employerId);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, List<Vacancy>>> loadVacanciesForEmployer(String employerId) async {
    try {
      final models = await datasource.loadOwnVacancies(employerId);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }
}
