class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool error;

  ApiException({required this.message, this.statusCode, required this.error});

  @override
  String toString() => message;
}
