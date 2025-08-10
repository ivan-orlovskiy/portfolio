import 'package:swipehr/src/core/exceptions/base_exception.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';

class LocalDatabaseException extends BaseException {
  LocalDatabaseException();

  @override
  String get exceptionMessage => Lang.unknownLocalEX;
}
