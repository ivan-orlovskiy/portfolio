part of 'employee_vacancies_bloc.dart';

sealed class EmployeeVacanciesEvent extends Equatable {
  const EmployeeVacanciesEvent();
}

class EmployeeVacanciesLoad extends EmployeeVacanciesEvent {
  final String employerId;

  const EmployeeVacanciesLoad(this.employerId);

  @override
  List<Object> get props => [employerId];
}
