part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

final class AppInitialize extends AppEvent {
  const AppInitialize();
}

final class AppPasswordRecovered extends AppEvent {
  const AppPasswordRecovered();
}

final class AppSignIn extends AppEvent {
  final String email;
  final String password;
  final Function() onSuccess;
  final Function(String errorMessage) onError;

  const AppSignIn(this.email, this.password, this.onSuccess, this.onError);

  @override
  List<Object> get props => [email, password, onSuccess, onError];
}

final class AppSignUp extends AppEvent {
  final String email;
  final String password;
  final String nickname;
  final Function() onSuccess;
  final Function(String errorMessage) onError;

  const AppSignUp(this.email, this.password, this.nickname, this.onSuccess, this.onError);

  @override
  List<Object> get props => [email, password, nickname, onSuccess, onError];
}

final class AppSignOut extends AppEvent {
  const AppSignOut();
}
