part of 'employee_vacancies_bloc.dart';

sealed class EmployeeVacanciesState extends Equatable {
  const EmployeeVacanciesState();
}

class EmployeeVacanciesLoading extends EmployeeVacanciesState {
  const EmployeeVacanciesLoading();

  @override
  List<Object> get props => [];
}

class EmployeeVacanciesLoaded extends EmployeeVacanciesState {
  final List<Vacancy> vacancies;

  const EmployeeVacanciesLoaded(this.vacancies);

  @override
  List<Object> get props => [...vacancies];
}

class EmployeeVacanciesError extends EmployeeVacanciesState {
  final String message;

  const EmployeeVacanciesError(this.message);

  @override
  List<Object> get props => [message];
}
