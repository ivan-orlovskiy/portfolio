part of 'vacancy_applications_bloc.dart';

sealed class VacancyApplicationsState extends Equatable {
  const VacancyApplicationsState();
}

final class VacancyApplicationsLoading extends VacancyApplicationsState {
  const VacancyApplicationsLoading();

  @override
  List<Object> get props => [];
}

final class VacancyApplicationsLoaded extends VacancyApplicationsState {
  final List<Application> applications;

  const VacancyApplicationsLoaded(this.applications);

  @override
  List<Object> get props => [...applications];
}
