part of 'application_bloc.dart';

sealed class ApplicationState extends Equatable {
  const ApplicationState();
}

class ApplicationLoaded extends ApplicationState {
  final Application? application;

  const ApplicationLoaded(this.application);

  @override
  List<Object> get props => [];
}

class ApplicationLoading extends ApplicationState {
  const ApplicationLoading();

  @override
  List<Object> get props => [];
}
