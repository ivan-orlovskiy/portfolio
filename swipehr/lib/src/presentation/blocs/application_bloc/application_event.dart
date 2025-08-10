part of 'application_bloc.dart';

sealed class ApplicationEvent extends Equatable {
  const ApplicationEvent();
}

class ApplicationLoad extends ApplicationEvent {
  final String vacancyId;

  const ApplicationLoad(this.vacancyId);

  @override
  List<Object> get props => [vacancyId];
}

class ApplicationDelete extends ApplicationEvent {
  final String applicationId;

  const ApplicationDelete(this.applicationId);

  @override
  List<Object> get props => [applicationId];
}

class ApplicationApply extends ApplicationEvent {
  final File file;
  final Application application;

  const ApplicationApply(this.application, this.file);

  @override
  List<Object> get props => [application, file];
}
