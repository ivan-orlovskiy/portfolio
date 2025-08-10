import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/domain/entities/employee.dart';

abstract class IEmployeeRepository {
  Future<Either<Failure, Success>> deleteAccount(String employeeId);
  Future<Either<Failure, Employee>> loadOwnAccount(String employeeId);
  Future<Either<Failure, Employee>> signIn(String email, String password);
  Future<Either<Failure, Success>> signOut();
  Future<Either<Failure, Employee>> signUp(String email, String password, File photo);
}
