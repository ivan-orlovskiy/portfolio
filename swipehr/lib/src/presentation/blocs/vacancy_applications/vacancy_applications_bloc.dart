import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/domain/usecases/employer/vacancies/load_applications_for_a_vacancy.dart';

part 'vacancy_applications_event.dart';
part 'vacancy_applications_state.dart';

class VacancyApplicationsBloc extends Bloc<VacancyApplicationsEvent, VacancyApplicationsState> {
  final LoadApplicationsForAVacancy loadApplicationsForAVacancy;

  VacancyApplicationsBloc({
    required this.loadApplicationsForAVacancy,
  }) : super(const VacancyApplicationsLoading()) {
    on<VacancyApplicationsLoad>((event, emit) => _onLoad(event, emit));
  }

  void _onLoad(VacancyApplicationsLoad event, Emitter<VacancyApplicationsState> emit) async {
    emit(const VacancyApplicationsLoading());

    final result = await loadApplicationsForAVacancy(
      LoadApplicationsForAVacancyParams(vacancyId: event.vacancyId),
    );

    result.fold(
      (l) => emit(const VacancyApplicationsLoaded([])),
      (r) => emit(VacancyApplicationsLoaded(r)),
    );
  }
}
