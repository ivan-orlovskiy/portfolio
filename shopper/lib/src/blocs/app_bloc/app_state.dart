part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class AppLoadingScreen extends AppState {
  const AppLoadingScreen();
}

final class AppSignScreen extends AppState {
  const AppSignScreen();
}

final class AppScreen extends AppState {
  const AppScreen();
}
