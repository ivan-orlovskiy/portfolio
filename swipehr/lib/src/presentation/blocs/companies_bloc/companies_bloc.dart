import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipehr/src/core/usecase/no_params.dart';
import 'package:swipehr/src/domain/entities/employer.dart';
import 'package:swipehr/src/domain/usecases/employee/application/load_companies.dart';

part 'companies_event.dart';
part 'companies_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final LoadCompanies loadCompanies;

  CompaniesBloc({
    required this.loadCompanies,
  }) : super(const CompaniesLoading()) {
    on<CompaniesLoad>((event, emit) => _onLoad(event, emit));
  }

  void _onLoad(CompaniesLoad event, Emitter<CompaniesState> emit) async {
    emit(const CompaniesLoading());

    final result = await loadCompanies(const NoParams());

    result.fold(
      (l) => emit(CompaniesError(l.errorMessage)),
      (r) => emit(CompaniesLoaded(r)),
    );
  }
}
