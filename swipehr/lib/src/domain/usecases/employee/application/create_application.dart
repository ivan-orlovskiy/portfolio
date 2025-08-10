import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_application_repository.dart';

class CreateApplication implements IUsecase<Success, CreateApplicationParams> {
  final IApplicationRepository repository;

  CreateApplication(this.repository);

  @override
  Future<Either<Failure, Success>> call(CreateApplicationParams params) async {
    return await repository.createApplication(params.newApplication, params.file);
  }
}

class CreateApplicationParams extends Equatable {
  final File file;
  final Application newApplication;

  const CreateApplicationParams({
    required this.newApplication,
    required this.file,
  });

  @override
  List<Object> get props => [newApplication, file];
}
