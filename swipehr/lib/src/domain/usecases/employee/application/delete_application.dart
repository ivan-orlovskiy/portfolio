import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/success/success.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_application_repository.dart';

class DeleteApplication implements IUsecase<Success, DeleteApplicationParams> {
  final IApplicationRepository repository;

  DeleteApplication(this.repository);

  @override
  Future<Either<Failure, Success>> call(DeleteApplicationParams params) async {
    return await repository.deleteApplication(params.applicationId);
  }
}

class DeleteApplicationParams extends Equatable {
  final String applicationId;

  const DeleteApplicationParams({
    required this.applicationId,
  });

  @override
  List<Object> get props => [applicationId];
}
