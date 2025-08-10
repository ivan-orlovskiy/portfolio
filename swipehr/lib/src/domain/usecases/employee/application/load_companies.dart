import 'package:dartz/dartz.dart';
import 'package:swipehr/src/core/failures/failure.dart';
import 'package:swipehr/src/core/usecase/i_usecase.dart';
import 'package:swipehr/src/core/usecase/no_params.dart';
import 'package:swipehr/src/domain/entities/employer.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_repository.dart';

class LoadCompanies implements IUsecase<List<Employer>, NoParams> {
  final IEmployerRepository repository;

  LoadCompanies(this.repository);

  @override
  Future<Either<Failure, List<Employer>>> call(NoParams params) async {
    return await repository.loadCompanies();
  }
}
