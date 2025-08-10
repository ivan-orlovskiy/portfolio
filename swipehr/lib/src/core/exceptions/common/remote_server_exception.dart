import 'package:swipehr/src/core/exceptions/base_exception.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';

class RemoteServerException extends BaseException {
  const RemoteServerException();

  @override
  String get exceptionMessage => Lang.unknownRemoteEX;
}
