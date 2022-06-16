class UnexpectedFileException implements Exception {
  String cause;
  UnexpectedFileException(this.cause);
}

class APIResponseException implements Exception {
  String cause;
  APIResponseException(this.cause);
}
