import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/domain/entities/employer.dart';

abstract class IEmployerRepository {
  Future<Either<Failure, List<Employer>>> loadCompanies();
  Future<Either<Failure, Success>> deleteAccount(String employerId);
  Future<Either<Failure, Employer>> loadOwnAccount(String employerId);
  Future<Either<Failure, Employer>> signIn(String email, String password);
  Future<Either<Failure, Success>> signOut();
  Future<Either<Failure, Employer>> signUp(
      String email, String password, String companyName, File photo);
}
