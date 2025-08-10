import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/domain/entities/application.dart';

abstract class IApplicationRepository {
  Future<Either<Failure, Success>> createApplication(Application newApplication, File file);
  Future<Either<Failure, Success>> deleteApplication(String applicationId);
  Future<Either<Failure, Application>> loadOwnApplication(String employeeId, String vacancyId);
  Future<Either<Failure, List<Application>>> loadApplicationsForAVacancy(String vacancyId);
}
