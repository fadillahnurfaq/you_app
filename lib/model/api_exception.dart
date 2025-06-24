class ApiException {
  final int? statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});
}
