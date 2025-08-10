import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/domain/usecases/employee/application/load_vacancies_for_employer.dart';

part 'employee_vacancies_event.dart';
part 'employee_vacancies_state.dart';

class EmployeeVacanciesBloc extends Bloc<EmployeeVacanciesEvent, EmployeeVacanciesState> {
  final LoadVacanciesForEmployer loadVacanciesForEmployer;

  EmployeeVacanciesBloc({
    required this.loadVacanciesForEmployer,
  }) : super(const EmployeeVacanciesLoading()) {
    on<EmployeeVacanciesLoad>((event, emit) => _onLoad(event, emit));
  }

  void _onLoad(EmployeeVacanciesLoad event, Emitter<EmployeeVacanciesState> emit) async {
    emit(const EmployeeVacanciesLoading());

    final result = await loadVacanciesForEmployer(
        LoadVacanciesForEmployerParams(employerId: event.employerId));

    result.fold(
      (l) => emit(EmployeeVacanciesError(l.errorMessage)),
      (r) => emit(EmployeeVacanciesLoaded(r)),
    );
  }
}
