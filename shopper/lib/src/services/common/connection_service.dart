import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionService {
  final InternetConnectionChecker internetConnectionChecker;

  ConnectionService({
    required this.internetConnectionChecker,
  });

  Future<bool> get isConnected async => await internetConnectionChecker.hasConnection;
}
