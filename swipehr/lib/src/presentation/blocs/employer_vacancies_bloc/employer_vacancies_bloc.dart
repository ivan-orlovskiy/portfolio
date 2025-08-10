import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/domain/usecases/employee/application/load_vacancies_for_employer.dart';
import 'package:swipehr/src/domain/usecases/employer/vacancies/create_vacancy.dart';
import 'package:swipehr/src/domain/usecases/employer/vacancies/delete_vacancy.dart';

part 'employer_vacancies_event.dart';
part 'employer_vacancies_state.dart';

class EmployerVacanciesBloc extends Bloc<EmployerVacanciesEvent, EmployerVacanciesState> {
  final SharedPreferences sp;
  final LoadVacanciesForEmployer loadVacanciesForEmployer;
  final CreateVacancy createVacancy;
  final DeleteVacancy deleteVacancy;

  static const String userIdKey = 'user_id';

  EmployerVacanciesBloc({
    required this.sp,
    required this.loadVacanciesForEmployer,
    required this.createVacancy,
    required this.deleteVacancy,
  }) : super(const EmployerVacanciesLoading()) {
    on<EmployerVacanciesLoad>((event, emit) => _onLoad(event, emit));
    on<EmployerVacanciesCreateVacancy>((event, emit) => _onCreate(event, emit));
    on<EmployerVacanciesDeleteVacancy>((event, emit) => _onDelete(event, emit));
  }

  void _onLoad(EmployerVacanciesLoad event, Emitter<EmployerVacanciesState> emit) async {
    emit(const EmployerVacanciesLoading());

    final employerId = sp.getString(userIdKey) ?? '';

    final result =
        await loadVacanciesForEmployer(LoadVacanciesForEmployerParams(employerId: employerId));

    result.fold(
      (l) => emit(EmployerVacanciesError(l.errorMessage)),
      (r) => emit(EmployerVacanciesLoaded(r)),
    );
  }

  void _onCreate(EmployerVacanciesCreateVacancy event, Emitter<EmployerVacanciesState> emit) async {
    emit(const EmployerVacanciesLoading());

    final result = await createVacancy(CreateVacancyParams(newVacancy: event.vacancy));

    result.fold(
      (l) => add(const EmployerVacanciesLoad()),
      (r) => add(const EmployerVacanciesLoad()),
    );
  }

  void _onDelete(EmployerVacanciesDeleteVacancy event, Emitter<EmployerVacanciesState> emit) async {
    emit(const EmployerVacanciesLoading());

    final result = await deleteVacancy(DeleteVacancyParams(vacancyId: event.vacancyId));

    result.fold(
      (l) => add(const EmployerVacanciesLoad()),
      (r) => add(const EmployerVacanciesLoad()),
    );
  }
}
