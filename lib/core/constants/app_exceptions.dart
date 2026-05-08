class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message';
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

class CompositionException implements Exception {
  final String message;
  CompositionException(this.message);

  @override
  String toString() => 'CompositionException: $message';
}

class ShareException implements Exception {
  final String message;
  ShareException(this.message);

  @override
  String toString() => 'ShareException: $message';
}

class StateException implements Exception {
  final String message;
  StateException(this.message);

  @override
  String toString() => 'StateException: $message';
}