import 'package:dio/dio.dart';
import 'package:lorry_trip/config/utils.dart';
import 'package:lorry_trip/modules/api_response.dart';

class ApiCall {
  final Dio _dio = Dio();

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Connection timeout",
          isError: true,
        );
        return ApiException(message: "Connection timeout", error: true);

      case DioExceptionType.sendTimeout:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Request timeout",
          isError: true,
        );
        return ApiException(message: "Request timeout", error: true);

      case DioExceptionType.receiveTimeout:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Server timeout",
          isError: true,
        );
        return ApiException(message: "Server timeout", error: true);

      case DioExceptionType.connectionError:
        AppUtils.showSnackBar(
          title: "Error",
          message: "No internet connection",
          isError: true,
        );
        return ApiException(message: "No internet connection", error: true);

      case DioExceptionType.badCertificate:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Invalid certificate",
          isError: true,
        );
        return ApiException(message: "Invalid certificate", error: true);

      case DioExceptionType.cancel:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Request cancelled",
          isError: true,
        );
        return ApiException(message: "Request cancelled", error: true);

      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response?.statusCode, e.response?.data);

      case DioExceptionType.transformTimeout:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Response parsing timeout",
          isError: true,
        );
        return ApiException(message: "Response parsing timeout", error: true);

      case DioExceptionType.unknown:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Something went wrong",
          isError: true,
        );
        return ApiException(message: "Something went wrong", error: true);
    }
  }

  ApiException _handleStatusCode(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        AppUtils.showSnackBar(
          title: "Error",
          message: data["message"] ?? "Bad Request",
          isError: true,
        );
        return ApiException(
          message: data["message"] ?? "Bad Request",
          statusCode: statusCode,
          error: true,
        );

      case 401:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Unauthorized",
          isError: true,
        );
        return ApiException(
          message: "Unauthorized",
          statusCode: statusCode,
          error: true,
        );

      case 403:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Forbidden",
          isError: true,
        );
        return ApiException(
          message: "Forbidden",
          statusCode: statusCode,
          error: true,
        );

      case 404:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Resource not found",
          isError: true,
        );
        return ApiException(
          message: "Resource not found",
          statusCode: statusCode,
          error: true,
        );

      case 409:
        AppUtils.showSnackBar(
          title: "Error",
          message: data["message"] ?? "Conflict",
          isError: true,
        );
        return ApiException(
          message: data["message"] ?? "Conflict",
          statusCode: statusCode,
          error: true,
        );

      case 422:
        AppUtils.showSnackBar(
          title: "Error",
          message: data["message"] ?? "Validation failed",
          isError: true,
        );
        return ApiException(
          message: data["message"] ?? "Validation failed",
          statusCode: statusCode,
          error: true,
        );

      case 500:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Internal server error",
          isError: true,
        );
        return ApiException(
          message: "Internal server error",
          statusCode: statusCode,
          error: true,
        );

      case 502:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Bad gateway",
          isError: true,
        );
        return ApiException(
          message: "Bad gateway",
          statusCode: statusCode,
          error: true,
        );

      case 503:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Service unavailable",
          isError: true,
        );
        return ApiException(
          message: "Service unavailable",
          statusCode: statusCode,
          error: true,
        );

      default:
        AppUtils.showSnackBar(
          title: "Error",
          message: "Unexpected error",
          isError: true,
        );
        return ApiException(
          message: "Unexpected error",
          statusCode: statusCode,
          error: true,
        );
    }
  }
}
