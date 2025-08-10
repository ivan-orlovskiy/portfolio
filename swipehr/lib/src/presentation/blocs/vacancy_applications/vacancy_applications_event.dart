part of 'vacancy_applications_bloc.dart';

sealed class VacancyApplicationsEvent extends Equatable {
  const VacancyApplicationsEvent();
}

class VacancyApplicationsLoad extends VacancyApplicationsEvent {
  final String vacancyId;

  const VacancyApplicationsLoad(this.vacancyId);

  @override
  List<Object> get props => [vacancyId];
}
