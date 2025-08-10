class BaseException {
  final String message;

  BaseException({
    required this.message,
  });

  @override
  String toString() => 'BaseException(message: $message)';
}
