part of 'employer_vacancies_bloc.dart';

sealed class EmployerVacanciesState extends Equatable {
  const EmployerVacanciesState();
}

class EmployerVacanciesLoading extends EmployerVacanciesState {
  const EmployerVacanciesLoading();

  @override
  List<Object> get props => [];
}

class EmployerVacanciesLoaded extends EmployerVacanciesState {
  final List<Vacancy> vacancies;

  const EmployerVacanciesLoaded(this.vacancies);

  @override
  List<Object> get props => [...vacancies];
}

class EmployerVacanciesError extends EmployerVacanciesState {
  final String message;

  const EmployerVacanciesError(this.message);

  @override
  List<Object> get props => [message];
}
