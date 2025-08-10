import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/domain/usecases/employee/application/create_application.dart';
import 'package:swipehr/src/domain/usecases/employee/application/delete_application.dart';
import 'package:swipehr/src/domain/usecases/employee/application/load_own_application.dart';

part 'application_event.dart';
part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final SharedPreferences sp;
  final LoadOwnApplication loadOwnApplication;
  final DeleteApplication deleteApplication;
  final CreateApplication createApplication;

  static const String userIdKey = 'user_id';

  ApplicationBloc({
    required this.sp,
    required this.loadOwnApplication,
    required this.deleteApplication,
    required this.createApplication,
  }) : super(const ApplicationLoading()) {
    on<ApplicationLoad>((event, emit) => _onLoad(event, emit));
    on<ApplicationDelete>((event, emit) => _onDelete(event, emit));
    on<ApplicationApply>((event, emit) => _onApply(event, emit));
  }

  void _onLoad(ApplicationLoad event, Emitter<ApplicationState> emit) async {
    emit(const ApplicationLoading());

    final userId = sp.getString(userIdKey) ?? '';
    final vacancyId = event.vacancyId;

    final result = await loadOwnApplication(
      LoadOwnApplicationParams(
        employeeId: userId,
        vacancyId: vacancyId,
      ),
    );

    result.fold(
      (l) => emit(const ApplicationLoaded(null)),
      (r) => emit(ApplicationLoaded(r)),
    );
  }

  void _onDelete(ApplicationDelete event, Emitter<ApplicationState> emit) async {
    final previousState = state;
    emit(const ApplicationLoading());

    final result = await deleteApplication(
      DeleteApplicationParams(applicationId: event.applicationId),
    );

    result.fold(
      (l) => emit(previousState),
      (r) => emit(const ApplicationLoaded(null)),
    );
  }

  void _onApply(ApplicationApply event, Emitter<ApplicationState> emit) async {
    emit(const ApplicationLoading());

    final result = await createApplication(CreateApplicationParams(
      newApplication: event.application,
      file: event.file,
    ));

    result.fold(
      (l) => emit(const ApplicationLoaded(null)),
      (r) => add(ApplicationLoad(event.application.vacancyId)),
    );
  }
}
