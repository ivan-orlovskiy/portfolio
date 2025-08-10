import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/exceptions/base_exception.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_employer_datasource.dart';
import 'package:swipehr/src/domain/entities/employer.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_repository.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';

class EmployerRepository implements IEmployerRepository {
  final IEmployerDatasource datasource;

  EmployerRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Success>> deleteAccount(String employerId) async {
    try {
      await datasource.deleteAccount(employerId);
      return const Right(Success());
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, List<Employer>>> loadCompanies() async {
    try {
      final models = await datasource.loadCompanies();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Employer>> loadOwnAccount(String employerId) async {
    try {
      final model = await datasource.loadOwnAccount(employerId);
      final entity = model.toEntity();
      return Right(entity);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Employer>> signIn(String email, String password) async {
    try {
      final model = await datasource.signIn(email, password);
      final entity = model.toEntity();
      return Right(entity);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Success>> signOut() async {
    try {
      await datasource.signOut();
      return const Right(Success());
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Employer>> signUp(
      String email, String password, String companyName, File photo) async {
    try {
      final model = await datasource.signUp(email, password, companyName, photo);
      final entity = model.toEntity();
      return Right(entity);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }
}
