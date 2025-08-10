import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/exceptions/base_exception.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_employee_datasource.dart';
import 'package:swipehr/src/domain/entities/employee.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_repository.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';

class EmployeeRepository implements IEmployeeRepository {
  final IEmployeeDatasource datasource;

  EmployeeRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Success>> deleteAccount(String employeeId) async {
    try {
      await datasource.deleteAccount(employeeId);
      return const Right(Success());
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Employee>> loadOwnAccount(String employeeId) async {
    try {
      final model = await datasource.loadOwnAccount(employeeId);
      final entity = model.toEntity();
      return Right(entity);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }

  @override
  Future<Either<Failure, Employee>> signIn(String email, String password) async {
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
  Future<Either<Failure, Employee>> signUp(String email, String password, File photo) async {
    try {
      final model = await datasource.signUp(email, password, photo);
      final entity = model.toEntity();
      return Right(entity);
    } on BaseException catch (e) {
      return Left(Failure(e.exceptionMessage));
    } catch (_) {
      return Left(Failure(Lang.unknownEX));
    }
  }
}
