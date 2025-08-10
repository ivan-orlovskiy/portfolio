part of 'employer_vacancies_bloc.dart';

sealed class EmployerVacanciesEvent extends Equatable {
  const EmployerVacanciesEvent();
}

class EmployerVacanciesLoad extends EmployerVacanciesEvent {
  const EmployerVacanciesLoad();

  @override
  List<Object> get props => [];
}

class EmployerVacanciesCreateVacancy extends EmployerVacanciesEvent {
  final Vacancy vacancy;

  const EmployerVacanciesCreateVacancy(this.vacancy);

  @override
  List<Object> get props => [vacancy];
}

class EmployerVacanciesDeleteVacancy extends EmployerVacanciesEvent {
  final String vacancyId;

  const EmployerVacanciesDeleteVacancy(this.vacancyId);

  @override
  List<Object> get props => [vacancyId];
}
