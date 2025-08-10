import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/exceptions/base_exception.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_application_datasource.dart';
import 'package:swipehr/src/data/models/application_model.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_application_repository.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';

class ApplicationRepository implements IApplicationRepository {
  final IApplicationDatasource datasource;

  ApplicationRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Success>> createApplication(Application newApplication, File file) async {
    // try {
    final model = ApplicationModel.fromEntity(newApplication);
    await datasource.createApplication(model, file);
    return const Right(Success());
    // } on BaseException catch (e) {
    //   return Left(Failure(e.exceptionMessage));
    // } catch (_) {
    //   return Left(Failure(Lang.unknownEX));
    // }
  }

  @override
  Future<Either<Failure, Success>> deleteApplication(String applicationId) async {
    try {
      await datasource.deleteApplication(applicationId);
      return const Right(Success());
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, List<Application>>> loadApplicationsForAVacancy(String vacancyId) async {
    try {
      final models = await datasource.loadApplicationsForAVacancy(vacancyId);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Application>> loadOwnApplication(
      String employeeId, String vacancyId) async {
    try {
      final model = await datasource.loadOwnApplication(employeeId, vacancyId);
      final entitiy = model.toEntity();
      return Right(entitiy);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }
}
