class UnexpectedFileException implements Exception {
  UnexpectedFileException(this.cause);
  String cause;
}

class APIResponseException implements Exception {
  APIResponseException(this.cause);
  String cause;
}
