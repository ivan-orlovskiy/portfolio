import 'package:swipehr/src/core/exceptions/base_exception.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';

class NetworkException extends BaseException {
  const NetworkException();

  @override
  String get exceptionMessage => Lang.notConnectedEX;
}
